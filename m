Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1BCVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:37:36 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47425 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1BCVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:37:34 -0500
Subject: Re: [PATCH 0/4] RTC regression fixups
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTikgTNVkxeb+4HQonce-Y=z7EpxXn_SuwVj=EdE2@mail.gmail.com>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
	 <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com>
	 <1296760576.3336.324.camel@work-vm>
	 <AANLkTikgTNVkxeb+4HQonce-Y=z7EpxXn_SuwVj=EdE2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 13:37:27 -0800
Message-ID: <1296769047.3336.332.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 18:31 -0200, Marcelo Roberto Jimenez wrote:
> Hi John,
> 
> Currently, the RTC driver _must_ declare the read_alarm() callback,
> even if it does nothing. But the code in drivers/rtc/interface.c does
> 
> 	if (rtc->ops == NULL)
> 		err = -ENODEV;
> 	else if (!rtc->ops->read_alarm)
> 		err = -EINVAL;
> 	else {
> 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
> 		alarm->enabled = rtc->aie_timer.enabled;
> 		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
> 	}
> 
> The read_alarm() callback is not being performed.

So this was recently added by d5553a556165535337ece8592f066407c62eec2e
to handle the cases where the driver didn't support alarm irqs, and the
error wasn't being properly propagated upwards.

> Two questions:
> 
> 1 - Should the callback be removed or should it be kept and called in
> the else part?

So, we probably should change the check to set_alarm or some other flag
to check if the hardware supports irqs, then remove the driver
read_alarm() function.


> 2 - In case we are keeping it, should it be enforced like it is now,
> or should it be kept optional? I'd rather have it optional, that means
> less useless code in the drivers.

Yes. We want to minimize the unnecessary code. I'll take a shot at it
shortly here.

Also, to avoid duplicate work, please see my dev/rtc-cleanups branch
here:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/rtc-cleanups

I've got some patches that remove the dead irq_set_state, irq_set_freq
and update_irq_enable functions from the rtc drivers. It would be great
if you were able to give those patches a whirl to make sure I didn't
flub anything.

thanks
-john



