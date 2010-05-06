Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0EFHjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:39:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34542 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0EFHjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jCcDcNHgvaZ77WCErhX5wyMSTv8vJlA52gSDhAub5u/s88NjsIl7uqYGtV9aMx6kVa
         SKh5ikHjFpAV5Zp3fywxrGcvpvLdBMpkM5UOVcllNXwWxwnVeFNVxobkSUmHW87c6i7o
         wdNfVcxdN5lP68G058Z7CdMWzvxI/YV5ht1IA=
MIME-Version: 1.0
In-Reply-To: <20100506064453.GI1172@elte.hu>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere>
	 <20100505174234.GH5686@lenovo> <20100506064453.GI1172@elte.hu>
Date: Thu, 6 May 2010 11:39:52 +0400
Message-ID: <w2vaa79d98a1005060039ua7dd1b0t952fcd8662d4d759@mail.gmail.com>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures from 
	preemption
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 6, 2010, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On Wed, May 05, 2010 at 06:57:34PM +0200, Frederic Weisbecker wrote:
>> ...
>> > > @@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
>> > >  {
>> > >   unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>> > >   unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
>> > > - int cpu = raw_smp_processor_id();
>> > > + int cpu = get_cpu();
>> > >   struct hw_perf_event *hwc;
>> > >   struct p4_event_bind *bind;
>> > >   unsigned int i, thread, num;
>> > > @@ -777,6 +779,7 @@ reserve:
>> > >   }
>> > >
>> > >  done:
>> > > + put_cpu();
>> > >   return num ? -ENOSPC : 0;
>> > >  }
>> >
>> > That's no big deal. But I think the schedule_events() is called on
>> > pmu::enable() time, when preemption is already disabled.
>> >
>>
>> We'll be on a safe side using get/put_cpu here (ie in case
>> if something get changed one day).
>
> hm, when 'something gets changed one day' we'll see a warning when using
> unsafe primitives.
>
> So if preemption is always off here we really should not add extra runtime
> overhead via get_cpu()/put_cpu().
>
> So wouldnt it be better (and faster) to disable preemption in
> hw_perf_event_init(), which seems to be the bit missing?
>
>         Ingo
>

the thing are that p4 is only snippet here which is sensible to
preemtion, and hw_perf_event_init is executing with preemtion off (but
i could miss the details here, dont have code under my hands at
moment, so PeterZ help is needed ;) but more important reason why i've
saved get/put here is that otherwise i would not have rights to put
tested-by tag, since it would not be the patch Steven has tested. We
could make a patch on top of this one, or we could drop this one, make
new with explicit preemt off in caller and use smp_processor_id in p4
schedule routine. What is preferred?
