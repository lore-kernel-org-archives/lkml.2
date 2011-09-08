Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1IHHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:10:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:60868 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab1IHHK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:10:29 -0400
Message-ID: <4E686A48.2020004@oracle.com>
Date: Thu, 08 Sep 2011 15:10:00 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Moore <Eric.Moore@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com,
        Greg Marsden <greg.marsden@oracle.com>, linux-kernel@vger.kernel.org,
        Joe Jin <joe.jin@oracle.com>
Subject: [PATCH] [SCSI] mptsas: enable driver multi-threaded probe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E686A60.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When server installed some mptsas controller, kernel took long time to
initialized and probe the disks. This patch will create a probe thread for
each device.

By our test, server with 4 LSI controllers, after applied this patch, saved
40s(60 vs 20) for boot time.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
---
 drivers/message/fusion/mptsas.c |   52 +++++++++++++++++++++++++++++++++++---
 1 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7596aec..6c29efc 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -51,6 +51,7 @@
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>	/* for mdelay */
+#include <linux/kthread.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -85,6 +86,10 @@ module_param(mpt_pt_clear, int, 0);
 MODULE_PARM_DESC(mpt_pt_clear,
 		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
+static bool mptsas_multiprobe = 1;
+module_param(mptsas_multiprobe, bool, 0);
+MODULE_PARM_DESC(mptsas_multiprobe, " Probe disks by per-device, "
+		"default enabled");
 
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPTSAS_MAX_LUN (16895)
@@ -5118,9 +5123,17 @@ static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id)
 	scsi_device_put(sdev);
 }
 
+struct mptsas_mtprobe_structure {
+	struct pci_dev *pdev;
+	struct pci_device_id *id;
+};
+
 static int
-mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+__mptsas_probe(void *void_data)
 {
+	struct mptsas_mtprobe_structure *data = void_data;
+	struct pci_dev		*pdev = data->pdev;
+	struct pci_device_id	*id = data->id;
 	struct Scsi_Host	*sh;
 	MPT_SCSI_HOST		*hd;
 	MPT_ADAPTER 		*ioc;
@@ -5134,7 +5147,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	r = mpt_attach(pdev,id);
 	if (r)
-		return r;
+		goto done;
 
 	ioc = pci_get_drvdata(pdev);
 	mptsas_fw_event_off(ioc);
@@ -5172,7 +5185,8 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		printk(MYIOC_s_WARN_FMT
 			"Skipping ioc=%p because SCSI Initiator mode "
 			"is NOT enabled!\n", ioc->name, ioc);
-		return 0;
+		r = 0;
+		goto done;
 	}
 
 	sh = scsi_host_alloc(&mptsas_driver_template, sizeof(MPT_SCSI_HOST));
@@ -5282,14 +5296,42 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->old_sas_discovery_protocal = 1;
 	mptsas_scan_sas_topology(ioc);
 	mptsas_fw_event_on(ioc);
-	return 0;
+	r = 0;
+ done:
+	kfree(void_data);
+	return r;
 
  out_mptsas_probe:
-
+	kfree(void_data);
 	mptscsih_remove(pdev);
 	return error;
 }
 
+static int
+mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct mptsas_mtprobe_structure	*data;
+	struct task_struct		*t;
+	int ret = 0;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->pdev = pdev;
+	data->id = id;
+
+	if (mptsas_multiprobe) {
+		t = kthread_run(__mptsas_probe, data,
+				"mptsas_probe-%d", pci_name(pdev));
+		if (IS_ERR(t))
+			ret = __mptsas_probe(data);
+	} else
+		ret = __mptsas_probe(data);
+
+	return ret;
+}
+
 void
 mptsas_shutdown(struct pci_dev *pdev)
 {
-- 
1.7.6

