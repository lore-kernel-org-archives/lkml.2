Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1BZMeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 07:34:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55577 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1BZMeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 07:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RnJYAgjKeKfsRlrLoxy65tbb7T2U8p6G7TBZLSo3tFH0LZ+pa8em5f7PVp5fBjmk9B
         PW7VvaXwGrmknVbRyss3jmgWWMcazC8Xqyz0XNIPUAfsque021QaWd72NU9VtId/WUg/
         zPyYts/v984S4YGCafS3i/W7pc1y3sRKtcU5Q=
Message-ID: <4D68F346.1000500@gmail.com>
Date: Sat, 26 Feb 2011 15:34:14 +0300
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
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>	<1294348732-15030-6-git-send-email-dzickus@redhat.com>	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>	<4D68B397.6040809@gmail.com> <AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
In-Reply-To: <AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 02:19 PM, huang ying wrote:
> Hi,
>
> On Sat, Feb 26, 2011 at 4:02 PM, Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
>> On 02/23/2011 05:39 AM, Maciej W. Rozycki wrote:
>> ...
>>>
>>>   [Catching up with old e-mail...]
>>>
>>>   In line with the comment above that you're removing -- have you (or
>>> anyone else) adjusted code elsewhere so that external NMIs are actually
>>> delivered to processors other than the BSP?  I can't see such code in this
>>> series nor an explanation as to why it wouldn't be needed.
>>>
>>>   For the record -- the piece of code above reflects our setup where the
>>> LINT1 input is enabled and configured for the NMI delivery mode on the BSP
>>> only and all the other processors have this line disabled in their local
>>> APIC units.  If system NMIs are to be handled after the removal of the
>>> BSP, then another processor has to be selected and configured for NMI
>>> reception.  Alternatively, all local units could have their LINT1 input
>>> enabled and arbitrate handling, although it would be quite disruptive as
>>> all the processors would take the interrupt if it happened.  OTOH it would
>>> be more fault-tolerant in the case of a CPU failure.  On a typical x86 box
>>> the system NMI cannot be routed to an I/O APIC input.
>>>
>>>    Maciej
>>
>>   Hi Maciej, good catch! The code doesn't reconfig LVT. As just Don pointed
>> it might be Intel is working on something, dunno. Probably we better should
>> drop this patch for now (at least until LVT reconfig would not be
>> implemented).
>

   Hi Huang,

> Why?  Without LVT reconfig, system with this patch can not work
> properly?

   I guess we have a few nits here -- first an important comment were
removed which doesn't reflect what happens on hw level for real. At
least we should put it back just to not confuse people who read this
code, something like

	/*
	 * FIXME: Only BSP can see external NMI for now and hot-unplug
	 * for BSP is not yet implemented
	 */
	WARN_ON_ONCE(smp_processor_id());

   The reason for WARN_ON_ONCE here is that -- imagine the situation when
perf-nmi happens on one cpu with external nmi on BSP and for some reason
(say code on upper level is screwed\bogus or anything else) nmi-notifier
didn't handled it properly as result we might have a report like "SERR for
reason xx on CPU 1" while this cpu didn't see this signal at all. And then
due to locking ordering BSP will see unknown nmi while in real those nmi belongs
him and it was CPU 1 who observed erronious NMI from upper level. Note this
is theoretical scenario I never saw anything like this ;)

   And since LVT reconfig might not be that simple as we might imagine I think
having additional lock in nmi handling code is not good at all.

> This is just one of the steps to make CPU 0 hot-removable.
> We must enable CPU 0 hot-removing in one step?

   Not of course but as I said having additional lock here for free
is not that good until we have a serious reason for it.

   Though, I would be glad if I'm wrong in my conclusions ;)

-- 
     Cyrill
