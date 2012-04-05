Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2DETU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:20:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50902 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2DETTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:19:34 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <mark.asselstine@windriver.com>
Subject: [PATCH 1/3] trace-cmd: add checks for invalid pointers to fix segfaults
Date: Thu, 5 Apr 2012 15:19:44 -0400
Message-ID: <1333653586-3379-2-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
References: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 'trace-cmd report' after running latency tracers will cause a
segfault due to invalid pointers. Adding checks to ensure
pointers/lists are initialized before attempting to use them prevents
these segfaults.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
 trace-input.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index b6af1e6..5151c1e 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -695,7 +695,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 static void free_page(struct tracecmd_input *handle, int cpu)
 {
-	if (!handle->cpu_data[cpu].page)
+	if (!handle->cpu_data || cpu >= handle->cpus ||
+	    !handle->cpu_data[cpu].page)
 		return;
 
 	__free_page(handle, handle->cpu_data[cpu].page);
@@ -746,8 +747,12 @@ void tracecmd_record_ref(struct record *record)
 
 static void free_next(struct tracecmd_input *handle, int cpu)
 {
-	struct record *record = handle->cpu_data[cpu].next;
+	struct record *record;
+
+	if (!handle->cpu_data || cpu >= handle->cpus)
+		return;
 
+	record = handle->cpu_data[cpu].next;
 	if (!record)
 		return;
 
@@ -2337,7 +2342,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 		/* The tracecmd_peek_data may have cached a record */
 		free_next(handle, cpu);
 		free_page(handle, cpu);
-		if (!list_empty(&handle->cpu_data[cpu].pages))
+		if (handle->cpu_data &&
+		    !list_empty(&handle->cpu_data[cpu].pages))
 			warning("pages still allocated on cpu %d%s",
 				cpu, show_records(&handle->cpu_data[cpu].pages));
 	}
-- 
1.7.5.4

