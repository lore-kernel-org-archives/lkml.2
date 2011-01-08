Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1AHKg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 05:36:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41108 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1AHKg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 05:36:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
Date: Sat, 8 Jan 2011 11:36:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org> <AANLkTin8cntsFpaikpfzPbWL1YFb702rPync240X4axW@mail.gmail.com> <1294367420.4518.171.camel@work-vm>
In-Reply-To: <1294367420.4518.171.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101081136.06682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 07, 2011, John Stultz wrote:
> On Thu, 2011-01-06 at 16:58 -0800, Arve Hjønnevåg wrote:
> > 2011/1/6 John Stultz <john.stultz@linaro.org>:
> > > So otherwise, do you see any reason why android might not be able to
> > > adapt this code to replace the android alarm timers?
> > >
> > 
> > The user-space interface does not look appealing, but I don't see any
> > reason why the in-kernel interface(s) cannot be shared. Our user-space
> > code has a single thread that waits for alarms to trigger, while the
> > alarms can be modified from any thread.
> 
> So its something like nanosleep(), only other threads can extend or
> shorten the sleep time?
> 
> Could you explain some of the rational for such an interface, so I can
> better understand the need?
> 
> >  As far as I can tell, using
> > the posix interface would either require a thread per alarm (up to 5)
> > or using signals. Both make the user-space code more complicated, and
> 
> Yea, it probably would need signals, but I'd have to grok the use case a
> little better. And its possible it would complicate the user-space code
> some, but on the other hand, it would be using a more standard kernel
> interface. The other option is extending the posix interface to try to
> better match the need.
> 
> > it is not clear if either of them provide a clear hand-off between
> > where the kernel needs to block suspend because the alarm has not been
> > delivered to user-space and where user-space needs to block suspend
> > because it is handling the alarm.
> 
> Indeed. I'm still looking into the pm_wake details to see the
> limitations there. Some method of inheriting a stay_awake seems to be
> needed, but sounds pretty ugly. Alternatively we may need some method or
> callback to the kernel to detect that a signal has been handled by
> userland (allowing the pm_relax to occur).
> 
> Rafael: Any thoughts here?

I think this problem is specific to Android where suspend is started
automatically from kernel space, so user space needs an interface to actively
prevent the kernel from starting suspend.

The mainline model is that suspend will always be started from user space,
so instead of telling the kernel not to suspend user space needs to avoid
starting suspend in the first place.  In this model the kernel code can simply
call pm_relax() as soon as _it_ doesn't need to prevent the system from
suspending any more (eg. it knows that user space has learnt of the alarm) and
it need not worry about the user space part (eg. whether or not user space
is still handling the alarm). 

Thanks,
Rafael
