Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0FYCU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 22:20:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62777 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0FYCUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 22:20:25 -0400
Message-ID: <4C241206.8040708@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 10:18:46 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl
Subject: [PATCH 3/3] perf: Fix the bug which fails to put memory mapping to
 record file
References: <4C241140.9090008@cn.fujitsu.com>
In-Reply-To: <4C241140.9090008@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we execute perf record without -t or -p option, it fails to load
process memory map to record file. Here fix it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 tools/perf/builtin-record.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 84d58b7..f834d21 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -685,9 +685,19 @@ static int __cmd_record(int argc, const char **argv)
 	if (perf_guest)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
-	if (!system_wide && profile_cpu == -1)
-		event__synthesize_thread(target_tid, process_synthesized_event,
-					 session);
+	if (!system_wide && profile_cpu == -1) {
+		int ret;
+
+		if (target_tid != -1) {
+			ret = event__synthesize_thread(target_tid,
+						 process_synthesized_event,
+						 session);
+		} else {
+			ret = event__synthesize_thread(all_tids[0],
+						 process_synthesized_event,
+						 session);
+		}
+	}
 	else
 		event__synthesize_threads(process_synthesized_event, session);
 
-- 1.6.5.2 
