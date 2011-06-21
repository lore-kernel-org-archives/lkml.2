Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1FULil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:38:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56051 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1FULik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:38:40 -0400
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an
 extra reg (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTi=-rfp8qrh4-u7wtnq7e0PkFTNwxA@mail.gmail.com>
References: <20110606145708.GA7279@quad> <1307644812.2497.1022.camel@laptop>
	 <BANLkTimSO-+-0=bc=TZqvUxe7gwsSn1xRg@mail.gmail.com>
	 <1307652527.2497.1024.camel@laptop>
	 <BANLkTi=-rfp8qrh4-u7wtnq7e0PkFTNwxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Jun 2011 13:37:56 +0200
Message-ID: <1308656276.26237.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 11:54 +0200, Stephane Eranian wrote:
> On Thu, Jun 9, 2011 at 10:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2011-06-09 at 22:36 +0200, Stephane Eranian wrote:
> >> On Thu, Jun 9, 2011 at 8:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Mon, 2011-06-06 at 16:57 +0200, Stephane Eranian wrote:
> >> >> +static struct cpu_hw_events *allocate_fake_cpuc(void)
> >> >> +{
> >> >> +       struct cpu_hw_events *cpuc;
> >> >> +       int cpu = smp_processor_id();
> >> >
> >> > That's a boo-boo, clearly we are in a preemptible context here (see the
> >> > GFP_KERNEL allocation on the next line), so using smp_processor_id()
> >> > isn't valid.
> >> >
> >> Good point. I missed that.
> >
> > Yeah, I did too, Ingo found it during testing.
> >
> >> > Now since all that allocate_shared_regs() does with it is pick a NUMA
> >> > node, we should probably use raw_smp_processor_id() and leave it at
> >> > that, right?
> >> >
> Looked at that some more. It is more subtle than this.
> allocate_shared_regs() is used in two places:
>   - allocate_fake_cpuc()
>   - intel_pmu_cpu_prepare()
> 
> In the first case, it does not matter where the cpuc is allocated,
> it's not on any
> critical path. But for the other situation, it'd better be allocated
> on the cpu node.
> But I think that is what we get given it is called during the CPU
> hotplug prepare
> path, so it must be running on the CPU to prepare and thus a kzalloc() should
> allocate on the right node, right?

Yeah. Let me shove these patches mingo wards again.
