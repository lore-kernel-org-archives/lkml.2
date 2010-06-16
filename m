Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab0FPSTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:19:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0FPSTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:19:46 -0400
Subject: Re: [RFC][PATCH 0/8] perf pmu interface
From: Peter Zijlstra <peterz@infradead.org>
To: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100616160027.590430763@chello.nl>
References: <20100616160027.590430763@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 20:19:32 +0200
Message-ID: <1276712372.1745.619.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 18:00 +0200, Peter Zijlstra wrote:
> These patches prepare the perf code for multiple pmus (no user
> interface yet, Lin Ming is working on that). These patches remove all
> weak functions and rework the struct pmu interface.
> 
> The latter is inspired by the work Frederic is doing to to filter out
> IRQ contexts.
> 
> These patches are very prelimenary, they haven't seen a compiler yet and
> the last patch still needs sparc,ppc and arm converted.
> 
> But they patches seem to be in a good enough shape to see what people
> think..

Another idea I was kicking about was to push find_get_context()
partially into struct pmu, so that we can have context's per pmu.

For cpu-wide contexts its easy, for per-task contexts we need more
pointers in task_struct, so I was thinking of something like:

enum {
  perf_swevent_context = 0,
  perf_cpu_context,
#ifdef HW_BREAKPOINT
  perf_bp_context,
#endif
  perf_nr_task_context
};

struct task_struct {
  ...
  struct perf_event_context *perf_event_ctxs[perf_nr_task_context];
  ...
};

and have add for loops over the struct pmu list for the cpu-wide
contexts and for loops over perf_nr_task_context for the task contexts.

It would add some extra code to the hot-paths, but its the best I can
come up with.
