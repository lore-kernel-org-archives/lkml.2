Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab2HIAwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:52:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51492 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758675Ab2HIAwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:52:00 -0400
MIME-Version: 1.0
Date: Thu, 9 Aug 2012 02:51:58 +0200
Message-ID: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
Subject: [BUG] perf: sharing of cpuctx between core and ibs PMU causes problems
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ran into a problem on my AMD box whereby I would hit the
WARN_ON_ONCE(cpuctx->cgrp) in perf_cgroup_switch().

It took me a while to track this down. It turns out that the
list_for_each_entry_rcu() loop had multiple iterations. That's
normal, we have CPU PMU and IBS PMU.  But what caused
the warning to fire is that both the core and IBS PMU were
pointing to the same cpuctx struct. Thus, the cpuctx->cgrp
was already set  in the second iteration.

Is the warning a false positive?

In perf_pmu_register(), there is a search for a matching
pmu->task_ctx_nr. Given that the field is pointing to
perf_hw_context for both cpu and IBS PMU, there is
a match and therefore the cpuctx are shared.

The question is: why do we have to share the cpuctx?

Note that the same issue probably exists with the Intel
uncore PMU.

If we need to share, then the perf_cgroup_switch() code
needs to change because, as it stands, it is doing the
switching twice in this case.

Either way something looks wrong here.

Any idea?
