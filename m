Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab1B0BBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 20:01:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40975 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1B0BBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=snzneEhhUOD1HSrB6ShFAmQnp/1SLLO0ADx9npLP/Xm1d6opaxMDQdTPadbFhpHTrp
         E54jzP63vf0AYci1tlzfaQTirWQcVb5+n7uqIjTwjOjYmCMKTGV+Q3Jevjp2WeABGe7Z
         6gIHUTQvaZ/PfoVoow1v0A0k5kSx6Z9mN0B/c=
MIME-Version: 1.0
In-Reply-To: <4D6917C6.2050509@gmail.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
	<1294348732-15030-6-git-send-email-dzickus@redhat.com>
	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
	<4D68B397.6040809@gmail.com>
	<AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
	<4D68F346.1000500@gmail.com>
	<AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>
	<4D6917C6.2050509@gmail.com>
Date: Sun, 27 Feb 2011 09:01:17 +0800
Message-ID: <AANLkTinRyzkt_PtbnM4pNUUd7gwXSMQsTOVS9otG7v6D@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: huang ying <huang.ying.caritas@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 11:09 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 02/26/2011 05:07 PM, huang ying wrote:
>>
>> On Sat, Feb 26, 2011 at 8:34 PM, Cyrill Gorcunov<gorcunov@gmail.com>
>>  wrote:
>> [snip]
>>>>
>>>> Why?  Without LVT reconfig, system with this patch can not work
>>>> properly?
>>>
>>>  I guess we have a few nits here -- first an important comment were
>>> removed which doesn't reflect what happens on hw level for real. At
>>> least we should put it back just to not confuse people who read this
>>> code, something like
>>>
>>>        /*
>>>         * FIXME: Only BSP can see external NMI for now and hot-unplug
>>>         * for BSP is not yet implemented
>>>         */
>>>        WARN_ON_ONCE(smp_processor_id());
>>>
>>>  The reason for WARN_ON_ONCE here is that -- imagine the situation when
>>> perf-nmi happens on one cpu with external nmi on BSP and for some reason
>>> (say code on upper level is screwed\bogus or anything else) nmi-notifier
>>> didn't handled it properly as result we might have a report like "SERR
>>> for
>>> reason xx on CPU 1" while this cpu didn't see this signal at all. And
>>> then
>>> due to locking ordering BSP will see unknown nmi while in real those nmi
>>> belongs
>>> him and it was CPU 1 who observed erronious NMI from upper level. Note
>>> this
>>> is theoretical scenario I never saw anything like this ;)
>>
>> Yes.  That is possible, at least in theory.  But similar issue is
>> possible for original code too.  For example, On CPU 0,
>>
>> 1. perf NMI 1 triggered
>> 2. NMI handler enter
>> 3. perf NMI 2 triggered (1 NMI is pending)
>> 4. perf NMI handler handled 2 events
>> 5. NMI handler return
>> 6. NMI handler enter (because of pending NMI)
>> 7. external NMI triggered (another NMI is pending)
>> 8. external NMI handler handled SERR
>> 9. NMI handler return
>> 10. NMI handler enter (because of pending NMI)
>> 11. unknown NMI triggered
>>
>> If my analysis is correct, this kind of issue can not be resolved even
>> if we revert to original code.
>>
>> Best Regards,
>> Huang Ying
>
>  Of course there is a way to hit unknown nmi if upper level is screwed (we
> may see this with p4
> pmu on ht machine+kgdb which I didn't manage to fix yet) but with the former
> code an external nmi would
> not ever be handled by cpu which apic is not configured as a listener
> regardless anything. Ie there was 1:1
> mapping between extnmi observer and handler.
>
>  Probably we should put question in another fashion, ie in the fasion of
> overall design -- who should be
> responsible for handling external nmis, 1) the cpu which apic is configured
> to observe such nmis or 2) any cpu?
> If we take 1) then no lock is needed and underlied code will report real cpu
> number who observed nmi. If
> we take 2) then lock is needed but we need a big comment in default_do_nmi
> together with probably cpu number
> fixed in serr\iochk printk's.

I am OK with both solutions.

Best Regards,
Huang Ying
