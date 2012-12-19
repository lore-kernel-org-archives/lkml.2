Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2LSPJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:09:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2LSPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:09:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf x86: Add precise sysfs attribute
Date: Wed, 19 Dec 2012 16:07:21 +0100
Message-Id: <1355929642-28392-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding sysfs precise attribute for cpu device (/sys/devices/cpu)
to show the maximum value for perf event precise attribute.

This will be initialy used for automated precise event perf test
and could be helpful otherwise. Arnaldo suggested to use this as
a guide for default adding of precise attribute for HW events.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6774c17..190995e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -377,19 +377,26 @@ static inline int precise_br_compat(struct perf_event *event)
 	return m == b;
 }
 
-int x86_pmu_hw_config(struct perf_event *event)
+static int x86_get_precise(void)
 {
-	if (event->attr.precise_ip) {
-		int precise = 0;
+	int precise = 0;
 
-		/* Support for constant skid */
-		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
+	/* Support for constant skid */
+	if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
+		precise++;
+
+		/* Support for IP fixup */
+		if (x86_pmu.lbr_nr)
 			precise++;
+	}
 
-			/* Support for IP fixup */
-			if (x86_pmu.lbr_nr)
-				precise++;
-		}
+	return precise;
+}
+
+int x86_pmu_hw_config(struct perf_event *event)
+{
+	if (event->attr.precise_ip) {
+		int precise = x86_get_precise();
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
@@ -1700,6 +1707,13 @@ static int x86_pmu_event_init(struct perf_event *event)
 	return err;
 }
 
+static ssize_t get_attr_precise(struct device *cdev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return snprintf(buf, 10, "%d\n", x86_get_precise());
+}
+
 static int x86_pmu_event_idx(struct perf_event *event)
 {
 	int idx = event->hw.idx;
@@ -1752,9 +1766,11 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 }
 
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_ATTR(precise, S_IRUGO, get_attr_precise, NULL);
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_precise.attr,
 	NULL,
 };
 
-- 
1.7.11.7

