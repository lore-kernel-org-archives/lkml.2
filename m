Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0DXUlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 16:41:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62072 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0DXUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 16:41:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Sat, 24 Apr 2010 22:40:50 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004242154.02421.arnd@arndb.de> <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004242240.51176.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Eb9pmp4pOOKjbzvjXvem/4+ype2J2X/C/DLd
 fcT9gD6PhQBrdVHxwCIFIMUwIkDx7OkwaFkyR8x+vbaBQr09N3
 71MvUwAdU2o+qigiqvwaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 April 2010 22:01:18 Linus Torvalds wrote:
> On Sat, 24 Apr 2010, Arnd Bergmann wrote:
> > 
> > The CONFIG_BKL stuff is not a requirement for doing this, but something
> > we also want to do in the next merge window, i.e. mark all BKL users
> > as CONFIG_BKL, not just the ones that use the locked_ioctl (or bkl_ioctl).
> 
> .. and I think that's simply fundamentally wrong. What does it buy us, 
> except for another really annoying config option? It sure as hell doesn't 
> buy us any code-size (what, a couple of bytes).

With CONFIG_BKL disabled, we gain a few cyles in the scheduler,
since we no longer need to check if the BKL was held and needs to
be released. Not much, but better than just a few bytes of object size.

With CONFIG_BKL=m, what we gain is visibility: Doing an lsmod will
show you if bkl.ko is loaded and what other modules are using it.
My hope is that this will motivate people to remove it from the
remaining modules.
One of the crazier ideas was to automatically taint the kernel when
bkl.ko gets loaded. This does not gain us anything besides making a
statement.

> Quite frankly, if you want to just prepare to rename things one by one, 
> then you might as well just have a single line
> 
>         #define bkl_ioctl ioctl
> 
> and then you can do
> 
>         .bkl_ioctl = driver_ioctl
> 
> but the thing is - what does that buy us without the ability to grep for 
> and cause compile errors for drivers that haven't done this? Nothing.

Being able to grep is not the reason for this patch. The reason is that
we're trying to eliminate the BKL from all non-obscure code in the kernel
and one of the nasty ones is fs/ioctl.c, which always gets compiled in.
The trick with bkl.ko requires that any code calling lock_kernel() needs
to be a module, so the deprecated_ioctl() helper will have to be part
of bkl.ko as well.

> So seriously - I'd much rather just get one single large patch that just 
> renames everything. None of this crap that makes no sense.

Ok. We'll go back to my intial approach for ioctl then, doing it all at
once. The reason for the staged approach was to avoid bisect breakage
and conflicts with maintainer updates, but since most of the remaining
users at this point are really unmaintained (or staging drivers), there's
probably not much to worry about here.

There will be one patch that does three things:
- add a deprecated_ioctl() function
- rename fops->ioctl to fops->bkl_ioctl
- set fops->unlocked_ioctl=deprecated_ioctl for any file_operations instance
  that uses bkl_ioctl
Is this ok for you?

Regarding the CONFIG_BKL option, should that also be done as another patch
changing all the Kconfig files? My preference would be to have one patch
adding the Kconfig option first, giving the maintainers the choice to either
mark their code 'depends on BKL' or to remove the dependency by changing
their code.

	Arnd
