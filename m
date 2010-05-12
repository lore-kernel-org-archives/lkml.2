Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0ELRuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:50:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0ELRut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:50:49 -0400
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>
In-Reply-To: <4BEAE476.1090100@linux.vnet.ibm.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
	 <1273588935.1810.6.camel@laptop>  <4BEAE476.1090100@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 19:50:46 +0200
Message-ID: <1273686646.1626.145.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 10:25 -0700, Corey Ashford wrote:

> Thanks for looking into this problem!  Unfortunately, I've been unable 
> to test your patch.  It doesn't apply to 2.6.33.3 

Strange the code looks very similar, the below is a diff against a
virgin v2.6.33.3.

---
 kernel/perf_event.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 32d0ae2..e8ae0c2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -290,6 +290,18 @@ static void update_event_times(struct perf_event *event)
 }
 
 /*
+ * Update total_time_enabled and total_time_running for all events in a group.
+ */
+static void update_group_times(struct perf_event *leader)
+{
+	struct perf_event *event;
+
+	update_event_times(leader);
+	list_for_each_entry(event, &leader->sibling_list, group_entry)
+		update_event_times(event);
+}
+
+/*
  * Add a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
  */
@@ -337,7 +349,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
-	update_event_times(event);
+	update_group_times(event);
 
 	/*
 	 * If event was in error state, then keep it
@@ -508,18 +520,6 @@ retry:
 }
 
 /*
- * Update total_time_enabled and total_time_running for all events in a group.
- */
-static void update_group_times(struct perf_event *leader)
-{
-	struct perf_event *event;
-
-	update_event_times(leader);
-	list_for_each_entry(event, &leader->sibling_list, group_entry)
-		update_event_times(event);
-}
-
-/*
  * Cross CPU call to disable a performance event
  */
 static void __perf_event_disable(void *info)


