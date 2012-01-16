Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2APMc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:32:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab2APMc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:32:26 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
Date: Mon, 16 Jan 2012 13:31:39 +0100
Message-Id: <1326717103-10287-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'format' attribute for pmu device that contains
a syntax description on how to construct raw events.

The event configuration is described in following
struct pefr_event_attr attributes:

  config
  config1
  config2

Each line of the format file describes mapping of name
and bitfield definition within one of abve attributes.

eg:
  event   config:0-7
  umask   config:8-15
  usr     config:16
  os      config:17
  edge    config:18
  any     config:21
  inv     config:23
  cmask   config:24-31

Line syntax:
  line:      NAME config ':' bits
  config:    'config' | 'config1' | 'config2"
  bits:      bits ',' bit_term | bit_term
  bit_term:  VALUE '-' VALUE | VALUE

Adding event_format callback to the struct pmu, which provides
the format information. The pmu shall override this function
and provide its own specific format information.

If not overloaded the default format information is used:

  config  config:0-63
  config1 config1:0-63
  config2 config2:0-63

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    6 ++++++
 kernel/events/core.c       |   23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0b91db2..bf17d15 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -638,6 +638,12 @@ struct pmu {
 	 */
 	int (*event_init)		(struct perf_event *event);
 
+	/*
+	 * Provide event raw format information for sysfs
+	 * 'format' attribute.
+	 */
+	ssize_t (*event_format)		(struct pmu *pmu, char *page);
+
 #define PERF_EF_START	0x01		/* start the counter when adding    */
 #define PERF_EF_RELOAD	0x02		/* reload the counter when starting */
 #define PERF_EF_UPDATE	0x04		/* update the counter when stopping */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91fb68a..3bec8ca 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5492,8 +5492,31 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
 }
 
+static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
+{
+	ssize_t ret;
+
+	ret  = sprintf(page,       "config  config:0-63\n");
+	ret += sprintf(page + ret, "config1 config1:0-63\n");
+	ret += sprintf(page + ret, "config2 config2:0-63\n");
+
+	return ret;
+}
+
+static ssize_t
+format_show(struct device *dev, struct device_attribute *attr, char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	if (pmu->event_format)
+		pmu->event_format(pmu, page);
+
+	return perf_default_event_format(pmu, page);
+}
+
 static struct device_attribute pmu_dev_attrs[] = {
        __ATTR_RO(type),
+       __ATTR_RO(format),
        __ATTR_NULL,
 };
 
-- 
1.7.6.5

