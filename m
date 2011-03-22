Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1CVTo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:44:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40681 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1CVTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:44:53 -0400
Subject: Re: [PATCH v2] RTC: Selectively enable PIE-Hrtimer emulation.
From: John Stultz <john.stultz@linaro.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
In-Reply-To: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
References: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 12:44:36 -0700
Message-ID: <1300823076.2731.123.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 17:08 +0900, MyungJoo Ham wrote:
> The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
> events", has enabled PIE interrupt emulation with hrtimer unconditionally.
> However, we do have RTC devices that support PIE and such devices are
> not meant to be emulated by hrtimer.

I guess the question I want to ask here, is what is the value of getting
PIE interrupts over the hrtimer? For most cases it is yet another
interrupt. Could you expand a bit more on why you need real PIE irqs?

> Besides, we sometimes need RTC-PIE
> to function while hrtimer does not; e.g., CPU's RTC PIE as a
> suspend-to-RAM wakeup source.

So this indeed is a limitation. hrtimer emulated PIE's won't wake the
system up.  So is this a "Besides...sometimes" sort of case, or is PIE
wakeups really the only issue here?

To better understand the scope of the issue, I'd like to know more about
your uage of PIE mode as a wakeup source. Given PIE mode is for sub 1HZ
irqs, do you really use suspend/resume at a periodic rate multiple times
a second? Is this done with the current mainline kernel? What would be
the penalty of moving to a 1HZ wakeup?

If this indeed a critical limitation, then it needs to be solved.
However, instead of just re-enabling the pie mode access to userland
(which will likely need more then the patch here provides to avoid
breaking the RTC event multiplexing), I'd much prefer to see the the
solution as extending the in-kernel RTC API to allow for sub-second
resolution alarms, then using a periodic mode rtc alarm to emulate PIE
mode irqs out to userland.

Alessandro: Your thoughts here? As it seems most RTC hardware can handle
it, any objections to extending the in-kernel interface to provide
sub-second resolution (it doesn't mean they will provide it, but it
doesn't limit the hardware at the interface level).

> This patch allows to selectively use the PIE emulation. If the rtc
> driver has implemented PIE related ops (irq_set_state and irq_set_freq),

So, both irq_set_state and irq_set_freq were removed upstream in the
2.6.39-rc1 merge window, so this patch def won't work upstream. 

Sorry for the trouble here! Hopefully we can get things resolved and
working shortly here.

thanks
-john

