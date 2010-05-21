Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0EUJMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:12:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0EUJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:26 -0400
Message-Id: <20100521090710.684479310@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/10] perf: Fix wakeup storm for RO mmap()s
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-fix-RO-wakeups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RO mmap()s don't update the tail pointer, so comparing against
it for determining the written data size doesn't really do any good.

Keep track of when we last did a wakeup, and compare against that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -599,7 +599,7 @@ struct perf_mmap_data {
 	local_t				head;		/* write position    */
 	local_t				nest;		/* nested writers    */
 	local_t				events;		/* event limit       */
-	local_t				wakeup;		/* needs a wakeup    */
+	local_t				wakeup;		/* wakeup stamp      */
 	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3055,8 +3055,8 @@ int perf_output_begin(struct perf_output
 	handle->offset	= offset;
 	handle->head	= head;
 
-	if (head - tail > data->watermark)
-		local_inc(&data->wakeup);
+	if (head - local_read(&data->wakeup) > data->watermark)
+		local_add(data->watermark, &data->wakeup);
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;


