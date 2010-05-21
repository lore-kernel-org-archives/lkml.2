Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0EULaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:30:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:58626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab0EUL36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:29:58 -0400
Date: Fri, 21 May 2010 11:29:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.684479310@chello.nl>
References: <20100521090710.684479310@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix wakeup storm for RO mmap()s
Message-ID: <tip-adb8e118f288dc4c569ac9a89010b81a4745fbf0@git.kernel.org>
Git-Commit-ID: adb8e118f288dc4c569ac9a89010b81a4745fbf0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:29:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adb8e118f288dc4c569ac9a89010b81a4745fbf0
Gitweb:     http://git.kernel.org/tip/adb8e118f288dc4c569ac9a89010b81a4745fbf0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 16:21:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:58 +0200

perf: Fix wakeup storm for RO mmap()s

RO mmap()s don't update the tail pointer, so
comparing against it for determining the written data
size doesn't really do any good.

Keep track of when we last did a wakeup, and compare
against that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.684479310@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7cd7b35..7098ebb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -599,7 +599,7 @@ struct perf_mmap_data {
 	local_t				head;		/* write position    */
 	local_t				nest;		/* nested writers    */
 	local_t				events;		/* event limit       */
-	local_t				wakeup;		/* needs a wakeup    */
+	local_t				wakeup;		/* wakeup stamp      */
 	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7a93252..1531e0b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3056,8 +3056,8 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->offset	= offset;
 	handle->head	= head;
 
-	if (head - tail > data->watermark)
-		local_inc(&data->wakeup);
+	if (head - local_read(&data->wakeup) > data->watermark)
+		local_add(data->watermark, &data->wakeup);
 
 	if (have_lost) {
 		lost_event.header.type = PERF_RECORD_LOST;
