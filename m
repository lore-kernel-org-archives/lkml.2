Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2CXH6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2CXH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:58:47 -0400
Date: Sat, 24 Mar 2012 00:58:28 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-b01c3a0010aabadf745f3e7fdb9cab682e0a28a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1332513680-7870-1-git-send-email-jolsa@redhat.com>
References: <1332513680-7870-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Move mmap page data_head offset assertion out of header
Git-Commit-ID: b01c3a0010aabadf745f3e7fdb9cab682e0a28a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 24 Mar 2012 00:58:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b01c3a0010aabadf745f3e7fdb9cab682e0a28a2
Gitweb:     http://git.kernel.org/tip/b01c3a0010aabadf745f3e7fdb9cab682e0a28a2
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 23 Mar 2012 15:41:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 24 Mar 2012 08:46:59 +0100

perf: Move mmap page data_head offset assertion out of header

Having the build time assertion in header is making the perf
build fail on x86 with:

  ../../include/linux/perf_event.h:411:32: error: variably modified \
		‘__assert_mmap_data_head_offset’ at file scope [-Werror]

I'm moving the build time validation out of the header, because
I think it's better than to lessen the perf build warn/error
check.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: cjashfor@linux.vnet.ibm.com
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/r/1332513680-7870-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index dc3b052..3f92a19 100644
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
