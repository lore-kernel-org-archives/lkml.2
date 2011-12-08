Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1LHKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:50:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:53124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1LHKus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:50:48 -0500
Message-ID: <1323341376.17673.10.camel@twins>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Thu, 08 Dec 2011 11:49:36 +0100
In-Reply-To: <CABPqkBT=XrbyLLzxUf7KKwk4MGcSVq-b0DtDQL1cgg1z1b0UpQ@mail.gmail.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-10-git-send-email-eranian@google.com>
	 <1323121074.32012.40.camel@twins>
	 <CABPqkBT=XrbyLLzxUf7KKwk4MGcSVq-b0DtDQL1cgg1z1b0UpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 10:25 -0800, Stephane Eranian wrote:
> On Mon, Dec 5, 2011 at 1:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> >> +               /*
> >> +                * check if the context has at least one
> >> +                * event using PERF_SAMPLE_BRANCH_STACK
> >> +                */
> >> +               if (cpuctx->ctx.nr_branch_stack > 0
> >> +                   && pmu->flush_branch_stack) {
> >> +
> >> +                       pmu = cpuctx->ctx.pmu;
> >> +
> >> +                       perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> >> +
> >> +                       perf_pmu_disable(pmu);
> >> +
> >> +                       pmu->flush_branch_stack();
> >> +
> >> +                       perf_pmu_enable(pmu);
> >> +
> >> +                       perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> >> +               }
> >> +       }
> >
> > (what whitespace looks funny)
> >
> > So all PMUs not supporting this branch stuff will fail to create a
> > has_branch_stack() event, right? Thus all ctx with !0 nr_branch_stack
> > support it. Doesn't this make the test for pmu->flush_branch_stack
> > redundant?
> >
> >
> No, nr_branch_stack counts the number of active events with
> branch_stack. It's like the ctx->nr_cgroups. Processors which
> do not support branch_stack will always have this field to 0.
> It's not because a processor supports branch_stack that we
> need to call flush_branch_stack(), i.e., we use a lazy approach.

What you're saying is we can support branch stack and not need
flush_branch_stack()? Say in the case the x86 LBR TOS field would be a
full u64 counter, since then we could sample the TOS on context switch
and filter on that, obviating the hard reset we do now.

And the advantage of testing for the operation as opposed to putting in
a dummy function (like we do for most other optional methods) is
avoiding all that ctx_lock and pmu_disable muck.

Fair enough.
