Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab1DYOPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:15:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54959 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab1DYOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TGeK1rJsmQlt5h+DuzrBwD4CAlqEOcSFOfjMaWLGW/3UIcF2PJUMsOi3d4001JRxXV
         KwKuJxsxeDNUwPF7I2dyv8fyRvhWoNyG+cXiWQo9goP7sG4WLXQwM96pUNiudfFl0G9O
         KobfT85rLdn3L0F7dhNxzr8e8WwhDsn3CuJsk=
Message-ID: <4DB581FD.8080006@gmail.com>
Date: Mon, 25 Apr 2011 18:15:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        George Spelvin <linux@horizon.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf, nmi: Move LVT un-masking into irq handlers
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com> <1303398203-2918-4-git-send-email-dzickus@redhat.com> <20110422082636.GC24011@elte.hu> <20110425133954.GA20887@redhat.com>
In-Reply-To: <20110425133954.GA20887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 05:39 PM, Don Zickus wrote:
> On Fri, Apr 22, 2011 at 10:26:36AM +0200, Ingo Molnar wrote:
>>
>> * Don Zickus <dzickus@redhat.com> wrote:
>>
>>> --- a/arch/x86/kernel/cpu/perf_event.c
>>> +++ b/arch/x86/kernel/cpu/perf_event.c
>>> @@ -1284,6 +1284,9 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>>>  
>>>  	cpuc = &__get_cpu_var(cpu_hw_events);
>>>  
>>> +	/* chipsets have their own quirks when to unmask */
>>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>> +
>>
>> What sense does this comment make in this place?
>>
>> Yes, chipsets have their own quirks - but the generic handler is not one of 
>> them. So a more appropriate comment would be to point out why we want to unmask 
>> there - before PMU handling or after it, etc.
> 
> Yup.  I rework that.

I suspect the comment from one of my draft version might fulfit, Don do you have it?
/me looking in sent mbox

+	/*
+	 * We have to unmask LVTPC *before* enabling counters,
+	 * the key moment is that LVTPC is getting masked on
+	 * PMI arrival and if PMU enabled before APIC unmasked
+	 * a new oveflow signal may reach it but not propagated
+	 * as NMI (due to transition timings) and LVTPC eventually
+	 * stick masked forever dropping any further PMI signals.
+	 */

it was for pmu-intel but i think same applies to general pmu handler.

> 
>>
>> Like the P4 quirk is documented a bit better:
>>
>>> +        /*
>>> +	 * P4 quirks:
>>> +	 * - An overflown perfctr will assert its interrupt
>>> +	 *   until the OVF flag in its CCCR is cleared.
>>> +	 * - LVTPC is masked on interrupt and must be
>>> +	 *   unmasked by the LVTPC handler.
>>> +	 */
>>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>
>> (btw., there's whitespace damage above as well.)
>>
>> Furthermore, the P4 comment should *explain* the quirk coherently, not just 
>> list random facts. What happens, why, where, and why do we unmask the LVTPC in 
>> that spot.

  Ingo, actually I don't understand what else could be added here, should we post
the backtrace calls there? Or plain "we reach this point with OVF bit set" is enough?

  Don't get me wrong please but the whole picture of what is happening can be seen only when
all caller sequence is taken into account and once (for some reason) the sequence
get changed the "detailed" comment would simply mess the comment reader so I think
the former comment is detailed enough and what is more important it's "general" enough
so it doesn't depend on when code is called but points a reader on hw details and it's
up to a reader to check "current" calling sequence because kernel code changes too
damn fast ;)

> 
> Yeah, I copied that from the old watchdog code.  I'll revise that too and
> repost.
> 
> Cheers,
> Don


-- 
    Cyrill
