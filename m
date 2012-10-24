Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865Ab2JXPeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:14 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52764 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933942Ab2JXPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:06 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzz17326ah8275bh5eeeKz2dh668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MCELWN-01-3R8-02
X-M-MSG: 
Message-ID: <50880AD7.2030806@amd.com>
Date: Wed, 24 Oct 2012 17:35:51 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86/amd: disable way access filter on affected CPUs
References: <1351065377-1989-1-git-send-email-andre.przywara@amd.com> <20121024104609.GA13010@gmail.com>
In-Reply-To: <20121024104609.GA13010@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 12:46 PM, Ingo Molnar wrote:
>
> * Andre Przywara <andre.przywara@amd.com> wrote:
>
>> The WAF may hurt the performance of some workloads, caused by
>> aliasing issues in the L1 cache.
>> Disable it on the affected CPUs.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
>> ---
>>   arch/x86/kernel/cpu/amd.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index f7e98a2..1b7d165 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>>   		}
>>   	}
>>
>> +	/*
>> +	 * The way access filter has a performance penalty on some workloads.
>> +	 * Disable it on the affected CPUs.
>> +	 */
>> +	if ((c->x86 == 0x15) &&
>> +	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
>> +		u64 val;
>> +
>> +		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
>> +			val |= 0x1E;
>> +			wrmsrl_safe(0xc0011021, val);
>> +		}
>> +	}
>
> Would be nice to hear more about the background of this change,
> about the amount of 'penalty' and the nature of the workloads.

The issue is similar to that one of last year:
http://lkml.indiana.edu/hypermail/linux/kernel/1107.3/00041.html
That new patch does not replace the old one, we just need another quirk 
for newer CPUs.

The penalty depends on the circumstances, if you need a number, I can 
only tell you the 3% from last year.

The workloads would be those that access code from the same physical 
page under different virtual addresses, so different processes using the 
same libraries with ASLR or multiple instances of PIE-binaries.
The code needs to be accessed simultaneously from both cores of the same 
compute unit.

More details here:
http://developer.amd.com/Assets/SharedL1InstructionCacheonAMD15hCPU.pdf

> Also, it would be useful to know how the [0x02..0x1f] model
> range was chosen.

That is everything that has the core known as Piledriver.
That includes the AMD A-Series (aka Trinity) and the just released new 
CPUs of the FX-Series (aka Vishera).
The model numbering is a bit odd here: FX CPUs have model 2, A-Series 
has model 10h, with possible extensions to 1Fh. Hence the range of model 
ids.
Model 2 CPUs should have the fix in BIOS, but I guess there are quite 
some boxes out there which will not be updated. Better safe than sorry.

Regards,
Andre.

-- 
Andre Przywara
AMD-OSRC (Dresden)
Tel: x29712

