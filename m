Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab0LTNGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:06:35 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:33942 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab0LTNGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:06:33 -0500
Message-Id: <20101220130629.974963910@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Mon, 20 Dec 2010 14:05:45 +0100
From: graalfs@linux.vnet.ibm.com
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: [patch 4/4] Handle memory unmap while hardware sampling is running
References: <20101220130541.446049933@linux.vnet.ibm.com>
Content-Disposition: inline; filename=handle_munmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: graalfs@linux.vnet.ibm.com

During memory unmap hardware sampling is deactivated.
After all samples have been collected hardware sampling is reactivated again.
 
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
---
 arch/s390/oprofile/hwsampler_files.c |    2 +-
 drivers/oprofile/buffer_sync.c       |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/oprofile/buffer_sync.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/buffer_sync.c
+++ linux-2.6/drivers/oprofile/buffer_sync.c
@@ -32,6 +32,11 @@
 #include <linux/sched.h>
 #include <linux/gfp.h>
 
+#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
+#include <asm/hwsampler.h>
+extern unsigned long oprofile_hwsampler;
+#endif
+
 #include "oprofile_stats.h"
 #include "event_buffer.h"
 #include "cpu_buffer.h"
@@ -513,6 +518,10 @@ void sync_buffer(int cpu)
 
 	mutex_lock(&buffer_mutex);
 
+#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
+	if (oprofile_hwsampler)
+		hwsampler_deactivate(cpu);
+#endif
 	add_cpu_switch(cpu);
 
 	op_cpu_buffer_reset(cpu);
@@ -569,6 +578,10 @@ void sync_buffer(int cpu)
 
 	mark_done(cpu);
 
+#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
+	if (oprofile_hwsampler)
+		hwsampler_activate(cpu);
+#endif
 	mutex_unlock(&buffer_mutex);
 }
 
Index: linux-2.6/arch/s390/oprofile/hwsampler_files.c
===================================================================
--- linux-2.6.orig/arch/s390/oprofile/hwsampler_files.c
+++ linux-2.6/arch/s390/oprofile/hwsampler_files.c
@@ -22,7 +22,7 @@ unsigned long oprofile_max_interval;
 static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
 static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
 
-static unsigned long oprofile_hwsampler;
+unsigned long oprofile_hwsampler;
 
 static int oprofile_hwsampler_start(void)
 {

