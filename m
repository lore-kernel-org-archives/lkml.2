Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1AFSEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:04:14 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40830 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1AFSEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:04:12 -0500
Subject: Re: [PATCH 12/12] [RFC] Introduce Alarm (hybrid) timers
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
	 <1294280159-2513-13-git-send-email-john.stultz@linaro.org>
	 <AANLkTi=i9bnAz9FoB_Q1u4pTOwpBCTHK4S21iukZWBpF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 10:04:01 -0800
Message-ID: <1294337041.4518.87.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 20:07 -0800, Arve Hjønnevåg wrote:
> On Wed, Jan 5, 2011 at 6:15 PM, John Stultz <john.stultz@linaro.org> wrote:
> > Its possible that I've missed some subtleties of the Android
> > alarm driver interface, and that some of the interface decisions
> > I've made may not allow Android to use this interface directly,
> > I'd be very interested if those details could be pointed out,
> > and hopefully we can find a good solution to get this useful
> > functionality upstream.
> >
> 
> I don't know how suited the posix interface is for this, but I think
> it is critical to prevent suspend while an alarm is pending. If an
> alarm is important enough to wake the system up from suspend, it is
> probably not safe to suspend right after it triggered. The android
> alarm driver holds a wakelock until user-space calls back in to wait
> for the next alarm, while in-kernel alarms are called from interrupt

Hrm. I was hoping to avoid wakelock discussions for now. What happens if
an app sets a single alarm and then never calls back in? I assume
closing the device drops the wakelock?

> context. The apis provided in include/linux/pm_wakeup.h should provide
> the functionality you need to prevent suspend until the alarms have
> been fully processed, but I have not tried this api yet.

Ok. I'll have to check out the pm_wakeup.h api and see if it can be
used.

> It would also be useful to still allow in-kernel alarms to be
> activated from atomic context (we currently do this in a couple of
> drivers to avoid using a second wakelock).

This is useful. I think I was being overly cautious using a mutex
instead of a spinlock for the base lock since I was worried about
calling into the RTC code which require mutexes, but we only do that at
suspend, so it should be ok to use a spinlock there. I'll revise and add
that in.

So otherwise, do you see any reason why android might not be able to
adapt this code to replace the android alarm timers?

thanks
-john


