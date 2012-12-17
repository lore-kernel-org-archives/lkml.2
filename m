Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2LQNLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:11:24 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:59137 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LQNLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:11:23 -0500
Message-ID: <50CF19EA.3070203@itwm.fraunhofer.de>
Date: Mon, 17 Dec 2012 14:11:06 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Weidong Han <weidong.han@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>, sbsiddha@gmail.com
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com> <50CE12EB.1050804@itwm.fraunhofer.de> <20121216191347.GB14678@liondog.tnic> <50CE24FE.3030409@itwm.fraunhofer.de> <20121216203913.GB14643@liondog.tnic> <50CEE736.8020000@itwm.fraunhofer.de> <20121217100014.GA31866@liondog.tnic>
In-Reply-To: <20121217100014.GA31866@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 11:00 AM, Borislav Petkov wrote:
> + Suresh.
>
> On Mon, Dec 17, 2012 at 10:34:46AM +0100, Bernd Schubert wrote:
>> On 12/16/2012 09:39 PM, Borislav Petkov wrote:
>>> On Sun, Dec 16, 2012 at 08:46:06PM +0100, Bernd Schubert wrote:
>>>> Hmm, I read it the other way around - x2apic depends on interrupt
>>>> remapping, but interrupt remapping can be used without x2apic.
>>>
>>> Ok, you're right. X2APIC should depend on IRQ_REMAP:
>>> https://lwn.net/Articles/289881/
>>>
>>>> The help text of CONFIG_IRQ_REMAP also says "x2APIC enhancements or to
>>>> support platforms with CPU's having > 8 bit APIC ID, say Y." I guess
>>>> may CPU has the latter?
>>>
>>> I think it is what Yinghai said - you obviously need x2apic kernel
>>> support if you have IRQ_REMAP on.
>>>
>>>> Can the kernel panic a bit improved to help user to understand what
>>>> needs to be enabled?
>>>
>>> Well, your kernel enables IRQ_REMAP properly:
>>>
>>> [    0.031115] Enabled IRQ remapping in x2apic mode
>>>
>>> I guess at that stage we could probably check for x2apic support and
>>> scream loudly if it is not present... IMHO.
>>>
>> Hmm, I think that would the wrong place,
>
> It has to be the right place because this "Enabled IRQ..." printk above
> is from the IRQ remapping code which detects an x2apic mode in your
> case.
>
>> as the initial 3.7.0 configuration didn't have IRQ_REMAP enabled.
>
> Huh, so why do I see the above message in your dmesg output in
> http://marc.info/?l=linux-kernel&m=135540103415652 then?

Oh huh, that is the dmesg from 3.4.7, which booted fine. I just sent it 
hoping it would help to see where the issue comes from.
When I run "make oldconfig" for 3.7.0 I accidentally unset 
CONFIG_IRQ_REMAP, wich also unset CONFIG_X86_X2APIC :(

>
> Ok, let's sort things out here. Your .config has
>
> # CONFIG_IRQ_REMAP is not set
>
> but in the original dmesg you sent, the printk above comes from
> intel_irq_remapping.c which gets enabled by CONFIG_IRQ_REMAP.
>
> So, can you try enabling only CONFIG_IRQ_REMAP and leave
> CONFIG_X86_X2APIC off to confirm the original observation?

No need, as I said above, the printk comes from a different kernel with 
a different config. With either CONFIG_IRQ_REMAP=false or 
CONFIG_X86_X2APIC=false the booting ends in a kernel panic.

>
> Also, I'd guess your machine can boot with both options off?

No, only partly with "noapic", but that makes ahci to fail to detect 
disks later on.

>
>> And that was the reason why x2apic got disabled during the "make
>> oldconfig" process...
>>
>> Is this message an indication for missing x2apic?
>>
>> "smpboot: weird, boot (#255) not listed by the BIOS"
>
> It's an indication that something is fishy with the apic IDs.
>
> Thanks.
>


Cheers,
Bernd
