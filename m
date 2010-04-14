Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0DNUvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:51:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42450 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IEsGBTL2GKiHU25ytfhDVOuMtHhiAIaljQX6pILNhm/7DQ9Fx9zGMtK6A3Y69KS+CC
         pJBcUNwx77yxd5+iEzs2fVFdLem+IxeNaUvpHY6oKpfVRGYO81Btk+nRfT4E5NYhomkc
         JRSXKGFGnwV7WgK8QRXbDYodbol7xCkidLiaE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] perf: Always record tracepoints raw samples from perf record
Date: Wed, 14 Apr 2010 22:51:33 +0200
Message-Id: <1271278294-7336-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1271278294-7336-1-git-send-regression-fweisbec@gmail.com>
References: <1271278294-7336-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events are mostly used for tracing rather than simple
counting. Don't bother anymore with adding -R when using them,
just record raw samples of trace events every time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/util/parse-events.c           |   14 ++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b29bd2d..020d871 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -101,7 +101,7 @@ OPTIONS
 
 -R::
 --raw-samples::
-Collect raw sample records from all opened counters (typically for tracepoint counters).
+Collect raw sample records from all opened counters (default for tracepoint counters).
 
 SEE ALSO
 --------
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 435781e..880070c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -410,7 +410,6 @@ static enum event_result
 parse_single_tracepoint_event(char *sys_name,
 			      const char *evt_name,
 			      unsigned int evt_length,
-			      char *flags,
 			      struct perf_event_attr *attr,
 			      const char **strp)
 {
@@ -419,13 +418,9 @@ parse_single_tracepoint_event(char *sys_name,
 	u64 id;
 	int fd;
 
-	if (flags) {
-		if (!strncmp(flags, "record", strlen(flags))) {
-			attr->sample_type |= PERF_SAMPLE_RAW;
-			attr->sample_type |= PERF_SAMPLE_TIME;
-			attr->sample_type |= PERF_SAMPLE_CPU;
-		}
-	}
+	attr->sample_type |= PERF_SAMPLE_RAW;
+	attr->sample_type |= PERF_SAMPLE_TIME;
+	attr->sample_type |= PERF_SAMPLE_CPU;
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
@@ -533,8 +528,7 @@ static enum event_result parse_tracepoint_event(const char **strp,
 						       flags);
 	} else
 		return parse_single_tracepoint_event(sys_name, evt_name,
-						     evt_length, flags,
-						     attr, strp);
+						     evt_length, attr, strp);
 }
 
 static enum event_result
-- 
1.6.2.3

