Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1DTTAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:00:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36050 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1DTTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SCDDXSkH1CKh1MrAqqkrDS398nNXiupN73DZuAjms2t3ClyPez7Q9dZIdu/2ltudA/
         Y5BBwwuuWtvJgoatLbddAyj2g2alE5NFZ9/1g4QaJw0Pghltm5nuNxDOtlY14/A7KOVP
         AKlpAPqNxWaLDHLsWoWkXHoL5fxbvM+SgoFyo=
Message-ID: <4DAF2D2C.6060509@gmail.com>
Date: Wed, 20 Apr 2011 22:59:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        robert.richter@amd.com, andi@firstfloor.org, ming.m.lin@intel.com,
        eranian@google.com, ying.huang@intel.com,
        mathieu.desnoyers@efficios.com, acme@redhat.com
Subject: Re: [RFC] x86, perf: high volume of events produces a flood of unknown
 NMIs
References: <20110420182613.GA31724@redhat.com> <4DAF2A57.1010804@gmail.com>
In-Reply-To: <4DAF2A57.1010804@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 10:47 PM, Cyrill Gorcunov wrote:
> On 04/20/2011 10:26 PM, Don Zickus wrote:
>> Hi,
>>
>> Arnaldo pointed me at an NMI problem that happens when he tries to
>> generate a high volume of perf events.  He receives a flood of unknown
>> NMIs.
>>
>> I have been poking at the problem and came up with a patch, but it doesn't
>> always work.  I was hoping people who understood how the NMI works at a
>> low level might be able to help me.
>>
>> I was able to duplicate this on an AMD Phenom, Pentium 4, Xeon Core2quad,
>> and Nehalem.  The problem I think is the large generation of back-to-back
>> NMIs.  The perf nmi handler may accidentally handle some of those
>> extra/in-flight NMIs in its first pass, leaving the next NMI to be
>> unhandled and generating an unknown NMI message.
>>
>> Robert included logic to check for two back-to-back NMIs, but that falls
>> short when more then three are generated.  I modified his logic to account
>> for three back-to-back NMIs, but that didn't completely solve the problem.
>>
>> I took another approach at catching back-to-back NMIs that seemed to work
>> on all my machines except for the Xeon core2quad, but I am not entirely
>> sure if my approach is valid.
>>
>> The approach I took was based on the idea that if an NMI is being
>> generated while currently in an NMI handler, the current NMI when finished
>> won't continue executing the next instruction before the exception but
>> instead jump back into another NMI exception frame.
>>
>> As a result, the args passed in to the NMI handler should have the same ip
>> and sp as the previous NMI interrupt.  Otherwise one could assume that
>> some amount of time passed between interrupts (enough to return from the
>> exception and execute code).
>>
>> I thought this would allow me to trap an infinite number of back-to-back
>> NMIs.  Like I said it seemed to work in a number of machines, except for
>> my Xeon core2quad.
>>
>> Does anyone know if my approach is a valid one?  Or is there a better way
>> to catch this condition?  Or maybe some other tips or tricks I can use to
>> help come up with a solution for this?
>>
>> Or perhaps we don't care about this because in the end perf can't even
>> capture the data without spitting out a CPU Overload message.
>>
>> Thoughts?
>>
> 
> Hi Don, just a thought -- since pmi masks lvtpc we could read it and check if it's
> masked or no, though I fear it is quite time consuming operation in compare with
> frames :( (hmm, intel spec mentions only p4 and xeon as masking lvtpc)

Something like

	if (apic_read(APIC_LVTPC) & APIC_LVT_MASKED))
		handle-perf

-- 
    Cyrill
