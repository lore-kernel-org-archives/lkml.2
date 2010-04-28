Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0D1VwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:52:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0D1VwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xt1xP55G/ctJh1hs/K3QwzRfpU+Ism/fWFywJKRT83usx2O1CVb4qlEd6Thk5+UUtY
         pRV8D3PMBpIif7rBUbR7efP4H67qHDq3Ag7CY/6NboCRd0xWTMVRoS6TW3RHSkBO4z6L
         Z51OCnb+mYhhhSQubOf1fOEFQ/PSxXn85Ovio=
Date: Wed, 28 Apr 2010 23:52:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Jan Blunck <jblunck@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the
	bkl-pushdown.
Message-ID: <20100428215214.GC6037@nowhere>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <201004271317.45503.arnd@arndb.de> <alpine.LFD.2.00.1004271352510.3318@localhost> <201004271503.18077.arnd@arndb.de> <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 07:55:02AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 27 Apr 2010, Arnd Bergmann wrote:
> > +static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  {
> >  	struct video_device *vdev = video_devdata(filp);
> > +	int ret;
> >  
> >  	/* Allow ioctl to continue even if the device was unregistered.
> >  	   Things like dequeueing buffers might still be useful. */
> > +	if (vdev->fops->unlocked_ioctl) {
> > +		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> > +	} else if (vdev->fops->ioctl) {
> > +		/* TODO: convert all drivers to unlocked_ioctl */
> > +		lock_kernel();
> > +		ret = vdev->fops->ioctl(filp, cmd, arg);
> > +		unlock_kernel();
> > +	} else 
> > +		ret = -ENOTTY;
> >  
> > +	return ret;
> 
> [ Removed the '-' lines so you can see what the end result ends up being ]
> 
> Please, if you do this for the V4L2 layer, then DO NOT make the same 
> mistake we did with the vasic VFS layer.
> 
> In other words, DO NOT keep the "bkl" version named just "ioctl". It was a 
> horrible horrible mistake, and it has resulted in problems years 
> afterwards.
> 
> I realize that it's so easy to just add a new ".unlocked_ioctl" member, 
> and then as people start using it, they get rid of the BKL. But it's a 
> mistake. It was a mistake for the VFS layer, it would be a mistake for the 
> V4L2 layer.
> 
> Instead, spend the 15 minutes just renaming every current 'ioctl' user in 
> the V4L2 layer. It's not that much work, the scripts I documented in my 
> renaming patch do 95% of the work (you just need to change 
> "file_operations" to "v4l2_file_operations"). It's not that painful. And 
> then you don't just push the BKL down, you actually annotate the remaining 
> users so that they can be grepped for.
> 
> So please please please, don't make the same mistake we did long ago. 
> 
> 		Linus


Hmm, there are 92 struct v4l2_file_operations::ioctl but actually a lot
of duplicates ioctl. In fact there are just 26 ioctl functions.

It's probably worth the whole pushdown instead of the rename.

I'm going to do this.

