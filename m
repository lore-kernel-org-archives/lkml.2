Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1DOXGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:06:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11973 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1DOXGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:06:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="85929007"
Message-ID: <4DA8CF7F.7020904@codeaurora.org>
Date: Fri, 15 Apr 2011 16:06:39 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mathieu.desnoyers@efficios.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        dwalker@fifo99.com, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1104152058050.2744@localhost6.localdomain6> <4DA8C1E2.3020205@codeaurora.org> <alpine.LFD.2.00.1104160030480.2744@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1104160030480.2744@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 15 Apr 2011, Abhijeet Dharmapurikar wrote:
> 
>> Thomas Gleixner wrote:
>>> On Fri, 15 Apr 2011, Abhijeet Dharmapurikar wrote:
>>>
>>>> Some drivers need to know what the status of the interrupt line is.
>>>> This is especially true for drivers that register a handler with
>>>> IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and in the handler they
>>>> need to know which edge transition it was invoked for.
>>> What's the purpose of this? How is that going to be used?
>> The main purpose is to know in the handler if it was invoked becuase of a
>> rising edge or the falling edge.
> 
> Come on. That's not an explanation. I know that already and it does
> not answer my question how this is going to be used. IOW: What does
> the driver do aside of knowing that it was a rising falling edge?
>  
>> Now one could say that the driver should maintain some state and toggle it
>> upon each invocation of this handler. That scheme quickly goes out of sync
>> because we might ignore interrupts while suspended.
> 
> Suspend is a totaly different issue. I have the impression that you
> are trying to solve some basic issue at the driver level again - just
> this time you add some core helper to get it solved.
> 
> Can you please show _AND_ explain the code which is going to use this?

Sorry, misunderstood your question. Dont have code ready yet but here 
are few examples which I need to address in the near future

The USB_ID pin is an interrupt to the pmic. This pin is used to detect 
if a peripheral or a host is connected. If a peripheral is connected the 
  ID pin is driven low (for the host case it remains floating) and when 
it is removed a pull up draws it high. We want to detect in the handler 
whether it was invoked when the cable was plugged in or when cable was 
plugged out. That helps the handler decide to turn on/off a regulator 
which provides power to the peripheral.

A similar scheme applies to VBUS line of the USB too. If it goes high 
that means a USB cable from host (or charger) is plugged in, if it goes 
low USB cable was removed out. Enumeration/charging begins or stops 
depending on the value read from the interrupt pin.

The battery temperature too is an edge interrupt. If it goes high it 
means battery temp is either too hot or cold, charging needs to stop. 
Charging can be resumed when this interrupt goes low.

There are many more such interrupts including battery insertion/removal, 
sdcard insertion/removal, few keys on the phone etc which can benefit 
from this api.

Note that these are not gpio lines configured as interrupts. If it were 
gpio lines I can easily derive the gpio number (irq_to_gpio()) and read 
the line.

I hope this clarifies my problem a bit more.

I can provide an api in my irq controller driver - lets call it 
pm8xxx_read_irq_line(int irq) and ask the drivers to call it but thought 
doing it via irq_chip could benefit other irq_controllers.

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
