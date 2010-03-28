Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0C1UEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:04:14 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34174 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0C1UEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QqsDyUboFxEyrxeZ1cPh5Ijveeu8CpxrtYY1oVTU60vLuibbfYTveeNOvEjkUQ+DXq
         9YuKr8dj2OfPfoZnUZH6FS46nBUqdXgoAsqVQPKlP/wzzRMTgLOU1jOIV7EN9RJgp5pv
         bT9gPsro0u8bgWCa2y2TTJ7DUK1Le7G1VKLTs=
Date: Sun, 28 Mar 2010 22:04:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328200411.GC5116@nowhere>
References: <201003242240.54907.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003242240.54907.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:40:54PM +0100, Arnd Bergmann wrote:
> I've spent some time continuing the work of the people on Cc and many others
> to remove the big kernel lock from Linux and I now have bkl-removal branch
> in my git tree at git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
> that lets me run a kernel on my quad-core machine with the only users of the BKL
> being mostly obscure device driver modules.
> 
> The oldest patch in this series is roughly eight years old and is Willy's patch
> to remove the BKL from fs/locks.c, and I took a series of patches from Jan that
> removes it from most of the VFS.
> 
> The other non-obvious changes are:
> 
> - all file operations that either have an .ioctl method or do not have their
>   own .llseek method used to implicitly require the BKL. I've changed that
>   so they need to explicitly set .llseek = default_llseek, .unlocked_ioctl =
>   default_ioctl, and changed all the code that either has supplied a .ioctl
>   method or looks like it needs the BKL somewhere else, meaning the
>   default_llseek function might actually do something.
> 
> - The block layer now has a global bkldev_mutex that is used in all block
>   drivers in place of the BKL. The only recursive instance of the BKL was
>   __blkdev_get(), which is now called with the blkdev_mutex held instead of
>   grabbing the BKL. This has some possible performance implications that
>   need to be looked into.
> 
> - The init/main.c code no longer take the BKL. I figured that this was
>   completely unnecessary because there is no other code running at the
>   same time that takes the BKL.
> 
> - The most invasive change is in the TTY layer, which has a new global
>   mutex (sorry!). I know that Alan has plans of his own to remove the BKL
>   from this subsystem, so my patches may not go anywhere, but they seem
>   to work fine for me.
>   I've called the new lock the 'Big TTY Mutex' (BTM), a name that probably
>   makes more sense if you happen to speak German.
>   The basic idea here is to make recursive locking and the release-on-sleep
>   explicit, so every mutex_lock, wait_event, workqueue_flush and schedule
>   in the TTY layer now explicitly releases the BTM before blocking.
> 
> - All drivers that still require the BKL are now listed as 'depends on BKL'
>   in Kconfig, and you can set that symbol to 'y', 'm' or 'n'. If the lock
>   itself is a module, only other modules can use it, and /proc/modules
>   will tell you exactly which ones those are. I've thought about adding
>   a module_init function in that module that will taint the kernel, but so
>   far I haven't done that.
> 
> - Included is a debugfs file that gives statistics over the BKL usage from
>   early boot on. This is now obsolete and will not get merged, but I'm
>   including it for reference.
> 
> Frederic has volunteered to help merging all of this upstream, which I
> very much welcome. The shape that the tree is in now is very inconsistent,
> especially some of the bits at the end are a bit dodgy and all of it needs
> more testing.
> 
> I've built-tested an allmodconfig kernel with CONFIG_BKL disabled
> on x86_64, i386, powerpc64, powerpc32, s390 and arm to make sure I
> catch all the modules that depend on BKL, and I've been running
> various versions of this tree on my desktop machine over the last few
> weeks while adding stuff.
> 
> 	Arnd
> 
> ---
> 
> Arnd Bergmann (44):
>       input: kill BKL, fix input_open_file locking
>       ptrace: kill BKL
>       procfs: kill BKL in llseek
>       random: forbid llseek on random chardev
>       x86/microcode: use nonseekable_open
>       perf_event: use nonseekable_open



I just queued the perf_event one. It looks pretty good. I'm also
looking at some of the most trivials (ehm..less hards) in the list
and see which we can submit right away.

Thanks.

