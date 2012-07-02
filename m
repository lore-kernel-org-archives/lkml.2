Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2GBDnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:43:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54041 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GBDnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:43:18 -0400
Date: Mon, 2 Jul 2012 04:43:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120702034310.GE22927@ZenIV.linux.org.uk>
References: <1340947838.2293.2.camel@falcor>
 <20120629083311.GX14083@ZenIV.linux.org.uk>
 <1340974925.2309.13.camel@falcor>
 <20120629174130.GY14083@ZenIV.linux.org.uk>
 <1341005929.2194.9.camel@falcor.watson.ibm.com>
 <1341014197.2342.7.camel@falcor.watson.ibm.com>
 <20120630050238.GZ14083@ZenIV.linux.org.uk>
 <1341172202.2556.13.camel@falcor>
 <20120701205722.GD22927@ZenIV.linux.org.uk>
 <1341193591.2249.3.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341193591.2249.3.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 09:46:31PM -0400, Mimi Zohar wrote:
> On Sun, 2012-07-01 at 21:57 +0100, Al Viro wrote:
> > On Sun, Jul 01, 2012 at 03:50:02PM -0400, Mimi Zohar wrote:
> > > Replacing it with a call to __fput(), the system boots.
> > 
> > "it" being just the part under that if (unlikely(...)))?  Very interesting...  If so, we
> > have some kernel thread ending up with delayed __fput() which somehow makes dracut (assuimg
> > you are using fedora initramfs to go with fedora config) unhappy.  With your own patch,
> > doing async __fput() in a lot of cases when this one doesn't delay past the return to
> > userland managing to survive the boot...  I wonder which files end up triggering that fun
> > and which kernel thread is responsible...  Could you slap a printk() in there, showing
> > file->f_dentry->d_inode->i_mode (octal) and at least file->f_dentry->d_name.name?
> > Along with the current->comm[], all under that inner if ().  And see which ones end up
> > going that way by the time execve() of /sbin/init fails.
> 
> pid=1 uid=0 d_name=init comm=swapper/0 dev="rootfs" mode=100775
> pid=1 uid=0 d_name=bash comm=swapper/0 dev="rootfs" mode=100755

OK...  Here's what I suspect is going on:
	* populating initramfs writes binaries there.  We open files (for write) from
the kernel thread (there's nothing other than kernel threads at that point), write to
them, then close().  Final fput() gets delayed.
	* Then we proceed to execve().  Which means mapping the binary with MAP_DENYWRITE.
Which fails, since there's a struct file still opened for write on that sucker.

Your patch did not delay those fput() - they were done without ->mmap_sem held.  So
it survived.  Booting without initramfs always survives; booting with initramfs may
or may not survive, depending on the timings - if that scheduled work manages to
run by the time we do those execve(), we win.  Note that async_synchronize_full()
done in init_post() might easily affect that, depending on config.

As a quick test, could you try slapping a delay somewhere around the beginning
of init_post() and see if it rescues the system?
