Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1DVQVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:21:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1DVQVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FOeYmWfnywPaGAV7dz6h7hO4DKrcbeeecdu9GBnc8GqFVuoGoGAVWPBIa860nyaE5y
         GQsQkHSClbb8yAvhZXXA==
MIME-Version: 1.0
In-Reply-To: <1303486219.2461.61.camel@localhost>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	<1303478798.2461.11.camel@localhost>
	<BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
	<1303482702.2461.40.camel@localhost>
	<BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
	<1303484597.2461.50.camel@localhost>
	<BANLkTinTRnSWbR8NTd5J-mmL=w7RecXk8g@mail.gmail.com>
	<1303486219.2461.61.camel@localhost>
Date: Fri, 22 Apr 2011 18:21:49 +0200
Message-ID: <BANLkTi=wZqmsXzyCHCYBVX24k+eWaSZotw@mail.gmail.com>
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 5:30 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Fri, 2011-04-22 at 23:05 +0800, Stephane Eranian wrote:
>> On Fri, Apr 22, 2011 at 5:03 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > On Fri, 2011-04-22 at 22:41 +0800, Stephane Eranian wrote:
>> >> On Fri, Apr 22, 2011 at 4:31 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> >> > On Fri, 2011-04-22 at 21:46 +0800, Stephane Eranian wrote:
>> >> >> On Fri, Apr 22, 2011 at 3:26 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> >> >> > On Fri, 2011-04-22 at 20:59 +0800, Stephane Eranian wrote:
>> >> >> >> Lin,
>> >> >> >>
>> >> >> >> In arch/x86/include/asm/smp.h, you added:
>> >> >> >>
>> >> >> >> static inline bool cpu_has_ht_siblings(void)
>> >> >> >> {
>> >> >> >>        bool has_siblings = false;
>> >> >> >> #ifdef CONFIG_SMP
>> >> >> >>        has_siblings = cpu_has_ht && smp_num_siblings > 1;
>> >> >> >> #endif
>> >> >> >>        return has_siblings;
>> >> >> >> }
>> >> >> >>
>> >> >> >> I am wondering about the goal of this function.
>> >> >> >>
>> >> >> >> Is it supposed to return whether or not HT is enabled?
>> >> >> >>
>> >> >> >> Ht enabled != HT supported
>> >> >> >
>> >> >> > It's used to check if HT is supported.
>> >> >> >
>> >> >> Ok, that makes more sense.
>> >> >>
>> >> >> > But unfortunately, we didn't find a way to check if HT is enabled.
>> >> >> > So I just check if HT is supported.
>> >> >> >
>> >> >> >>
>> >> >> >> +static inline int is_ht_enabled(void)
>> >> >> >> +{
>> >> >> >> +       bool has_ht = false;
>> >> >> >> +#ifdef CONFIG_SMP
>> >> >> >> +       int w;
>> >> >> >> +       w = cpumask_weight(cpu_sibling_mask(smp_processor_id()));
>> >> >> >> +       has_ht = cpu_has_ht && w > 1;
>> >> >> >> +#endif
>> >> >> >> +       return has_ht;
>> >> >> >> +}
>> >> >> >>
>> >> >> >> OTOH, you need some validation even in the case HT is off. No two events
>> >> >> >> scheduled together on the same PMU can have different values for the extra
>> >> >
>> >> > I got it now.
>> >> >
>> >> >> >> reg. Thus, the fact that cpu_has_ht_siblings() is imune to HT state helps here,
>> >> >> >> but then what's the point of it?
>> >> >> >
>> >> >> > The points is to avoid the percore resource allocations(which are used
>> >> >> > to sync between HTs) if HT is not supported.
>> >> >> >
>> >> >> But if you check x86_pmu.extra_regs, that should do it as well.
>> >> >
>> >> > I don't understand here.
>> >> > Did you mean we can avoid the percore resource allocations by just
>> >> > checking x86_pmu.extra_regs? How?
>> >>
>> >> Is you have not extra_regs, i.e., regs that are shared, then why would
>> >> you need the percore allocation?
>> >
>> > But "extra_regs" does not imply they are regs that are shared.
>> > It only means some events need to set extra registers to work.
>> >
>> Do you have example of such register that would not require the
>> extra mutual exclusion either between HT threads or between
>> events on the same PMU?
>
> No.
>
> I was thinking the case that "extra_regs" may be per-thread, instead of
> pef-core.
>
Yes, I am looking into that in my patch. You need this on NHM/WSM and
SNB.

But you would still need a struct to track the locked in value for the
extra_reg to avoid conflict even on one thread.

> So if there are "extra_regs" or not does not connected directly with if
> locking is needed or not.
>
True but it is "connected" to the kernel having to maintain the current
value for that extra_reg and ensuring that no other events conflict with
it.
