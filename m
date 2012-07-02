Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2GBMDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:03:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60488 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2GBMDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:03:06 -0400
Date: Mon, 2 Jul 2012 13:02:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120702120259.GG22927@ZenIV.linux.org.uk>
References: <20120629174130.GY14083@ZenIV.linux.org.uk>
 <1341005929.2194.9.camel@falcor.watson.ibm.com>
 <1341014197.2342.7.camel@falcor.watson.ibm.com>
 <20120630050238.GZ14083@ZenIV.linux.org.uk>
 <1341172202.2556.13.camel@falcor>
 <20120701205722.GD22927@ZenIV.linux.org.uk>
 <1341193591.2249.3.camel@falcor>
 <20120702034310.GE22927@ZenIV.linux.org.uk>
 <20120702051155.GF22927@ZenIV.linux.org.uk>
 <1341229790.2350.1.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341229790.2350.1.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 07:49:50AM -0400, Mimi Zohar wrote:

> > > > pid=1 uid=0 d_name=init comm=swapper/0 dev="rootfs" mode=100775
> > > > pid=1 uid=0 d_name=bash comm=swapper/0 dev="rootfs" mode=100755
> > > 
> > > OK...  Here's what I suspect is going on:
> > > 	* populating initramfs writes binaries there.  We open files (for write) from
> > > the kernel thread (there's nothing other than kernel threads at that point), write to
> > > them, then close().  Final fput() gets delayed.
> > > 	* Then we proceed to execve().  Which means mapping the binary with MAP_DENYWRITE.
> > > Which fails, since there's a struct file still opened for write on that sucker.
> > > 
> > > Your patch did not delay those fput() - they were done without ->mmap_sem held.  So
> > > it survived.  Booting without initramfs always survives; booting with initramfs may
> > > or may not survive, depending on the timings - if that scheduled work manages to
> > > run by the time we do those execve(), we win.  Note that async_synchronize_full()
> > > done in init_post() might easily affect that, depending on config.
> > > 
> > > As a quick test, could you try slapping a delay somewhere around the beginning
> > > of init_post() and see if it rescues the system?
> > 
> > Ho-hum...  How about this (modulo missing documentation of the whole sad mess):
> 
> Sorry, neither adding the delay or this patch helped.

Really odd.  Could you print the error returned by kernel_execve() in run_init_process()?
At least that way we'll get some indication of what's going on there.  Another thing:
could you slap matching printks into the nested if() in fput() and the loop in
delayed_fput(), just to see if we do get __fput() done on all the right struct file?
Just "fput: %p", file and "delayed_fput: %p", file would probably be enough.

I'm assuming that I hadn't misparsed what you wrote and that __fput() in nested
if() in fput() was enough to get the thing working.  Could you confirm that?

