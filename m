Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab0FQTkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:40:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572Ab0FQTkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FJw4tg8BbF1WCa1OK4lWkLoAXe4NyRWdnFxeg4g0564DuzBr6S/843r1/S2JrpcnBm
         sp9pfs+oqBcp02C/Rp45dCkWv4ak+mZZEgJXOU7GwdLx0d6SheJHIDMmP0ntl+Xnnm/J
         +0lfCu22VBo3T2d0qMdr2cJH6y9IwrL7h/q3U=
MIME-Version: 1.0
In-Reply-To: <201006172114.19033.rjw@sisk.pl>
References: <201006141653.03879.rjw@sisk.pl>
	<201006171821.37060.rjw@sisk.pl>
	<AANLkTimxt3An0nSARe71YuMWMgSD07PjU8dNvyJIJu3U@mail.gmail.com>
	<201006172114.19033.rjw@sisk.pl>
Date: Thu, 17 Jun 2010 15:40:21 -0400
Message-ID: <AANLkTimRQLDDyIB0LIE018gR24s593rkMyTvDuF1ntJT@mail.gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with 
	radeon/KMS and r300
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>, Dave Airlie <airlied@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 3:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, June 17, 2010, Alex Deucher wrote:
>> 2010/6/17 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday, June 16, 2010, Alex Deucher wrote:
>> >> On Wed, Jun 16, 2010 at 4:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > On Wednesday, June 16, 2010, Ondrej Zary wrote:
>> >> >> On Wednesday 16 June 2010, Rafael J. Wysocki wrote:
>> >> >> > On Tuesday, June 15, 2010, Rafael J. Wysocki wrote:
>> >> >> > > On Monday, June 14, 2010, Alex Deucher wrote:
>> >> >> > > > On Mon, Jun 14, 2010 at 3:03 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> > > > > On Monday, June 14, 2010, Alex Deucher wrote:
>> >> >> > > > >> On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.pl>
>> >> >> wrote:
>> >> >> > > > >> > Alex, Dave,
>> >> >> > > > >> >
>> >> >> > > > >> > I'm afraid hibernation is broken on all machines using radeon/KMS
>> >> >> > > > >> > with r300 after commit ce8f53709bf440100cb9d31b1303291551cf517f
>> >> >> > > > >> > (drm/radeon/kms/pm: rework power management).  At least, I'm able
>> >> >> > > > >> > to reproduce the symptom, which is that the machine hangs hard
>> >> >> > > > >> > around the point where an image is created (probably during the
>> >> >> > > > >> > device thaw phase), on two different boxes with r300 (the output
>> >> >> > > > >> > of lspci from one of them is attached for reference, the other one
>> >> >> > > > >> > is HP nx6325).
>> >> >> > > > >> >
>> >> >> > > > >> > Suspend to RAM appears to work fine at least on one of the
>> >> >> > > > >> > affected boxes.
>> >> >> > > > >> >
>> >> >> > > > >> > Unfortunately, the commit above changes a lot of code and it's not
>> >> >> > > > >> > too easy to figure out what's wrong with it and I didn't have the
>> >> >> > > > >> > time to look more into details of this failure.  However, it looks
>> >> >> > > > >> > like you use .suspend() and .resume() callbacks as .freeze() and
>> >> >> > > > >> > .thaw() which may not be 100% correct (in fact it looks like the
>> >> >> > > > >> > "legacy" PCI suspend/resume is used, which is not recommended any
>> >> >> > > > >> > more).
>> >> >> > > > >>
>> >> >> > > > >> Does it work any better after Dave's last drm pull request?
>> >> >> > > > >
>> >> >> > > > > Nope.  The symptom is slightly different, though, because now it
>> >> >> > > > > hangs after turning off the screen.
>> >> >> > > > >
>> >> >> > > > >> With the latest changes, pm should not be a factor unless it's
>> >> >> > > > >> explicitly enabled via sysfs.
>> >> >> > > > >
>> >> >> > > > > Well, I guess the first pm patch changed more than just pm, then.
>> >> >> > > >
>> >> >> > > > Does this patch help?
>> >> >> > > > http://lists.freedesktop.org/archives/dri-devel/2010-June/001314.html
>> >> >> > >
>> >> >> > > No, it doesn't.  I try to hibernate, everything works to the point where
>> >> >> > > the screen goes off and the box hangs (solid).  Normally, it would turn
>> >> >> > > the screen back on and continue with saving the image.
>> >> >> > >
>> >> >> > > But, since that happens with the patch above applied, I think it doesn't
>> >> >> > > really pass the suspend phase (IOW, it probably hangs somewhere in the
>> >> >> > > radeon's suspend routine).
>> >> >> >
>> >> >> > I've just verified that in fact hibernation works on HP nx6325 with
>> >> >> > 2.6.35-rc3, but it takes about 55 sec. to suspend the graphics adapter in
>> >> >> > the "freeze" phase.  Surprisingly enough, during suspend to RAM it works
>> >> >> > normally (as well as in the "poweroff" phase of hibernation).
>> >> >>
>> >> >> It takes 2 minutes on RV530:
>> >> >> https://bugzilla.redhat.com/show_bug.cgi?id=586522
>> >> >
>> >> > Well, my second affected box appears to hang somewhere in the radeon's suspend
>> >> > routine.
>> >>
>> >> Does the attached patch help?
>> >
>> > It helps, but from what I can see in the code, it still has a few problems.
>> >
>> > First, the mutex around cancel_delayed_work() in radeon_pm_suspend()
>> > doesn't really serve any purpose, because rdev->pm.pm_method cannot change
>> > at this point and cancel_delayed_work() only tries to delete the work's timer.
>> > Moreover, it doesn't prevent the work handler from running, in which case the
>> > handler can do some wrong things and will rearm itself to do some more wrong
>> > things going forward.  So, I think it's better to wait for the handler to run in case it's
>> > already been queued up and it should also be prevented from rearming itself in
>> > that case.
>> >
>> > Second, in radeon_set_pm_method() the cancel_delayed_work() is not sufficient
>> > to prevent the work handler from running and queing up itself for the next run
>> > (the failure scenario is that cancel_delayed_work_sync() returns 0, so the
>> > handler is run, it waits on the mutex and then rearms itself after the mutex
>> > has been released), so it looks like cancel_delayed_work_sync()
>> > should be used to make sure it's not going to run again, but calling
>> > that cancel_delayed_work_sync() from under the mutex is not a good idea.
>> >
>> > Finally, there's a potential deadlock in radeon_pm_fini(), where
>> > cancel_delayed_work_sync() is called under rdev->pm.mutex, but the
>> > work handler tries to acquire the same mutex (if it wins the race).
>> >
>> > So, I think something like the appended patch is needed.
>> >
>>
>> Looks reasonable.  Does it fix the suspend issue?
>
> Do you mean the $subject one?  Yes, it does.

Great.  Thanks for fixing that up.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

>
> Rafael
>
>
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > ---
>> >  drivers/gpu/drm/radeon/radeon.h    |    3 +-
>> >  drivers/gpu/drm/radeon/radeon_pm.c |   41 ++++++++++++++++++++++++++++++-------
>> >  2 files changed, 36 insertions(+), 8 deletions(-)
>> >
>> > Index: linux-2.6/drivers/gpu/drm/radeon/radeon_pm.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/gpu/drm/radeon/radeon_pm.c
>> > +++ linux-2.6/drivers/gpu/drm/radeon/radeon_pm.c
>> > @@ -397,13 +397,20 @@ static ssize_t radeon_set_pm_method(stru
>> >                rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
>> >                mutex_unlock(&rdev->pm.mutex);
>> >        } else if (strncmp("profile", buf, strlen("profile")) == 0) {
>> > +               bool flush_wq = false;
>> > +
>> >                mutex_lock(&rdev->pm.mutex);
>> > -               rdev->pm.pm_method = PM_METHOD_PROFILE;
>> > +               if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
>> > +                       cancel_delayed_work(&rdev->pm.dynpm_idle_work);
>> > +                       flush_wq = true;
>> > +               }
>> >                /* disable dynpm */
>> >                rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
>> >                rdev->pm.dynpm_planned_action = DYNPM_ACTION_NONE;
>> > -               cancel_delayed_work(&rdev->pm.dynpm_idle_work);
>> > +               rdev->pm.pm_method = PM_METHOD_PROFILE;
>> >                mutex_unlock(&rdev->pm.mutex);
>> > +               if (flush_wq)
>> > +                       flush_workqueue(rdev->wq);
>> >        } else {
>> >                DRM_ERROR("invalid power method!\n");
>> >                goto fail;
>> > @@ -418,9 +425,18 @@ static DEVICE_ATTR(power_method, S_IRUGO
>> >
>> >  void radeon_pm_suspend(struct radeon_device *rdev)
>> >  {
>> > +       bool flush_wq = false;
>> > +
>> >        mutex_lock(&rdev->pm.mutex);
>> > -       cancel_delayed_work(&rdev->pm.dynpm_idle_work);
>> > +       if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
>> > +               cancel_delayed_work(&rdev->pm.dynpm_idle_work);
>> > +               if (rdev->pm.dynpm_state == DYNPM_STATE_ACTIVE)
>> > +                       rdev->pm.dynpm_state = DYNPM_STATE_SUSPENDED;
>> > +               flush_wq = true;
>> > +       }
>> >        mutex_unlock(&rdev->pm.mutex);
>> > +       if (flush_wq)
>> > +               flush_workqueue(rdev->wq);
>> >  }
>> >
>> >  void radeon_pm_resume(struct radeon_device *rdev)
>> > @@ -432,6 +448,12 @@ void radeon_pm_resume(struct radeon_devi
>> >        rdev->pm.current_sclk = rdev->clock.default_sclk;
>> >        rdev->pm.current_mclk = rdev->clock.default_mclk;
>> >        rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
>> > +       if (rdev->pm.pm_method == PM_METHOD_DYNPM
>> > +           && rdev->pm.dynpm_state == DYNPM_STATE_SUSPENDED) {
>> > +               rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
>> > +               queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
>> > +                                       msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
>> > +       }
>> >        mutex_unlock(&rdev->pm.mutex);
>> >        radeon_pm_compute_clocks(rdev);
>> >  }
>> > @@ -486,6 +508,8 @@ int radeon_pm_init(struct radeon_device
>> >  void radeon_pm_fini(struct radeon_device *rdev)
>> >  {
>> >        if (rdev->pm.num_power_states > 1) {
>> > +               bool flush_wq = false;
>> > +
>> >                mutex_lock(&rdev->pm.mutex);
>> >                if (rdev->pm.pm_method == PM_METHOD_PROFILE) {
>> >                        rdev->pm.profile = PM_PROFILE_DEFAULT;
>> > @@ -493,13 +517,16 @@ void radeon_pm_fini(struct radeon_device
>> >                        radeon_pm_set_clocks(rdev);
>> >                } else if (rdev->pm.pm_method == PM_METHOD_DYNPM) {
>> >                        /* cancel work */
>> > -                       cancel_delayed_work_sync(&rdev->pm.dynpm_idle_work);
>> > +                       cancel_delayed_work(&rdev->pm.dynpm_idle_work);
>> > +                       flush_wq = true;
>> >                        /* reset default clocks */
>> >                        rdev->pm.dynpm_state = DYNPM_STATE_DISABLED;
>> >                        rdev->pm.dynpm_planned_action = DYNPM_ACTION_DEFAULT;
>> >                        radeon_pm_set_clocks(rdev);
>> >                }
>> >                mutex_unlock(&rdev->pm.mutex);
>> > +               if (flush_wq)
>> > +                       flush_workqueue(rdev->wq);
>> >
>> >                device_remove_file(rdev->dev, &dev_attr_power_profile);
>> >                device_remove_file(rdev->dev, &dev_attr_power_method);
>> > @@ -720,12 +747,12 @@ static void radeon_dynpm_idle_work_handl
>> >                        radeon_pm_get_dynpm_state(rdev);
>> >                        radeon_pm_set_clocks(rdev);
>> >                }
>> > +
>> > +               queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
>> > +                                       msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
>> >        }
>> >        mutex_unlock(&rdev->pm.mutex);
>> >        ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
>> > -
>> > -       queue_delayed_work(rdev->wq, &rdev->pm.dynpm_idle_work,
>> > -                                       msecs_to_jiffies(RADEON_IDLE_LOOP_MS));
>> >  }
>> >
>> >  /*
>> > Index: linux-2.6/drivers/gpu/drm/radeon/radeon.h
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/gpu/drm/radeon/radeon.h
>> > +++ linux-2.6/drivers/gpu/drm/radeon/radeon.h
>> > @@ -619,7 +619,8 @@ enum radeon_dynpm_state {
>> >        DYNPM_STATE_DISABLED,
>> >        DYNPM_STATE_MINIMUM,
>> >        DYNPM_STATE_PAUSED,
>> > -       DYNPM_STATE_ACTIVE
>> > +       DYNPM_STATE_ACTIVE,
>> > +       DYNPM_STATE_SUSPENDED,
>> >  };
>> >  enum radeon_dynpm_action {
>> >        DYNPM_ACTION_NONE,
>> >
>>
>>
>
>
