Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0HYXpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:45:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab0HYXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:45:02 -0400
Date: Wed, 25 Aug 2010 16:44:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix init ordering of /dev/console vs callers of
 modprobe
Message-Id: <20100825164448.7db5d749.akpm@linux-foundation.org>
In-Reply-To: <20100806153443.26610.87253.stgit@warthog.procyon.org.uk>
References: <20100806153443.26610.87253.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 16:34:43 +0100
David Howells <dhowells@redhat.com> wrote:

> Make /dev/console get initialised before any initialisation routine that
> invokes modprobe because if modprobe fails, it's going to want to open
> /dev/console, presumably to write an error message to.
> 
> The problem with that is that if the /dev/console driver is not yet
> initialised, the chardev handler will call request_module() to invoke modprobe,
> which will fail, because we never compile /dev/console as a module.
> 
> This will lead to a modprobe loop, showing the following in the kernel log:
> 
> 	request_module: runaway loop modprobe char-major-5-1
> 	request_module: runaway loop modprobe char-major-5-1
> 	request_module: runaway loop modprobe char-major-5-1
> 	request_module: runaway loop modprobe char-major-5-1
> 	request_module: runaway loop modprobe char-major-5-1

Boy, that's a familiar message.

> This can happen, for example, when the built in md5 module can't find the built
> in cryptomgr module (because the latter fails to initialise).  The md5 module
> comes before the call to tty_init(), presumably because 'crypto' comes before
> 'drivers' alphabetically.
> 
> Fix this by calling tty_init() from chrdev_init().

http://www.google.com/search?sclient=psy&hl=en&site=&source=hp&q=%22request_module%3A+runaway+loop+modprobe%22&aq=f&aqi=g1&aql=&oq=&gs_rfai=CPc2Or6p1TOLmIIyu6QOT_-zuDwAAAKoEBU_QHJC0&pbx=1&cad=cbv
gets 10000 hits.  How many of those do you reckon this patch will fix? 

