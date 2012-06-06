Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2FFHCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2FFHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:02:05 -0400
Date: Wed, 6 Jun 2012 00:01:48 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-114067b69e7b2c691faace0e33db2f04096f668d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, fan4326@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, fan4326@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
References: <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Check if callchain is corrupted
Git-Commit-ID: 114067b69e7b2c691faace0e33db2f04096f668d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  114067b69e7b2c691faace0e33db2f04096f668d
Gitweb:     http://git.kernel.org/tip/114067b69e7b2c691faace0e33db2f04096f668d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 31 May 2012 14:43:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 11:20:34 -0300

perf tools: Check if callchain is corrupted

We faced segmentation fault on perf top -G at very high sampling rate
due to a corrupted callchain. While the root cause was not revealed (I
failed to figure it out), this patch tries to protect us from the
segfault on such cases.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sunjin Yang <fan4326@gmail.com>
Link: http://lkml.kernel.org/r/1338443007-24857-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    4 ++--
 tools/perf/util/session.c  |   14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..1817d40 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -555,6 +555,8 @@ enum perf_event_type {
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
+#define PERF_MAX_STACK_DEPTH		255
+
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
 	PERF_CONTEXT_KERNEL		= (__u64)-128,
@@ -609,8 +611,6 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <asm/local.h>
 
-#define PERF_MAX_STACK_DEPTH		255
-
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3b6f8e4..04d1e33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -300,6 +300,11 @@ int machine__resolve_callchain(struct machine *self,
 
 	callchain_cursor_reset(&callchain_cursor);
 
+	if (chain->nr > PERF_MAX_STACK_DEPTH) {
+		pr_warning("corrupted callchain. skipping...\n");
+		return 0;
+	}
+
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
 		struct addr_location al;
@@ -318,7 +323,14 @@ int machine__resolve_callchain(struct machine *self,
 			case PERF_CONTEXT_USER:
 				cpumode = PERF_RECORD_MISC_USER;	break;
 			default:
-				break;
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 0;
 			}
 			continue;
 		}
