Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1A1Efs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:35:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1A1Edp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:45 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=KfAb1R83KNMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=hBWW8U-Tjhmsyq5nGhsA:9 a=AtiXsElqQt-VTbQ-Q7wA:7 a=Z8SVm-kwZ14OzBS8u2DmXIqIWgQA:4 a=fOX5Bau-VLh-bvhM:21 a=lEfEXCZ3Tmr1wANV:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128042118.561146147@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 00/12] tracing/filter: Remove 32 pred limit and add short circuits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing some intense tracing, I hit the 32 pred limit in the filters.
This annoyed me a little, so I decided to remove this constraint.
But as I saw that the current approach needs to store state in a stack,
the algorithm needed to be changed such that we could do any
arbitrary number of preds without needing to store state.

This patch series converts the stack version into a tree walk that can
use the direction of the walk to store the state.

An added bonus is that this also allows short circuit of AND and OR
logic when one value is found to be false or true respectively.
That is, if the left child is false and the operation is an AND, we
do not need to process the right child. We can just set the result
to false and pass it up to the parent.

For an optimization, the tree is also folded so that multiple ANDs
or ORs in a row are converted to a single pred that has all
the opperations in an array:

  a || b || c || d || e ...

  a && b && c && d && e ...

Either of the above does not need a tree walk. If any of the ORs
are found to be true, we can exit and move to the parent. If any
of the ANDs are found to be false we can do the same. Otherwise
we can use the result of the last compare.

I'm sending this out as an RFC first, but they are pretty much
set. I'll start running them through more vigorous tests and then
package them up for 2.6.39.

This email is to let people know what is happening.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/tracing/filter


Steven Rostedt (12):
      tracing/filter: Have no filter return a match
      tracing/filter: Move OR and AND logic out of fn() method
      tracing/filter: Dynamically allocate preds
      tracing/filter: Call synchronize_sched() just once for system filters
      tracing/filter: Allocate the preds in an array
      tracing/filter: Free pred array on disabling of filter
      tracing/filter: Use a tree instead of stack for filter_match_preds()
      tracing/filter: Optimize short ciruit check
      tracing/filter: Check the created pred tree
      tracing/filter: Optimize filter by folding the tree
      tracing/filter: Move MAX_FILTER_PRED to local tracing directory
      tracing/filter: Increase the max preds to 2^14

----
 include/linux/ftrace_event.h       |    1 -
 kernel/trace/trace.h               |   38 ++-
 kernel/trace/trace_events_filter.c |  751 ++++++++++++++++++++++++++++++-----
 3 files changed, 675 insertions(+), 115 deletions(-)
