Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0LOJgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:36:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0LOJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:36:03 -0500
Message-ID: <4D088C05.5060701@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 17:36:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        serge@hallyn.com
Subject: [PATCH v2 4/6] cgroups: Mark some subsystems bindable/unbindable
References: <4D088BB5.30903@cn.fujitsu.com>
In-Reply-To: <4D088BB5.30903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:35:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:36:00,
	Serialize complete at 2010-12-15 17:36:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those subsystems (debug, cpuacct, net_cls and devices),
setting the bindable/unbindable flag is sufficient.

Set freezer subsystem as bindable but not unbindable, because
sub-cgroups' can be in FROZEN state.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c          |    6 +++++-
 kernel/cgroup_freezer.c  |    1 +
 kernel/sched.c           |    2 ++
 security/device_cgroup.c |    2 ++
 4 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 463575d..fa2c5de 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1063,6 +1063,8 @@ static int hierarchy_reset_css_refs(struct cgroup *cgrp, void *data)
 	int i;
 
 	for_each_set_bit(i, &removed_bits, CGROUP_SUBSYS_COUNT) {
+		struct cgroup_subsys_state *css = cgrp->subsys[i];
+
 		if (atomic_read(&css->refcnt) == 0)
 			atomic_set(&css->refcnt, 1);
 	}
@@ -1086,7 +1088,7 @@ static int hierarchy_clear_css_refs(struct cgroup *cgrp, void *data)
 	}
 	return 0;
 failed:
-	hierarchy_reset_css_refs(struct cgroup *cgrp, void *data);
+	hierarchy_reset_css_refs(cgrp, data);
 	return -EBUSY;
 }
 
@@ -5201,5 +5203,7 @@ struct cgroup_subsys debug_subsys = {
 	.destroy = debug_destroy,
 	.populate = debug_populate,
 	.subsys_id = debug_subsys_id,
+	.bindable = true,
+	.unbindable = true,
 };
 #endif /* CONFIG_CGROUP_DEBUG */
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e7bebb7..213ecd9 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -393,4 +393,5 @@ struct cgroup_subsys freezer_subsys = {
 	.attach		= NULL,
 	.fork		= freezer_fork,
 	.exit		= NULL,
+	.bindable	= true,
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..930ee2e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9346,6 +9346,8 @@ struct cgroup_subsys cpuacct_subsys = {
 	.destroy = cpuacct_destroy,
 	.populate = cpuacct_populate,
 	.subsys_id = cpuacct_subsys_id,
+	.bindable = true,
+	.unbindable = true,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8d9c48f..51321e9 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -473,6 +473,8 @@ struct cgroup_subsys devices_subsys = {
 	.destroy = devcgroup_destroy,
 	.populate = devcgroup_populate,
 	.subsys_id = devices_subsys_id,
+	.bindable = true,
+	.unbindable = true,
 };
 
 int devcgroup_inode_permission(struct inode *inode, int mask)
-- 
1.6.3

