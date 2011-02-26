Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1BZPKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:10:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52599 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1BZPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:10:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vsa7zbncCqHFJXa0rZ3y77EPiu8rzJ5zaZxEgVK27pnQ2c2oW3YFYWDoWrQPJZyyMU
         kpzE/t1A5Ub3WCN5LD1I3ntLWjE7XByRE4zi0hSHEmintmHxHw1Fj4JPNrFvK1YSaoVj
         P8T5P/APi0+CH9sgiQkMhc7zXk2AsLs0JHehQ=
Message-ID: <4D6917C6.2050509@gmail.com>
Date: Sat, 26 Feb 2011 18:09:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be processed
 on any CPU
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>	<1294348732-15030-6-git-send-email-dzickus@redhat.com>	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>	<4D68B397.6040809@gmail.com>	<AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>	<4D68F346.1000500@gmail.com> <AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>
In-Reply-To: <AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 05:07 PM, huang ying wrote:
> On Sat, Feb 26, 2011 at 8:34 PM, Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
> [snip]
>>> Why?  Without LVT reconfig, system with this patch can not work
>>> properly?
>>
>>   I guess we have a few nits here -- first an important comment were
>> removed which doesn't reflect what happens on hw level for real. At
>> least we should put it back just to not confuse people who read this
>> code, something like
>>
>>         /*
>>          * FIXME: Only BSP can see external NMI for now and hot-unplug
>>          * for BSP is not yet implemented
>>          */
>>         WARN_ON_ONCE(smp_processor_id());
>>
>>   The reason for WARN_ON_ONCE here is that -- imagine the situation when
>> perf-nmi happens on one cpu with external nmi on BSP and for some reason
>> (say code on upper level is screwed\bogus or anything else) nmi-notifier
>> didn't handled it properly as result we might have a report like "SERR for
>> reason xx on CPU 1" while this cpu didn't see this signal at all. And then
>> due to locking ordering BSP will see unknown nmi while in real those nmi
>> belongs
>> him and it was CPU 1 who observed erronious NMI from upper level. Note this
>> is theoretical scenario I never saw anything like this ;)
>
> Yes.  That is possible, at least in theory.  But similar issue is
> possible for original code too.  For example, On CPU 0,
>
> 1. perf NMI 1 triggered
> 2. NMI handler enter
> 3. perf NMI 2 triggered (1 NMI is pending)
> 4. perf NMI handler handled 2 events
> 5. NMI handler return
> 6. NMI handler enter (because of pending NMI)
> 7. external NMI triggered (another NMI is pending)
> 8. external NMI handler handled SERR
> 9. NMI handler return
> 10. NMI handler enter (because of pending NMI)
> 11. unknown NMI triggered
>
> If my analysis is correct, this kind of issue can not be resolved even
> if we revert to original code.
>
> Best Regards,
> Huang Ying

   Of course there is a way to hit unknown nmi if upper level is screwed (we may see this with p4
pmu on ht machine+kgdb which I didn't manage to fix yet) but with the former code an external nmi would
not ever be handled by cpu which apic is not configured as a listener regardless anything. Ie there was 1:1
mapping between extnmi observer and handler.

   Probably we should put question in another fashion, ie in the fasion of overall design -- who should be
responsible for handling external nmis, 1) the cpu which apic is configured to observe such nmis or 2) any cpu?
If we take 1) then no lock is needed and underlied code will report real cpu number who observed nmi. If
we take 2) then lock is needed but we need a big comment in default_do_nmi together with probably cpu number
fixed in serr\iochk printk's.

-- 
     Cyrill
