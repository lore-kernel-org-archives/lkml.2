Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1LHSEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:04:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1LHSEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:04:39 -0500
MIME-Version: 1.0
In-Reply-To: <1323341376.17673.10.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1318595833-29984-10-git-send-email-eranian@google.com>
	<1323121074.32012.40.camel@twins>
	<CABPqkBT=XrbyLLzxUf7KKwk4MGcSVq-b0DtDQL1cgg1z1b0UpQ@mail.gmail.com>
	<1323341376.17673.10.camel@twins>
Date: Thu, 8 Dec 2011 10:04:38 -0800
Message-ID: <CABPqkBTJ1M0Hpm-VHXGSSOtLHFQWuuo7AnaJzwEQ9a4WD8YFbw@mail.gmail.com>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 2:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-12-07 at 10:25 -0800, Stephane Eranian wrote:
>> On Mon, Dec 5, 2011 at 1:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>> >> +               /*
>> >> +                * check if the context has at least one
>> >> +                * event using PERF_SAMPLE_BRANCH_STACK
>> >> +                */
>> >> +               if (cpuctx->ctx.nr_branch_stack > 0
>> >> +                   && pmu->flush_branch_stack) {
>> >> +
>> >> +                       pmu = cpuctx->ctx.pmu;
>> >> +
>> >> +                       perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> >> +
>> >> +                       perf_pmu_disable(pmu);
>> >> +
>> >> +                       pmu->flush_branch_stack();
>> >> +
>> >> +                       perf_pmu_enable(pmu);
>> >> +
>> >> +                       perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> >> +               }
>> >> +       }
>> >
>> > (what whitespace looks funny)
>> >
>> > So all PMUs not supporting this branch stuff will fail to create a
>> > has_branch_stack() event, right? Thus all ctx with !0 nr_branch_stack
>> > support it. Doesn't this make the test for pmu->flush_branch_stack
>> > redundant?
>> >
>> >
>> No, nr_branch_stack counts the number of active events with
>> branch_stack. It's like the ctx->nr_cgroups. Processors which
>> do not support branch_stack will always have this field to 0.
>> It's not because a processor supports branch_stack that we
>> need to call flush_branch_stack(), i.e., we use a lazy approach.
>
> What you're saying is we can support branch stack and not need
> flush_branch_stack()? Say in the case the x86 LBR TOS field would be a
> full u64 counter, since then we could sample the TOS on context switch
> and filter on that, obviating the hard reset we do now.
>
The whole motivation behind the flush_branch_stack is explained in the
Changelog of the patch. In summary, we need to flush the LBR (regardless
of TOS) because in system-wide we need to be able to associate the content
of the LBR with a specific task. Given that the HW does not capture the PID
in the LBR buffer, the kernel has to intervene. Why don't we have this already?
Because we are capturing at all priv levels. But with this patchset, it becomes
possible to filter taken branches based on priv levels. Thus, if you only sample
at the user level and run in system-wide mode, it is more likely you could end
up with branches belonging to two different tasks in the LBR buffer. But you'd
have no way of determining this just by looking at the content of the buffer.
So instead, we need to flush the LBR on context switch to associate a PID
with them.

Because this is an expensive operation, we want to do this only when we
sample on LBR. That's what the ctx->nr_branch_stack is about. We could
refine that some more by checking for system-wide events with only
user priv level on the branch stack. But I did not do that yet.

Does this make more sense now?

> And the advantage of testing for the operation as opposed to putting in
> a dummy function (like we do for most other optional methods) is
> avoiding all that ctx_lock and pmu_disable muck.
>
> Fair enough.
