Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab0FPTH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:07:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab0FPTH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:07:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=nh3IRd0oge7/vOXTkx5RanmJFAOiHRSz5L4sLcDmc0XtMGNWd4MFy5So9LS7pzaiL
	HJ/JxI3g6VhrpQt5fMpmw==
Message-ID: <4c192107.4f1ee30a.4316.fffff98e@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 16 Jun 2010 20:59:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: avoid synthesizing mmap() for all processes in per-thread mode perf record
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bug was introduced by commit c45c6ea2e5c57960dc67e00294c2b78e9540c007.

Perf record was scanning /proc/PID to create synthetic PERF_RECOR_MMAP
entries even though it was running in per-thread mode. There was a bogus
check to select what mmaps to synthesize. We only need all processes in
system-wide mode.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 39c7247..5efc3fc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -714,7 +714,7 @@ static int __cmd_record(int argc, const char **argv)
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
-	if (!system_wide && cpu_list)
+	if (!system_wide)
 		event__synthesize_thread(target_tid, process_synthesized_event,
 					 session);
 	else
