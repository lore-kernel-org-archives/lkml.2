Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab0GVLN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:13:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:9746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab0GVLN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,242,1278313200"; 
   d="scan'208";a="588614907"
Subject: [RFC][PATCH v1 07/15] perf: export tracepoint events via sysfs:
 block
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jaxboe@fusionio.com>
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
Date: Thu, 22 Jul 2010 19:14:13 +0800
Message-ID: <1279797253.20942.88.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block tracepoint events are exported like below,

/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/events
|-- block_bio_backmerge
|   |-- config
|   `-- type
|-- block_bio_bounce
|   |-- config
|   `-- type
|-- block_bio_complete
|   |-- config
|   `-- type
|-- block_bio_frontmerge
.....
/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/sda1/events
|-- block_bio_backmerge
|   |-- config
|   `-- type
|-- block_bio_bounce
|   |-- config
|   `-- type
|-- block_bio_complete
|   |-- config
|   `-- type
|-- block_bio_frontmerge
.....
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sr0/events
/sys/devices/virtual/block/ram0/events
....
/sys/devices/virtual/block/ram15/events
/sys/devices/virtual/block/loop0/events
....
/sys/devices/virtual/block/loop7/events
/sys/devices/virtual/block/md0/events
---
 fs/partitions/check.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 72c5265..e18ac81 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/genhd.h>
 #include <linux/blktrace_api.h>
+#include <linux/perf_event.h>
 
 #include "check.h"
 
@@ -446,6 +447,9 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	if (err)
 		goto out_put;
 
+	/* For example, /sys/block/sda1/events/ */
+	perf_sys_add_tp(&pdev->kobj, "block");
+
 	err = -ENOMEM;
 	p->holder_dir = kobject_create_and_add("holders", &pdev->kobj);
 	if (!p->holder_dir)
@@ -506,6 +510,9 @@ void register_disk(struct gendisk *disk)
 		device_del(ddev);
 		return;
 	}
+
+	/* For example, /sys/block/sda/events/ */
+	perf_sys_add_tp(&ddev->kobj, "block");
 #endif
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);



