Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1KWIeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:34:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56923 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KWId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:33:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Nov 2011 17:32:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: [RFC][PATCH 2/3] use static_branch for cgroup_xxxx_disabled
Message-Id: <20111123173250.97880e5f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7eae9a2735bf8df8a7e12f10dd7c27e729760196 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 15:53:18 +0900
Subject: [PATCH 2/3] use static_branch for cgroup_xxx_disabled

The behavior of cgroup_xxx_disable is determined at boot.
Then, using static_brach() will allow us binary patching rather
than checking global variable.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |   22 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9eaa6fe..511cb6a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -16,6 +16,7 @@
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -526,9 +527,16 @@ struct cgroup_subsys {
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
+#ifdef CONFIG_JUMP_LABEL
+#define SUBSYS(_x)\
+	extern struct jump_label_key cgroup_ ## _x ## _disabled_key;\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return static_branch(&cgroup_ ## _x ## _disabled_key);}
+#else
 #define SUBSYS(_x)\
 	static inline bool cgroup_ ## _x ## _disabled(void){\
 		return _x ## _subsys.disabled;}
+#endif
 #define SUBSYS_UNDEFINED(_x)\
 	static inline bool cgroup_ ## _x ## _disabled(void){\
 		return true;}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..28d4430 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -75,7 +75,7 @@ static DEFINE_MUTEX(cgroup_mutex);
 static struct cgroup_subsys *subsys[CGROUP_SUBSYS_COUNT] = {
 #include <linux/cgroup_subsys.h>
 };
-
+#undef SUBSYS
 #define MAX_CGROUP_ROOT_NAMELEN 64
 
 /*
@@ -4776,6 +4776,25 @@ static void cgroup_release_agent(struct work_struct *work)
 	raw_spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
+#ifdef CONFIG_JUMP_LABEL
+#define SUBSYS(_x)\
+	struct jump_label_key cgroup_ ## _x ## _disable_key;
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+
+static void cgroup_subsys_disable(void)
+{
+#define SUBSYS(_x)\
+	if ( _x ## _subsys.disabled)\
+		jump_label_inc(&cgroup_ ## _x ## _disable_key);
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+}
+#else
+static void cgroup_subsys_disable(void)
+{
+}
+#endif
 
 static int __init cgroup_disable(char *str)
 {
@@ -4800,6 +4819,7 @@ static int __init cgroup_disable(char *str)
 			}
 		}
 	}
+	cgroup_subsys_disable();
 	return 1;
 }
 __setup("cgroup_disable=", cgroup_disable);
-- 
1.7.4.1


