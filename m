Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1ANWnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:43:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25911 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1ANWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:43:40 -0500
Message-ID: <4D30D150.9030900@kernel.org>
Date: Fri, 14 Jan 2011 14:42:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Greg KH <greg@kroah.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
References: <20110111010714.GB32585@kroah.com> <4D2BB048.2050509@kernel.org> <1294723290.17779.349.camel@pasglop> <4D2BF9F3.5080709@kernel.org> <1294731467.17779.352.camel@pasglop> <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com> <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <alpine.LFD.2.00.1101140014590.2678@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1101140014590.2678@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 03:31 PM, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Yinghai Lu wrote:
> 
>>>
>>> What the hell is the root problem ?
>>
>> for patch
>>
>> x86: usb handoff in early_quirk
>>
>> some systems keep getting
>>   APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
>>   APIC delta adjusted to PM-Timer: 831249 (1163736)
>>
>> USB legacy SMI handler is not disabled at that time.
>>
>> According to Thomas:
>> | http://lkml.indiana.edu/hypermail/linux/kernel/0703.2/0420.html
>> | 
>> | The wrong calibration values are probably caused by SMM code trying to
>> | emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.
>> | This prohibits the accurate delivery of PIT interrupts, which are used
>> | to calibrate the local APIC timer. Unfortunately we have no way to
>> | disable this BIOS misfeature in the early boot process.
>>
>> Try to disable USB legacy support early with this patch.
>> So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
>> After this patch, that warning never show up for 100 reboot tests.
>>
>> reuse code from drivers/usb/host/pci-quirks.c
>>
>>
>> but pci-quirks.c is using udelay and msleep ...
>>
>> And BenH does't want 
>> 1. if (early)...
>> 2. include .c
>> 3. new API new about safe_udelay/safe_msleep...
>>
>> just want to keep the old udelay/mdelay.
> 
> NAK. That's the total wrong thing to do.
> 
> Do we have any indication that we miscalibrate? If no, then were is
> the point of this ? If yes, then I it's way easier to fix that than
> doing all this ugly churn.
> 
> We deal with that SMI crap in the TSC calibration as well and I'd
> rather see a combined TSC/APIC calibration than all this fugliness.

maybe disabling USB legacy support early patches could help this one?

http://ubuntuforums.org/archive/index.php/t-1289119.html

| Recently changed motherboard and cpu to
| gigabyte ga-ma790xt-ud4p and amd phenom II x4 965.
|
| Sometimes (and I mean sometimes) ubuntu 9.04 does not recognize
| all cpu cores, but 1 (sometimes :) even 2 or 3).
| I have tried Karmic(9.10), and at first it recognized all cores, but now it
| is back to normal (random not recognizing).
...
| sgb   October 16th, 2009, 01:03 PM
| Thanks everyone,
| I have resolved the issue.
| Unbelievable as it is: four port USB hub was responsible
| for this random behavior. As soon as it is removed,
| everything is working as it should.
| I am amazed...
| But it's working now. :)
| If anyone has any theory how windows bypassed it,
| and why linux *sometimes* did, and sometimes did not,
| I would really like to hear... :confused:
| Thanks again for Your effort.
