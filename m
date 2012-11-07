Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2KGTTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:19:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34828 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab2KGTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:19:06 -0500
Date: Wed, 7 Nov 2012 11:19:52 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] perf: Create a sysfs entry for Power event format
Message-ID: <20121107191951.GD16211@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107191818.GA16211@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110719-8974-0000-0000-000010CE9AEA
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00189311; UDB=6.00042867; UTC=2012-11-07
 19:19:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From bafc551c31ce23c1cba0b75d23de6c46aba90f26 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 6 Nov 2012 16:30:28 -0800
Subject: [PATCH 4/4] perf: Create a sysfs entry for Power event format

Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
which describes the format of a POWER cpu.

	$ cat /sys/bus/event_source/devices/cpu/format/event
	config:0-20

The format of the event is the same for all POWER cpus, so bulk of this
change is in the code common to POWER cpus.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    8 ++++++++
 arch/powerpc/perf/core-book3s.c              |   19 +++++++++++++++++++
 arch/powerpc/perf/power7-pmu.c               |    1 +
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index ad84f73..20a49bf 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -130,3 +130,11 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
 		.attr = __ATTR(_name, 0444, power_events_sysfs_show, NULL),\
 		.id   = PM_##_id,                                               \
 	};
+
+/*
+ * Format of a perf event is the same on all POWER cpus. Declare a
+ * common sysfs attribute group that individual POWER cpus can share.
+ */
+extern struct attribute_group power_pmu_format_group;
+
+
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 19b23bd..388e2a1 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1315,6 +1315,25 @@ ssize_t power_events_sysfs_show(struct device *dev,
        return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
 }
 
+static ssize_t power_config_sysfs_show(struct device *dev,
+				struct device_attribute *attr, char *page)
+{
+	return sprintf(page, "config:0-20\n");
+}
+
+static struct device_attribute config_dev_attr = \
+			__ATTR(event, 0444, power_config_sysfs_show, NULL);
+
+static struct attribute *power_pmu_format_attr[] = {
+	&config_dev_attr.attr,
+	NULL,
+};
+
+struct attribute_group power_pmu_format_group = {
+	.name = "format",
+	.attrs = power_pmu_format_attr,
+};
+
 struct pmu power_pmu = {
 	.pmu_enable	= power_pmu_enable,
 	.pmu_disable	= power_pmu_disable,
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 31c61ab..aa9f588 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -387,6 +387,7 @@ static struct attribute_group power7_pmu_events_group = {
 };
 
 static const struct attribute_group *power7_pmu_attr_groups[] = {
+	&power_pmu_format_group,
 	&power7_pmu_events_group,
 	NULL,
 };
-- 
1.7.1

