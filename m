Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1CKTCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:02:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45952 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1CKTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:02:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6282"; a="79266136"
Message-ID: <4D7A71B9.9000306@codeaurora.org>
Date: Fri, 11 Mar 2011 11:02:17 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org> <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6> <4D79A85D.8000301@codeaurora.org> <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Yes however while updating the code I noticed that I would need to keep
>> account of all the interrupts enabled and all the interrupts marked wakeup.
>> This aids in switching to the wakeup set in the suspend callback and the
>> enabled set in the resume callback. I will update the resume callback to
>> enable the interrupts in irqs_allowed(the local state storage) in the next
>> patch (my current patch does not do that).
>>
>> IOW I need to keep the local state storage.
> 
> Wrong. The interrupts are disabled and reenabled by the core code and
> not by some extra suspend/resume callbacks in your driver. The core
> checks those marked as IRQ_WAKE, the wake callback to the irq chip is
> only there if you need to set up some hardware register in order to
> make the wake functionality work. So again, you don't need local state
> as the core tracks the state for you.

Help me understand this, the core code calls disable on all the 
interrupts while going to suspend. Notice that I have no disable 
callback, which means those interrupts remain unmasked.

I could have a situation, when the system(a mobile phone) goes to 
suspend we dont want to wake it up because of unnecessary interrupts. A 
good example is, we want to wakeup the phone if the battery goes low, 
but dont want to wake it up if an acceleromter interrupt triggers. The 
drivers respectively mark the battery low interrupt as wakeup and the 
accelerometer interrupt as a non-wake up interrupt. Assume both of them 
are edge triggered interrupts.

The genirq code does not mask the interrupt while going to suspend, it 
only calls disable(), which I understand should not mask the interrupt 
for check_wakeup_irqs() to work.

If I don't mask that accelerometer interrupts in the interrupt 
controller's suspend() the phone will wakeup every time the user moves 
around, draining the battery unnecessarily.

One might say that the accelerometer should be deactivated in the 
suspend callback of the accelerometer driver. Yes this can be done and 
we will not see an interrupt while suspended. However not all hardware 
can be deactivated like that. There are some devices which simply 
interrupt and the only way to keep from waking up is masking their 
interrupts.

How do you suggest I mask the accelerometer interrupt?

Abhijeet
--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
