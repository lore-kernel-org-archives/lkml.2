Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab0GVLRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:17:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:9196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0GVLRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="820554849"
Subject: [RFC][PATCH v1 13/15] perf: export tracepoint events via sysfs:
 ext4, jbd2, xfs, gfs2
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 19:17:50 +0800
Message-ID: <1279797470.20942.96.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4, jbd2, xfs, gfs2 tracepoint events are exported like below,

/sys/fs/events/
|-- ext4_alloc_da_blocks
|   |-- config
|   `-- type
....
....
|-- jbd2_checkpoint
|   |-- config
|   `-- type
....
....
|-- xfs_agf
|   |-- config
|   `-- type
....
....
|-- gfs2_block_alloc
|   |-- config
|   `-- type
....
....
---
 fs/namespace.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 88058de..b4bc3dd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/perf_event.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -2305,6 +2306,20 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, &root);
 }
 
+static void fs_sys_add_tp(struct kobject *kobj)
+{
+	struct kobject *events_kobj;
+
+	events_kobj = perf_sys_create_events_dir(kobj);
+	if (events_kobj)
+		return;
+
+	perf_sys_add_tp_events(events_kobj, "ext4");
+	perf_sys_add_tp_events(events_kobj, "jbd2");
+	perf_sys_add_tp_events(events_kobj, "xfs");
+	perf_sys_add_tp_events(events_kobj, "gfs2");
+}
+
 void __init mnt_init(void)
 {
 	unsigned u;
@@ -2332,6 +2347,8 @@ void __init mnt_init(void)
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
 		printk(KERN_WARNING "%s: kobj create error\n", __func__);
+	else
+		fs_sys_add_tp(fs_kobj);
 	init_rootfs();
 	init_mount_tree();
 }



