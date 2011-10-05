Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab1JEQzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:55:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:52172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935078Ab1JEQzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,492,1312182000"; 
   d="scan'208";a="23558377"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <lenb@kernel.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 7/8] kernel/power/main.c: Not suspend/resume if CPU0 is offlined
Date: Wed,  5 Oct 2011 09:39:18 -0700
Message-Id: <1317832759-10223-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

System resumes from CPU0 on today's x86 BIOS. Don't suspend/resume if CPU0 is
offlined and bsp_hotpluggable is 1.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 kernel/power/main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 6c601f8..33ffb6a 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/resume-trace.h>
 #include <linux/workqueue.h>
+#include <linux/cpu.h>
 
 #include "power.h"
 
@@ -178,6 +179,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 	int len;
 	int error = -EINVAL;
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (bsp_hotpluggable && cpumask_first(cpu_online_mask) != 0) {
+		printk(KERN_WARNING "Because CPU0 is offlined, system can't suspend/resume.\n");
+
+		return -ENODEV;
+	}
+#endif
+
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
-- 
1.6.0.3

