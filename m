Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab1GYILW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:11:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:38062 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GYILS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:11:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,259,1309762800"; 
   d="scan'208";a="31050825"
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1310996068.13765.67.camel@twins>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
	 <1310996068.13765.67.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 16:11:15 +0800
Message-ID: <1311581475.3938.1477.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 21:34 +0800, Peter Zijlstra wrote:
> 
> Also, I would prefer an interface like:
> 
> int perf_pmu_add_event(struct pmu *pmu, const char *name, u64 config)
> {
> }
> 
> which would create the events directory if not already present and
> allocate and add a pmu_sysfs_event thingy.

It's strange that I didn't find a way to check if a directory is present
in sysfs. Any hint?

So I proceeded with below code.

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 14337a3..6db73d0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -611,6 +611,7 @@ struct pmu {
 	struct list_head		entry;
 
 	struct device			*dev;
+	struct kobject			*events;
 	char				*name;
 	int				type;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3870c106..080d684 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7081,3 +7081,35 @@ fail:
 	kfree(attr_group);
 	kfree(all_attrs);
 }
+
+#define NAME_LEN 64
+
+int perf_pmu_add_event(struct pmu *pmu, const char *name, u64 config)
+{
+	struct kobject *events = pmu->events;
+	struct pmu_event *event;
+	struct kobj_attribute *event_attr;
+
+	if (!pmu_bus_running)
+		return -EINVAL;
+
+	if (!events) {
+		events = kobject_create_and_add("events", &pmu->dev->kobj);
+		if (!unlikely(events))
+			return -ENOMEM;
+	}
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	strncpy(event->name, name, NAME_LEN);
+	event->config = config;
+	event_attr = &event->attr;
+	sysfs_attr_init(&event_attr->attr);
+	event_attr->attr.name = event->name;
+	event_attr->attr.mode = 0444;
+	event_attr->show = pmu_event_show;
+
+	return sysfs_create_file(events, &event_attr->attr);
+}



