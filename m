Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0DYSFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 14:05:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61666 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0DYSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 14:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pq+RcD5UVMJDSbrMJ6JOwRZKuMBeDAB8juZZNdho5LA+7TdP3N/XRH+pZsO0cPKEoX
         Qpwih2dQ330nV7JYkLpa2Ytm/DpcFz53/5ALnVXYer65yml7nlz9IvdxfSu6c6Cy5yV3
         qjeBUUwKRlAD3g1JP2/66n2jTsoz9VXVcMlcQ=
Date: Sun, 25 Apr 2010 20:05:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100425180520.GD5375@nowhere>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <201004242154.02421.arnd@arndb.de> <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org> <201004242240.51176.arnd@arndb.de> <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org> <20100425173912.GA5375@nowhere> <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 10:49:51AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 25 Apr 2010, Frederic Weisbecker wrote:
> > 
> > And to prepare for that, are you ok with this scheme of:
> > 
> > -	.ioctl = foo,
> > +	.unlocked_ioctl = bkl_ioctl,
> > +	.bkl_ioctl	= foo,
> > 
> > ...done at the same time as the big rename patch.
> 
> Seriously, why not just
> 
> 	-	.ioctl = foo,
> 	+	.bkl_ioctl = foo
> 
> because that line of
> 
> 	+	.unlocked_ioctl = bkl_ioctl,
> 
> is just total and utter _garbage_.  There is zero reason for it.
> 
> In the long run (this is a year from now, when we rename "unlocked_ioctl" 
> back to just "ioctl"), the vfs_ioctl code will just do
> 
> 		struct file_operations *fops = filp->f_op;
> 
> 		if (!fops)
> 			return -ENOTTY;
> 
> 		if (fops->ioctl) {
> 			int error = fops->ioctl(...)
> 			if (error == -ENOIOCTLCMD)
> 				error = -EINVAL;
> 			return error;
> 		}
> 	#ifdef CONFIG_BKL
> 		if (fops->bkl_ioctl) {
> 			int error;
> 			lock_kernel();
> 			error = fops->bkl_ioctl(...)
> 			unlock_kernel();
> 			return error;
> 		}
> 	#endif
> 		return -ENOTTY;
> 
> and we're all done.
> 
> At NO point is there any advantage to that "bkl_ioctl" crap. It doesn't 
> help the legacy drivers (which won't even _compile_ unless CONFIG_BKL is 
> set anyway), it doesn't help the core code, it doesn't help _anybody_.
> 
> Not today, not tomorrow, not with CONFIG_BKL, and not without.
> 
> 			Linus


Well, we won't be able to get this bkl.ko but the desired effect of
having it was rather psychological than practical, as Arnd explained:
to make the dependency more visible and pull concerned people
into dropping the bkl from the drivers they are using.

But other than that, the final effect remains pretty the same so
it's not a big deal.

I'm ok with that.

Thanks for clarifying the situation!

