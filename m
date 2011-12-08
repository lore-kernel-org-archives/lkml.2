Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1LHSOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:14:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:57969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1LHSOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:14:50 -0500
Message-ID: <1323368035.17673.20.camel@twins>
Subject: Re: [PATCH 09/12] perf_events: add hook to flush branch_stack on
 context switch (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Thu, 08 Dec 2011 19:13:55 +0100
In-Reply-To: <CABPqkBTJ1M0Hpm-VHXGSSOtLHFQWuuo7AnaJzwEQ9a4WD8YFbw@mail.gmail.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	 <1318595833-29984-10-git-send-email-eranian@google.com>
	 <1323121074.32012.40.camel@twins>
	 <CABPqkBT=XrbyLLzxUf7KKwk4MGcSVq-b0DtDQL1cgg1z1b0UpQ@mail.gmail.com>
	 <1323341376.17673.10.camel@twins>
	 <CABPqkBTJ1M0Hpm-VHXGSSOtLHFQWuuo7AnaJzwEQ9a4WD8YFbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 10:04 -0800, Stephane Eranian wrote:
> The whole motivation behind the flush_branch_stack is explained in the
> Changelog of the patch. In summary, we need to flush the LBR (regardless
> of TOS) because in system-wide we need to be able to associate the content
> of the LBR with a specific task. Given that the HW does not capture the PID
> in the LBR buffer, the kernel has to intervene. 

That's not regardless of the TOS. If the TOS was a full u64 you wouldn't
need the TID (which would be good, since the hardware has no such
concept).

> Why don't we have this already?
> Because we are capturing at all priv levels. But with this patchset, it becomes
> possible to filter taken branches based on priv levels. Thus, if you only sample
> at the user level and run in system-wide mode, it is more likely you could end
> up with branches belonging to two different tasks in the LBR buffer. But you'd
> have no way of determining this just by looking at the content of the buffer.
> So instead, we need to flush the LBR on context switch to associate a PID
> with them.

Yeah, I get that.

> Because this is an expensive operation, we want to do this only when we
> sample on LBR. That's what the ctx->nr_branch_stack is about. We could
> refine that some more by checking for system-wide events with only
> user priv level on the branch stack. But I did not do that yet.
> 
> Does this make more sense now? 

It already did. The only thing I wanted to do was get rid of that method
check. Initially I overlooked the fact that its optional, even if you
support the branch stack. My reply from today argued for it, since
installing a dummy method would still have the needless ctx_lock &&
pmu_disable overhead.


