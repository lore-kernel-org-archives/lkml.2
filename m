Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab0C2Mpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:45:38 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:53991 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab0C2Mpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IQXFfqg/QPmtlkqDGr6QWKO001hFO4005WzrM+dXERRv8hpb0h5Yfiv4ZiX9i3vNa6
         By2VUJEbHmUDaZRuiM2mr1dPQcn496yC3SFyw4ONZYVfhEOwTr9Txb4CHxy43R2qJ5PK
         B9OlP/CCnH8nAlQXTl8n4lYkaJdkoAYbQ5ktI=
MIME-Version: 1.0
In-Reply-To: <201003242240.54907.arnd@arndb.de>
References: <201003242240.54907.arnd@arndb.de>
Date: Mon, 29 Mar 2010 14:45:34 +0200
Message-ID: <520f0cf11003290545k752e9a32v7c6ae15e515ecb51@mail.gmail.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
From: John Kacur <jkacur@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
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
>  own .llseek method used to implicitly require the BKL. I've changed that
>  so they need to explicitly set .llseek = default_llseek, .unlocked_ioctl =
>  default_ioctl, and changed all the code that either has supplied a .ioctl
>  method or looks like it needs the BKL somewhere else, meaning the
>  default_llseek function might actually do something.
>
> - The block layer now has a global bkldev_mutex that is used in all block
>  drivers in place of the BKL. The only recursive instance of the BKL was
>  __blkdev_get(), which is now called with the blkdev_mutex held instead of
>  grabbing the BKL. This has some possible performance implications that
>  need to be looked into.
>
> - The init/main.c code no longer take the BKL. I figured that this was
>  completely unnecessary because there is no other code running at the
>  same time that takes the BKL.
>
> - The most invasive change is in the TTY layer, which has a new global
>  mutex (sorry!). I know that Alan has plans of his own to remove the BKL
>  from this subsystem, so my patches may not go anywhere, but they seem
>  to work fine for me.
>  I've called the new lock the 'Big TTY Mutex' (BTM), a name that probably
>  makes more sense if you happen to speak German.
>  The basic idea here is to make recursive locking and the release-on-sleep
>  explicit, so every mutex_lock, wait_event, workqueue_flush and schedule
>  in the TTY layer now explicitly releases the BTM before blocking.
>
> - All drivers that still require the BKL are now listed as 'depends on BKL'
>  in Kconfig, and you can set that symbol to 'y', 'm' or 'n'. If the lock
>  itself is a module, only other modules can use it, and /proc/modules
>  will tell you exactly which ones those are. I've thought about adding
>  a module_init function in that module that will taint the kernel, but so
>  far I haven't done that.
>
> - Included is a debugfs file that gives statistics over the BKL usage from
>  early boot on. This is now obsolete and will not get merged, but I'm
>  including it for reference.
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
>        Arnd
>
> ---
>
> Arnd Bergmann (44):
>      input: kill BKL, fix input_open_file locking
>      ptrace: kill BKL
>      procfs: kill BKL in llseek
>      random: forbid llseek on random chardev
>      x86/microcode: use nonseekable_open
>      perf_event: use nonseekable_open
>      dm: use nonseekable_open
>      vgaarb: use nonseekable_open
>      kvm: don't require BKL
>      nvram: kill BKL
>      do_coredump: do not take BKL
>      hpet: kill BKL, add compat_ioctl
>      proc/pci: kill BKL
>      autofs/autofs4: move compat_ioctl handling into fs
>      usb/mon: kill BKL usage
>      fat: push down BKL
>      sunrpc: push down BKL
>      pcmcia: push down BKL
>      vfs: kill BKL in default_llseek
>      BKL: introduce CONFIG_BKL.
>      bkl-removal: make fops->ioctl and default_llseek optional
>      x86: update defconfig to CONFIG_BKL=m
>      bkl removal: make unlocked_ioctl mandatory
>      bkl removal: use default_llseek in code that uses the BKL
>      BKL removal: mark remaining users as 'depends on BKL'
>      tty: replace BKL with a new tty_lock
>      tty: make atomic_write_lock release tty_lock
>      tty: make tty_port->mutex nest under tty_lock
>      tty: make termios mutex nest under tty_lock
>      tty: make ldisc_mutex nest under tty_lock
>      tty: never hold tty_lock() while getting tty_mutex
>      ppp: use big tty mutex
>      tty: release tty lock when blocking
>      tty: implement BTM as mutex instead of BKL
>      briq_panel: do not use BTM
>      affs: remove leftover unlock_kernel
>      kvm: don't require BKL
>      block: replace BKL with global mutex
>      init: kill BKL usage
>      debug: instrument big kernel lock
>      BKL removal: make the BKL modular
>
> Matthew Wilcox (1):
>      [RFC] Remove BKL from fs/locks.c
>
> Jan Blunck (19):
>      JFS: Free sbi memory in error path
>      BKL: Explicitly add BKL around get_sb/fill_super
>      BKL: Remove outdated comment and include
>      BKL: Remove BKL from Amiga FFS
>      BKL: Remove BKL from BFS
>      BKL: Remove BKL from CifsFS
>      BKL: Remove BKL from ext3 fill_super()
>      BKL: Remove BKL from ext3_put_super() and ext3_remount()
>      BKL: Remove BKL from ext4 filesystem
>      BKL: Remove smp_lock.h from exofs
>      BKL: Remove BKL from HFS
>      BKL: Remove BKL from HFS+
>      BKL: Remove BKL from JFS
>      BKL: Remove BKL from NILFS2
>      BKL: Remove BKL from NTFS
>      BKL: Remove BKL from cgroup
>      BKL: Remove BKL from do_new_mount()
>      ext2: Add ext2_sb_info s_lock spinlock
>      BKL: Remove BKL from ext2 filesystem
> --

Great, Arnd, I like this.

I also have a private but stale tree where I have collected some
remove bkl patches (which I will review against your tree.)
I think that it is important that we keep chipping away at it though,
and that we all keep sending stuff upstream when it is ready.

Thanks
John
