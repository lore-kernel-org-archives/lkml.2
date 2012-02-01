Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2BAWp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:45:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab2BAWpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:45:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel threads fails
Date: Wed, 1 Feb 2012 23:49:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, pavel@ucw.cz,
        len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <20120201223647.GB19837@google.com>
In-Reply-To: <20120201223647.GB19837@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202012349.05110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 01, 2012, Tejun Heo wrote:
> On Thu, Feb 02, 2012 at 04:01:12AM +0530, Srivatsa S. Bhat wrote:
> > If freezing of kernel threads fails, we are expected to automatically thaw
> > tasks in the error recovery path. However, at times, we encounter situations
> > in which we would like the automatic error recovery path to thaw only the
> > kernel threads, because we want to be able to do some more cleanup before
> > we thaw userspace. Something like:
> > 
> > error = freeze_kernel_threads();
> > if (error) {
> > 	/* Do some cleanup */
> > 
> > 	/* Only then thaw userspace tasks*/
> > 	thaw_processes();
> > }
> > 
> > An example of such a situation is where we freeze/thaw filesystems during
> > suspend/hibernation. There, if freezing of kernel threads fails, we would
> > like to thaw the frozen filesystems before thawing the userspace tasks.
> > 
> > So, modify freeze_kernel_threads() to thaw only kernel threads in case of
> > freezing failure.
> > 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> with nits below,
> 
> > ---
> > 
> >  kernel/power/power.h   |   26 ++++++++++++++++++++++++--
> >  kernel/power/process.c |    7 +++++--
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > index 0c4defe..cf41c03 100644
> > --- a/kernel/power/power.h
> > +++ b/kernel/power/power.h
> > @@ -231,8 +231,30 @@ extern int pm_test_level;
> >  #ifdef CONFIG_SUSPEND_FREEZER
> >  static inline int suspend_freeze_processes(void)
> >  {
> > -	int error = freeze_processes();
> > -	return error ? : freeze_kernel_threads();
> > +	int error;
> > +
> > +	error = freeze_processes();
> > +
> > +	/*
> > +	 * freeze_processes() automatically thaws
> > +	 * every task if freezing fails. So we need
> > +	 * not do anything extra upon error.
> > +	 */
> > +	if (error)
> > +		goto Finish;
> > +
> > +	error = freeze_kernel_threads();
> > +
> > +	/*
> > +	 * freeze_kernel_threads() thaws only kernel
> > +	 * threads upon freezing failure. So we have
> > +	 * to thaw the userspace tasks ourselves.
> > +	 */
> > +	if (error)
> > +		thaw_processes();
> > +
> > + Finish:
> > +	return error;
> 
> Heh, the original ?: code was scary.

C'mon. ;-)

> That said, IMHO, the above seems
> a bit too verbose.  Functions usually shouldn't have side effects on
> failure and the above code is usual in that sense and it would be nice
> to mention the reformatting (from cryptic to sane) in the commit log.
> Also, how many columns are you flowing the text to?  It seems quite
> narrower than they usually should be.

I agree.

Srivatsa, care to resubmit?

Rafael
