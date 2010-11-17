Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934948Ab0KQQSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:18:46 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48248 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab0KQQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:18:44 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/7] sst: Add runtime PM support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:58:45 +0000
Message-ID: <20101117155821.21681.11968.stgit@localhost.localdomain>
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

This adds runtime PM support for audio driver.
This also fixes LPA audio mode for moorestown platform

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c              |   44 ++++++++++++++++++--
 .../staging/intel_sst/intel_sst_app_interface.c    |   13 +++++-
 drivers/staging/intel_sst/intel_sst_common.h       |    1 
 .../staging/intel_sst/intel_sst_drv_interface.c    |   13 +++++-
 drivers/staging/intel_sst/intel_sst_dsp.c          |    3 +
 drivers/staging/intel_sst/intel_sst_ipc.c          |    1 
 6 files changed, 67 insertions(+), 8 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index 24d3928..92e30f6 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
+#include <linux/pm_runtime.h>
 #include <asm/mrst.h>
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
@@ -318,6 +319,9 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 		}
 	}
 	sst_drv_ctx->lpe_stalled = 0;
+	pm_runtime_set_active(&pci->dev);
+	pm_runtime_enable(&pci->dev);
+	pm_runtime_allow(&pci->dev);
 	pr_debug("sst: ...successfully done!!!\n");
 	return ret;
 
@@ -405,9 +409,10 @@ int intel_sst_suspend(struct pci_dev *pci, pm_message_t state)
 	union config_status_reg csr;
 
 	pr_debug("sst: intel_sst_suspend called\n");
-
-	if (sst_drv_ctx->pb_streams != 0 || sst_drv_ctx->cp_streams != 0)
-		return -EPERM;
+	if (sst_drv_ctx->stream_cnt) {
+		pr_err("sst: active streams,not able to suspend\n");
+		return -EBUSY;
+	}
 	/*Assert RESET on LPE Processor*/
 	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
 	csr.full = csr.full | 0x2;
@@ -437,7 +442,7 @@ int intel_sst_resume(struct pci_dev *pci)
 	pr_debug("sst: intel_sst_resume called\n");
 	if (sst_drv_ctx->sst_state != SST_SUSPENDED) {
 		pr_err("sst: SST is not in suspended state\n");
-		return -EPERM;
+		return 0;
 	}
 	sst_drv_ctx = pci_get_drvdata(pci);
 	pci_set_power_state(pci, PCI_D0);
@@ -452,6 +457,34 @@ int intel_sst_resume(struct pci_dev *pci)
 	return 0;
 }
 
+static int intel_sst_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	pr_debug("sst: runtime_suspend called\n");
+	return intel_sst_suspend(pci_dev, PMSG_SUSPEND);
+}
+
+static int intel_sst_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	pr_debug("sst: runtime_resume called\n");
+	return intel_sst_resume(pci_dev);
+}
+
+static int intel_sst_runtime_idle(struct device *dev)
+{
+	pr_debug("sst: runtime_idle called\n");
+	if (sst_drv_ctx->stream_cnt == 0 && sst_drv_ctx->am_cnt == 0)
+		pm_schedule_suspend(dev, SST_SUSPEND_DELAY);
+	return -EBUSY;
+}
+
+static const struct dev_pm_ops intel_sst_pm = {
+	.runtime_suspend = intel_sst_runtime_suspend,
+	.runtime_resume = intel_sst_runtime_resume,
+	.runtime_idle = intel_sst_runtime_idle,
+};
+
 /* PCI Routines */
 static struct pci_device_id intel_sst_ids[] = {
 	{ PCI_VDEVICE(INTEL, SST_MRST_PCI_ID), 3},
@@ -468,6 +501,9 @@ static struct pci_driver driver = {
 #ifdef CONFIG_PM
 	.suspend = intel_sst_suspend,
 	.resume = intel_sst_resume,
+	.driver = {
+		.pm = &intel_sst_pm,
+	},
 #endif
 };
 
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 60aca55..9aac69f 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -33,6 +33,7 @@
 #include <linux/aio.h>
 #include <linux/uaccess.h>
 #include <linux/firmware.h>
+#include <linux/pm_runtime.h>
 #include <linux/ioctl.h>
 #ifdef CONFIG_MRST_RAR_HANDLER
 #include "../rar_register/rar_register.h"
@@ -100,8 +101,10 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 	unsigned int retval;
 
 	mutex_lock(&sst_drv_ctx->stream_lock);
+	pm_runtime_get_sync(&sst_drv_ctx->pci->dev);
 	retval = intel_sst_check_device();
 	if (retval) {
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
 		mutex_unlock(&sst_drv_ctx->stream_lock);
 		return retval;
 	}
@@ -110,6 +113,7 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 		struct ioctl_pvt_data *data =
 			kzalloc(sizeof(struct ioctl_pvt_data), GFP_KERNEL);
 		if (!data) {
+			pm_runtime_put(&sst_drv_ctx->pci->dev);
 			mutex_unlock(&sst_drv_ctx->stream_lock);
 			return -ENOMEM;
 		}
@@ -122,6 +126,7 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 		pr_debug("sst: pvt_id handle = %d!\n", data->pvt_id);
 	} else {
 		retval = -EUSERS;
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
 		mutex_unlock(&sst_drv_ctx->stream_lock);
 	}
 	return retval;
@@ -144,8 +149,10 @@ int intel_sst_open_cntrl(struct inode *i_node, struct file *file_ptr)
 
 	/* audio manager open */
 	mutex_lock(&sst_drv_ctx->stream_lock);
+	pm_runtime_get_sync(&sst_drv_ctx->pci->dev);
 	retval = intel_sst_check_device();
 	if (retval) {
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
 		mutex_unlock(&sst_drv_ctx->stream_lock);
 		return retval;
 	}
@@ -154,8 +161,10 @@ int intel_sst_open_cntrl(struct inode *i_node, struct file *file_ptr)
 		sst_drv_ctx->am_cnt++;
 		pr_debug("sst: AM handle opened...\n");
 		file_ptr->private_data = NULL;
-	} else
+	} else {
 		retval = -EACCES;
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
+	}
 
 	mutex_unlock(&sst_drv_ctx->stream_lock);
 	return retval;
@@ -178,6 +187,7 @@ int intel_sst_release(struct inode *i_node, struct file *file_ptr)
 	mutex_lock(&sst_drv_ctx->stream_lock);
 	sst_drv_ctx->encoded_cnt--;
 	sst_drv_ctx->stream_cnt--;
+	pm_runtime_put(&sst_drv_ctx->pci->dev);
 	mutex_unlock(&sst_drv_ctx->stream_lock);
 	free_stream_context(data->str_id);
 	kfree(data);
@@ -189,6 +199,7 @@ int intel_sst_release_cntrl(struct inode *i_node, struct file *file_ptr)
 	/* audio manager close */
 	mutex_lock(&sst_drv_ctx->stream_lock);
 	sst_drv_ctx->am_cnt--;
+	pm_runtime_put(&sst_drv_ctx->pci->dev);
 	mutex_unlock(&sst_drv_ctx->stream_lock);
 	pr_debug("sst: AM handle closed\n");
 	return 0;
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index dcc1ebb..a828824 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -37,6 +37,7 @@
 #define SST_FW_FILENAME_MFLD "fw_sst_082f.bin"
 #define SST_MRST_PCI_ID 0x080A
 #define SST_MFLD_PCI_ID 0x082F
+#define SST_SUSPEND_DELAY 2000
 
 enum sst_states {
 	SST_FW_LOADED = 1,
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 22b95ca..1ff6420 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/firmware.h>
+#include <linux/pm_runtime.h>
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
 #include "intel_sst_fw_ipc.h"
@@ -308,12 +309,15 @@ int sst_open_pcm_stream(struct snd_sst_params *str_param)
 	struct stream_info *str_info;
 	int retval;
 
+	pm_runtime_get_sync(&sst_drv_ctx->pci->dev);
+
 	if (sst_drv_ctx->sst_state == SST_SUSPENDED) {
 		/*LPE is suspended, resume it before proceding*/
 		pr_debug("sst: Resuming from Suspended state\n");
 		retval = intel_sst_resume(sst_drv_ctx->pci);
 		if (retval) {
 			pr_err("sst: Resume Failed = %#x, abort\n", retval);
+			pm_runtime_put(&sst_drv_ctx->pci->dev);
 			return retval;
 		}
 	}
@@ -323,21 +327,25 @@ int sst_open_pcm_stream(struct snd_sst_params *str_param)
 		retval = sst_download_fw();
 		if (retval) {
 			pr_err("sst: FW download fail %x, abort\n", retval);
+			pm_runtime_put(&sst_drv_ctx->pci->dev);
 			return retval;
 		}
 		send_intial_rx_timeslot();
 	}
 
-	if (!str_param)
+	if (!str_param) {
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
 		return -EINVAL;
+	}
 
 	retval = sst_get_stream(str_param);
 	if (retval > 0) {
 		sst_drv_ctx->stream_cnt++;
 		str_info = &sst_drv_ctx->streams[retval];
 		str_info->src = MAD_DRV;
+	} else
+		pm_runtime_put(&sst_drv_ctx->pci->dev);
 
-	}
 	return retval;
 }
 
@@ -363,6 +371,7 @@ int sst_close_pcm_stream(unsigned int str_id)
 	stream->period_elapsed = NULL;
 	sst_drv_ctx->stream_cnt--;
 	pr_debug("sst: will call runtime put now\n");
+	pm_runtime_put(&sst_drv_ctx->pci->dev);
 	return 0;
 }
 /*
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index d80a6ee..5149cf1 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -48,7 +48,8 @@ static int intel_sst_reset_dsp_mrst(void)
 	union config_status_reg csr;
 
 	pr_debug("sst: Resetting the DSP in mrst\n");
-	csr.full = 0x3a2;
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.full |= 0x382;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
 	csr.part.strb_cntr_rst = 0;
diff --git a/drivers/staging/intel_sst/intel_sst_ipc.c b/drivers/staging/intel_sst/intel_sst_ipc.c
index 39c67fa..37c6505 100644
--- a/drivers/staging/intel_sst/intel_sst_ipc.c
+++ b/drivers/staging/intel_sst/intel_sst_ipc.c
@@ -180,6 +180,7 @@ int process_fw_init(struct sst_ipc_msg_wq *msg)
 		sst_send_sound_card_type();
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_FW_RUNNING;
+	sst_drv_ctx->lpe_stalled = 0;
 	mutex_unlock(&sst_drv_ctx->sst_lock);
 	pr_debug("sst: FW Version %x.%x\n",
 			init->fw_version.major, init->fw_version.minor);

