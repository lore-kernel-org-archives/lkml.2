Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0DYRwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:52:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab0DYRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:52:00 -0400
Date: Sun, 25 Apr 2010 10:49:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <20100425173912.GA5375@nowhere>
Message-ID: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004242154.02421.arnd@arndb.de> <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org> <201004242240.51176.arnd@arndb.de> <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org>
 <20100425173912.GA5375@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Apr 2010, Frederic Weisbecker wrote:
> 
> And to prepare for that, are you ok with this scheme of:
> 
> -	.ioctl = foo,
> +	.unlocked_ioctl = bkl_ioctl,
> +	.bkl_ioctl	= foo,
> 
> ...done at the same time as the big rename patch.

Seriously, why not just

	-	.ioctl = foo,
	+	.bkl_ioctl = foo

because that line of

	+	.unlocked_ioctl = bkl_ioctl,

is just total and utter _garbage_.  There is zero reason for it.

In the long run (this is a year from now, when we rename "unlocked_ioctl" 
back to just "ioctl"), the vfs_ioctl code will just do

		struct file_operations *fops = filp->f_op;

		if (!fops)
			return -ENOTTY;

		if (fops->ioctl) {
			int error = fops->ioctl(...)
			if (error == -ENOIOCTLCMD)
				error = -EINVAL;
			return error;
		}
	#ifdef CONFIG_BKL
		if (fops->bkl_ioctl) {
			int error;
			lock_kernel();
			error = fops->bkl_ioctl(...)
			unlock_kernel();
			return error;
		}
	#endif
		return -ENOTTY;

and we're all done.

At NO point is there any advantage to that "bkl_ioctl" crap. It doesn't 
help the legacy drivers (which won't even _compile_ unless CONFIG_BKL is 
set anyway), it doesn't help the core code, it doesn't help _anybody_.

Not today, not tomorrow, not with CONFIG_BKL, and not without.

			Linus
