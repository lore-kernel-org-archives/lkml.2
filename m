Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0JCTfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:35:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47117 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381Ab0JCTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:35:52 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf: Detach group events when removing event from ctx
Date: Sun,  3 Oct 2010 20:35:50 +0100
Message-Id: <8e7ce03ad7d5f94290a4e865c1fe5f7f7279e27f.1286134285.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing an event from a task's list of events we need to make sure
that we also detach all group events. If we don't, then when we later
call perf_group_attach() we'll hit the WARN_ON_ONCE() like so,

[ 1200.449161] ------------[ cut here ]------------
[ 1200.449171] WARNING: at kernel/perf_event.c:313 add_event_to_ctx+0xe1/0x159()
[ 1200.449174] Hardware name: MacBook2,1
[ 1200.449176] Modules linked in: dm_mod sg sd_mod
[ 1200.449183] Pid: 7619, comm: perf Not tainted 2.6.36-rc6-tip+ #2
[ 1200.449186] Call Trace:
[ 1200.449193]  [<ffffffff8103b71e>] warn_slowpath_common+0x85/0x9d
[ 1200.449197]  [<ffffffff8103b750>] warn_slowpath_null+0x1a/0x1c
[ 1200.449201]  [<ffffffff810a16fb>] add_event_to_ctx+0xe1/0x159
[ 1200.449206]  [<ffffffff810a2f01>] perf_install_in_context+0x85/0x99
[ 1200.449210]  [<ffffffff810a7811>] sys_perf_event_open+0x4da/0x633
[ 1200.449216]  [<ffffffff81002b1b>] system_call_fastpath+0x16/0x1b
[ 1200.449218] ---[ end trace 9df38c30c6cacb50 ]---

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 kernel/perf_event.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c16158c..c13d869 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -550,8 +550,11 @@ retry:
 	 * can remove the event safely, if the call above did not
 	 * succeed.
 	 */
-	if (!list_empty(&event->group_entry))
+	if (!list_empty(&event->group_entry)) {
+		perf_group_detach(event);
 		list_del_event(event, ctx);
+	}
+
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
-- 
1.7.1

