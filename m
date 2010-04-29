Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab0D3Rlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:41:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:58917 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab0D3Rlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:41:32 -0400
Subject: Re: [lm-sensors] Simple fan question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100429105740.6e3b7716@hyperion.delvare>
References: <1272518506.24542.163.camel@pasglop>
	 <20100429105740.6e3b7716@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Apr 2010 08:56:46 +1000
Message-ID: <1272581806.24542.185.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean !

> In your case, the file would have only 3 possible values, with "off"
> mapping to 0, and "slow" and "fast" mapping to arbitrary positive
> values, like 64 and 192 or whatever you think is suitable. I understand
> that in your case, you don't really control the PWM output directly,
> but we do not have any interface for this, and I don't think there
> would be much value in adding one.
> 
> That being said, I am also only mildly convinced that fitting your chip
> in the standard pwm1 interface will be very helpful. I don't really
> expect tools such as the fancontrol script to behave properly when the
> pwm1 file only support a small number of discrete values. So the
> benefit of using the standard file name and semantics seems thin.

Yes, I'm not too sure either.

> > Another comment while at it is when implementing the thermal control for
> > PowerMacs a while back (windfarm etc...) I had to deal with two
> > different type of interfaces to fans. RPM controlled and PWM controlled.
> > 
> > The later basically let me program a percentile value (a percent of the
> > duty cycle).
> 
> This is exactly what pwm[1-*] files are about, except that we used
> range 0-255 instead of 0-100 for historical and practical reasons.

Ok, I missed those in the doco.

> > I looks like the described sysfs interface only does RPM, or at least
> > doesn't provide a way to expose the units used...
> 
> For RPM-controlled, look at the following entry instead:
> 
> fan[1-*]_target
> 		Desired fan speed
> 		Unit: revolution/min (RPM)
> 		RW
> 		Only makes sense if the chip supports closed-loop fan speed
> 		control based on the measured fan speed.
> 
> One significant difference is that, in this case, you always know which
> fan you control, while in the pwm[1-*] case you don't.

Right.

Now, maybe the best option is to have instead:

	fan[1-*]_discrete_value
		Discrete value
                RW

	fan[1-*]_supported values
                List of supported discrete values
                RO

IE. I like the interface to be self-explanatory rather than relying on
the user to know in advance what to write there. In which case I could
either use 0,1,2 as values or even "off, slow, fast".

I can then make a custom fancontrol script (or add a wart to the
existing one) to deal with this HW.

What do you think ?

Another option of course is to do the whole thermal control in a kernel
thread :-) That wouldn't be very hard nor take a lot of code, but I'm
sure I'll encounter resistance trying to merge that :-)

Cheers,
Ben.

