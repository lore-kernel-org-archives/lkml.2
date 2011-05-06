Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1EFTa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1EFTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:30:27 -0400
Date: Fri, 6 May 2011 12:30:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] add hook to read_from_oldmem() to check for non-ram
 pages
Message-Id: <20110506123019.80461d5d.akpm@linux-foundation.org>
In-Reply-To: <20110506105545.GA16945@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
	<20110503190806.GA12485@aepfle.de>
	<20110505142551.b4d2d95a.akpm@linux-foundation.org>
	<20110506105545.GA16945@aepfle.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 12:55:46 +0200
Olaf Hering <olaf@aepfle.de> wrote:

> Should the called code increase/decrease the modules refcount instead?
> I remember there was some MODULE_INC/MODULE_DEC macro (cant remember the
> exact name) at some point. What needs to be done inside the module to
> prevent an unload while its still in use? Is it __module_get/module_put
> for each call of fn()? 

A try_module_get(THIS_MODULE) in the register function will do the trick.
However it's unneeded.  Documentation/DocBook/kernel-hacking.tmpl tells us

try_module_get() module_put()

    These manipulate the module usage count, to protect against
    removal (a module also can't be removed if another module uses one
    of its exported symbols: see below).  Before calling into module
    code, you should call <function>try_module_get()</function> on
    that module: if it fails, then the module is being removed and you
    should act as if it wasn't there.  Otherwise, you can safely enter
    the module, and call <function>module_put()</function> when you're
    finished.

So as your module will have a reference to vmcore.c's register and unregister
functions, nothing needs to be done: the presence of the client module alone
will pin the vmcore.c module.

However it's all moot, because the fs/proc/vmcore.c code cannot
presently be built as a module and it's rather unlikely that it ever
will be.

