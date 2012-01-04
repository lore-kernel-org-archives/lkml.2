Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2ADSdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:33:45 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50400 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2ADSdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:33:43 -0500
Message-ID: <1325701967.3037.97.camel@work-vm>
Subject: Re: RTC revert request
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, NeilBrown <neilb@suse.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Date: Wed, 04 Jan 2012 10:32:47 -0800
In-Reply-To: <CA+55aFxybC2Y-EK4uFJUvj==8kkrokxJh-AWNCyo+9W+DdTw-Q@mail.gmail.com>
References: <1325648169.3037.84.camel@work-vm>
	 <CA+55aFxybC2Y-EK4uFJUvj==8kkrokxJh-AWNCyo+9W+DdTw-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010418-9360-0000-0000-0000021799E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 19:49 -0800, Linus Torvalds wrote:
> On Tue, Jan 3, 2012 at 7:36 PM, john stultz <johnstul@us.ibm.com> wrote:
> >
> > Thus, would you please revert:
> >
> > 93b2ec0128c431148b216b8f7337c1a52131ef03
> > rtc: Expire alarms after the time is set.
> >
> > and
> >
> > c0afabd3d553c521e003779c127143ffde55a16f
> > rtc: Disable the alarm in the hardware
> 
> Ok, I picked up on the second revert already because of being cc'd on
> the discussion about the stable tree.

Thanks. Sorry for being repetitive, I just wanted to make sure you saw
both.

> Can you point me at the background for that first one, or write a
> changelog for the revert for me? I don't want to have reverts without
> background and explanation of them..

Sure. Here's my assessment of the problem:
	https://lkml.org/lkml/2012/1/3/425

Here's Neil's comments, filling in more on the original issue, as well
as his agreement that we should revert for now:
	https://lkml.org/lkml/2012/1/3/454


The basic summary is that we need to ensure that RTC alarms in the past
are not added to the timerqueue, or if time is set forward, we properly
expire any alarms that are set to the past. Neil's patch does this by
scheduling the timer expiry function when we set the RTC time and at
initialization, when the hardware alarm could return a value in the
past. 

Unfortunately, the second case can cause a null pointer dereference if
the scheduled work runs prior to us completing the registration
function. Since the registration function isn't complete, the we haven't
yet returned a valid rtc structure pointer. And the scheduled work may
require that pointer.

This issue so far has only cropped up on Xen SMP guests, where
registration function takes longer and the scheduled work can quickly
run on another cpu before the registration function returns. Regardless
its a clear bug.

The right fix is likely to fix the initialization so that we don't use
any hardware alarm values that are in the past at registration time.
However, such a change will require more testing and this close to a
release I'd be more comfortable just reverting the problematic change.

Is that ok for a log?

thanks
-john







