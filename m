Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1DOWCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:02:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3087 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab1DOWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:02:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86117920"
Message-ID: <4DA8C072.3030705@codeaurora.org>
Date: Fri, 15 Apr 2011 15:02:26 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        dwalker@fifo99.com, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org> <20110415190319.GA24111@Krystal>
In-Reply-To: <20110415190319.GA24111@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Abhijeet Dharmapurikar (adharmap@codeaurora.org) wrote:
>> Drivers need to be aware whether the interrupt controller is a slow bus
>> and call read_irq_line in proper context.
> 
> Hrm, this strikes me as odd. Is there any way this generic API could
> handle the corner-cases without needed the caller to know this ?

Usually, a slow bus irq controller marks its irq as nested and has its 
irq handler running in thread context. In that case it will be safe to 
call irq_read_line from thread context. For the usual (non slow bus) irq 
controller we can always call irq_read_line within irq context.


This function is intended to be called from within the handler, to know 
if a rising edge or a falling edge caused the interrupt. It can be used 
in other places too, but then the driver needs to be careful about the 
interrupt controller slowbus nature.

The problem happens when this function is called from interrupt context 
when irq controller is slowbus. For example one has taken a spin_lock 
with interrupts disabled and now it wants to know the real time status 
on a pin that is controlled by a slow bus controller. The slowbus 
controller could end up sleeping and things go bad.

I should explain this more in the commit text. Will do so in the next 
revision of this patch.

>> + *	This function may be called from IRQ context only when
>> + *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
> 
> The comment here seems to imply "be careful when using this extremely
> fragile interface", which does not give me the warm safety feeling I
> would come to expect from a generic kernel API.
> 
> Any ideas on how to improve that ?

Well, even the enable_irq() and disable_irq_nosync() have the same 
calling restrictions. I picked this line from the comment block in 
enable_irq() function. You think I should explain it more in the 
upcoming patch?

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
