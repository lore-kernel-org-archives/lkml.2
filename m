Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1FUJy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:54:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1FUJy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HFawi3w06B6J5yOp1N1NtUZq7Fajuy4YJ1x1HVAoEHz0wtRdhMlxF0zc1VCdMQXA35
         cXYIDwSpE89skylYe5fQ==
MIME-Version: 1.0
In-Reply-To: <1307652527.2497.1024.camel@laptop>
References: <20110606145708.GA7279@quad>
	<1307644812.2497.1022.camel@laptop>
	<BANLkTimSO-+-0=bc=TZqvUxe7gwsSn1xRg@mail.gmail.com>
	<1307652527.2497.1024.camel@laptop>
Date: Tue, 21 Jun 2011 11:54:21 +0200
Message-ID: <BANLkTi=-rfp8qrh4-u7wtnq7e0PkFTNwxA@mail.gmail.com>
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

On Thu, Jun 9, 2011 at 10:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-06-09 at 22:36 +0200, Stephane Eranian wrote:
>> On Thu, Jun 9, 2011 at 8:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2011-06-06 at 16:57 +0200, Stephane Eranian wrote:
>> >> +static struct cpu_hw_events *allocate_fake_cpuc(void)
>> >> +{
>> >> +       struct cpu_hw_events *cpuc;
>> >> +       int cpu = smp_processor_id();
>> >
>> > That's a boo-boo, clearly we are in a preemptible context here (see the
>> > GFP_KERNEL allocation on the next line), so using smp_processor_id()
>> > isn't valid.
>> >
>> Good point. I missed that.
>
> Yeah, I did too, Ingo found it during testing.
>
>> > Now since all that allocate_shared_regs() does with it is pick a NUMA
>> > node, we should probably use raw_smp_processor_id() and leave it at
>> > that, right?
>> >
Looked at that some more. It is more subtle than this.
allocate_shared_regs() is used in two places:
  - allocate_fake_cpuc()
  - intel_pmu_cpu_prepare()

In the first case, it does not matter where the cpuc is allocated,
it's not on any
critical path. But for the other situation, it'd better be allocated
on the cpu node.
But I think that is what we get given it is called during the CPU
hotplug prepare
path, so it must be running on the CPU to prepare and thus a kzalloc() should
allocate on the right node, right?

>> Yeah, for what we do with fake_cpuc, it does not really matter where
>> it comes from. This is not on any critical path. The simplest allocator
>> will do it.
>
> OK, fixed that up.
>
>
