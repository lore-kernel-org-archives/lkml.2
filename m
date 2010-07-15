Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab0GORU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:20:27 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:44404 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab0GORU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:20:26 -0400
Date: Thu, 15 Jul 2010 10:20:26 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 1/2] blktrace: use cmpxchg
Message-ID: <20100715172026.GB12953@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715171937.GA12953@hexapodia.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded racy implementation of cmpxchg with the real thing.

This bug is probably easy to maliciously trigger from userspace, and
I think it will result in memory corruption, but the race window is
small so I think it's unlikely to be triggered accidentally.

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
---
 kernel/trace/blktrace.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 638711c..347fe8e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -511,11 +511,9 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	bt->trace_state = Blktrace_setup;
 
 	ret = -EBUSY;
-	old_bt = xchg(&q->blk_trace, bt);
-	if (old_bt) {
-		(void) xchg(&q->blk_trace, old_bt);
+	old_bt = cmpxchg(&q->blk_trace, NULL, bt);
+	if (old_bt)
 		goto err;
-	}
 
 	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();
@@ -1464,12 +1462,10 @@ static int blk_trace_setup_queue(struct request_queue *q,
 
 	blk_trace_setup_lba(bt, bdev);
 
-	old_bt = xchg(&q->blk_trace, bt);
-	if (old_bt != NULL) {
-		(void)xchg(&q->blk_trace, old_bt);
-		ret = -EBUSY;
+	ret = -EBUSY;
+	old_bt = cmpxchg(&q->blk_trace, NULL, bt);
+	if (old_bt)
 		goto free_bt;
-	}
 
 	if (atomic_inc_return(&blk_probes_ref) == 1)
 		blk_register_tracepoints();
-- 
1.7.1

