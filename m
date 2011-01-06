Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1AFUfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:35:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1AFUfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:35:01 -0500
Message-ID: <4D262771.4080100@redhat.com>
Date: Thu, 06 Jan 2011 10:34:57 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-3-git-send-email-zamsden@redhat.com> <F57C0733-9A1A-4A6D-9D62-39B836559878@suse.de> <4D25A710.5030500@redhat.com> <C35A7DC7-EBFD-464F-975E-F89886D299A8@suse.de>
In-Reply-To: <C35A7DC7-EBFD-464F-975E-F89886D299A8@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 01:40 AM, Alexander Graf wrote:
> On 06.01.2011, at 12:27, Zachary Amsden wrote:
>
>    
>> On 01/06/2011 12:34 AM, Alexander Graf wrote:
>>      
>>> Am 06.01.2011 um 11:10 schrieb Zachary Amsden<zamsden@redhat.com>:
>>>
>>>
>>>        
>>>> Use an MSR to allow "soft" migration to hosts which do not support
>>>> TSC trapping.  Rather than make this a required element of any
>>>> migration protocol, we allow the TSC rate to be exported as a data
>>>> field (useful in its own right), but we also allow a one time write
>>>> of the MSR during VM creation.  The result is that for the common
>>>> use case, no protocol change is required to communicate TSC rate
>>>> to the receiving host.
>>>>
>>>> This allows administrative tools to configure migration policy
>>>> as they see appropriate.  Rather than dictate this policy with the
>>>> KVM implementation, we properly allow migration to hosts which both
>>>> do and do not support setting of the TSC rate on the receiving end.
>>>> If it is wished to not support migration to a host which lacks
>>>> support for the TSC rate feature, that can be coordinated externally.
>>>>
>>>>          
>>> Isn't there a real hw equivalent of such a register? It might make more sense to just implement that then.
>>>
>>>
>>>        
>> Unfortunately, no.
>>      
> Bleks. I couldn't find anything in AMD documentation either. Intel documentation is usually hard to find and incomplete anyways, so maybe something's hiding there - but if it's hidden so well it's no use to implement either.
>    

While it makes perfect logical sense to us software people, from a 
hardware perspective it is ridiculous.  There is no signal input to the 
processor which can be counted and returned by a "CPU frequency MSR".  
The CPU frequency is simply what the CPU is clocked at.  And you can't 
burn it onto the die (think of overclocking), unless you have your own 
internal reference oscillator.

No, a CPU frequency MSR is impossible to implement sensibly in hardware 
because

1) if you have an internal clock, you have cross-CPU drift and can't 
easily share a common bus.
2) if you have an external clock, you have no way to measure the 
frequency of it without an internal reference, which again will vary, 
leading to different measured frequency on each CPU.

The only thing that sort of makes sense is a one-time writable MSR that 
is programmed by the BIOS to return the CPU frequency, as retrieved from 
the chipset.  This is merely a convenience for software people who can't 
be bothered to query the chipset directly or measure against a reference 
clock.

So as much as we'd like it, it really does make little sense from a 
hardware perspective.

Zach
