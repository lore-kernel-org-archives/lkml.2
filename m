Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2BMPIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:08:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2BMPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:08:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] PM / Sleep: Make enter_state() in kernel/power/suspend.c static
Date: Mon, 13 Feb 2012 16:12:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <201202120003.20879.rjw@sisk.pl> <201202122224.14640.rjw@sisk.pl> <4F389DE0.6020904@linux.vnet.ibm.com>
In-Reply-To: <4F389DE0.6020904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202131612.26973.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 13, 2012, Srivatsa S. Bhat wrote:
> On 02/13/2012 02:54 AM, Rafael J. Wysocki wrote:
> 
> > On Sunday, February 12, 2012, Srivatsa S. Bhat wrote:
> >> On 02/12/2012 04:34 AM, Rafael J. Wysocki wrote:
> >>
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>
> >>> The enter_state() function in kernel/power/suspend.c should be
> >>> static and state_store() in kernel/power/suspend.c should call
> >>> pm_suspend() instead of it, so make that happen (which also reduces
> >>> code duplication related to suspend statistics).
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>> ---
> >>>  kernel/power/main.c    |    6 +-----
> >>>  kernel/power/power.h   |    2 --
> >>>  kernel/power/suspend.c |    2 +-
> >>>  3 files changed, 2 insertions(+), 8 deletions(-)
> >>>
> >>> Index: linux/kernel/power/main.c
> >>> ===================================================================
> >>> --- linux.orig/kernel/power/main.c
> >>> +++ linux/kernel/power/main.c
> >>> @@ -292,11 +292,7 @@ static ssize_t state_store(struct kobjec
> >>>  #ifdef CONFIG_SUSPEND
> >>>  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
> >>>  		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
> >>> -			break;
> >>> -	}
> >>> -	if (state < PM_SUSPEND_MAX && *s) {
> >>> -		error = enter_state(state);
> >>> -		suspend_stats_update(error);
> >>> +			error = pm_suspend(state);
> >>
> >>
> >> This code will not stop after calling pm_suspend(). It will try more iterations
> >> in the for loop right?
> > 
> > Well, only one string in pm_states[] can be matched at a time, but I agree that
> > it doesn't make sense to continue the loop after we've found a match.
> > 
> >> We can probably keep the 'for' loop as it is, and just replace the 'if' block
> >> following the 'for' loop by: error = pm_suspend(state);
> > 
> > I think the patch below is correct.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Sleep: Make enter_state() in kernel/power/suspend.c static
> > 
> > The enter_state() function in kernel/power/suspend.c should be
> > static and state_store() in kernel/power/suspend.c should call
> > pm_suspend() instead of it, so make that happen (which also reduces
> > code duplication related to suspend statistics).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> 
> 
> Yeah, this version of the patch will work fine.
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks!

I wonder if that should be Reviewed-by, tough?  You evidently have reviewed
the patch (actually, all three of them).

Rafael


> >  kernel/power/main.c    |    8 +++-----
> >  kernel/power/power.h   |    2 --
> >  kernel/power/suspend.c |    2 +-
> >  3 files changed, 4 insertions(+), 8 deletions(-)
> > 
> > Index: linux/kernel/power/main.c
> > ===================================================================
> > --- linux.orig/kernel/power/main.c
> > +++ linux/kernel/power/main.c
> > @@ -291,12 +291,10 @@ static ssize_t state_store(struct kobjec
> > 
> >  #ifdef CONFIG_SUSPEND
> >  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
> > -		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
> > +		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
> > +			error = pm_suspend(state);
> >  			break;
> > -	}
> > -	if (state < PM_SUSPEND_MAX && *s) {
> > -		error = enter_state(state);
> > -		suspend_stats_update(error);
> > +		}
> >  	}
> >  #endif
> > 
> > Index: linux/kernel/power/power.h
> > ===================================================================
> > --- linux.orig/kernel/power/power.h
> > +++ linux/kernel/power/power.h
> > @@ -177,13 +177,11 @@ extern const char *const pm_states[];
> > 
> >  extern bool valid_state(suspend_state_t state);
> >  extern int suspend_devices_and_enter(suspend_state_t state);
> > -extern int enter_state(suspend_state_t state);
> >  #else /* !CONFIG_SUSPEND */
> >  static inline int suspend_devices_and_enter(suspend_state_t state)
> >  {
> >  	return -ENOSYS;
> >  }
> > -static inline int enter_state(suspend_state_t state) { return -ENOSYS; }
> >  static inline bool valid_state(suspend_state_t state) { return false; }
> >  #endif /* !CONFIG_SUSPEND */
> > 
> > Index: linux/kernel/power/suspend.c
> > ===================================================================
> > --- linux.orig/kernel/power/suspend.c
> > +++ linux/kernel/power/suspend.c
> > @@ -272,7 +272,7 @@ static void suspend_finish(void)
> >   * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
> >   * system enter the given sleep state and clean up after wakeup.
> >   */
> > -int enter_state(suspend_state_t state)
> > +static int enter_state(suspend_state_t state)
> >  {
> >  	int error;
> > 
> > 
> 
> 
> 

