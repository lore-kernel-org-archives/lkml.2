Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0EKBiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:38:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51978 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab0EKBiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:38:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <D1C79E74038141C1BCD3EF70A5032E34@rainbow>
From: "Iram Shahzad" <iram.shahzad@jp.fujitsu.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
References: <20090206060328.181057235@goodmis.org> <9D38EE7159934A5C85505E9517638040@rainbow> <alpine.LFD.2.00.1005101707410.3401@localhost.localdomain>
Subject: Re: hrtimer: about hres_active
Date: Tue, 11 May 2010 10:39:12 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Many thanks for the reply. I understood why hrtimer list
is not checked in hrtimer_get_next_event in the case of
high res active.

Please let me ask more about the following.

> No. The system switches to high resolution mode late in the boot
> process and it does so only when there is high res capable hardware
> available.

So far as I checked, hres_active is set to 1 in hrtimer_switch_to_hres.
hrtimer_switch_to_hres is only called from hrtimer_run_pending.
And hrtimer_run_pending is called from timer wheel softirq.
That is why I concluded that hres_active is set at 1st timer softirq.
Do you just mean that it is not the 1st softirq, or do you
mean that in some other place in the late boot process
there is another code which sets hres_active?

And is it correct that hres_active remains 1 forever once set to it?

Best regards
Iram

----- Original Message ----- 
From: "Thomas Gleixner" <tglx@linutronix.de>
To: "Iram Shahzad" <iram.shahzad@jp.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Tuesday, May 11, 2010 12:12 AM
Subject: Re: hrtimer: about hres_active


> Iram,
> 
> On Mon, 10 May 2010, Iram Shahzad wrote:
> 
>> I am trying to understand the purpose of "hres_active" of hrtimer
>> and have the following question in this regard.
>> 
>> It seems "hres_active" indicates whether high resolution mode is
>> active or not. But I am not clear about the idea behind it.
>> 
>> I see that hres_active is initialized to 0 here:
>>    hrtimer_init_hres
>> 
>> and set to 1 here:
>>    hrtimer_run_pending
>>       -> hrtimer_switch_to_hres
>> 
>> That means hrtimer becomes "active" at the 1st timer softirq
>> and remains so forever. Is this understanding correct?
> 
> No. The system switches to high resolution mode late in the boot
> process and it does so only when there is high res capable hardware
> available.
> 
>> My original concern is as follows:
>> 
>> hrtimer_get_next_event returns KTIME_MAX when hrtimer is "active".
>> So if the above understanding is correct, then after the 1st timer
>> softirq it will always return KTIME_MAX. This means cpu_idle will never
>> take the hrtimer event into account and will always base its decision
>> on the next event of the timer wheel. Is this intended behaviour?
> 
> Yes it is. In the case of high res active the hrtimer which is the
> next to expire is already armed on that CPU in the clock event
> device. Therefor we know already when the next hrtimer will fire. No
> need to lookup further. But we have to check the timer wheel as it
> might have a timer which is due earlier than the first to expire
> hrtimer.
> 
> Thanks,
> 
> tglx
>

