Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031708Ab2CGAtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:49:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593Ab2CGAtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:49:17 -0500
Date: Tue, 6 Mar 2012 16:49:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@parisplace.org>
Cc: gaowanlong@cn.fujitsu.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        sds@tycho.nsa.gov
Subject: Re: [PATCH] selinux: init target class when add avc callback
Message-Id: <20120306164916.171429c5.akpm@linux-foundation.org>
In-Reply-To: <1331080893.6253.1.camel@localhost>
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<4F56A4E2.5050001@cn.fujitsu.com>
	<20120306161543.63c3fc54.akpm@linux-foundation.org>
	<1331080893.6253.1.camel@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2012 19:41:33 -0500
Eric Paris <eparis@parisplace.org> wrote:

> __initcall() functions aren't serialized?  I guess that would be bad and
> we would need a lock.  I wonder if there are other places I assumed
> __initcall() would be serialized (note that all of these call sites are
> built in and not modules if that makes a difference)

There's plenty of code in the kernel which assumes that initcalls
are singly-threaded.  And init/main.c:do_initcalls() is very
singly-threaded!  It's less clear when the initcall is executed by
modprobe, but presumably there's something in the module code which
prevents concurrent execution of module_init() functions.

So I think the list management code is acceptable, as long as we ensure
that the function is only ever called from initcall functions.  We can
add a comment, but a neat way of ensuring this is to mark the function
__init.  This saves memory and will cause a build-time warning if we
screw up.

My point was that given that this function is only ever called from
initcalls, that weak GFP_ATOMIC could/should be replaced with
GFP_KERNEL.

