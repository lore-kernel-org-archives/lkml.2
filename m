Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0DJQJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:09:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65240 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0DJQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rSsr8BWRN/SuqkLm64zzm1hBSB7ek4lQQ/GQXEC5UMTAh5YUh8jsm6lMdIazltAWgZ
         Ynl5zhhs1pSpDajdYimUp82fw0XfoV3OdE8opMAfww1uff+ptQSZ9x0rcx8UBUPrc3ft
         ZFSs+xVbEUTfgM5lOTBagxveyQycZxnZ9qUL0=
Date: Sat, 10 Apr 2010 18:09:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100410160945.GF5204@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312221.23953.arnd@arndb.de> <20100331214058.GE5163@nowhere> <201004011442.38536.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011442.38536.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 02:42:38PM +0200, Arnd Bergmann wrote:
> On Wednesday 31 March 2010, Frederic Weisbecker wrote:
> > On Wed, Mar 31, 2010 at 10:21:23PM +0200, Arnd Bergmann wrote:
> > 
> > > In the meantime, we can move the declaration of the .locked_ioctl callback
> > > into an #ifdef CONFIG_BKL, to make sure nobody builds a driver with an
> > > ioctl function that does not get called.
> > 
> > 
> > Ok, now how to get this all merged? A single monolithic patch is probably
> > not appropriate.
> > 
> > The simplest is to have a single branch with the default_ioctl implemented,
> > and then attributed to drivers in a set cut by subsystems/drivers. And
> > push the whole for the next -rc1.
> > 
> > The other solution is to push default_ioctl for this release and get
> > the driver changes to each concerned tree. That said, I suspect a good
> > part of them are unmaintained, hence the other solution looks better
> > to me.
> 
> I don't care much about the unmaintained parts, we can always have a
> tree collecting all the patches for those drivers and merge it in -rc1.
> 
> I'd say the nicest way would be to get Linus to merge the patch
> below now, so we can start queuing stuff in maintainer trees on top
> of it, and check against linux-next what is still missing and push
> all of them from our branch.
> 
> 	Arnd
> 
> ---
> Subject: [PATCH] introduce CONFIG_BKL and default_ioctl
> 
> This is a preparation for the removal of the big kernel lock that
> introduces new interfaces for device drivers still using it.
> 
> We can start marking those device drivers as 'depends on CONFIG_BKL'
> now, and make that symbol optional later, when the point has come
> at which we are able to build a kernel without the BKL.
> 
> Similarly, device drivers that currently make use of the implicit
> BKL locking around the ioctl function can now get annotated by
> changing
> 
> 	.ioctl = foo_ioctl,
> 
> to
> 
> 	.locked_ioctl = foo_ioctl,
> 	.unlocked_ioctl = default_ioctl,
> 
> As soon as no driver remains using the old ioctl callback, it can
> get removed.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/ioctl.c               |   22 ++++++++++++++++++++++
>  include/linux/fs.h       |    3 +++
>  include/linux/smp_lock.h |    4 ++++
>  lib/Kconfig.debug        |   10 ++++++++++
>  4 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 6c75110..52c2698 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -58,6 +58,28 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
>  	return error;
>  }
>  
> +#ifdef CONFIG_BKL
> +/*
> + * default_ioctl - call unlocked_ioctl with BKL held
> + *
> + * Setting only the the ioctl operation but not unlocked_ioctl will become
> + * invalid in the future, all drivers that are not converted to unlocked_ioctl
> + * should set .unlocked_ioctl = default_ioctl now.
> + */
> +long default_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{



Do you mind if I rename this to deprecated_ioctl()?
This "default" naming suggests a fallback everyone that don't
need tricky things should use.

