Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2D0VR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:17:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42123 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2D0VR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:17:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
Date: Fri, 27 Apr 2012 23:22:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204262352.43254.rjw@sisk.pl> <20120427103959.233cf065@notabene.brown>
In-Reply-To: <20120427103959.233cf065@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204272322.05749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 27, 2012, NeilBrown wrote:
> On Thu, 26 Apr 2012 23:52:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, April 26, 2012, NeilBrown wrote:
> > > On Sun, 22 Apr 2012 23:23:23 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > > To: Linux PM list <linux-pm@vger.kernel.org>
> > > > Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, Arve Hjønnevåg <arve@android.com>, John Stultz <john.stultz@linaro.org>, Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> > > > Subject: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
> > > > Date: Sun, 22 Apr 2012 23:23:23 +0200
> > > > Sender: linux-kernel-owner@vger.kernel.org
> > > > User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
> > > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Introduce a mechanism by which the kernel can trigger global
> > > > transitions to a sleep state chosen by user space if there are no
> > > > active wakeup sources.
> > > 
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > >  just a few little issues below.  Over all I think that if we have to have
> > >  auto-sleep in the kernel, then this is a good way to do it.
> > 
> > Good, we seem to agree in principle, then. :-)
> > 
> > > > +static void try_to_suspend(struct work_struct *work)
> > > > +{
> > > > +	unsigned int initial_count, final_count;
> > > > +
> > > > +	if (!pm_get_wakeup_count(&initial_count, true))
> > > > +		goto out;
> > > > +
> > > > +	mutex_lock(&autosleep_lock);
> > > > +
> > > > +	if (!pm_save_wakeup_count(initial_count)) {
> > > > +		mutex_unlock(&autosleep_lock);
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (autosleep_state == PM_SUSPEND_ON) {
> > > > +		mutex_unlock(&autosleep_lock);
> > > > +		return;
> > > > +	}
> > > > +	if (autosleep_state >= PM_SUSPEND_MAX)
> > > > +		hibernate();
> > > > +	else
> > > > +		pm_suspend(autosleep_state);
> > > > +
> > > > +	mutex_unlock(&autosleep_lock);
> > > > +
> > > > +	if (!pm_get_wakeup_count(&final_count, false))
> > > > +		goto out;
> > > > +
> > > > +	if (final_count == initial_count)
> > > > +		schedule_timeout(HZ / 2);
> > > 
> > > This doesn't do what you seem to expect it to do.
> > > You need to set current->state to something like TASK_UNINTERRUPTIBLE
> > > before calling schedule_timeout, otherwise it is effectily a no-op.
> > > schedule_timeout_uninterruptible(), for example, will do this for you.
> > 
> > Right.  I obviously overlooked the missing state change.
> > 
> > > However the value of this isn't clear to me, so a comment would probably be a
> > > good thing.
> > > This continue presumably fires if we wake up without any wakeup sources
> > > being activated.  In that case you want to delay for 500ms - presumably to
> > > avoid a tight suspend/resume loop if something goes wrong?
> > 
> > Yes.
> > 
> > > I have occasionally seen a stray/uninteresting interrupt wake from suspend
> > > immediately after entering suspend and the next attempt succeeds.  Maybe this
> > > is a bug in some driver somewhere, but not a big one.  I think I would rather
> > > in that case that we attempt to re-enter suspend immediately.  Maybe after a
> > > few failed attempts it makes sense to back off.
> > 
> > Perhaps.  We can adjust this particular thing later, I think.
> > 
> > > The other question is: if we want to back-off, is 500ms really enough?  What
> > > will be gained by, or could be achieved in, that time?  An exponential
> > > back-off might be defensible, but I can't see the value of a 500ms fixed
> > > back-off.
> > > However if you can, I'd love to see a comment in there explaining it.
> > 
> > Sure.
> > 
> > > > +
> > > > + out:
> > > > +	queue_up_suspend_work();
> > > > +}
> > > > +
> > > 
> > > 
> > > > +
> > > > +int pm_autosleep_set_state(suspend_state_t state)
> > > > +{
> > > > +
> > > > +#ifndef CONFIG_HIBERNATION
> > > > +	if (state >= PM_SUSPEND_MAX)
> > > > +		return -EINVAL;
> > > > +#endif
> > > > +
> > > > +	__pm_stay_awake(autosleep_ws);
> > > > +
> > > > +	mutex_lock(&autosleep_lock);
> > > > +
> > > > +	autosleep_state = state;
> > > > +
> > > > +	__pm_relax(autosleep_ws);
> > > 
> > > I'm struggling to see the point of the autosleep_ws.
> > > 
> > > A suspend cannot actually happen while this code is running (can it?) because
> > > it will wait for the process to enter the freezer.
> > > So the only effect of this is:
> > >   1/ cause the current auto-sleep cycle to abort and
> > >   2/ maybe add some accounting number is the autosleep_ws.
> > > Is that right?
> > > Which of these is needed?
> > 
> > This is to solve a problem when user space attempts to echo "off" to
> > /sys/power/autosleep exactly when pm_suspend() is initiated as a part
> > of autosleep under the autosleep lock.  In that case, if autosleep_ws is not
> > there, the process wanting to disable autosleep will have to wait for the
> > pm_suspend() to complete (unless it holds a wakelock), which is suboptimal.
> > 
> > > I would imagine that any process writing to /sys/power/autosleep would be
> > > holding a wakelock, and if it didn't it should expect things to be racy...
> > > 
> > > Am I missing something?
> > 
> > The assumption above is kind of optimistic in my opinion.  That process
> > very well may be a system administrator's bash, for example. :-)
> 
> If it is, then presumably the auto-sleep could kick in between any pair of
> keystrokes that the sysadmin types.  Or between the final 'enter' and when the
> write() system call begins.  All that autosleep_ws seems to provide is
> certainty that when the write() system call completes, autosleep will be
> fully disabled.
> I don't think that is really worth anything.
> 
> However, something did occur to me that I would like clarified.
> What happens if try_to_suspend() gets the autosleep_lock just before
> wakeup_count_store(), state_store() or pm_autosleep_set_state()
> try to get it?
> For pm_autosleep_set_state() the try_to_suspend() attempt will abort because
> it is holding autosleep_ws, so it will drop the lock and
> pm_autosleep_set_state() will continue happily.
> For the other two, what will happen (if there are no active wakesources and
> autosleep is enabled).
> I'm guessing that try_to_suspend will try to freeze all the process, which
> sends a pseudo signal to all processes, so the mutex_lock_interruptible will
> fail and the suspend will complete.
> Then will the aborted write() system call be re-attempted?
> 
> If that is right, then here is a very clear need to autosleep_ws:  it prevents
> a deadlock.

Yes, I think that this is the case.

> So it appears there is a very real need for autosleep_ws that even I can
> agree with.  It seems subtle though and could usefully be documented:
> 
> /* Note: it is only safe to mutex_lock(&autosleep_lock) if a wakeup_source
>  * is active, otherwise a deadlock with try_to_suspend() is possible.
>  * Alternatively mutex_lock_interruptible() can be used.  This will then fail
>  * if an auto_sleep cycle tries to freeze processes.
>  */

I'll add the comment above if you don't mind. :-)

> static DEFINE_MUTEX(autosleep_lock);
> 
> So:
>   Reviewed-by: NeilBrown <neilb@suse.de>

Thanks!

Rafael
