Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0DYRjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:39:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42298 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0DYRjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YB5Z8LK228f28LdMxMXdDdvnjpaZsGfQynW9H7EX0c7xQtZK9sZXLzujbj+oG0pVLc
         bTUyBVX7X9h4WEIJtQQFqgNU4sOVGiZ+hbjp85HkupBSV8k4oqQDE432SVIVZjgQdRbo
         K6C+bQe3OI2n/m4odzak7FF8KEx3sgxjx6Y3s=
Date: Sun, 25 Apr 2010 19:39:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100425173912.GA5375@nowhere>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004242154.02421.arnd@arndb.de> <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org> <201004242240.51176.arnd@arndb.de> <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 03:15:23PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 24 Apr 2010, Arnd Bergmann wrote:
> > 
> > With CONFIG_BKL disabled, we gain a few cyles in the scheduler,
> 
> That has _nothing_ to do with the ioctl's though.
> 
> Stop mixing things up.
> 
> There are two totally independent issues:
> 
>  - making the BKL ioctl's be explicit and findable
> 
>  - eventually getting rid of the BKL entirely
> 
> and I think you guys are totally mixing things up, and making things WORSE 
> in the process.
> 
> The notion of having _three_ different "ioctl()" function pointers just 
> makes me want to gag. And there is absolutely _zero_ reason for it. Tjhere 
> is no way in hell that we want to have every subsystem maintainer try to 
> independently do their own ioctl's. Most of the drivers that have those 
> things are basically unmaintained or on the back burner anyway.
> 
> So don't make the current ugly ioctl situation worse. Not even as a 
> stop-gap, because there is absolutely _zero_ upside to making yet another 
> new crazy temporary ioctl interface.


Our final goal was not to have three different ioctl interfaces. This state was
only deemed to be temporary. This was the only way to make the change
smoother and don't conflict with other trees with a single monolithic patch.

But if you are ok with a single one, then we are going this way and we'll send it for
the next merge window.

 
> And don't try to conflate the issue of ioctl and BKL. There are still 
> code-paths that do lock_kernel() without the ioctl's, so the whole ioctl 
> renaming has _zero_ to do with CONFIG_BKL.


It's true, but once it gets pushed down/dropped from every core parts (which
is what we are working on currently in parallel), lock_kernel() and .bkl_ioctl
is only going to be used by unmaintained drivers. This is the time where having
a CONFIG_BKL is going to make sense. And it won't be a question of saving some
bytes but improve efficiency of schedule() for those who don't need such old or
unmaintained drivers.

May be we should only start to focus on this new config once this state is reached.

And to prepare for that, are you ok with this scheme of:

-	.ioctl = foo,
+	.unlocked_ioctl = bkl_ioctl,
+	.bkl_ioctl	= foo,

...done at the same time as the big rename patch.
This will prepare to remove the bkl from vfs and build it conditionally
from the bkl lib, once the bkl is out the core?

