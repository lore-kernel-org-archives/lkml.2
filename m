Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1FIUgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:36:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1FIUgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BMlDgm2dz0IzrctbHrCSGYsxT3QBYfCVcr8lOFnBwNl6bV7N1uIfzVsYwvP56XXT1r
         nrP/N7t8aPczOQM6mFiQ==
MIME-Version: 1.0
In-Reply-To: <1307644812.2497.1022.camel@laptop>
References: <20110606145708.GA7279@quad>
	<1307644812.2497.1022.camel@laptop>
Date: Thu, 9 Jun 2011 22:36:10 +0200
Message-ID: <BANLkTimSO-+-0=bc=TZqvUxe7gwsSn1xRg@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg (v4)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-06-06 at 16:57 +0200, Stephane Eranian wrote:
>> +static struct cpu_hw_events *allocate_fake_cpuc(void)
>> +{
>> +       struct cpu_hw_events *cpuc;
>> +       int cpu = smp_processor_id();
>
> That's a boo-boo, clearly we are in a preemptible context here (see the
> GFP_KERNEL allocation on the next line), so using smp_processor_id()
> isn't valid.
>
Good point. I missed that.

> Now since all that allocate_shared_regs() does with it is pick a NUMA
> node, we should probably use raw_smp_processor_id() and leave it at
> that, right?
>
Yeah, for what we do with fake_cpuc, it does not really matter where
it comes from. This is not on any critical path. The simplest allocator
will do it.


>> +       cpuc = kzalloc(sizeof(*cpuc), GFP_KERNEL);
>> +       if (!cpuc)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       /* only needed, if we have extra_regs */
>> +       if (x86_pmu.extra_regs) {
>> +               cpuc->shared_regs = allocate_shared_regs(cpu);
>> +               if (!cpuc->shared_regs)
>> +                       goto error;
>> +       }
>> +       return cpuc;
>> +error:
>> +       free_fake_cpuc(cpuc);
>> +       return ERR_PTR(-ENOMEM);
>> +}
>
>
