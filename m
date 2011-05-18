Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1ERUSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:18:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1ERUSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:18:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 2/2] PM / Core: partial resume/suspend API for suspend_again users.
Date: Wed, 18 May 2011 22:18:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, kyungmin.park@samsung.com
References: <20110512061928.GB2460@localhost.ucw.cz> <201105172252.32135.rjw@sisk.pl> <BANLkTinWF108dOaL-u7Y9vU9Z5X-vSn8zQ@mail.gmail.com>
In-Reply-To: <BANLkTinWF108dOaL-u7Y9vU9Z5X-vSn8zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182218.50088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, MyungJoo Ham wrote:
> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Tuesday, May 17, 2011, MyungJoo Ham wrote:
> >> A usage example is:
> >>
> >> bool example_suspend_again(void)
> >> {
> >>       int error, monitor_result;
> >>
> >>       if (!wakeup_reason_is_polling())
> >>               return false;
> >>
> >>       dpm_partial_resume(PMSG_RESUME, devs, ARRAY_SIZE(devs));
> >
> > I'm not sure you need the first argument here.  Also, if the array is
> > NULL terminated, you won't need the third one.
> >
> 
> It was to pass the parameter to device_resume(), pm_dev_err(),
> device_complete(), and device_prepare(), which have been using the
> state value. However, as it is supposed to be used in the context of
> suspend_devices_and_enter(), I'll remove it and assume PMSG_SUSPEND
> and PMSG_RESUME are in effect.
> 
> For the array style, do we generally prefer to use NULL at the end
> rather than supplying the size? If so, I'll change the array style.
> 
> >>       resume_console();
> >>
> >>       monitor_result = monitor_something();
> >>
> >>       suspend_console();
> >>       error = dpm_partial_suspend(PMSG_SUSPEND, devs, ARRAY_SIZE(devs));
> >
> > Same here.
> >
> >>       if (error || monitor_result == ERROR)
> >>               return false;
> >>
> >>       return true;
> >> }
> >
> > That said, I don't like this patch.  The reason is that you call
> > suspend_enter() is a loop and it calls the _noirq() callbacks for
> > _all_ devices and now you're going to only call .resume() and
> > .suspend() for several selected devices.  This is not too consistent.
> >
> > I wonder if those devices needed for .suspend_again() to work on
> > your platform could be resumed and suspended by their drivers'
> > _noirq() callbacks?
> 
> For now, we need to access PMIC, Fuel-Gauge, Charger (implemented as
> regulators), RTC, ADC (w/ hwmon), and UART(drivers/tty/serial).
> For PMIC, Fuel-Gauge, Charger, and RTC, they will work with no_irq
> callbacks without any modification.
> ADC will work if we just let it suspend and resume with no_irq callbacks.
> 
> However, for UART/serial, although it is only used for debugging, it
> wouldn't be easy and clean to enable only with no_irq callbacks. If we
> can keep observing the console with suspend_console_enabled=0, it
> would be much helpful.
> In order to let some UART/serial drivers work with no-irq callbacks,
> we'd need reconstruction in drivers/tty/serial/serial_core.c, too.
> 
> Anyway, as the effect of not having partial suspend/resume is limited
> for now (support for UART/serial can wait), I may defer this part and
> wait for better and clean methods. And yes, because of the possibility
> of having dependencies between devices, the inconsistency you've
> mentioned could be an issue for some systems. However, because such
> dependencies are not explicitly expressed to kernel while the platform
> should know about them, partial_suspend/resume was supposed to be
> called by the platform's suspend_again ops.

This is a difficult problem in general.  One solution of it I had been
considering some time ago might be to use two or more "suspend lists"
of devices instead of the single dpm_list we have right now.

Namely, suppose we have an array of lists that are idexed by priority
such that devices in the list of priority 0 are suspended first,
devices in the list of priority 1 are suspended next and so on (the
oredering of resume will have to be reversed).  Then, your new code may
request to only resume the highest pririty list and then call .suspend_again()
and possiblty continue with normal resume if it returns "false".
[Please note that you need to call .resume_noirq() for all devices anyway,
because device interrupts cannot be enabled before calling any drivers'
.resume_noirq() in case .suspend_again() returns "false".]

Devices will be added to the priority 0 list during registration and
there will be a special function to move a device to another list
(increase its suspend pririty) that will ensure the requisite dependencies
are met (i.e. the suspend priority of a device cannot be greater than
the suspend priority of its parent, so that the parent would be suspended
first).

Thanks,
Rafael
