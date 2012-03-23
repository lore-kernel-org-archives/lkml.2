Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2CWOlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:41:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2CWOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:41:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf: Move mmap page data_head offset assertion out of header
Date: Fri, 23 Mar 2012 15:41:20 +0100
Message-Id: <1332513680-7870-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having the build time assertion in header is making the perf build
fail on x86 with:
  ../../include/linux/perf_event.h:411:32: error: variably modified \
		‘__assert_mmap_data_head_offset’ at file scope [-Werror]

I'm moving the build time validation out of the header, because I think
it's better than to lessen the perf build warn/error check.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    7 -------
 kernel/events/core.c       |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ca9ed4e..ddbb6a9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -403,13 +403,6 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 };
 
-/*
- * Build time assertion that we keep the data_head at the intended location.
- * IOW, validation we got the __reserved[] size right.
- */
-extern char __assert_mmap_data_head_offset
-	[1 - 2*!!(offsetof(struct perf_event_mmap_page, data_head) != 1024)];
-
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
 #define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6e30445..a6a9ec4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7116,6 +7116,13 @@ void __init perf_event_init(void)
 
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
+
+	/*
+	 * Build time assertion that we keep the data_head at the intended
+	 * location.  IOW, validation we got the __reserved[] size right.
+	 */
+	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
+		     != 1024);
 }
 
 static int __init perf_event_sysfs_init(void)
-- 
1.7.1

