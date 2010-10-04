Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0JDKA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:00:56 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab0JDKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=ImOSQI4bsDqDXH4XxcMJqcQwo7q++ZZ5z1lGilE7ceYYQd11byKXkhACWtbPxt9WRG
         JWqlGYgWlag37WD/pC1w==
Message-ID: <4ca9a5d1.e8e9d80a.3dbb.ffff8f2e@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 4 Oct 2010 12:00:02 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix invalid pointer when pid is invalid
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an error in perf_event_open() when the pid
provided by the user is invalid. find_lively_task_by_vpid()
does not return NULL on error but an error code. Without the
fix the error code was silently passed to find_get_context()
which would eventually cause a invalid pointer dereference.

Signed-off-by: Stephane Eranian <eranian@google.com>

---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c16158c..64507ea 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5616,8 +5616,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (pid != -1)
+	if (pid != -1) {
 		task = find_lively_task_by_vpid(pid);
+		if (IS_ERR(task)) {
+			err = PTR_ERR(task);
+			goto err_group_fd;
+		}
+	}
 
 	/*
 	 * Get the target context (task or percpu):
