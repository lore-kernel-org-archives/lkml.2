Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0JOJnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:43:00 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35534 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0JOJm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:42:59 -0400
Subject: Re: [PATCH] perf: Detach group events when removing event from ctx
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <8e7ce03ad7d5f94290a4e865c1fe5f7f7279e27f.1286134285.git.matt@console-pimps.org>
References: <8e7ce03ad7d5f94290a4e865c1fe5f7f7279e27f.1286134285.git.matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 11:42:37 +0200
Message-ID: <1287135757.29097.1368.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 20:35 +0100, Matt Fleming wrote:
> When removing an event from a task's list of events we need to make sure
> that we also detach all group events. If we don't, then when we later
> call perf_group_attach() we'll hit the WARN_ON_ONCE() like so,
> 
> [ 1200.449161] ------------[ cut here ]------------
> [ 1200.449171] WARNING: at kernel/perf_event.c:313 add_event_to_ctx+0xe1/0x159()
> [ 1200.449174] Hardware name: MacBook2,1
> [ 1200.449176] Modules linked in: dm_mod sg sd_mod
> [ 1200.449183] Pid: 7619, comm: perf Not tainted 2.6.36-rc6-tip+ #2
> [ 1200.449186] Call Trace:
> [ 1200.449193]  [<ffffffff8103b71e>] warn_slowpath_common+0x85/0x9d
> [ 1200.449197]  [<ffffffff8103b750>] warn_slowpath_null+0x1a/0x1c
> [ 1200.449201]  [<ffffffff810a16fb>] add_event_to_ctx+0xe1/0x159
> [ 1200.449206]  [<ffffffff810a2f01>] perf_install_in_context+0x85/0x99
> [ 1200.449210]  [<ffffffff810a7811>] sys_perf_event_open+0x4da/0x633
> [ 1200.449216]  [<ffffffff81002b1b>] system_call_fastpath+0x16/0x1b
> [ 1200.449218] ---[ end trace 9df38c30c6cacb50 ]---

I think its due to the new and fancy move groups around context code
from: b04243ef70 (perf: Complete software pmu grouping).

Does the below cure it?

It only detaches the group when we move it from one context to another,
the perf_install_in_context() later on will then re-assemble the group
on the other context.

---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5592,6 +5592,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
 			perf_event_remove_from_context(sibling);
+			perf_group_detach(sibling);
 			put_ctx(gctx);
 		}
 		mutex_unlock(&gctx->mutex);

