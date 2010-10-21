Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0JUBvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:51:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3429 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab0JUBvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:51:10 -0400
Subject: [PATCH] drivers/staging/intel_sst: Use pr_fmt, fix misspellings
From: Joe Perches <joe@perches.com>
To: Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 18:51:06 -0700
Message-ID: <1287625866.15567.48.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove leading "sst: " from format strings.
Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Prefix is changed from "sst: " to "snd_intel_sst: "
Add missing newlines
Trim trailing spaces after newlines
Fix several different misspellings

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/intel_sst/intel_sst.c              |   50 +++---
 .../staging/intel_sst/intel_sst_app_interface.c    |  140 +++++++-------
 .../staging/intel_sst/intel_sst_drv_interface.c    |   62 +++---
 drivers/staging/intel_sst/intel_sst_dsp.c          |   67 ++++---
 drivers/staging/intel_sst/intel_sst_ipc.c          |  144 +++++++-------
 drivers/staging/intel_sst/intel_sst_pvt.c          |   36 ++--
 drivers/staging/intel_sst/intel_sst_stream.c       |   18 +-
 .../staging/intel_sst/intel_sst_stream_encoded.c   |  205 ++++++++++----------
 drivers/staging/intel_sst/intelmid.c               |  157 ++++++++--------
 drivers/staging/intel_sst/intelmid_ctrl.c          |   15 +-
 drivers/staging/intel_sst/intelmid_msic_control.c  |   24 ++-
 drivers/staging/intel_sst/intelmid_pvt.c           |   27 ++--
 drivers/staging/intel_sst/intelmid_v0_control.c    |   32 ++--
 drivers/staging/intel_sst/intelmid_v1_control.c    |   28 ++--
 drivers/staging/intel_sst/intelmid_v2_control.c    |   94 +++++-----
 15 files changed, 566 insertions(+), 533 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index 24d3928..0ba6742 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -29,6 +29,8 @@
  *  This file contains all init functions
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -169,17 +171,17 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 {
 	int i, ret = 0;
 
-	pr_debug("sst: Probe for DID %x\n", pci->device);
+	pr_debug("Probe for DID %x\n", pci->device);
 	mutex_lock(&drv_ctx_lock);
 	if (sst_drv_ctx) {
-		pr_err("sst: Only one sst handle is supported\n");
+		pr_err("Only one sst handle is supported\n");
 		mutex_unlock(&drv_ctx_lock);
 		return -EBUSY;
 	}
 
 	sst_drv_ctx = kzalloc(sizeof(*sst_drv_ctx), GFP_KERNEL);
 	if (!sst_drv_ctx) {
-		pr_err("sst: intel_sst malloc fail\n");
+		pr_err("malloc fail\n");
 		mutex_unlock(&drv_ctx_lock);
 		return -ENOMEM;
 	}
@@ -226,7 +228,7 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 	spin_lock_init(&sst_drv_ctx->list_spin_lock);
 
 	sst_drv_ctx->max_streams = pci_id->driver_data;
-	pr_debug("sst: Got drv data max stream %d\n",
+	pr_debug("Got drv data max stream %d\n",
 				sst_drv_ctx->max_streams);
 	for (i = 1; i <= sst_drv_ctx->max_streams; i++) {
 		struct stream_info *stream = &sst_drv_ctx->streams[i];
@@ -241,18 +243,18 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 			sst_drv_ctx->mmap_mem =
 				kzalloc(sst_drv_ctx->mmap_len, GFP_KERNEL);
 			if (sst_drv_ctx->mmap_mem) {
-				pr_debug("sst: Got memory %p size 0x%x\n",
+				pr_debug("Got memory %p size 0x%x\n",
 					sst_drv_ctx->mmap_mem,
 					sst_drv_ctx->mmap_len);
 				break;
 			}
 			if (sst_drv_ctx->mmap_len < (SST_MMAP_STEP*PAGE_SIZE)) {
-				pr_err("sst: mem alloc fail...abort!!\n");
+				pr_err("mem alloc fail...abort!!\n");
 				ret = -ENOMEM;
 				goto free_process_reply_wq;
 			}
 			sst_drv_ctx->mmap_len -= (SST_MMAP_STEP * PAGE_SIZE);
-			pr_debug("sst:mem alloc failed...trying %d\n",
+			pr_debug("mem alloc failed...trying %d\n",
 						sst_drv_ctx->mmap_len);
 		}
 	}
@@ -260,7 +262,7 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 	/* Init the device */
 	ret = pci_enable_device(pci);
 	if (ret) {
-		pr_err("sst: device cant be enabled\n");
+		pr_err("device cant be enabled\n");
 		goto do_free_mem;
 	}
 	sst_drv_ctx->pci = pci_dev_get(pci);
@@ -273,25 +275,25 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 	sst_drv_ctx->shim = pci_ioremap_bar(pci, 1);
 	if (!sst_drv_ctx->shim)
 		goto do_release_regions;
-	pr_debug("sst: SST Shim Ptr %p\n", sst_drv_ctx->shim);
+	pr_debug("SST Shim Ptr %p\n", sst_drv_ctx->shim);
 
 	/* Shared SRAM */
 	sst_drv_ctx->mailbox = pci_ioremap_bar(pci, 2);
 	if (!sst_drv_ctx->mailbox)
 		goto do_unmap_shim;
-	pr_debug("sst: SRAM Ptr %p\n", sst_drv_ctx->mailbox);
+	pr_debug("SRAM Ptr %p\n", sst_drv_ctx->mailbox);
 
 	/* IRAM */
 	sst_drv_ctx->iram = pci_ioremap_bar(pci, 3);
 	if (!sst_drv_ctx->iram)
 		goto do_unmap_sram;
-	pr_debug("sst:IRAM Ptr %p\n", sst_drv_ctx->iram);
+	pr_debug("IRAM Ptr %p\n", sst_drv_ctx->iram);
 
 	/* DRAM */
 	sst_drv_ctx->dram = pci_ioremap_bar(pci, 4);
 	if (!sst_drv_ctx->dram)
 		goto do_unmap_iram;
-	pr_debug("sst: DRAM Ptr %p\n", sst_drv_ctx->dram);
+	pr_debug("DRAM Ptr %p\n", sst_drv_ctx->dram);
 
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_UN_INIT;
@@ -301,24 +303,24 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 		IRQF_SHARED, SST_DRV_NAME, sst_drv_ctx);
 	if (ret)
 		goto do_unmap_dram;
-	pr_debug("sst: Registered IRQ 0x%x\n", pci->irq);
+	pr_debug("Registered IRQ 0x%x\n", pci->irq);
 
 	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
 		ret = misc_register(&lpe_dev);
 		if (ret) {
-			pr_err("sst: couldn't register LPE device\n");
+			pr_err("couldn't register LPE device\n");
 			goto do_free_irq;
 		}
 
 		/*Register LPE Control as misc driver*/
 		ret = misc_register(&lpe_ctrl);
 		if (ret) {
-			pr_err("sst: couldn't register misc driver\n");
+			pr_err("couldn't register misc driver\n");
 			goto do_free_irq;
 		}
 	}
 	sst_drv_ctx->lpe_stalled = 0;
-	pr_debug("sst: ...successfully done!!!\n");
+	pr_debug("...successfully done!!!\n");
 	return ret;
 
 do_free_irq:
@@ -347,7 +349,7 @@ free_mad_wq:
 	destroy_workqueue(sst_drv_ctx->mad_wq);
 do_free_drv_ctx:
 	kfree(sst_drv_ctx);
-	pr_err("sst: Probe failed with 0x%x\n", ret);
+	pr_err("Probe failed with 0x%x\n", ret);
 	return ret;
 }
 
@@ -404,7 +406,7 @@ int intel_sst_suspend(struct pci_dev *pci, pm_message_t state)
 {
 	union config_status_reg csr;
 
-	pr_debug("sst: intel_sst_suspend called\n");
+	pr_debug("intel_sst_suspend called\n");
 
 	if (sst_drv_ctx->pb_streams != 0 || sst_drv_ctx->cp_streams != 0)
 		return -EPERM;
@@ -434,9 +436,9 @@ int intel_sst_resume(struct pci_dev *pci)
 {
 	int ret = 0;
 
-	pr_debug("sst: intel_sst_resume called\n");
+	pr_debug("intel_sst_resume called\n");
 	if (sst_drv_ctx->sst_state != SST_SUSPENDED) {
-		pr_err("sst: SST is not in suspended state\n");
+		pr_err("SST is not in suspended state\n");
 		return -EPERM;
 	}
 	sst_drv_ctx = pci_get_drvdata(pci);
@@ -444,7 +446,7 @@ int intel_sst_resume(struct pci_dev *pci)
 	pci_restore_state(pci);
 	ret = pci_enable_device(pci);
 	if (ret)
-		pr_err("sst: device cant be enabled\n");
+		pr_err("device cant be enabled\n");
 
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_UN_INIT;
@@ -482,14 +484,14 @@ static int __init intel_sst_init(void)
 {
 	/* Init all variables, data structure etc....*/
 	int ret = 0;
-	pr_debug("sst: INFO: ******** SST DRIVER loading.. Ver: %s\n",
+	pr_debug("INFO: ******** SST DRIVER loading.. Ver: %s\n",
 				       SST_DRIVER_VERSION);
 
 	mutex_init(&drv_ctx_lock);
 	/* Register with PCI */
 	ret = pci_register_driver(&driver);
 	if (ret)
-		pr_err("sst: PCI register failed\n");
+		pr_err("PCI register failed\n");
 	return ret;
 }
 
@@ -504,7 +506,7 @@ static void __exit intel_sst_exit(void)
 {
 	pci_unregister_driver(&driver);
 
-	pr_debug("sst: driver unloaded\n");
+	pr_debug("driver unloaded\n");
 	return;
 }
 
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 463e5cb..fb718d4 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -27,6 +27,8 @@
  *  Upper layer interfaces (MAD driver, MMF) to SST driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/uio.h>
@@ -59,14 +61,14 @@ static int intel_sst_check_device(void)
 {
 	int retval = 0;
 	if (sst_drv_ctx->pmic_state != SND_MAD_INIT_DONE) {
-		pr_warn("sst: Sound card not availble\n ");
+		pr_warn("Sound card not available\n");
 		return -EIO;
 	}
 	if (sst_drv_ctx->sst_state == SST_SUSPENDED) {
-		pr_debug("sst: Resuming from Suspended state\n");
+		pr_debug("Resuming from Suspended state\n");
 		retval = intel_sst_resume(sst_drv_ctx->pci);
 		if (retval) {
-			pr_debug("sst: Resume Failed= %#x,abort\n", retval);
+			pr_debug("Resume Failed= %#x,abort\n", retval);
 			return retval;
 		}
 	}
@@ -116,7 +118,7 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 		data->pvt_id = sst_assign_pvt_id(sst_drv_ctx);
 		data->str_id = 0;
 		file_ptr->private_data = (void *)data;
-		pr_debug("sst: pvt_id handle = %d!\n", data->pvt_id);
+		pr_debug("pvt_id handle = %d!\n", data->pvt_id);
 	} else {
 		retval = -EUSERS;
 		mutex_unlock(&sst_drv_ctx->stream_lock);
@@ -145,7 +147,7 @@ int intel_sst_open_cntrl(struct inode *i_node, struct file *file_ptr)
 	mutex_lock(&sst_drv_ctx->stream_lock);
 	if (sst_drv_ctx->am_cnt < MAX_AM_HANDLES) {
 		sst_drv_ctx->am_cnt++;
-		pr_debug("sst: AM handle opened...\n");
+		pr_debug("AM handle opened...\n");
 		file_ptr->private_data = NULL;
 	} else
 		retval = -EACCES;
@@ -167,7 +169,7 @@ int intel_sst_release(struct inode *i_node, struct file *file_ptr)
 {
 	struct ioctl_pvt_data *data = file_ptr->private_data;
 
-	pr_debug("sst: Release called, closing app handle\n");
+	pr_debug("Release called, closing app handle\n");
 	mutex_lock(&sst_drv_ctx->stream_lock);
 	sst_drv_ctx->encoded_cnt--;
 	sst_drv_ctx->stream_cnt--;
@@ -183,7 +185,7 @@ int intel_sst_release_cntrl(struct inode *i_node, struct file *file_ptr)
 	mutex_lock(&sst_drv_ctx->stream_lock);
 	sst_drv_ctx->am_cnt--;
 	mutex_unlock(&sst_drv_ctx->stream_lock);
-	pr_debug("sst: AM handle closed\n");
+	pr_debug("AM handle closed\n");
 	return 0;
 }
 
@@ -209,7 +211,7 @@ int intel_sst_mmap(struct file *file_ptr, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	length = vma->vm_end - vma->vm_start;
-	pr_debug("sst: called for stream %d length 0x%x\n", str_id, length);
+	pr_debug("called for stream %d length 0x%x\n", str_id, length);
 
 	if (length > sst_drv_ctx->mmap_len)
 		return -ENOMEM;
@@ -232,7 +234,7 @@ int intel_sst_mmap(struct file *file_ptr, struct vm_area_struct *vma)
 	else
 		sst_drv_ctx->streams[str_id].mmapped = true;
 
-	pr_debug("sst: mmap ret 0x%x\n", retval);
+	pr_debug("mmap ret 0x%x\n", retval);
 	return retval;
 }
 
@@ -245,7 +247,7 @@ static int intel_sst_mmap_play_capture(u32 str_id,
 	struct stream_info *stream;
 	struct snd_sst_mmap_buff_entry *buf_entry;
 
-	pr_debug("sst:called for str_id %d\n", str_id);
+	pr_debug("called for str_id %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return -EINVAL;
@@ -262,7 +264,7 @@ static int intel_sst_mmap_play_capture(u32 str_id,
 	stream->curr_bytes = 0;
 	stream->cumm_bytes = 0;
 
-	pr_debug("sst:new buffers count %d status %d\n",
+	pr_debug("new buffers count %d status %d\n",
 			mmap_buf->entries, stream->status);
 	buf_entry = mmap_buf->buff;
 	for (i = 0; i < mmap_buf->entries; i++) {
@@ -291,13 +293,13 @@ static int intel_sst_mmap_play_capture(u32 str_id,
 		stream->status = STREAM_RUNNING;
 		if (stream->ops == STREAM_OPS_PLAYBACK) {
 			if (sst_play_frame(str_id) < 0) {
-				pr_warn("sst: play frames fail\n");
+				pr_warn("play frames fail\n");
 				mutex_unlock(&stream->lock);
 				return -EIO;
 			}
 		} else if (stream->ops == STREAM_OPS_CAPTURE) {
 			if (sst_capture_frame(str_id) < 0) {
-				pr_warn("sst: capture frame fail\n");
+				pr_warn("capture frame fail\n");
 				mutex_unlock(&stream->lock);
 				return -EIO;
 			}
@@ -313,7 +315,7 @@ static int intel_sst_mmap_play_capture(u32 str_id,
 
 	if (retval >= 0)
 		retval = stream->cumm_bytes;
-	pr_debug("sst:end of play/rec ioctl bytes = %d!!\n", retval);
+	pr_debug("end of play/rec ioctl bytes = %d!!\n", retval);
 	return retval;
 }
 
@@ -335,7 +337,7 @@ static int intel_sst_play_capture(struct stream_info *stream, int str_id)
 
 	if (stream->status == STREAM_INIT && stream->prev == STREAM_UN_INIT) {
 		/* stream is not started yet */
-		pr_debug("sst: Stream isn't in started state %d, prev %d\n",
+		pr_debug("Stream isn't in started state %d, prev %d\n",
 			stream->status, stream->prev);
 	} else if ((stream->status == STREAM_RUNNING ||
 			stream->status == STREAM_PAUSED) &&
@@ -344,13 +346,13 @@ static int intel_sst_play_capture(struct stream_info *stream, int str_id)
 		if (stream->ops == STREAM_OPS_PLAYBACK ||
 				stream->ops == STREAM_OPS_PLAYBACK_DRM) {
 			if (sst_play_frame(str_id) < 0) {
-				pr_warn("sst: play frames failed\n");
+				pr_warn("play frames failed\n");
 				mutex_unlock(&stream->lock);
 				return -EIO;
 			}
 		} else if (stream->ops == STREAM_OPS_CAPTURE) {
 			if (sst_capture_frame(str_id) < 0) {
-				pr_warn("sst: capture frames failed\n ");
+				pr_warn("capture frames failed\n");
 				mutex_unlock(&stream->lock);
 				return -EIO;
 			}
@@ -365,7 +367,7 @@ static int intel_sst_play_capture(struct stream_info *stream, int str_id)
 	retval = sst_wait_interruptible(sst_drv_ctx, &stream->data_blk);
 	if (retval) {
 		stream->status = STREAM_INIT;
-		pr_debug("sst: wait returned error...\n");
+		pr_debug("wait returned error...\n");
 	}
 	return retval;
 }
@@ -463,7 +465,7 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
 		if (((unsigned long)iovec[index].iov_base
 				+ iovec[index].iov_len) <
 				((unsigned long)iovec[index].iov_base)) {
-			pr_debug("sst: Buffer overflows");
+			pr_debug("Buffer overflows\n");
 			kfree(stream_bufs);
 			return -EINVAL;
 		}
@@ -476,7 +478,7 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
 		}
 
 		copied_size += size;
-		pr_debug("sst: copied_size - %lx\n", copied_size);
+		pr_debug("copied_size - %lx\n", copied_size);
 		if ((copied_size >= mmap_len) ||
 				(stream->sg_index == nr_segs)) {
 			add_to_list = 1;
@@ -506,7 +508,7 @@ static int snd_sst_copy_userbuf_capture(struct stream_info *stream,
 	int retval = 0;
 
 	/* copy sent buffers */
-	pr_debug("sst: capture stream copying to user now...\n");
+	pr_debug("capture stream copying to user now...\n");
 	list_for_each_entry_safe(kbufs, _kbufs, &stream->bufs, node) {
 		if (kbufs->in_use == true) {
 			/* copy to user */
@@ -526,7 +528,7 @@ static int snd_sst_copy_userbuf_capture(struct stream_info *stream,
 			}
 		}
 	}
-	pr_debug("sst: end of cap copy\n");
+	pr_debug("end of cap copy\n");
 	return retval;
 }
 
@@ -578,7 +580,7 @@ static int intel_sst_read_write(unsigned int str_id, char __user *buf,
 		return -EINVAL;
 	stream = &sst_drv_ctx->streams[str_id];
 	if (stream->mmapped == true) {
-		pr_warn("sst: user write and stream is mapped");
+		pr_warn("user write and stream is mapped\n");
 		return -EIO;
 	}
 	if (!count)
@@ -586,7 +588,7 @@ static int intel_sst_read_write(unsigned int str_id, char __user *buf,
 	stream->curr_bytes = 0;
 	stream->cumm_bytes = 0;
 	/* copy user buf details */
-	pr_debug("sst: new buffers %p, copy size %d, status %d\n" ,
+	pr_debug("new buffers %p, copy size %d, status %d\n" ,
 			buf, (int) count, (int) stream->status);
 
 	stream->buf_type = SST_BUF_USER_STATIC;
@@ -606,7 +608,7 @@ static int intel_sst_read_write(unsigned int str_id, char __user *buf,
 	stream->cur_ptr = NULL;
 	if (retval >= 0)
 		retval = stream->cumm_bytes;
-	pr_debug("sst: end of play/rec bytes = %d!!\n", retval);
+	pr_debug("end of play/rec bytes = %d!!\n", retval);
 	return retval;
 }
 
@@ -627,7 +629,7 @@ int intel_sst_write(struct file *file_ptr, const char __user *buf,
 	int str_id = data->str_id;
 	struct stream_info *stream = &sst_drv_ctx->streams[str_id];
 
-	pr_debug("sst: called for %d\n", str_id);
+	pr_debug("called for %d\n", str_id);
 	if (stream->status == STREAM_UN_INIT ||
 		stream->status == STREAM_DECODE) {
 		return -EBADRQC;
@@ -653,12 +655,12 @@ ssize_t intel_sst_aio_write(struct kiocb *kiocb, const struct iovec *iov,
 	int str_id = data->str_id;
 	struct stream_info *stream;
 
-	pr_debug("sst: entry - %ld\n", nr_segs);
+	pr_debug("entry - %ld\n", nr_segs);
 
 	if (is_sync_kiocb(kiocb) == false)
 		return -EINVAL;
 
-	pr_debug("sst: called for str_id %d\n", str_id);
+	pr_debug("called for str_id %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return -EINVAL;
@@ -671,7 +673,7 @@ ssize_t intel_sst_aio_write(struct kiocb *kiocb, const struct iovec *iov,
 	}
 	stream->curr_bytes = 0;
 	stream->cumm_bytes = 0;
-	pr_debug("sst: new segs %ld, offset %d, status %d\n" ,
+	pr_debug("new segs %ld, offset %d, status %d\n" ,
 			nr_segs, (int) offset, (int) stream->status);
 	stream->buf_type = SST_BUF_USER_STATIC;
 	do {
@@ -686,7 +688,7 @@ ssize_t intel_sst_aio_write(struct kiocb *kiocb, const struct iovec *iov,
 	stream->cur_ptr = NULL;
 	if (retval >= 0)
 		retval = stream->cumm_bytes;
-	pr_debug("sst: end of play/rec bytes = %d!!\n", retval);
+	pr_debug("end of play/rec bytes = %d!!\n", retval);
 	return retval;
 }
 
@@ -707,7 +709,7 @@ int intel_sst_read(struct file *file_ptr, char __user *buf,
 	int str_id = data->str_id;
 	struct stream_info *stream = &sst_drv_ctx->streams[str_id];
 
-	pr_debug("sst: called for %d\n", str_id);
+	pr_debug("called for %d\n", str_id);
 	if (stream->status == STREAM_UN_INIT ||
 			stream->status == STREAM_DECODE)
 		return -EBADRQC;
@@ -732,14 +734,14 @@ ssize_t intel_sst_aio_read(struct kiocb *kiocb, const struct iovec *iov,
 	int str_id = data->str_id;
 	struct stream_info *stream;
 
-	pr_debug("sst: entry - %ld\n", nr_segs);
+	pr_debug("entry - %ld\n", nr_segs);
 
 	if (is_sync_kiocb(kiocb) == false) {
-		pr_debug("sst: aio_read from user space is not allowed\n");
+		pr_debug("aio_read from user space is not allowed\n");
 		return -EINVAL;
 	}
 
-	pr_debug("sst: called for str_id %d\n", str_id);
+	pr_debug("called for str_id %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return -EINVAL;
@@ -752,7 +754,7 @@ ssize_t intel_sst_aio_read(struct kiocb *kiocb, const struct iovec *iov,
 	stream->curr_bytes = 0;
 	stream->cumm_bytes = 0;
 
-	pr_debug("sst: new segs %ld, offset %d, status %d\n" ,
+	pr_debug("new segs %ld, offset %d, status %d\n" ,
 			nr_segs, (int) offset, (int) stream->status);
 	stream->buf_type = SST_BUF_USER_STATIC;
 	do {
@@ -767,34 +769,34 @@ ssize_t intel_sst_aio_read(struct kiocb *kiocb, const struct iovec *iov,
 	stream->cur_ptr = NULL;
 	if (retval >= 0)
 		retval = stream->cumm_bytes;
-	pr_debug("sst: end of play/rec bytes = %d!!\n", retval);
+	pr_debug("end of play/rec bytes = %d!!\n", retval);
 	return retval;
 }
 
 /* sst_print_stream_params - prints the stream parameters (debug fn)*/
 static void sst_print_stream_params(struct snd_sst_get_stream_params *get_prm)
 {
-	pr_debug("sst: codec params:result =%d\n",
+	pr_debug("codec params:result = %d\n",
 				get_prm->codec_params.result);
-	pr_debug("sst: codec params:stream = %d\n",
+	pr_debug("codec params:stream = %d\n",
 				get_prm->codec_params.stream_id);
-	pr_debug("sst: codec params:codec = %d\n",
+	pr_debug("codec params:codec = %d\n",
 				get_prm->codec_params.codec);
-	pr_debug("sst: codec params:ops = %d\n",
+	pr_debug("codec params:ops = %d\n",
 				get_prm->codec_params.ops);
-	pr_debug("sst: codec params:stream_type= %d\n",
+	pr_debug("codec params:stream_type = %d\n",
 				get_prm->codec_params.stream_type);
-	pr_debug("sst: pcmparams:sfreq= %d\n",
+	pr_debug("pcmparams:sfreq = %d\n",
 				get_prm->pcm_params.sfreq);
-	pr_debug("sst: pcmparams:num_chan= %d\n",
+	pr_debug("pcmparams:num_chan = %d\n",
 				get_prm->pcm_params.num_chan);
-	pr_debug("sst: pcmparams:pcm_wd_sz= %d\n",
+	pr_debug("pcmparams:pcm_wd_sz = %d\n",
 				get_prm->pcm_params.pcm_wd_sz);
 	return;
 }
 
 /**
- * intel_sst_ioctl - recieves the device ioctl's
+ * intel_sst_ioctl - receives the device ioctl's
  * @file_ptr:pointer to file
  * @cmd:Ioctl cmd
  * @arg:data
@@ -820,7 +822,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_SST_STREAM_PAUSE):
-		pr_debug("sst: IOCTL_PAUSE recieved for %d!\n", str_id);
+		pr_debug("IOCTL_PAUSE received for %d!\n", str_id);
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -829,7 +831,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		break;
 
 	case _IOC_NR(SNDRV_SST_STREAM_RESUME):
-		pr_debug("sst: SNDRV_SST_IOCTL_RESUME recieved!\n");
+		pr_debug("SNDRV_SST_IOCTL_RESUME received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -840,7 +842,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_STREAM_SET_PARAMS): {
 		struct snd_sst_params *str_param = (struct snd_sst_params *)arg;
 
-		pr_debug("sst: IOCTL_SET_PARAMS recieved!\n");
+		pr_debug("IOCTL_SET_PARAMS received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -864,7 +866,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 					retval = -EINVAL;
 			}
 		} else {
-			pr_debug("sst: SET_STREAM_PARAMS recieved!\n");
+			pr_debug("SET_STREAM_PARAMS received!\n");
 			/* allocated set params only */
 			retval = sst_set_stream_param(str_id, str_param);
 			/* Block the call for reply */
@@ -887,21 +889,21 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_SET_VOL): {
 		struct snd_sst_vol *set_vol;
 		struct snd_sst_vol *rec_vol = (struct snd_sst_vol *)arg;
-		pr_debug("sst: SET_VOLUME recieved for %d!\n",
+		pr_debug("SET_VOLUME received for %d!\n",
 				rec_vol->stream_id);
 		if (minor == STREAM_MODULE && rec_vol->stream_id == 0) {
-			pr_debug("sst: invalid operation!\n");
+			pr_debug("invalid operation!\n");
 			retval = -EPERM;
 			break;
 		}
 		set_vol = kzalloc(sizeof(*set_vol), GFP_ATOMIC);
 		if (!set_vol) {
-			pr_debug("sst: mem allocation failed\n");
+			pr_debug("mem allocation failed\n");
 			retval = -ENOMEM;
 			break;
 		}
 		if (copy_from_user(set_vol, rec_vol, sizeof(*set_vol))) {
-			pr_debug("sst: copy failed\n");
+			pr_debug("copy failed\n");
 			retval = -EFAULT;
 			break;
 		}
@@ -912,10 +914,10 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_GET_VOL): {
 		struct snd_sst_vol *rec_vol = (struct snd_sst_vol *)arg;
 		struct snd_sst_vol get_vol;
-		pr_debug("sst: IOCTL_GET_VOLUME recieved for stream = %d!\n",
+		pr_debug("IOCTL_GET_VOLUME received for stream = %d!\n",
 				rec_vol->stream_id);
 		if (minor == STREAM_MODULE && rec_vol->stream_id == 0) {
-			pr_debug("sst: invalid operation!\n");
+			pr_debug("invalid operation!\n");
 			retval = -EPERM;
 			break;
 		}
@@ -925,7 +927,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EIO;
 			break;
 		}
-		pr_debug("sst: id:%d\n, vol:%d, ramp_dur:%d, ramp_type:%d\n",
+		pr_debug("id:%d\n, vol:%d, ramp_dur:%d, ramp_type:%d\n",
 				get_vol.stream_id, get_vol.volume,
 				get_vol.ramp_duration, get_vol.ramp_type);
 		if (copy_to_user((struct snd_sst_vol *)arg,
@@ -940,7 +942,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_MUTE): {
 		struct snd_sst_mute *set_mute;
 		struct snd_sst_vol *rec_mute = (struct snd_sst_vol *)arg;
-		pr_debug("sst: SNDRV_SST_SET_VOLUME recieved for %d!\n",
+		pr_debug("SNDRV_SST_SET_VOLUME received for %d!\n",
 			rec_mute->stream_id);
 		if (minor == STREAM_MODULE && rec_mute->stream_id == 0) {
 			retval = -EPERM;
@@ -962,7 +964,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_STREAM_GET_PARAMS): {
 		struct snd_sst_get_stream_params get_params;
 
-		pr_debug("sst: IOCTL_GET_PARAMS recieved!\n");
+		pr_debug("IOCTL_GET_PARAMS received!\n");
 		if (minor != 0) {
 			retval = -EBADRQC;
 			break;
@@ -984,7 +986,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 
 	case _IOC_NR(SNDRV_SST_MMAP_PLAY):
 	case _IOC_NR(SNDRV_SST_MMAP_CAPTURE):
-		pr_debug("sst: SNDRV_SST_MMAP_PLAY/CAPTURE recieved!\n");
+		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -994,7 +996,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		break;
 
 	case _IOC_NR(SNDRV_SST_STREAM_DROP):
-		pr_debug("sst: SNDRV_SST_IOCTL_DROP recieved!\n");
+		pr_debug("SNDRV_SST_IOCTL_DROP received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EINVAL;
 			break;
@@ -1007,7 +1009,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		struct snd_sst_tstamp tstamp = {0};
 		unsigned long long time, freq, mod;
 
-		pr_debug("sst: SNDRV_SST_STREAM_GET_TSTAMP recieved!\n");
+		pr_debug("SNDRV_SST_STREAM_GET_TSTAMP received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -1028,7 +1030,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_STREAM_START):{
 		struct stream_info *stream;
 
-		pr_debug("sst: SNDRV_SST_STREAM_START recieved!\n");
+		pr_debug("SNDRV_SST_STREAM_START received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EINVAL;
 			break;
@@ -1067,7 +1069,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_SET_TARGET_DEVICE): {
 		struct snd_sst_target_device *target_device;
 
-		pr_debug("sst: SET_TARGET_DEVICE recieved!\n");
+		pr_debug("SET_TARGET_DEVICE received!\n");
 		target_device =	(struct snd_sst_target_device *)arg;
 		BUG_ON(!target_device);
 		if (minor != AM_MODULE) {
@@ -1082,7 +1084,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		struct snd_sst_driver_info *info =
 			(struct snd_sst_driver_info *)arg;
 
-		pr_debug("sst: SNDRV_SST_DRIVER_INFO recived\n");
+		pr_debug("SNDRV_SST_DRIVER_INFO received\n");
 		info->version = SST_VERSION_NUM;
 		/* hard coding, shud get sumhow later */
 		info->active_pcm_streams = sst_drv_ctx->stream_cnt -
@@ -1102,7 +1104,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		struct snd_sst_buff_entry ibuf_temp[param->ibufs->entries],
 				obuf_temp[param->obufs->entries];
 
-		pr_debug("sst: SNDRV_SST_STREAM_DECODE recived\n");
+		pr_debug("SNDRV_SST_STREAM_DECODE received\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -1155,7 +1157,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	}
 
 	case _IOC_NR(SNDRV_SST_STREAM_DRAIN):
-		pr_debug("sst: SNDRV_SST_STREAM_DRAIN recived\n");
+		pr_debug("SNDRV_SST_STREAM_DRAIN received\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EINVAL;
 			break;
@@ -1167,7 +1169,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 		unsigned long long *bytes = (unsigned long long *)arg;
 		struct snd_sst_tstamp tstamp = {0};
 
-		pr_debug("sst: STREAM_BYTES_DECODED recieved!\n");
+		pr_debug("STREAM_BYTES_DECODED received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EINVAL;
 			break;
@@ -1184,7 +1186,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_FW_INFO): {
 		struct snd_sst_fw_info *fw_info;
 
-		pr_debug("sst: SNDRV_SST_FW_INFO recived\n");
+		pr_debug("SNDRV_SST_FW_INFO received\n");
 
 		fw_info = kzalloc(sizeof(*fw_info), GFP_ATOMIC);
 		if (!fw_info) {
@@ -1210,7 +1212,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	default:
 		retval = -EINVAL;
 	}
-	pr_debug("sst: intel_sst_ioctl:complete ret code = %d\n", retval);
+	pr_debug("intel_sst_ioctl:complete ret code = %d\n", retval);
 	return retval;
 }
 
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 669e298..5b10ddf 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -26,6 +26,8 @@
  *  Upper layer interfaces (MAD driver, MMF) to SST driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/fs.h>
@@ -52,10 +54,10 @@ int sst_download_fw(void)
 		name = SST_FW_FILENAME_MRST;
 	else
 		name = SST_FW_FILENAME_MFLD;
-	pr_debug("sst: Downloading %s FW now...\n", name);
+	pr_debug("Downloading %s FW now...\n", name);
 	retval = request_firmware(&fw_sst, name, &sst_drv_ctx->pci->dev);
 	if (retval) {
-		pr_err("sst: request fw failed %d\n", retval);
+		pr_err("request fw failed %d\n", retval);
 		return retval;
 	}
 	sst_drv_ctx->alloc_block[0].sst_id = FW_DWNL_ID;
@@ -66,7 +68,7 @@ int sst_download_fw(void)
 
 	retval = sst_wait_timeout(sst_drv_ctx, &sst_drv_ctx->alloc_block[0]);
 	if (retval)
-		pr_err("sst: fw download failed %d\n" , retval);
+		pr_err("fw download failed %d\n" , retval);
 end_restore:
 	release_firmware(fw_sst);
 	sst_drv_ctx->alloc_block[0].sst_id = BLOCK_UNINIT;
@@ -90,7 +92,7 @@ int sst_stalled(void)
 
 		retry--;
 	}
-	pr_debug("sst: in Stalled State\n");
+	pr_debug("in Stalled State\n");
 	return retval;
 }
 
@@ -138,23 +140,23 @@ int sst_get_stream_allocated(struct snd_sst_params *str_param,
 	retval = sst_alloc_stream((char *) &str_param->sparams, str_param->ops,
 				str_param->codec, str_param->device_type);
 	if (retval < 0) {
-		pr_err("sst: sst_alloc_stream failed %d\n", retval);
+		pr_err("sst_alloc_stream failed %d\n", retval);
 		return retval;
 	}
-	pr_debug("sst: Stream allocated %d\n", retval);
+	pr_debug("Stream allocated %d\n", retval);
 	str_id = retval;
 	str_info = &sst_drv_ctx->streams[str_id];
 	/* Block the call for reply */
 	retval = sst_wait_interruptible_timeout(sst_drv_ctx,
 			&str_info->ctrl_blk, SST_BLOCK_TIMEOUT);
 	if ((retval != 0) || (str_info->ctrl_blk.ret_code != 0)) {
-		pr_debug("sst: FW alloc failed retval %d, ret_code %d\n",
+		pr_debug("FW alloc failed retval %d, ret_code %d\n",
 				retval, str_info->ctrl_blk.ret_code);
 		str_id = -str_info->ctrl_blk.ret_code; /*return error*/
 		*lib_dnld = str_info->ctrl_blk.data;
 		sst_clean_stream(str_info);
 	} else
-		pr_debug("sst: FW Stream allocated sucess\n");
+		pr_debug("FW Stream allocated success\n");
 	return str_id; /*will ret either error (in above if) or correct str id*/
 }
 
@@ -196,14 +198,14 @@ int sst_get_stream(struct snd_sst_params *str_param)
 		/* codec download is required */
 		struct snd_sst_alloc_response *response;
 
-		pr_debug("sst: Codec is required.... trying that\n");
+		pr_debug("Codec is required.... trying that\n");
 		if (lib_dnld == NULL) {
-			pr_err("sst: lib download null!!! abort\n");
+			pr_err("lib download null!!! abort\n");
 			return -EIO;
 		}
 		i = sst_get_block_stream(sst_drv_ctx);
 		response = sst_drv_ctx->alloc_block[i].ops_block.data;
-		pr_debug("sst: alloc block allocated = %d\n", i);
+		pr_debug("alloc block allocated = %d\n", i);
 		if (i < 0) {
 			kfree(lib_dnld);
 			return -ENOMEM;
@@ -213,15 +215,15 @@ int sst_get_stream(struct snd_sst_params *str_param)
 
 		sst_drv_ctx->alloc_block[i].sst_id = BLOCK_UNINIT;
 		if (!retval) {
-			pr_debug("sst: codec was downloaded sucesfully\n");
+			pr_debug("codec was downloaded successfully\n");
 
 			retval = sst_get_stream_allocated(str_param, &lib_dnld);
 			if (retval <= 0)
 				goto err;
 
-			pr_debug("sst: Alloc done stream id %d\n", retval);
+			pr_debug("Alloc done stream id %d\n", retval);
 		} else {
-			pr_debug("sst: codec download failed\n");
+			pr_debug("codec download failed\n");
 			retval = -EIO;
 			goto err;
 		}
@@ -279,10 +281,10 @@ void sst_process_mad_ops(struct work_struct *work)
 		retval = sst_start_stream(mad_ops->stream_id);
 		break;
 	case SST_SND_STREAM_PROCESS:
-		pr_debug("sst: play/capt frames...\n");
+		pr_debug("play/capt frames...\n");
 		break;
 	default:
-		pr_err("sst:  wrong control_ops reported\n");
+		pr_err(" wrong control_ops reported\n");
 	}
 	return;
 }
@@ -301,19 +303,19 @@ int sst_control_set(int control_element, void *value)
 
 	if (sst_drv_ctx->sst_state == SST_SUSPENDED) {
 		/*LPE is suspended, resume it before proceding*/
-		pr_debug("sst: Resuming from Suspended state\n");
+		pr_debug("Resuming from Suspended state\n");
 		retval = intel_sst_resume(sst_drv_ctx->pci);
 		if (retval) {
-			pr_err("sst: Resume Failed = %#x, abort\n", retval);
+			pr_err("Resume Failed = %#x, abort\n", retval);
 			return retval;
 		}
 	}
 	if (sst_drv_ctx->sst_state == SST_UN_INIT) {
 		/* FW is not downloaded */
-		pr_debug("sst: DSP Downloading FW now...\n");
+		pr_debug("DSP Downloading FW now...\n");
 		retval = sst_download_fw();
 		if (retval) {
-			pr_err("sst: FW download fail %x, abort\n", retval);
+			pr_err("FW download fail %x, abort\n", retval);
 			return retval;
 		}
 		if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID &&
@@ -361,7 +363,7 @@ int sst_control_set(int control_element, void *value)
 		struct pcm_stream_info *str_info;
 		struct stream_info *stream;
 
-		pr_debug("sst: stream init called\n");
+		pr_debug("stream init called\n");
 		str_info = (struct pcm_stream_info *)value;
 		str_id = str_info->str_id;
 		retval = sst_validate_strid(str_id);
@@ -369,7 +371,7 @@ int sst_control_set(int control_element, void *value)
 			break;
 
 		stream = &sst_drv_ctx->streams[str_id];
-		pr_debug("sst: setting the period ptrs\n");
+		pr_debug("setting the period ptrs\n");
 		stream->pcm_substream = str_info->mad_substream;
 		stream->period_elapsed = str_info->period_elapsed;
 		stream->sfreq = str_info->sfreq;
@@ -398,14 +400,14 @@ int sst_control_set(int control_element, void *value)
 			+(str_id * sizeof(fw_tstamp))),
 			sizeof(fw_tstamp));
 
-		pr_debug("sst: Pointer Query on strid = %d ops %d\n",
+		pr_debug("Pointer Query on strid = %d ops %d\n",
 						str_id, stream->ops);
 
 		if (stream->ops == STREAM_OPS_PLAYBACK)
 			stream_info->buffer_ptr = fw_tstamp.samples_rendered;
 		else
 			stream_info->buffer_ptr = fw_tstamp.samples_processed;
-		pr_debug("sst: Samples rendered = %llu, buffer ptr %llu\n",
+		pr_debug("Samples rendered = %llu, buffer ptr %llu\n",
 			fw_tstamp.samples_rendered, stream_info->buffer_ptr);
 		break;
 	}
@@ -417,7 +419,7 @@ int sst_control_set(int control_element, void *value)
 	}
 	default:
 		/* Illegal case */
-		pr_warn("sst: illegal req\n");
+		pr_warn("illegal req\n");
 		return -EINVAL;
 	}
 
@@ -439,12 +441,12 @@ struct intel_sst_card_ops sst_pmic_ops = {
 int register_sst_card(struct intel_sst_card_ops *card)
 {
 	if (!sst_drv_ctx) {
-		pr_err("sst: No SST driver register card reject\n");
+		pr_err("No SST driver register card reject\n");
 		return -ENODEV;
 	}
 
 	if (!card || !card->module_name) {
-		pr_err("sst: Null Pointer Passed\n");
+		pr_err("Null Pointer Passed\n");
 		return -EINVAL;
 	}
 	if (sst_drv_ctx->pmic_state == SND_MAD_UN_INIT) {
@@ -460,13 +462,13 @@ int register_sst_card(struct intel_sst_card_ops *card)
 			sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
 			return 0;
 		} else {
-			pr_err("sst: strcmp fail %s\n", card->module_name);
+			pr_err("strcmp fail %s\n", card->module_name);
 			return -EINVAL;
 		}
 
 	} else {
 		/* already registered a driver */
-		pr_err("sst: Repeat for registeration..denied\n");
+		pr_err("Repeat for registration..denied\n");
 		return -EBADRQC;
 	}
 	return 0;
@@ -486,7 +488,7 @@ void unregister_sst_card(struct intel_sst_card_ops *card)
 		/* unreg */
 		sst_pmic_ops.module_name = "";
 		sst_drv_ctx->pmic_state = SND_MAD_UN_INIT;
-		pr_debug("sst: Unregistered %s\n", card->module_name);
+		pr_debug("Unregistered %s\n", card->module_name);
 	}
 	return;
 }
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index d80a6ee..d1b0537 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -29,6 +29,9 @@
  *  This file contains all dsp controlling functions like firmware download,
  * setting/resetting dsp cores, etc
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/firmware.h>
@@ -47,7 +50,7 @@ static int intel_sst_reset_dsp_mrst(void)
 {
 	union config_status_reg csr;
 
-	pr_debug("sst: Resetting the DSP in mrst\n");
+	pr_debug("Resetting the DSP in mrst\n");
 	csr.full = 0x3a2;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
@@ -68,7 +71,7 @@ static int intel_sst_reset_dsp_medfield(void)
 {
 	union config_status_reg csr;
 
-	pr_debug("sst: Resetting the DSP in medfield\n");
+	pr_debug("Resetting the DSP in medfield\n");
 	csr.full = 0x048303E2;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 
@@ -90,7 +93,7 @@ static int sst_start_mrst(void)
 	csr.part.run_stall = 0;
 	csr.part.sst_reset = 0;
 	csr.part.strb_cntr_rst = 1;
-	pr_debug("sst: Setting SST to execute_mrst 0x%x\n", csr.full);
+	pr_debug("Setting SST to execute_mrst 0x%x\n", csr.full);
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 
 	return 0;
@@ -111,7 +114,7 @@ static int sst_start_medfield(void)
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 	csr.full = 0x04830061;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
-	pr_debug("sst: Starting the DSP_medfld\n");
+	pr_debug("Starting the DSP_medfld\n");
 
 	return 0;
 }
@@ -130,16 +133,16 @@ static int sst_parse_module(struct fw_module_header *module)
 	u32 count;
 	void __iomem *ram;
 
-	pr_debug("sst: module sign %s size %x blocks %x type %x\n",
+	pr_debug("module sign %s size %x blocks %x type %x\n",
 			module->signature, module->mod_size,
 			module->blocks, module->type);
-	pr_debug("sst: module entrypoint 0x%x\n", module->entry_point);
+	pr_debug("module entrypoint 0x%x\n", module->entry_point);
 
 	block = (void *)module + sizeof(*module);
 
 	for (count = 0; count < module->blocks; count++) {
 		if (block->size <= 0) {
-			pr_err("sst: block size invalid\n");
+			pr_err("block size invalid\n");
 			return -EINVAL;
 		}
 		switch (block->type) {
@@ -150,7 +153,7 @@ static int sst_parse_module(struct fw_module_header *module)
 			ram = sst_drv_ctx->dram;
 			break;
 		default:
-			pr_err("sst: wrong ram type0x%x in block0x%x\n",
+			pr_err("wrong ram type0x%x in block0x%x\n",
 					block->type, count);
 			return -EINVAL;
 		}
@@ -184,10 +187,10 @@ static int sst_parse_fw_image(const struct firmware *sst_fw)
 	if ((strncmp(header->signature, SST_FW_SIGN, 4) != 0) ||
 			(sst_fw->size != header->file_size + sizeof(*header))) {
 		/* Invalid FW signature */
-		pr_err("sst: InvalidFW sign/filesize mismatch\n");
+		pr_err("Invalid FW sign/filesize mismatch\n");
 		return -EINVAL;
 	}
-	pr_debug("sst: header sign=%s size=%x modules=%x fmt=%x size=%x\n",
+	pr_debug("header sign=%s size=%x modules=%x fmt=%x size=%x\n",
 			header->signature, header->file_size, header->modules,
 			header->file_format, sizeof(*header));
 	module = (void *)sst_fw->data + sizeof(*header);
@@ -214,7 +217,7 @@ int sst_load_fw(const struct firmware *fw, void *context)
 {
 	int ret_val;
 
-	pr_debug("sst: load_fw called\n");
+	pr_debug("load_fw called\n");
 	BUG_ON(!fw);
 
 	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID)
@@ -239,7 +242,7 @@ int sst_load_fw(const struct firmware *fw, void *context)
 	if (ret_val)
 		return ret_val;
 
-	pr_debug("sst: fw loaded successful!!!\n");
+	pr_debug("fw loaded successful!!!\n");
 	return ret_val;
 }
 
@@ -261,7 +264,7 @@ static int sst_download_library(const struct firmware *fw_lib,
 
 	pvt_id = sst_assign_pvt_id(sst_drv_ctx);
 	i = sst_get_block_stream(sst_drv_ctx);
-	pr_debug("sst: alloc block allocated = %d, pvt_id %d\n", i, pvt_id);
+	pr_debug("alloc block allocated = %d, pvt_id %d\n", i, pvt_id);
 	if (i < 0) {
 		kfree(msg);
 		return -ENOMEM;
@@ -281,11 +284,11 @@ static int sst_download_library(const struct firmware *fw_lib,
 	if (retval) {
 		/* error */
 		sst_drv_ctx->alloc_block[i].sst_id = BLOCK_UNINIT;
-		pr_err("sst: Prep codec downloaded failed %d\n",
+		pr_err("Prep codec downloaded failed %d\n",
 				retval);
 		return -EIO;
 	}
-	pr_debug("sst: FW responded, ready for download now...\n");
+	pr_debug("FW responded, ready for download now...\n");
 	/* downloading on success */
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_FW_LOADED;
@@ -325,7 +328,7 @@ static int sst_download_library(const struct firmware *fw_lib,
 	list_add_tail(&msg->node, &sst_drv_ctx->ipc_dispatch_list);
 	spin_unlock(&sst_drv_ctx->list_spin_lock);
 	sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
-	pr_debug("sst: Waiting for FW response Download complete\n");
+	pr_debug("Waiting for FW response Download complete\n");
 	sst_drv_ctx->alloc_block[i].ops_block.condition = false;
 	retval = sst_wait_timeout(sst_drv_ctx, &sst_drv_ctx->alloc_block[i]);
 	if (retval) {
@@ -337,7 +340,7 @@ static int sst_download_library(const struct firmware *fw_lib,
 		return -EIO;
 	}
 
-	pr_debug("sst: FW sucess on Download complete\n");
+	pr_debug("FW success on Download complete\n");
 	sst_drv_ctx->alloc_block[i].sst_id = BLOCK_UNINIT;
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_FW_RUNNING;
@@ -360,14 +363,14 @@ static int sst_validate_library(const struct firmware *fw_lib,
 
 	header = (struct fw_header *)fw_lib->data;
 	if (header->modules != 1) {
-		pr_err("sst: Module no mismatch found\n ");
+		pr_err("Module no mismatch found\n");
 		err = -EINVAL;
 		goto exit;
 	}
 	module = (void *)fw_lib->data + sizeof(*header);
 	*entry_point = module->entry_point;
-	pr_debug("sst: Module entry point 0x%x\n", *entry_point);
-	pr_debug("sst: Module Sign %s, Size 0x%x, Blocks 0x%x Type 0x%x\n",
+	pr_debug("Module entry point 0x%x\n", *entry_point);
+	pr_debug("Module Sign %s, Size 0x%x, Blocks 0x%x Type 0x%x\n",
 			module->signature, module->mod_size,
 			module->blocks, module->type);
 
@@ -381,20 +384,20 @@ static int sst_validate_library(const struct firmware *fw_lib,
 			dsize += block->size;
 			break;
 		default:
-			pr_err("sst: Invalid block type for 0x%x\n", n_blk);
+			pr_err("Invalid block type for 0x%x\n", n_blk);
 			err = -EINVAL;
 			goto exit;
 		}
 		block = (void *)block + sizeof(*block) + block->size;
 	}
 	if (isize > slot->iram_size || dsize > slot->dram_size) {
-		pr_err("sst: library exceeds size allocated\n");
+		pr_err("library exceeds size allocated\n");
 		err = -EINVAL;
 		goto exit;
 	} else
-		pr_debug("sst: Library is safe for download...\n");
+		pr_debug("Library is safe for download...\n");
 
-	pr_debug("sst: iram 0x%x, dram 0x%x, iram 0x%x, dram 0x%x\n",
+	pr_debug("iram 0x%x, dram 0x%x, iram 0x%x, dram 0x%x\n",
 			isize, dsize, slot->iram_size, slot->dram_size);
 exit:
 	return err;
@@ -414,15 +417,15 @@ int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 
 	memset(buf, 0, sizeof(buf));
 
-	pr_debug("sst: Lib Type 0x%x, Slot 0x%x, ops 0x%x\n",
+	pr_debug("Lib Type 0x%x, Slot 0x%x, ops 0x%x\n",
 			lib->lib_info.lib_type, lib->slot_info.slot_num, ops);
-	pr_debug("sst: Version 0x%x, name %s, caps 0x%x media type 0x%x\n",
+	pr_debug("Version 0x%x, name %s, caps 0x%x media type 0x%x\n",
 		lib->lib_info.lib_version, lib->lib_info.lib_name,
 		lib->lib_info.lib_caps, lib->lib_info.media_type);
 
-	pr_debug("sst: IRAM Size 0x%x, offset 0x%x\n",
+	pr_debug("IRAM Size 0x%x, offset 0x%x\n",
 		lib->slot_info.iram_size, lib->slot_info.iram_offset);
-	pr_debug("sst: DRAM Size 0x%x, offset 0x%x\n",
+	pr_debug("DRAM Size 0x%x, offset 0x%x\n",
 		lib->slot_info.dram_size, lib->slot_info.dram_offset);
 
 	switch (lib->lib_info.lib_type) {
@@ -442,7 +445,7 @@ int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 		type = "wma9_";
 		break;
 	default:
-		pr_err("sst: Invalid codec type\n");
+		pr_err("Invalid codec type\n");
 		error = -EINVAL;
 		goto wake;
 	}
@@ -458,11 +461,11 @@ int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 			lib->slot_info.slot_num);
 	len += snprintf(buf + len, sizeof(buf) - len, ".bin");
 
-	pr_debug("sst: Requesting %s\n", buf);
+	pr_debug("Requesting %s\n", buf);
 
 	error = request_firmware(&fw_lib, buf, &sst_drv_ctx->pci->dev);
 	if (error) {
-		pr_err("sst: library load failed %d\n", error);
+		pr_err("library load failed %d\n", error);
 		goto wake;
 	}
 	error = sst_validate_library(fw_lib, &lib->slot_info, &entry_point);
@@ -476,7 +479,7 @@ int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 		goto wake_free;
 
 	/* lib is downloaded and init send alloc again */
-	pr_debug("sst: Library is downloaded now...\n");
+	pr_debug("Library is downloaded now...\n");
 wake_free:
 	/* sst_wake_up_alloc_block(sst_drv_ctx, pvt_id, error, NULL); */
 	release_firmware(fw_lib);
diff --git a/drivers/staging/intel_sst/intel_sst_ipc.c b/drivers/staging/intel_sst/intel_sst_ipc.c
index 39c67fa..993c533 100644
--- a/drivers/staging/intel_sst/intel_sst_ipc.c
+++ b/drivers/staging/intel_sst/intel_sst_ipc.c
@@ -26,6 +26,8 @@
  *  This file defines all ipc functions
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
@@ -75,16 +77,16 @@ void sst_post_message(struct work_struct *work)
 	/*To check if LPE is in stalled state.*/
 	retval = sst_stalled();
 	if (retval < 0) {
-		pr_err("sst: in stalled state\n");
+		pr_err("in stalled state\n");
 		return;
 	}
-	pr_debug("sst: post message called\n");
+	pr_debug("post message called\n");
 	spin_lock(&sst_drv_ctx->list_spin_lock);
 
 	/* check list */
 	if (list_empty(&sst_drv_ctx->ipc_dispatch_list)) {
 		/* list is empty, mask imr */
-		pr_debug("sst: Empty msg queue... masking\n");
+		pr_debug("Empty msg queue... masking\n");
 		imr.full = readl(sst_drv_ctx->shim + SST_IMRX);
 		imr.part.done_interrupt = 1;
 		/* dummy register for shim workaround */
@@ -97,7 +99,7 @@ void sst_post_message(struct work_struct *work)
 	header.full = sst_shim_read(sst_drv_ctx->shim, SST_IPCX);
 	if (header.part.busy) {
 		/* busy, unmask */
-		pr_debug("sst: Busy not free... unmasking\n");
+		pr_debug("Busy not free... unmasking\n");
 		imr.full = readl(sst_drv_ctx->shim + SST_IMRX);
 		imr.part.done_interrupt = 0;
 		/* dummy register for shim workaround */
@@ -109,8 +111,8 @@ void sst_post_message(struct work_struct *work)
 	msg = list_entry(sst_drv_ctx->ipc_dispatch_list.next,
 			struct ipc_post, node);
 	list_del(&msg->node);
-	pr_debug("sst: Post message: header = %x\n", msg->header.full);
-	pr_debug("sst: size: = %x\n", msg->header.part.data);
+	pr_debug("Post message: header = %x\n", msg->header.full);
+	pr_debug("size: = %x\n", msg->header.part.data);
 	if (msg->header.part.large)
 		memcpy_toio(sst_drv_ctx->mailbox + SST_MAILBOX_SEND,
 			msg->mailbox_data, msg->header.part.data);
@@ -166,13 +168,13 @@ int process_fw_init(struct sst_ipc_msg_wq *msg)
 		(struct ipc_header_fw_init *)msg->mailbox;
 	int retval = 0;
 
-	pr_debug("sst: *** FW Init msg came***\n");
+	pr_debug("*** FW Init msg came***\n");
 	if (init->result) {
 		mutex_lock(&sst_drv_ctx->sst_lock);
 		sst_drv_ctx->sst_state = SST_ERROR;
 		mutex_unlock(&sst_drv_ctx->sst_lock);
-		pr_debug("sst: FW Init failed, Error %x\n", init->result);
-		pr_err("sst: FW Init failed, Error %x\n", init->result);
+		pr_debug("FW Init failed, Error %x\n", init->result);
+		pr_err("FW Init failed, Error %x\n", init->result);
 		retval = -init->result;
 		return retval;
 	}
@@ -181,11 +183,11 @@ int process_fw_init(struct sst_ipc_msg_wq *msg)
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_FW_RUNNING;
 	mutex_unlock(&sst_drv_ctx->sst_lock);
-	pr_debug("sst: FW Version %x.%x\n",
+	pr_debug("FW Version %x.%x\n",
 			init->fw_version.major, init->fw_version.minor);
-	pr_debug("sst: Build No %x Type %x\n",
+	pr_debug("Build No %x Type %x\n",
 			init->fw_version.build, init->fw_version.type);
-	pr_debug("sst:  Build date %s Time %s\n",
+	pr_debug(" Build date %s Time %s\n",
 			init->build_info.date, init->build_info.time);
 	sst_wake_up_alloc_block(sst_drv_ctx, FW_DWNL_ID, retval, NULL);
 	return retval;
@@ -204,19 +206,19 @@ void sst_process_message(struct work_struct *work)
 			container_of(work, struct sst_ipc_msg_wq, wq);
 	int str_id = msg->header.part.str_id;
 
-	pr_debug("sst: IPC process for %x\n", msg->header.full);
+	pr_debug("IPC process for %x\n", msg->header.full);
 
 	/* based on msg in list call respective handler */
 	switch (msg->header.part.msg_id) {
 	case IPC_SST_BUF_UNDER_RUN:
 	case IPC_SST_BUF_OVER_RUN:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst:  stream id %d invalid\n", str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
-		pr_err("sst: Buffer under/overrun for%d\n",
+		pr_err("Buffer under/overrun for %d\n",
 				msg->header.part.str_id);
-		pr_err("sst: Got Underrun & not to send data...ignore\n");
+		pr_err("Got Underrun & not to send data...ignore\n");
 		break;
 
 	case IPC_SST_GET_PLAY_FRAMES:
@@ -224,35 +226,35 @@ void sst_process_message(struct work_struct *work)
 			struct stream_info *stream ;
 
 			if (sst_validate_strid(str_id)) {
-				pr_err("sst: strid %d invalid\n", str_id);
+				pr_err("strid %d invalid\n", str_id);
 				break;
 			}
 			/* call sst_play_frame */
 			stream = &sst_drv_ctx->streams[str_id];
-			pr_debug("sst: sst_play_frames for %d\n",
+			pr_debug("sst_play_frames for %d\n",
 					msg->header.part.str_id);
 			mutex_lock(&sst_drv_ctx->streams[str_id].lock);
 			sst_play_frame(msg->header.part.str_id);
 			mutex_unlock(&sst_drv_ctx->streams[str_id].lock);
 			break;
 		} else
-			pr_err("sst: sst_play_frames for Penwell!!\n");
+			pr_err("sst_play_frames for Penwell!!\n");
 
 	case IPC_SST_GET_CAPT_FRAMES:
 		if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
 			struct stream_info *stream;
 			/* call sst_capture_frame */
 			if (sst_validate_strid(str_id)) {
-				pr_err("sst: str id %d invalid\n", str_id);
+				pr_err("str id %d invalid\n", str_id);
 				break;
 			}
 			stream = &sst_drv_ctx->streams[str_id];
-			pr_debug("sst: sst_capture_frames for %d\n",
+			pr_debug("sst_capture_frames for %d\n",
 					msg->header.part.str_id);
 			mutex_lock(&stream->lock);
 			if (stream->mmapped == false &&
 					stream->src == SST_DRV) {
-				pr_debug("sst: waking up block for copy.\n");
+				pr_debug("waking up block for copy.\n");
 				stream->data_blk.ret_code = 0;
 				stream->data_blk.condition = true;
 				stream->data_blk.on = false;
@@ -261,11 +263,11 @@ void sst_process_message(struct work_struct *work)
 				sst_capture_frame(msg->header.part.str_id);
 			mutex_unlock(&stream->lock);
 		} else
-			pr_err("sst: sst_play_frames for Penwell!!\n");
+			pr_err("sst_play_frames for Penwell!!\n");
 		break;
 
 	case IPC_IA_PRINT_STRING:
-		pr_debug("sst: been asked to print something by fw\n");
+		pr_debug("been asked to print something by fw\n");
 		/* TBD */
 		break;
 
@@ -277,12 +279,12 @@ void sst_process_message(struct work_struct *work)
 
 	case IPC_SST_STREAM_PROCESS_FATAL_ERR:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: stream id %d invalid\n", str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
-		pr_err("sst: codec fatal error %x stream %d...\n",
+		pr_err("codec fatal error %x stream %d...\n",
 				msg->header.full, msg->header.part.str_id);
-		pr_err("sst: Dropping the stream\n");
+		pr_err("Dropping the stream\n");
 		sst_drop_stream(msg->header.part.str_id);
 		break;
 	case IPC_IA_LPE_GETTING_STALLED:
@@ -293,7 +295,7 @@ void sst_process_message(struct work_struct *work)
 		break;
 	default:
 		/* Illegal case */
-		pr_err("sst: Unhandled msg %x header %x\n",
+		pr_err("Unhandled msg %x header %x\n",
 		msg->header.part.msg_id, msg->header.full);
 	}
 	sst_clear_interrupt();
@@ -322,7 +324,7 @@ void sst_process_reply(struct work_struct *work)
 		if (!msg->header.part.data) {
 			sst_drv_ctx->tgt_dev_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 			msg->header.part.msg_id, msg->header.part.data);
 			sst_drv_ctx->tgt_dev_blk.ret_code =
 					-msg->header.part.data;
@@ -340,7 +342,7 @@ void sst_process_reply(struct work_struct *work)
 			int major = fw_info->fw_version.major;
 			int minor = fw_info->fw_version.minor;
 			int build = fw_info->fw_version.build;
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 				       msg->header.part.msg_id);
 			pr_debug("INFO: ***FW*** = %02d.%02d.%02d\n",
 					major, minor, build);
@@ -349,13 +351,13 @@ void sst_process_reply(struct work_struct *work)
 				sizeof(struct snd_sst_fw_info));
 			sst_drv_ctx->fw_info_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 			msg->header.part.msg_id, msg->header.part.data);
 			sst_drv_ctx->fw_info_blk.ret_code =
 					-msg->header.part.data;
 		}
 		if (sst_drv_ctx->fw_info_blk.on == true) {
-			pr_debug("sst: Memcopy succedded\n");
+			pr_debug("Memcopy succeeded\n");
 			sst_drv_ctx->fw_info_blk.on = false;
 			sst_drv_ctx->fw_info_blk.condition = true;
 			wake_up(&sst_drv_ctx->wait_queue);
@@ -364,11 +366,11 @@ void sst_process_reply(struct work_struct *work)
 	}
 	case IPC_IA_SET_STREAM_MUTE:
 		if (!msg->header.part.data) {
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 				       msg->header.part.msg_id);
 			sst_drv_ctx->mute_info_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 			msg->header.part.msg_id, msg->header.part.data);
 			sst_drv_ctx->mute_info_blk.ret_code =
 					-msg->header.part.data;
@@ -382,11 +384,11 @@ void sst_process_reply(struct work_struct *work)
 		break;
 	case IPC_IA_SET_STREAM_VOL:
 		if (!msg->header.part.data) {
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 				       msg->header.part.msg_id);
 			sst_drv_ctx->vol_info_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 					msg->header.part.msg_id,
 			msg->header.part.data);
 			sst_drv_ctx->vol_info_blk.ret_code =
@@ -402,15 +404,15 @@ void sst_process_reply(struct work_struct *work)
 		break;
 	case IPC_IA_GET_STREAM_VOL:
 		if (msg->header.part.large) {
-			pr_debug("sst: Large Msg Received Successfully\n");
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Large Msg Received Successfully\n");
+			pr_debug("Msg succeeded %x\n",
 				       msg->header.part.msg_id);
 			memcpy_fromio(sst_drv_ctx->vol_info_blk.data,
 				(void *) msg->mailbox,
 				sizeof(struct snd_sst_vol));
 			sst_drv_ctx->vol_info_blk.ret_code = 0;
 		} else {
-			pr_err("sst: Msg %x reply error %x\n",
+			pr_err("Msg %x reply error %x\n",
 			msg->header.part.msg_id, msg->header.part.data);
 			sst_drv_ctx->vol_info_blk.ret_code =
 					-msg->header.part.data;
@@ -424,18 +426,18 @@ void sst_process_reply(struct work_struct *work)
 
 	case IPC_IA_GET_STREAM_PARAMS:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: stream id %d invalid\n", str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
 		str_info = &sst_drv_ctx->streams[str_id];
 		if (msg->header.part.large) {
-			pr_debug("sst: Get stream large success\n");
+			pr_debug("Get stream large success\n");
 			memcpy_fromio(str_info->ctrl_blk.data,
 				((void *)(msg->mailbox)),
 				sizeof(struct snd_sst_fw_get_stream_params));
 			str_info->ctrl_blk.ret_code = 0;
 		} else {
-			pr_err("sst: Msg %x reply error %x\n",
+			pr_err("Msg %x reply error %x\n",
 				msg->header.part.msg_id, msg->header.part.data);
 			str_info->ctrl_blk.ret_code = -msg->header.part.data;
 		}
@@ -447,19 +449,19 @@ void sst_process_reply(struct work_struct *work)
 		break;
 	case IPC_IA_DECODE_FRAMES:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: stream id %d invalid\n", str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
 		str_info = &sst_drv_ctx->streams[str_id];
 		if (msg->header.part.large) {
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 				       msg->header.part.msg_id);
 			memcpy_fromio(str_info->data_blk.data,
 					((void *)(msg->mailbox)),
 					sizeof(struct snd_sst_decode_info));
 			str_info->data_blk.ret_code = 0;
 		} else {
-			pr_err("sst: Msg %x reply error %x\n",
+			pr_err("Msg %x reply error %x\n",
 				msg->header.part.msg_id, msg->header.part.data);
 			str_info->data_blk.ret_code = -msg->header.part.data;
 		}
@@ -471,17 +473,17 @@ void sst_process_reply(struct work_struct *work)
 		break;
 	case IPC_IA_DRAIN_STREAM:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: stream id %d invalid\n", str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
 		str_info = &sst_drv_ctx->streams[str_id];
 		if (!msg->header.part.data) {
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 					msg->header.part.msg_id);
 			str_info->ctrl_blk.ret_code = 0;
 
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 				msg->header.part.msg_id, msg->header.part.data);
 			str_info->ctrl_blk.ret_code = -msg->header.part.data;
 
@@ -496,7 +498,7 @@ void sst_process_reply(struct work_struct *work)
 
 	case IPC_IA_DROP_STREAM:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: str id %d invalid\n", str_id);
+			pr_err("str id %d invalid\n", str_id);
 			break;
 		}
 		str_info = &sst_drv_ctx->streams[str_id];
@@ -504,12 +506,12 @@ void sst_process_reply(struct work_struct *work)
 			struct snd_sst_drop_response *drop_resp =
 				(struct snd_sst_drop_response *)msg->mailbox;
 
-			pr_debug("sst: Drop ret bytes %x\n", drop_resp->bytes);
+			pr_debug("Drop ret bytes %x\n", drop_resp->bytes);
 
 			str_info->curr_bytes = drop_resp->bytes;
 			str_info->ctrl_blk.ret_code =  0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 				msg->header.part.msg_id, msg->header.part.data);
 			str_info->ctrl_blk.ret_code = -msg->header.part.data;
 		}
@@ -521,10 +523,10 @@ void sst_process_reply(struct work_struct *work)
 		break;
 	case IPC_IA_ENABLE_RX_TIME_SLOT:
 		if (!msg->header.part.data) {
-			pr_debug("sst: RX_TIME_SLOT success\n");
+			pr_debug("RX_TIME_SLOT success\n");
 			sst_drv_ctx->hs_info_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 				msg->header.part.msg_id,
 				msg->header.part.data);
 			sst_drv_ctx->hs_info_blk.ret_code =
@@ -541,17 +543,17 @@ void sst_process_reply(struct work_struct *work)
 	case IPC_IA_SET_STREAM_PARAMS:
 		str_info = &sst_drv_ctx->streams[str_id];
 		if (!msg->header.part.data) {
-			pr_debug("sst: Msg succedded %x\n",
+			pr_debug("Msg succeeded %x\n",
 					msg->header.part.msg_id);
 			str_info->ctrl_blk.ret_code = 0;
 		} else {
-			pr_err("sst:  Msg %x reply error %x\n",
+			pr_err(" Msg %x reply error %x\n",
 					msg->header.part.msg_id,
 					msg->header.part.data);
 			str_info->ctrl_blk.ret_code = -msg->header.part.data;
 		}
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst:  stream id %d invalid\n", str_id);
+			pr_err(" stream id %d invalid\n", str_id);
 			break;
 		}
 
@@ -564,9 +566,9 @@ void sst_process_reply(struct work_struct *work)
 
 	case IPC_IA_FREE_STREAM:
 		if (!msg->header.part.data) {
-			pr_debug("sst: Stream %d freed\n", str_id);
+			pr_debug("Stream %d freed\n", str_id);
 		} else {
-			pr_err("sst: Free for %d ret error %x\n",
+			pr_err("Free for %d ret error %x\n",
 				       str_id, msg->header.part.data);
 		}
 		break;
@@ -575,7 +577,7 @@ void sst_process_reply(struct work_struct *work)
 		struct snd_sst_alloc_response *resp =
 				(struct snd_sst_alloc_response *)msg->mailbox;
 		if (resp->str_type.result)
-			pr_err("sst: error alloc stream = %x\n",
+			pr_err("error alloc stream = %x\n",
 				       resp->str_type.result);
 		sst_alloc_stream_response(str_id, resp);
 		break;
@@ -584,21 +586,21 @@ void sst_process_reply(struct work_struct *work)
 	case IPC_IA_PLAY_FRAMES:
 	case IPC_IA_CAPT_FRAMES:
 		if (sst_validate_strid(str_id)) {
-			pr_err("sst: stream id %d invalid\n" , str_id);
+			pr_err("stream id %d invalid\n", str_id);
 			break;
 		}
-		pr_debug("sst: Ack for play/capt frames recived\n");
+		pr_debug("Ack for play/capt frames received\n");
 		break;
 
 	case IPC_IA_PREP_LIB_DNLD: {
 		struct snd_sst_str_type *str_type =
 			(struct snd_sst_str_type *)msg->mailbox;
-		pr_debug("sst: Prep Lib download %x\n",
+		pr_debug("Prep Lib download %x\n",
 				msg->header.part.msg_id);
 		if (str_type->result)
-			pr_err("sst: Prep lib download %x\n", str_type->result);
+			pr_err("Prep lib download %x\n", str_type->result);
 		else
-			pr_debug("sst: Can download codec now...\n");
+			pr_debug("Can download codec now...\n");
 		sst_wake_up_alloc_block(sst_drv_ctx, str_id,
 				str_type->result, NULL);
 		break;
@@ -609,12 +611,12 @@ void sst_process_reply(struct work_struct *work)
 			(struct snd_sst_lib_download_info *)msg->mailbox;
 		int retval = resp->result;
 
-		pr_debug("sst: Lib downloaded %x\n", msg->header.part.msg_id);
+		pr_debug("Lib downloaded %x\n", msg->header.part.msg_id);
 		if (resp->result) {
-			pr_err("sst: err in lib dload %x\n", resp->result);
+			pr_err("err in lib dload %x\n", resp->result);
 		} else {
-			pr_debug("sst: Codec download complete...\n");
-			pr_debug("sst: codec Type %d Ver %d Built %s: %s\n",
+			pr_debug("Codec download complete...\n");
+			pr_debug("codec Type %d Ver %d Built %s: %s\n",
 				resp->dload_lib.lib_info.lib_type,
 				resp->dload_lib.lib_info.lib_version,
 				resp->dload_lib.lib_info.b_date,
@@ -639,17 +641,17 @@ void sst_process_reply(struct work_struct *work)
 	case IPC_IA_GET_FW_BUILD_INF: {
 		struct sst_fw_build_info *build =
 			(struct sst_fw_build_info *)msg->mailbox;
-		pr_debug("sst: Build date:%sTime:%s", build->date, build->time);
+		pr_debug("Build date:%sTime:%s", build->date, build->time);
 		break;
 	}
 	case IPC_IA_SET_PMIC_TYPE:
 		break;
 	case IPC_IA_START_STREAM:
-		pr_debug("sst: reply for START STREAM %x\n", msg->header.full);
+		pr_debug("reply for START STREAM %x\n", msg->header.full);
 		break;
 	default:
 		/* Illegal case */
-		pr_err("sst: process reply:default = %x\n", msg->header.full);
+		pr_err("process reply:default = %x\n", msg->header.full);
 	}
 	sst_clear_interrupt();
 	return;
diff --git a/drivers/staging/intel_sst/intel_sst_pvt.c b/drivers/staging/intel_sst/intel_sst_pvt.c
index 6487e19..01f8c3b 100644
--- a/drivers/staging/intel_sst/intel_sst_pvt.c
+++ b/drivers/staging/intel_sst/intel_sst_pvt.c
@@ -29,6 +29,8 @@
  *  This file contains all private functions
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/firmware.h>
@@ -60,7 +62,7 @@ int sst_get_block_stream(struct intel_sst_drv *sst_drv_ctx)
 		}
 	}
 	if (i == MAX_ACTIVE_STREAM) {
-		pr_err("sst: max alloc_stream reached");
+		pr_err("max alloc_stream reached\n");
 		i = -EBUSY; /* active stream limit reached */
 	}
 	return i;
@@ -84,14 +86,14 @@ int sst_wait_interruptible(struct intel_sst_drv *sst_drv_ctx,
 				block->condition)) {
 		/* event wake */
 		if (block->ret_code < 0) {
-			pr_err("sst: stream failed %d\n", block->ret_code);
+			pr_err("stream failed %d\n", block->ret_code);
 			retval = -EBUSY;
 		} else {
-			pr_debug("sst: event up\n");
+			pr_debug("event up\n");
 			retval = 0;
 		}
 	} else {
-		pr_err("sst: signal interrupted\n");
+		pr_err("signal interrupted\n");
 		retval = -EINTR;
 	}
 	return retval;
@@ -115,18 +117,18 @@ int sst_wait_interruptible_timeout(
 {
 	int retval = 0;
 
-	pr_debug("sst: sst_wait_interruptible_timeout - waiting....\n");
+	pr_debug("sst_wait_interruptible_timeout - waiting....\n");
 	if (wait_event_interruptible_timeout(sst_drv_ctx->wait_queue,
 						block->condition,
 						msecs_to_jiffies(timeout))) {
 		if (block->ret_code < 0)
-			pr_err("sst: stream failed %d\n", block->ret_code);
+			pr_err("stream failed %d\n", block->ret_code);
 		else
-			pr_debug("sst: event up\n");
+			pr_debug("event up\n");
 		retval = block->ret_code;
 	} else {
 		block->on = false;
-		pr_err("sst: timeout occured...\n");
+		pr_err("timeout occurred...\n");
 		/*setting firmware state as uninit so that the
 		firmware will get re-downloaded on next request
 		this is because firmare not responding for 5 sec
@@ -156,18 +158,18 @@ int sst_wait_timeout(struct intel_sst_drv *sst_drv_ctx,
 	/* NOTE:
 	Observed that FW processes the alloc msg and replies even
 	before the alloc thread has finished execution */
-	pr_debug("sst: waiting for %x, condition %x\n",
+	pr_debug("waiting for %x, condition %x\n",
 		       block->sst_id, block->ops_block.condition);
 	if (wait_event_interruptible_timeout(sst_drv_ctx->wait_queue,
 				block->ops_block.condition,
 				msecs_to_jiffies(SST_BLOCK_TIMEOUT))) {
 		/* event wake */
-		pr_debug("sst: Event wake %x\n", block->ops_block.condition);
-		pr_debug("sst: message ret: %d\n", block->ops_block.ret_code);
+		pr_debug("Event wake %x\n", block->ops_block.condition);
+		pr_debug("message ret: %d\n", block->ops_block.ret_code);
 		retval = block->ops_block.ret_code;
 	} else {
 		block->ops_block.on = false;
-		pr_err("sst: Wait timed-out %x\n", block->ops_block.condition);
+		pr_err("Wait timed-out %x\n", block->ops_block.condition);
 		/* settign firmware state as uninit so that the
 		firmware will get redownloaded on next request
 		this is because firmare not responding for 5 sec
@@ -192,14 +194,14 @@ int sst_create_large_msg(struct ipc_post **arg)
 
 	msg = kzalloc(sizeof(struct ipc_post), GFP_ATOMIC);
 	if (!msg) {
-		pr_err("sst: kzalloc msg failed\n");
+		pr_err("kzalloc msg failed\n");
 		return -ENOMEM;
 	}
 
 	msg->mailbox_data = kzalloc(SST_MAILBOX_SIZE, GFP_ATOMIC);
 	if (!msg->mailbox_data) {
 		kfree(msg);
-		pr_err("sst: kzalloc mailbox_data failed");
+		pr_err("kzalloc mailbox_data failed");
 		return -ENOMEM;
 	};
 	*arg = msg;
@@ -219,7 +221,7 @@ int sst_create_short_msg(struct ipc_post **arg)
 
 	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
 	if (!msg) {
-		pr_err("sst: kzalloc msg failed\n");
+		pr_err("kzalloc msg failed\n");
 		return -ENOMEM;
 	}
 	msg->mailbox_data = NULL;
@@ -290,10 +292,10 @@ int sst_enable_rx_timeslot(int status)
 	struct ipc_post *msg = NULL;
 
 	if (sst_create_short_msg(&msg)) {
-		pr_err("sst: mem allocation failed\n");
+		pr_err("mem allocation failed\n");
 			return -ENOMEM;
 	}
-	pr_debug("sst: ipc message sending: ENABLE_RX_TIME_SLOT\n");
+	pr_debug("ipc message sending: ENABLE_RX_TIME_SLOT\n");
 	sst_fill_header(&msg->header, IPC_IA_ENABLE_RX_TIME_SLOT, 0, 0);
 	msg->header.part.data = status;
 	sst_drv_ctx->hs_info_blk.condition = false;
diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index b2c4b70..8f6e100 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -26,6 +26,8 @@
  *  This file contains the stream operations of SST driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
@@ -46,7 +48,7 @@
 int sst_check_device_type(u32 device, u32 num_chan, u32 *pcm_slot)
 {
 	if (device >= MAX_NUM_STREAMS) {
-		pr_debug("sst: device type invalid %d\n", device);
+		pr_debug("device type invalid %d\n", device);
 		return -EINVAL;
 	}
 	if (sst_drv_ctx->streams[device].status == STREAM_UN_INIT) {
@@ -71,15 +73,15 @@ int sst_check_device_type(u32 device, u32 num_chan, u32 *pcm_slot)
 		else if (device == SND_SST_DEVICE_CAPTURE && num_chan == 4)
 			*pcm_slot = 0x0F;
 		else {
-			pr_debug("sst: No condition satisfied.. ret err\n");
+			pr_debug("No condition satisfied.. ret err\n");
 			return -EINVAL;
 		}
 	} else {
-		pr_debug("sst: this stream state is not uni-init, is %d\n",
+		pr_debug("this stream state is not uni-init, is %d\n",
 				sst_drv_ctx->streams[device].status);
 		return -EBADRQC;
 	}
-	pr_debug("sst: returning slot %x\n", *pcm_slot);
+	pr_debug("returning slot %x\n", *pcm_slot);
 	return 0;
 }
 /**
@@ -96,7 +98,7 @@ static unsigned int get_mrst_stream_id(void)
 		if (sst_drv_ctx->streams[i].status == STREAM_UN_INIT)
 			return i;
 	}
-	pr_debug("sst: Didnt find empty stream for mrst\n");
+	pr_debug("Didnt find empty stream for mrst\n");
 	return -EBUSY;
 }
 
@@ -305,7 +307,7 @@ int sst_pause_stream(int str_id)
 		if (str_info->prev == STREAM_UN_INIT)
 			return -EBADRQC;
 		if (str_info->ctrl_blk.on == true) {
-			pr_err("SST ERR: control path is in use\n ");
+			pr_err("SST ERR: control path is in use\n");
 			return -EINVAL;
 		}
 		if (sst_create_short_msg(&msg))
@@ -333,7 +335,7 @@ int sst_pause_stream(int str_id)
 		}
 	} else {
 		retval = -EBADRQC;
-		pr_err("SST ERR:BADQRC for stream\n ");
+		pr_err("SST ERR: BADQRC for stream\n");
 	}
 
 	return retval;
@@ -468,7 +470,7 @@ int sst_drop_stream(int str_id)
 		}
 	} else {
 		retval = -EBADRQC;
-		pr_err("SST ERR:BADQRC for stream\n");
+		pr_err("SST ERR: BADQRC for stream\n");
 	}
 	return retval;
 }
diff --git a/drivers/staging/intel_sst/intel_sst_stream_encoded.c b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
index fbae39f..d4e94f1 100644
--- a/drivers/staging/intel_sst/intel_sst_stream_encoded.c
+++ b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
@@ -26,6 +26,8 @@
  *  This file contains the stream operations of SST driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/syscalls.h>
 #include <linux/firmware.h>
@@ -53,7 +55,7 @@ int sst_get_stream_params(int str_id,
 	struct stream_info *str_info;
 	struct snd_sst_fw_get_stream_params *fw_params;
 
-	pr_debug("sst: get_stream for %d\n", str_id);
+	pr_debug("get_stream for %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return retval;
@@ -61,16 +63,16 @@ int sst_get_stream_params(int str_id,
 	str_info = &sst_drv_ctx->streams[str_id];
 	if (str_info->status != STREAM_UN_INIT) {
 		if (str_info->ctrl_blk.on == true) {
-			pr_err("sst: control path in use\n");
+			pr_err("control path in use\n");
 			return -EINVAL;
 		}
 		if (sst_create_short_msg(&msg)) {
-			pr_err("sst: message creation failed\n");
+			pr_err("message creation failed\n");
 			return -ENOMEM;
 		}
 		fw_params = kzalloc(sizeof(*fw_params), GFP_ATOMIC);
 		if (!fw_params) {
-			pr_err("sst: mem allcoation failed\n ");
+			pr_err("mem allocation failed\n");
 			kfree(msg);
 			return -ENOMEM;
 		}
@@ -104,7 +106,7 @@ int sst_get_stream_params(int str_id,
 		get_params->codec_params.stream_type = str_info->str_type;
 		kfree(fw_params);
 	} else {
-		pr_debug("sst: Stream is not in the init state\n");
+		pr_debug("Stream is not in the init state\n");
 	}
 	return retval;
 }
@@ -125,17 +127,17 @@ int sst_set_stream_param(int str_id, struct snd_sst_params *str_param)
 
 	BUG_ON(!str_param);
 	if (sst_drv_ctx->streams[str_id].ops != str_param->ops) {
-		pr_err("sst: Invalid operation\n");
+		pr_err("Invalid operation\n");
 		return -EINVAL;
 	}
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return retval;
-	pr_debug("sst: set_stream for %d\n", str_id);
+	pr_debug("set_stream for %d\n", str_id);
 	str_info =  &sst_drv_ctx->streams[str_id];
 	if (sst_drv_ctx->streams[str_id].status == STREAM_INIT) {
 		if (str_info->ctrl_blk.on == true) {
-			pr_err("sst: control path in use\n");
+			pr_err("control path in use\n");
 			return -EAGAIN;
 		}
 		if (sst_create_large_msg(&msg))
@@ -163,7 +165,7 @@ int sst_set_stream_param(int str_id, struct snd_sst_params *str_param)
 		}
 	} else {
 		retval = -EBADRQC;
-		pr_err("sst: BADQRC for stream\n");
+		pr_err("BADQRC for stream\n");
 	}
 	return retval;
 }
@@ -183,7 +185,7 @@ int sst_get_vol(struct snd_sst_vol *get_vol)
 	struct snd_sst_vol *fw_get_vol;
 	int str_id = get_vol->stream_id;
 
-	pr_debug("sst: get vol called\n");
+	pr_debug("get vol called\n");
 
 	if (sst_create_short_msg(&msg))
 		return -ENOMEM;
@@ -195,7 +197,7 @@ int sst_get_vol(struct snd_sst_vol *get_vol)
 	sst_drv_ctx->vol_info_blk.on = true;
 	fw_get_vol = kzalloc(sizeof(*fw_get_vol), GFP_ATOMIC);
 	if (!fw_get_vol) {
-		pr_err("sst: mem allocation failed\n");
+		pr_err("mem allocation failed\n");
 		kfree(msg);
 		return -ENOMEM;
 	}
@@ -209,10 +211,10 @@ int sst_get_vol(struct snd_sst_vol *get_vol)
 	if (retval)
 		retval = -EIO;
 	else {
-		pr_debug("sst: stream id %d\n", fw_get_vol->stream_id);
-		pr_debug("sst: volume %d\n", fw_get_vol->volume);
-		pr_debug("sst: ramp duration %d\n", fw_get_vol->ramp_duration);
-		pr_debug("sst: ramp_type %d\n", fw_get_vol->ramp_type);
+		pr_debug("stream id %d\n", fw_get_vol->stream_id);
+		pr_debug("volume %d\n", fw_get_vol->volume);
+		pr_debug("ramp duration %d\n", fw_get_vol->ramp_duration);
+		pr_debug("ramp_type %d\n", fw_get_vol->ramp_type);
 		memcpy(get_vol, fw_get_vol, sizeof(*fw_get_vol));
 	}
 	return retval;
@@ -231,10 +233,10 @@ int sst_set_vol(struct snd_sst_vol *set_vol)
 	int retval = 0;
 	struct ipc_post *msg = NULL;
 
-	pr_debug("sst: set vol called\n");
+	pr_debug("set vol called\n");
 
 	if (sst_create_large_msg(&msg)) {
-		pr_err("sst: message creation failed\n");
+		pr_err("message creation failed\n");
 		return -ENOMEM;
 	}
 	sst_fill_header(&msg->header, IPC_IA_SET_STREAM_VOL, 1,
@@ -254,7 +256,7 @@ int sst_set_vol(struct snd_sst_vol *set_vol)
 	retval = sst_wait_interruptible_timeout(sst_drv_ctx,
 			&sst_drv_ctx->vol_info_blk, SST_BLOCK_TIMEOUT);
 	if (retval) {
-		pr_err("sst: error in set_vol = %d\n", retval);
+		pr_err("error in set_vol = %d\n", retval);
 		retval = -EIO;
 	}
 	return retval;
@@ -273,10 +275,10 @@ int sst_set_mute(struct snd_sst_mute *set_mute)
 	int retval = 0;
 	struct ipc_post *msg = NULL;
 
-	pr_debug("sst: set mute called\n");
+	pr_debug("set mute called\n");
 
 	if (sst_create_large_msg(&msg)) {
-		pr_err("sst: message creation failed\n");
+		pr_err("message creation failed\n");
 		return -ENOMEM;
 	}
 	sst_fill_header(&msg->header, IPC_IA_SET_STREAM_MUTE, 1,
@@ -297,7 +299,7 @@ int sst_set_mute(struct snd_sst_mute *set_mute)
 	retval = sst_wait_interruptible_timeout(sst_drv_ctx,
 			&sst_drv_ctx->mute_info_blk, SST_BLOCK_TIMEOUT);
 	if (retval) {
-		pr_err("sst: error in set_mute = %d\n", retval);
+		pr_err("error in set_mute = %d\n", retval);
 		retval = -EIO;
 	}
 	return retval;
@@ -358,20 +360,20 @@ int sst_parse_target(struct snd_sst_slot_info *slot)
 		slot->device_type == SND_SST_DEVICE_PCM) {
 			retval = sst_activate_target(slot);
 			if (retval)
-				pr_err("sst: SST_Activate_target_fail\n");
+				pr_err("SST_Activate_target_fail\n");
 			else
-				pr_err("sst: SST_Activate_target_pass\n");
+				pr_err("SST_Activate_target_pass\n");
 		return retval;
 	} else if (slot->action == SND_SST_PORT_PREPARE &&
 			slot->device_type == SND_SST_DEVICE_PCM) {
 				retval = sst_prepare_target(slot);
 			if (retval)
-				pr_err("sst: SST_prepare_target_fail\n");
+				pr_err("SST_prepare_target_fail\n");
 			else
-				pr_err("sst: SST_prepare_target_pass\n");
+				pr_err("SST_prepare_target_pass\n");
 			return retval;
 	} else {
-		pr_err("sst: slot_action : %d, device_type: %d\n",
+		pr_err("slot_action : %d, device_type: %d\n",
 				slot->action, slot->device_type);
 		return retval;
 	}
@@ -383,7 +385,7 @@ int sst_send_target(struct snd_sst_target_device *target)
 	struct ipc_post *msg;
 
 	if (sst_create_large_msg(&msg)) {
-		pr_err("sst: message creation failed\n");
+		pr_err("message creation failed\n");
 		return -ENOMEM;
 	}
 	sst_fill_header(&msg->header, IPC_IA_TARGET_DEV_SELECT, 1, 0);
@@ -399,11 +401,11 @@ int sst_send_target(struct snd_sst_target_device *target)
 	list_add_tail(&msg->node, &sst_drv_ctx->ipc_dispatch_list);
 	spin_unlock(&sst_drv_ctx->list_spin_lock);
 	sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
-	pr_debug("sst: message sent- waiting\n");
+	pr_debug("message sent- waiting\n");
 	retval = sst_wait_interruptible_timeout(sst_drv_ctx,
 			&sst_drv_ctx->tgt_dev_blk, TARGET_DEV_BLOCK_TIMEOUT);
 	if (retval)
-		pr_err("sst: target device ipc failed = 0x%x\n", retval);
+		pr_err("target device ipc failed = 0x%x\n", retval);
 	return retval;
 
 }
@@ -439,7 +441,7 @@ int sst_target_device_validate(struct snd_sst_target_device *target)
 					goto err;
 			} else {
 err:
-				pr_err("sst: i/p params incorrect\n");
+				pr_err("i/p params incorrect\n");
 				return -EINVAL;
 			}
 		}
@@ -460,15 +462,15 @@ int sst_target_device_select(struct snd_sst_target_device *target)
 {
 	int retval, i, prepare_count = 0;
 
-	pr_debug("sst: Target Device Select\n");
+	pr_debug("Target Device Select\n");
 
 	if (target->device_route < 0 || target->device_route > 2) {
-		pr_err("sst: device route is invalid\n");
+		pr_err("device route is invalid\n");
 		return -EINVAL;
 	}
 
 	if (target->device_route != 0) {
-		pr_err("sst: Unsupported config\n");
+		pr_err("Unsupported config\n");
 		return -EIO;
 	}
 	retval = sst_target_device_validate(target);
@@ -480,18 +482,18 @@ int sst_target_device_select(struct snd_sst_target_device *target)
 		return retval;
 	for (i = 0; i < SST_MAX_TARGET_DEVICES; i++) {
 		if (target->devices[i].action == SND_SST_PORT_ACTIVATE) {
-			pr_debug("sst: activate called in %d\n", i);
+			pr_debug("activate called in %d\n", i);
 			retval = sst_parse_target(&target->devices[i]);
 			if (retval)
 				return retval;
 		} else if (target->devices[i].action == SND_SST_PORT_PREPARE) {
-			pr_debug("sst: PREPARE in %d, Forwading\n", i);
+			pr_debug("PREPARE in %d, Forwarding\n", i);
 			retval = sst_parse_target(&target->devices[i]);
 			if (retval) {
-				pr_err("sst: Parse Target fail %d", retval);
+				pr_err("Parse Target fail %d\n", retval);
 				return retval;
 			}
-			pr_debug("sst: Parse Target successful %d", retval);
+			pr_debug("Parse Target successful %d\n", retval);
 			if (target->devices[i].device_type ==
 						SND_SST_DEVICE_PCM)
 				prepare_count++;
@@ -512,11 +514,11 @@ static inline int sst_get_RAR(struct RAR_buffer *buffers, int count)
 	rar_status = rar_handle_to_bus(buffers, count);
 
 	if (count != rar_status) {
-		pr_err("sst: The rar CALL Failed");
+		pr_err("The rar CALL Failed");
 		retval = -EIO;
 	}
 	if (buffers->info.type != RAR_TYPE_AUDIO) {
-		pr_err("sst: Invalid RAR type\n");
+		pr_err("Invalid RAR type\n");
 		return -EINVAL;
 	}
 	return retval;
@@ -539,10 +541,10 @@ static int sst_create_sg_list(struct stream_info *stream,
 		if (kbufs->in_use == false) {
 #ifdef CONFIG_MRST_RAR_HANDLER
 			if (stream->ops == STREAM_OPS_PLAYBACK_DRM) {
-				pr_debug("sst: DRM playback handling\n");
+				pr_debug("DRM playback handling\n");
 				rar_buffers.info.handle = (__u32)kbufs->addr;
 				rar_buffers.info.size = kbufs->size;
-				pr_debug("sst: rar handle 0x%x size=0x%x",
+				pr_debug("rar handle 0x%x size=0x%x\n",
 					rar_buffers.info.handle,
 					rar_buffers.info.size);
 				retval =  sst_get_RAR(&rar_buffers, 1);
@@ -552,7 +554,7 @@ static int sst_create_sg_list(struct stream_info *stream,
 				sg_list->addr[i].addr = rar_buffers.bus_address;
 				/* rar_buffers.info.size; */
 				sg_list->addr[i].size = (__u32)kbufs->size;
-				pr_debug("sst: phyaddr[%d] 0x%x Size:0x%x\n"
+				pr_debug("phyaddr[%d] 0x%x Size:0x%x\n"
 					, i, sg_list->addr[i].addr,
 					sg_list->addr[i].size);
 			}
@@ -562,7 +564,7 @@ static int sst_create_sg_list(struct stream_info *stream,
 					virt_to_phys((void *)
 						kbufs->addr + kbufs->offset);
 				sg_list->addr[i].size = kbufs->size;
-				pr_debug("sst: phyaddr[%d]:0x%x Size:0x%x\n"
+				pr_debug("phyaddr[%d]:0x%x Size:0x%x\n"
 				, i , sg_list->addr[i].addr, kbufs->size);
 			}
 			stream->curr_bytes += sg_list->addr[i].size;
@@ -574,7 +576,7 @@ static int sst_create_sg_list(struct stream_info *stream,
 	}
 
 	sg_list->num_entries = i;
-	pr_debug("sst:sg list entries = %d\n", sg_list->num_entries);
+	pr_debug("sg list entries = %d\n", sg_list->num_entries);
 	return i;
 }
 
@@ -595,7 +597,7 @@ int sst_play_frame(int str_id)
 	struct sst_stream_bufs *kbufs = NULL, *_kbufs;
 	struct stream_info *stream;
 
-	pr_debug("sst: play frame for %d\n", str_id);
+	pr_debug("play frame for %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return retval;
@@ -615,14 +617,14 @@ int sst_play_frame(int str_id)
 	stream->curr_bytes = 0;
 	if (list_empty(&stream->bufs)) {
 		/* no user buffer available */
-		pr_debug("sst: Null buffer stream status %d\n", stream->status);
+		pr_debug("Null buffer stream status %d\n", stream->status);
 		stream->prev = stream->status;
 		stream->status = STREAM_INIT;
-		pr_debug("sst:new stream status = %d\n", stream->status);
+		pr_debug("new stream status = %d\n", stream->status);
 		if (stream->need_draining == true) {
-			pr_debug("sst:draining stream\n");
+			pr_debug("draining stream\n");
 			if (sst_create_short_msg(&msg)) {
-				pr_err("sst: mem alloc failed\n");
+				pr_err("mem allocation failed\n");
 				return -ENOMEM;
 			}
 			sst_fill_header(&msg->header, IPC_IA_DRAIN_STREAM,
@@ -633,7 +635,7 @@ int sst_play_frame(int str_id)
 			spin_unlock(&sst_drv_ctx->list_spin_lock);
 			sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
 		} else if (stream->data_blk.on == true) {
-			pr_debug("sst:user list empty.. wake\n");
+			pr_debug("user list empty.. wake\n");
 			/* unblock */
 			stream->data_blk.ret_code = 0;
 			stream->data_blk.condition = true;
@@ -678,7 +680,7 @@ int sst_capture_frame(int str_id)
 	struct stream_info *stream;
 
 
-	pr_debug("sst:capture frame for %d\n", str_id);
+	pr_debug("capture frame for %d\n", str_id);
 	retval = sst_validate_strid(str_id);
 	if (retval)
 		return retval;
@@ -688,19 +690,19 @@ int sst_capture_frame(int str_id)
 		if (kbufs->in_use == true) {
 			list_del(&kbufs->node);
 			kfree(kbufs);
-			pr_debug("sst:del node\n");
+			pr_debug("del node\n");
 		}
 	}
 	if (list_empty(&stream->bufs)) {
 		/* no user buffer available */
-		pr_debug("sst:Null buffer!!!!stream status %d\n",
+		pr_debug("Null buffer!!!!stream status %d\n",
 			       stream->status);
 		stream->prev = stream->status;
 		stream->status = STREAM_INIT;
-		pr_debug("sst:new stream status = %d\n",
+		pr_debug("new stream status = %d\n",
 			       stream->status);
 		if (stream->data_blk.on == true) {
-			pr_debug("sst:user list empty.. wake\n");
+			pr_debug("user list empty.. wake\n");
 			/* unblock */
 			stream->data_blk.ret_code = 0;
 			stream->data_blk.condition = true;
@@ -731,7 +733,7 @@ int sst_capture_frame(int str_id)
 	stream->cumm_bytes += stream->curr_bytes;
 	stream->curr_bytes = 0;
 
-    pr_debug("sst:Cum bytes  = %d\n", stream->cumm_bytes);
+    pr_debug("Cum bytes  = %d\n", stream->cumm_bytes);
 	return 0;
 }
 
@@ -743,7 +745,7 @@ static unsigned int calculate_min_size(struct snd_sst_buffs *bufs)
 		if (bufs->buff_entry[i].size < min_val)
 			min_val = bufs->buff_entry[i].size;
 	}
-	pr_debug("sst:min_val = %d\n", min_val);
+	pr_debug("min_val = %d\n", min_val);
 	return min_val;
 }
 
@@ -754,7 +756,7 @@ static unsigned int calculate_max_size(struct snd_sst_buffs *bufs)
 		if (bufs->buff_entry[i].size > max_val)
 			max_val = bufs->buff_entry[i].size;
 	}
-	pr_debug("sst:max_val = %d\n", max_val);
+	pr_debug("max_val = %d\n", max_val);
 	return max_val;
 }
 
@@ -773,7 +775,7 @@ static int sst_allocate_decode_buf(struct stream_info *str_info,
 			if (dbufs->ibufs->entries == dbufs->obufs->entries)
 				return 0;
 			else {
-				pr_err("sst: RAR entries dont match\n");
+				pr_err("RAR entries dont match\n");
 				 return -EINVAL;
 			}
 		} else
@@ -783,26 +785,26 @@ static int sst_allocate_decode_buf(struct stream_info *str_info,
 	}
 #endif
 	if (!str_info->decode_ibuf) {
-		pr_debug("sst:no i/p buffers, trying full size\n");
+		pr_debug("no i/p buffers, trying full size\n");
 		str_info->decode_isize = cum_input_given;
 		str_info->decode_ibuf = kzalloc(str_info->decode_isize,
 						GFP_KERNEL);
 		str_info->idecode_alloc = str_info->decode_isize;
 	}
 	if (!str_info->decode_ibuf) {
-		pr_debug("sst:buff alloc failed, try max size\n");
+		pr_debug("buff alloc failed, try max size\n");
 		str_info->decode_isize = calculate_max_size(dbufs->ibufs);
 		str_info->decode_ibuf = kzalloc(
 				str_info->decode_isize, GFP_KERNEL);
 		str_info->idecode_alloc = str_info->decode_isize;
 	}
 	if (!str_info->decode_ibuf) {
-		pr_debug("sst:buff alloc failed, try min size\n");
+		pr_debug("buff alloc failed, try min size\n");
 		str_info->decode_isize = calculate_min_size(dbufs->ibufs);
 		str_info->decode_ibuf = kzalloc(str_info->decode_isize,
 						GFP_KERNEL);
 		if (!str_info->decode_ibuf) {
-			pr_err("sst: mem allocation failed\n");
+			pr_err("mem allocation failed\n");
 			return -ENOMEM;
 		}
 		str_info->idecode_alloc = str_info->decode_isize;
@@ -820,7 +822,7 @@ static int sst_send_decode_mess(int str_id, struct stream_info *str_info,
 	struct ipc_post *msg = NULL;
 	int retval = 0;
 
-	pr_debug("SST DBGsst_set_mute:called\n");
+	pr_debug("SST DBG:sst_set_mute:called\n");
 
 	if (str_info->decode_ibuf_type == SST_BUF_RAR) {
 #ifdef CONFIG_MRST_RAR_HANDLER
@@ -857,7 +859,7 @@ static int sst_send_decode_mess(int str_id, struct stream_info *str_info,
 	dec_info->input_bytes_consumed = 0;
 	dec_info->output_bytes_produced = 0;
 	if (sst_create_large_msg(&msg)) {
-		pr_err("sst: message creation failed\n");
+		pr_err("message creation failed\n");
 		return -ENOMEM;
 	}
 
@@ -894,7 +896,7 @@ static int sst_prepare_input_buffers_rar(struct stream_info *str_info,
 				dbufs->ibufs->buff_entry[i].buffer,
 				sizeof(__u32));
 		if (retval) {
-			pr_err("sst:cpy from user fail\n");
+			pr_err("cpy from user fail\n");
 			return -EAGAIN;
 		}
 		rar_buffers.info.type = dbufs->ibufs->type;
@@ -931,7 +933,7 @@ static int sst_prepare_input_buffers(struct stream_info *str_info,
 {
 	int i, cpy_size, retval = 0;
 
-	pr_debug("sst:input_index = %d, input entries = %d\n",
+	pr_debug("input_index = %d, input entries = %d\n",
 			 *input_index, dbufs->ibufs->entries);
 	for (i = *input_index; i < dbufs->ibufs->entries; i++) {
 #ifdef CONFIG_MRST_RAR_HANDLER
@@ -939,7 +941,7 @@ static int sst_prepare_input_buffers(struct stream_info *str_info,
 			dbufs, input_index, in_copied,
 				input_index_valid_size, new_entry_flag);
 		if (retval) {
-			pr_err("sst: In prepare input buffers for RAR\n");
+			pr_err("In prepare input buffers for RAR\n");
 			return -EIO;
 		}
 #endif
@@ -947,10 +949,10 @@ static int sst_prepare_input_buffers(struct stream_info *str_info,
 		if (*input_index_valid_size == 0)
 			*input_index_valid_size =
 				dbufs->ibufs->buff_entry[i].size;
-		pr_debug("sst:inout addr = %p, size = %d\n",
+		pr_debug("inout addr = %p, size = %d\n",
 			dbufs->ibufs->buff_entry[i].buffer,
 			*input_index_valid_size);
-		pr_debug("sst:decode_isize = %d, in_copied %d\n",
+		pr_debug("decode_isize = %d, in_copied %d\n",
 			str_info->decode_isize, *in_copied);
 		if (*input_index_valid_size <=
 					(str_info->decode_isize - *in_copied))
@@ -958,12 +960,12 @@ static int sst_prepare_input_buffers(struct stream_info *str_info,
 		else
 			cpy_size = str_info->decode_isize - *in_copied;
 
-		pr_debug("sst:cpy size = %d\n", cpy_size);
+		pr_debug("cpy size = %d\n", cpy_size);
 		if (!dbufs->ibufs->buff_entry[i].buffer) {
-			pr_err("sst: i/p buffer is null\n");
+			pr_err("i/p buffer is null\n");
 			return -EINVAL;
 		}
-		pr_debug("sst:Try copy To %p, From %p, size %d\n",
+		pr_debug("Try copy To %p, From %p, size %d\n",
 				str_info->decode_ibuf + *in_copied,
 				dbufs->ibufs->buff_entry[i].buffer, cpy_size);
 
@@ -972,22 +974,22 @@ static int sst_prepare_input_buffers(struct stream_info *str_info,
 				(void *) dbufs->ibufs->buff_entry[i].buffer,
 				cpy_size);
 		if (retval) {
-			pr_err("sst: copy from user failed\n");
+			pr_err("copy from user failed\n");
 			return -EIO;
 		}
 		*in_copied += cpy_size;
 		*input_index_valid_size -= cpy_size;
-		pr_debug("sst:in buff size = %d, in_copied = %d\n",
+		pr_debug("in buff size = %d, in_copied = %d\n",
 			*input_index_valid_size, *in_copied);
 		if (*input_index_valid_size != 0) {
-			pr_debug("sst:more input buffers left\n");
+			pr_debug("more input buffers left\n");
 			dbufs->ibufs->buff_entry[i].buffer += cpy_size;
 			break;
 		}
 		if (*in_copied == str_info->decode_isize &&
 			*input_index_valid_size == 0 &&
 			(i+1) <= dbufs->ibufs->entries) {
-			pr_debug("sst:all input buffers copied\n");
+			pr_debug("all input buffers copied\n");
 			*new_entry_flag = true;
 			*input_index = i + 1;
 			break;
@@ -1005,23 +1007,23 @@ static int sst_prepare_output_buffers(struct stream_info *str_info,
 
 {
 	int i, cpy_size, retval = 0;
-	pr_debug("sst:output_index = %d, output entries = %d\n",
+	pr_debug("output_index = %d, output entries = %d\n",
 				*output_index,
 				dbufs->obufs->entries);
 	for (i = *output_index; i < dbufs->obufs->entries; i++) {
 		*output_index = i;
-		pr_debug("sst:output addr = %p, size = %d\n",
+		pr_debug("output addr = %p, size = %d\n",
 			dbufs->obufs->buff_entry[i].buffer,
 			dbufs->obufs->buff_entry[i].size);
-		pr_debug("sst:output_size = %d, out_copied = %d\n",
+		pr_debug("output_size = %d, out_copied = %d\n",
 				output_size, *out_copied);
 		if (dbufs->obufs->buff_entry[i].size <
 				(output_size - *out_copied))
 			cpy_size = dbufs->obufs->buff_entry[i].size;
 		else
 			cpy_size = output_size - *out_copied;
-		pr_debug("sst:cpy size = %d\n", cpy_size);
-		pr_debug("sst:Try copy To: %p, From %p, size %d\n",
+		pr_debug("cpy size = %d\n", cpy_size);
+		pr_debug("Try copy To: %p, From %p, size %d\n",
 				dbufs->obufs->buff_entry[i].buffer,
 				sst_drv_ctx->mmap_mem + *out_copied,
 				cpy_size);
@@ -1029,13 +1031,13 @@ static int sst_prepare_output_buffers(struct stream_info *str_info,
 					sst_drv_ctx->mmap_mem + *out_copied,
 					cpy_size);
 		if (retval) {
-			pr_err("sst: copy to user failed\n");
+			pr_err("copy to user failed\n");
 			return -EIO;
 		} else
-			pr_debug("sst:copy to user passed\n");
+			pr_debug("copy to user passed\n");
 		*out_copied += cpy_size;
 		dbufs->obufs->buff_entry[i].size -= cpy_size;
-		pr_debug("sst:o/p buff size %d, out_copied %d\n",
+		pr_debug("o/p buff size %d, out_copied %d\n",
 			dbufs->obufs->buff_entry[i].size, *out_copied);
 		if (dbufs->obufs->buff_entry[i].size != 0) {
 			*output_index = i;
@@ -1073,7 +1075,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 	unsigned long long input_bytes, output_bytes;
 
 	sst_drv_ctx->scard_ops->power_down_pmic();
-	pr_debug("sst: Powering_down_PMIC...\n");
+	pr_debug("Powering_down_PMIC...\n");
 
 	retval = sst_validate_strid(str_id);
 	if (retval)
@@ -1081,7 +1083,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 
 	str_info = &sst_drv_ctx->streams[str_id];
 	if (str_info->status != STREAM_INIT) {
-		pr_err("sst: invalid stream state = %d\n",
+		pr_err("invalid stream state = %d\n",
 			       str_info->status);
 		return -EINVAL;
 	}
@@ -1098,7 +1100,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 	retval =  sst_allocate_decode_buf(str_info, dbufs,
 				cum_input_given, cum_output_given);
 	if (retval) {
-		pr_err("sst: mem allocation failed, abort!!!\n");
+		pr_err("mem allocation failed, abort!!!\n");
 		retval = -ENOMEM;
 		goto finish;
 	}
@@ -1114,7 +1116,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 			dbufs, &input_index, &in_copied,
 			&input_index_valid_size, &new_entry_flag);
 		if (retval) {
-			pr_err("sst: prepare in buffers failed\n");
+			pr_err("prepare in buffers failed\n");
 			goto finish;
 		}
 
@@ -1145,8 +1147,8 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 				str_info->decode_osize = dbufs->obufs->
 					buff_entry[output_index].size;
 				str_info->decode_obuf_type = dbufs->obufs->type;
-				pr_debug("sst:DRM handling\n");
-				pr_debug("o/p_add=0x%lu Size=0x%x",
+				pr_debug("DRM handling\n");
+				pr_debug("o/p_add=0x%lu Size=0x%x\n",
 					(unsigned long) str_info->decode_obuf,
 					str_info->decode_osize);
 			} else {
@@ -1160,7 +1162,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 		if (str_info->ops != STREAM_OPS_PLAYBACK_DRM) {
 			if (str_info->decode_isize > in_copied) {
 				str_info->decode_isize = in_copied;
-				pr_debug("sst:i/p size = %d\n",
+				pr_debug("i/p size = %d\n",
 						str_info->decode_isize);
 			}
 		}
@@ -1168,20 +1170,19 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 
 		retval = sst_send_decode_mess(str_id, str_info, &dec_info);
 		if (retval || dec_info.input_bytes_consumed == 0) {
-			pr_err(
-				"SST ERR: mess failed or no input consumed\n");
+			pr_err("SST ERR: mess failed or no input consumed\n");
 			goto finish;
 		}
 		input_bytes = dec_info.input_bytes_consumed;
 		output_bytes = dec_info.output_bytes_produced;
 
-		pr_debug("sst:in_copied=%d, con=%lld, prod=%lld\n",
+		pr_debug("in_copied=%d, con=%lld, prod=%lld\n",
 			in_copied, input_bytes, output_bytes);
 		if (dbufs->obufs->type == SST_BUF_RAR) {
 			output_index += 1;
 			if (output_index == dbufs->obufs->entries) {
 				copy_in_done = true;
-				pr_debug("sst:all i/p cpy done\n");
+				pr_debug("all i/p cpy done\n");
 			}
 			total_output += output_bytes;
 		} else {
@@ -1190,14 +1191,14 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 			retval = sst_prepare_output_buffers(str_info, dbufs,
 				&output_index, output_size, &out_copied);
 			if (retval) {
-				pr_err("sst:prep out buff fail\n");
+				pr_err("prep out buff fail\n");
 				goto finish;
 			}
 			if (str_info->ops != STREAM_OPS_PLAYBACK_DRM) {
 				if (in_copied != input_bytes) {
 					int bytes_left = in_copied -
 								input_bytes;
-					pr_debug("sst:bytes %d\n",
+					pr_debug("bytes %d\n",
 							bytes_left);
 					if (new_entry_flag == true)
 						input_index--;
@@ -1237,7 +1238,7 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 			total_output += out_copied;
 			if (str_info->decode_osize != out_copied) {
 				str_info->decode_osize -= out_copied;
-				pr_debug("sst:output size modified = %d\n",
+				pr_debug("output size modified = %d\n",
 						str_info->decode_osize);
 			}
 		}
@@ -1251,16 +1252,16 @@ int sst_decode(int str_id, struct snd_sst_dbufs *dbufs)
 		} else {
 			if (total_output == cum_output_given) {
 				copy_out_done = true;
-				pr_debug("sst:all o/p cpy done\n");
+				pr_debug("all o/p cpy done\n");
 			}
 
 			if (total_input == cum_input_given) {
 				copy_in_done = true;
-				pr_debug("sst:all i/p cpy done\n");
+				pr_debug("all i/p cpy done\n");
 			}
 		}
 
-		pr_debug("sst:copy_out = %d, copy_in = %d\n",
+		pr_debug("copy_out = %d, copy_in = %d\n",
 				copy_out_done, copy_in_done);
 	}
 
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 4c0264c..47b91e5 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -24,6 +24,9 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  * ALSA driver for Intel MID sound card chipset
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
@@ -118,7 +121,7 @@ static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		pr_debug("sst: Trigger Start\n");
+		pr_debug("Trigger Start\n");
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_START,
 				&stream->stream_info.str_id);
 		if (ret_val)
@@ -128,7 +131,7 @@ static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 		stream->stream_status = RUNNING;
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		pr_debug("sst: in stop\n");
+		pr_debug("in stop\n");
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_DROP,
 				&stream->stream_info.str_id);
 		if (ret_val)
@@ -136,7 +139,7 @@ static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 		stream->stream_status = DROPPED;
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		pr_debug("sst: in pause\n");
+		pr_debug("in pause\n");
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_PAUSE,
 				&stream->stream_info.str_id);
 		if (ret_val)
@@ -144,7 +147,7 @@ static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 		stream->stream_status = PAUSED;
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		pr_debug("sst: in pause release\n");
+		pr_debug("in pause release\n");
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_RESUME,
 						&stream->stream_info.str_id);
 		if (ret_val)
@@ -170,17 +173,17 @@ static int snd_intelmad_pcm_prepare(struct snd_pcm_substream *substream)
 	int ret_val = 0;
 	struct snd_intelmad *intelmaddata;
 
-	pr_debug("sst: pcm_prepare called\n");
+	pr_debug("pcm_prepare called\n");
 
 	WARN_ON(!substream);
 	stream = substream->runtime->private_data;
 	intelmaddata = snd_pcm_substream_chip(substream);
-	pr_debug("sst: pb cnt = %d cap cnt = %d\n",\
+	pr_debug("pb cnt = %d cap cnt = %d\n",\
 		intelmaddata->playback_cnt,
 		intelmaddata->capture_cnt);
 
 	if (stream->stream_info.str_id) {
-		pr_debug("sst: Prepare called for already set stream\n");
+		pr_debug("Prepare called for already set stream\n");
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_DROP,
 					&stream->stream_info.str_id);
 		return ret_val;
@@ -197,7 +200,7 @@ static int snd_intelmad_pcm_prepare(struct snd_pcm_substream *substream)
 	/* return back the stream id */
 	snprintf(substream->pcm->id, sizeof(substream->pcm->id),
 			"%d", stream->stream_info.str_id);
-	pr_debug("sst: stream id to user = %s\n",
+	pr_debug("stream id to user = %s\n",
 			substream->pcm->id);
 
 	ret_val = snd_intelmad_init_stream(substream);
@@ -212,7 +215,7 @@ static int snd_intelmad_hw_params(struct snd_pcm_substream *substream,
 {
 	int ret_val;
 
-	pr_debug("sst: snd_intelmad_hw_params called\n");
+	pr_debug("snd_intelmad_hw_params called\n");
 	ret_val = snd_pcm_lib_malloc_pages(substream,
 			params_buffer_bytes(hw_params));
 	memset(substream->runtime->dma_area, 0,
@@ -223,7 +226,7 @@ static int snd_intelmad_hw_params(struct snd_pcm_substream *substream,
 
 static int snd_intelmad_hw_free(struct snd_pcm_substream *substream)
 {
-	pr_debug("sst: snd_intelmad_hw_free called\n");
+	pr_debug("snd_intelmad_hw_free called\n");
 	return snd_pcm_lib_free_pages(substream);
 }
 
@@ -253,12 +256,12 @@ static snd_pcm_uframes_t snd_intelmad_pcm_pointer
 	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_BUFFER_POINTER,
 				&stream->stream_info);
 	if (ret_val) {
-		pr_err("sst: error code = 0x%x\n", ret_val);
+		pr_err("error code = 0x%x\n", ret_val);
 		return ret_val;
 	}
-	pr_debug("sst: samples reported out 0x%llx\n",
+	pr_debug("samples reported out 0x%llx\n",
 			stream->stream_info.buffer_ptr);
-	pr_debug("sst: Frame bits:: %d period_count :: %d\n",
+	pr_debug("Frame bits:: %d period_count :: %d\n",
 			(int)substream->runtime->frame_bits,
 			(int)substream->runtime->period_size);
 
@@ -283,10 +286,10 @@ static int snd_intelmad_close(struct snd_pcm_substream *substream)
 
 	stream = substream->runtime->private_data;
 
-	pr_debug("sst: snd_intelmad_close called\n");
+	pr_debug("snd_intelmad_close called\n");
 	intelmaddata = snd_pcm_substream_chip(substream);
 
-	pr_debug("sst: str id = %d\n", stream->stream_info.str_id);
+	pr_debug("str id = %d\n", stream->stream_info.str_id);
 	if (stream->stream_info.str_id) {
 		/* SST API to actually stop/free the stream */
 		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_FREE,
@@ -296,7 +299,7 @@ static int snd_intelmad_close(struct snd_pcm_substream *substream)
 		else
 			intelmaddata->capture_cnt--;
 	}
-	pr_debug("sst: snd_intelmad_close : pb cnt = %d cap cnt = %d\n",
+	pr_debug("snd_intelmad_close : pb cnt = %d cap cnt = %d\n",
 		intelmaddata->playback_cnt, intelmaddata->capture_cnt);
 	kfree(substream->runtime->private_data);
 	return ret_val;
@@ -319,7 +322,7 @@ static int snd_intelmad_open(struct snd_pcm_substream *substream,
 
 	WARN_ON(!substream);
 
-	pr_debug("sst: snd_intelmad_open called\n");
+	pr_debug("snd_intelmad_open called\n");
 
 	intelmaddata = snd_pcm_substream_chip(substream);
 	runtime = substream->runtime;
@@ -456,17 +459,17 @@ void sst_mad_send_jack_report(struct snd_jack *jack,
 {
 
 	if (!jack) {
-		pr_debug("sst: MAD error jack empty\n");
+		pr_debug("MAD error jack empty\n");
 
 	} else {
-		pr_debug("sst: MAD send jack report for = %d!!!\n", status);
-		pr_debug("sst: MAD send jack report %d\n", jack->type);
+		pr_debug("MAD send jack report for = %d!!!\n", status);
+		pr_debug("MAD send jack report %d\n", jack->type);
 		snd_jack_report(jack, status);
 
 		/*button pressed and released */
 		if (buttonpressevent)
 			snd_jack_report(jack, 0);
-		pr_debug("sst: MAD sending jack report Done !!!\n");
+		pr_debug("MAD sending jack report Done !!!\n");
 	}
 
 
@@ -490,7 +493,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 	if (intsts & 0x4) {
 
 		if (!(intelmid_audio_interrupt_enable)) {
-			pr_debug("sst: Audio interrupt enable\n");
+			pr_debug("Audio interrupt enable\n");
 			sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 3);
 
 			sst_sc_reg_access(sc_access_write, PMIC_WRITE, 1);
@@ -500,7 +503,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 
 		}
 		/* send headphone detect */
-		pr_debug("sst: MAD headphone %d\n", intsts & 0x4);
+		pr_debug("MAD headphone %d\n", intsts & 0x4);
 		jack = &intelmaddata->jack[0].jack;
 		present = !(intelmaddata->jack[0].jack_status);
 		intelmaddata->jack[0].jack_status = present;
@@ -510,7 +513,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 
 	if (intsts & 0x2) {
 		/* send short push */
-		pr_debug("sst: MAD short push %d\n", intsts & 0x2);
+		pr_debug("MAD short push %d\n", intsts & 0x2);
 		jack = &intelmaddata->jack[2].jack;
 		present = 1;
 		jack_event_flag = 1;
@@ -518,7 +521,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 	}
 	if (intsts & 0x1) {
 		/* send long push */
-		pr_debug("sst: MAD long push %d\n", intsts & 0x1);
+		pr_debug("MAD long push %d\n", intsts & 0x1);
 		jack = &intelmaddata->jack[3].jack;
 		present = 1;
 		jack_event_flag = 1;
@@ -526,7 +529,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 	}
 	if (intsts & 0x8) {
 		if (!(intelmid_audio_interrupt_enable)) {
-			pr_debug("sst: Audio interrupt enable\n");
+			pr_debug("Audio interrupt enable\n");
 			sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 3);
 
 			sst_sc_reg_access(sc_access_write, PMIC_WRITE, 1);
@@ -535,7 +538,7 @@ void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
 			intelmaddata->jack[1].jack_status = 0;
 		}
 		/* send headset detect */
-		pr_debug("sst: MAD headset = %d\n", intsts & 0x8);
+		pr_debug("MAD headset = %d\n", intsts & 0x8);
 		jack = &intelmaddata->jack[1].jack;
 		present = !(intelmaddata->jack[1].jack_status);
 		intelmaddata->jack[1].jack_status = present;
@@ -558,10 +561,10 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 
 	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
 
-	pr_debug("sst: previous value: %x\n", intelmaddata->jack_prev_state);
+	pr_debug("previous value: %x\n", intelmaddata->jack_prev_state);
 
 	if (!(intelmid_audio_interrupt_enable)) {
-		pr_debug("sst: Audio interrupt enable\n");
+		pr_debug("Audio interrupt enable\n");
 		intelmaddata->jack_prev_state = 0xC0;
 		intelmid_audio_interrupt_enable = 1;
 	}
@@ -572,12 +575,12 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 			sc_access_read.reg_addr = 0x201;
 			sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
 			value = (sc_access_read.value);
-			pr_debug("sst: value returned = 0x%x\n", value);
+			pr_debug("value returned = 0x%x\n", value);
 		}
 
 		if (jack_prev_state == 0xc0 && value == 0x40) {
 			/*headset detected. */
-			pr_debug("sst: MAD headset inserted\n");
+			pr_debug("MAD headset inserted\n");
 			jack = &intelmaddata->jack[1].jack;
 			present = 1;
 			jack_event_flag = 1;
@@ -587,7 +590,7 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 
 		if (jack_prev_state == 0xc0 && value == 0x00) {
 			/* headphone  detected. */
-			pr_debug("sst: MAD headphone inserted\n");
+			pr_debug("MAD headphone inserted\n");
 			jack = &intelmaddata->jack[0].jack;
 			present = 1;
 			jack_event_flag = 1;
@@ -596,9 +599,9 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 
 		if (jack_prev_state == 0x40 && value == 0xc0) {
 			/*headset  removed*/
-			pr_debug("sst: Jack headset status %d\n",
+			pr_debug("Jack headset status %d\n",
 				intelmaddata->jack[1].jack_status);
-			pr_debug("sst: MAD headset removed\n");
+			pr_debug("MAD headset removed\n");
 			jack = &intelmaddata->jack[1].jack;
 			present = 0;
 			jack_event_flag = 1;
@@ -607,9 +610,9 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 
 		if (jack_prev_state == 0x00 && value == 0xc0) {
 			/* headphone  detected. */
-			pr_debug("sst: Jack headphone status %d\n",
+			pr_debug("Jack headphone status %d\n",
 					intelmaddata->jack[0].jack_status);
-			pr_debug("sst: headphone removed\n");
+			pr_debug("headphone removed\n");
 			jack = &intelmaddata->jack[0].jack;
 			present = 0;
 			jack_event_flag = 1;
@@ -618,7 +621,7 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 		if (jack_prev_state == 0x40 && value == 0x00) {
 			/*button pressed*/
 			do_gettimeofday(&intelmaddata->jack[1].buttonpressed);
-			pr_debug("sst: MAD button press detected n");
+			pr_debug("MAD button press detected\n");
 		}
 
 
@@ -628,19 +631,19 @@ void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
 				do_gettimeofday(
 					&intelmaddata->jack[1].buttonreleased);
 				/*button pressed */
-				pr_debug("sst: Button Released detected\n");
+				pr_debug("Button Released detected\n");
 				timediff = intelmaddata->jack[1].
 					buttonreleased.tv_sec - intelmaddata->
 					jack[1].buttonpressed.tv_sec;
 				buttonpressflag = 1;
 				if (timediff > 1) {
-					pr_debug("sst: long press detected\n");
+					pr_debug("long press detected\n");
 					/* send headphone detect/undetect */
 					jack = &intelmaddata->jack[3].jack;
 					present = 1;
 					jack_event_flag = 1;
 				} else {
-					pr_debug("sst: short press detected\n");
+					pr_debug("short press detected\n");
 					/* send headphone detect/undetect */
 					jack = &intelmaddata->jack[2].jack;
 					present = 1;
@@ -667,24 +670,24 @@ void sst_mad_jackdetection_nec(u8 intsts, struct snd_intelmad *intelmaddata)
 		sc_access_read.reg_addr = 0x132;
 		sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
 		value = (sc_access_read.value);
-		pr_debug("sst: value returned = 0x%x\n", value);
+		pr_debug("value returned = 0x%x\n", value);
 	}
 	if (intsts & 0x1) {
-		pr_debug("sst: headset detected\n");
+		pr_debug("headset detected\n");
 		/* send headset detect/undetect */
 		jack = &intelmaddata->jack[1].jack;
 		present = (value == 0x1) ? 1 : 0;
 		jack_event_flag = 1;
 	}
 	if (intsts & 0x2) {
-		pr_debug("sst: headphone detected\n");
+		pr_debug("headphone detected\n");
 		/* send headphone detect/undetect */
 		jack = &intelmaddata->jack[0].jack;
 		present = (value == 0x2) ? 1 : 0;
 		jack_event_flag = 1;
 	}
 	if (intsts & 0x4) {
-		pr_debug("sst: short push detected\n");
+		pr_debug("short push detected\n");
 		/* send short push */
 		jack = &intelmaddata->jack[2].jack;
 		present = 1;
@@ -692,7 +695,7 @@ void sst_mad_jackdetection_nec(u8 intsts, struct snd_intelmad *intelmaddata)
 		buttonpressflag = 1;
 	}
 	if (intsts & 0x8) {
-		pr_debug("sst: long push detected\n");
+		pr_debug("long push detected\n");
 		/* send long push */
 		jack = &intelmaddata->jack[3].jack;
 		present = 1;
@@ -738,12 +741,12 @@ static int __devinit snd_intelmad_register_irq(
 	u32 regbase = AUDINT_BASE, regsize = 8;
 	char *drv_name;
 
-	pr_debug("sst: irq reg done, regbase 0x%x, regsize 0x%x\n",
+	pr_debug("irq reg done, regbase 0x%x, regsize 0x%x\n",
 					regbase, regsize);
 	intelmaddata->int_base = ioremap_nocache(regbase, regsize);
 	if (!intelmaddata->int_base)
-		pr_err("sst: Mapping of cache failed\n");
-	pr_debug("sst: irq = 0x%x\n", intelmaddata->irq);
+		pr_err("Mapping of cache failed\n");
+	pr_debug("irq = 0x%x\n", intelmaddata->irq);
 	if (intelmaddata->cpu_id == CPU_CHIP_PENWELL)
 		drv_name = DRIVER_NAME_MFLD;
 	else
@@ -753,7 +756,7 @@ static int __devinit snd_intelmad_register_irq(
 				IRQF_SHARED, drv_name,
 				intelmaddata);
 	if (ret_val)
-		pr_err("sst: cannot register IRQ\n");
+		pr_err("cannot register IRQ\n");
 	return ret_val;
 }
 
@@ -775,10 +778,10 @@ static int __devinit snd_intelmad_sst_register(
 		if (ret_val)
 			return ret_val;
 		sst_card_vendor_id = (vendor_addr.value & (MASK2|MASK1|MASK0));
-		pr_debug("sst: orginal n extrated vendor id = 0x%x %d\n",
+		pr_debug("orginal n extrated vendor id = 0x%x %d\n",
 				vendor_addr.value, sst_card_vendor_id);
 		if (sst_card_vendor_id < 0 || sst_card_vendor_id > 2) {
-			pr_err("sst: vendor card not supported!!\n");
+			pr_err("vendor card not supported!!\n");
 			return -EIO;
 		}
 	} else
@@ -801,7 +804,7 @@ static int __devinit snd_intelmad_sst_register(
 	/* registering with SST driver to get access to SST APIs to use */
 	ret_val = register_sst_card(intelmaddata->sstdrv_ops);
 	if (ret_val) {
-		pr_err("sst: sst card registration failed\n");
+		pr_err("sst card registration failed\n");
 		return ret_val;
 	}
 
@@ -832,7 +835,7 @@ static int __devinit snd_intelmad_pcm_new(struct snd_card *card,
 	char name[32] = INTEL_MAD;
 	struct snd_pcm_ops *pb_ops = NULL, *cap_ops = NULL;
 
-	pr_debug("sst: called for pb %d, cp %d, idx %d\n", pb, cap, index);
+	pr_debug("called for pb %d, cp %d, idx %d\n", pb, cap, index);
 	ret_val = snd_pcm_new(card, name, index, pb, cap, &pcm);
 	if (ret_val)
 		return ret_val;
@@ -878,7 +881,7 @@ static int __devinit snd_intelmad_pcm(struct snd_card *card,
 
 	WARN_ON(!card);
 	WARN_ON(!intelmaddata);
-	pr_debug("sst: snd_intelmad_pcm called\n");
+	pr_debug("snd_intelmad_pcm called\n");
 	ret_val = snd_intelmad_pcm_new(card, intelmaddata, 1, 1, 0);
 	if (intelmaddata->cpu_id == CPU_CHIP_LINCROFT)
 		return ret_val;
@@ -903,7 +906,7 @@ static int snd_intelmad_jack(struct snd_intelmad *intelmaddata)
 	struct snd_jack *jack;
 	int retval;
 
-	pr_debug("sst: snd_intelmad_jack called\n");
+	pr_debug("snd_intelmad_jack called\n");
 	jack = &intelmaddata->jack[0].jack;
 	retval = snd_jack_new(intelmaddata->card, "Headphone",
 				SND_JACK_HEADPHONE, &jack);
@@ -982,9 +985,9 @@ static int __devinit snd_intelmad_mixer(struct snd_intelmad *intelmaddata)
 		ret_val = snd_ctl_add(card,
 				snd_ctl_new1(&controls[idx],
 				intelmaddata));
-		pr_debug("sst: mixer[idx]=%d added\n", idx);
+		pr_debug("mixer[idx]=%d added\n", idx);
 		if (ret_val) {
-			pr_err("sst: in adding of control index = %d\n", idx);
+			pr_err("in adding of control index = %d\n", idx);
 			break;
 		}
 	}
@@ -999,7 +1002,7 @@ static int snd_intelmad_dev_free(struct snd_device *device)
 
 	intelmaddata = device->device_data;
 
-	pr_debug("sst: snd_intelmad_dev_free called\n");
+	pr_debug("snd_intelmad_dev_free called\n");
 	snd_card_free(intelmaddata->card);
 	/*genl_unregister_family(&audio_event_genl_family);*/
 	unregister_sst_card(intelmaddata->sstdrv_ops);
@@ -1040,23 +1043,23 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	const struct platform_device_id *id = platform_get_device_id(pdev);
 	unsigned int cpu_id = (unsigned int)id->driver_data;
 
-	pr_debug("sst: probe for %s cpu_id %d\n", pdev->name, cpu_id);
+	pr_debug("probe for %s cpu_id %d\n", pdev->name, cpu_id);
 	if (!strcmp(pdev->name, DRIVER_NAME_MRST))
-		pr_debug("sst: detected MRST\n");
+		pr_debug("detected MRST\n");
 	else if (!strcmp(pdev->name, DRIVER_NAME_MFLD))
-		pr_debug("sst: detected MFLD\n");
+		pr_debug("detected MFLD\n");
 	else {
-		pr_err("sst: detected unknown device abort!!\n");
+		pr_err("detected unknown device abort!!\n");
 		return -EIO;
 	}
 	if ((cpu_id < CPU_CHIP_LINCROFT) || (cpu_id > CPU_CHIP_PENWELL)) {
-		pr_err("sst: detected unknown cpu_id abort!!\n");
+		pr_err("detected unknown cpu_id abort!!\n");
 		return -EIO;
 	}
 	/* allocate memory for saving internal context and working */
 	intelmaddata = kzalloc(sizeof(*intelmaddata), GFP_KERNEL);
 	if (!intelmaddata) {
-		pr_debug("sst: mem alloctn fail\n");
+		pr_debug("mem alloctn fail\n");
 		return -ENOMEM;
 	}
 
@@ -1064,7 +1067,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	intelmaddata->sstdrv_ops = kzalloc(sizeof(struct intel_sst_card_ops),
 					GFP_KERNEL);
 	if (!intelmaddata->sstdrv_ops) {
-		pr_err("sst: mem allocation for ops fail\n");
+		pr_err("mem allocation for ops fail\n");
 		kfree(intelmaddata);
 		return -ENOMEM;
 	}
@@ -1073,7 +1076,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	/* create a card instance with ALSA framework */
 	ret_val = snd_card_create(card_index, card_id, THIS_MODULE, 0, &card);
 	if (ret_val) {
-		pr_err("sst: snd_card_create fail\n");
+		pr_err("snd_card_create fail\n");
 		goto free_allocs;
 	}
 
@@ -1092,7 +1095,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	/* registering with LPE driver to get access to SST APIs to use */
 	ret_val = snd_intelmad_sst_register(intelmaddata);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_sst_register failed\n");
+		pr_err("snd_intelmad_sst_register failed\n");
 		goto free_allocs;
 	}
 
@@ -1100,19 +1103,19 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 
 	ret_val = snd_intelmad_pcm(card, intelmaddata);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_pcm failed\n");
+		pr_err("snd_intelmad_pcm failed\n");
 		goto free_allocs;
 	}
 
 	ret_val = snd_intelmad_mixer(intelmaddata);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_mixer failed\n");
+		pr_err("snd_intelmad_mixer failed\n");
 		goto free_allocs;
 	}
 
 	ret_val = snd_intelmad_jack(intelmaddata);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_jack failed\n");
+		pr_err("snd_intelmad_jack failed\n");
 		goto free_allocs;
 	}
 
@@ -1126,31 +1129,31 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 
 	ret_val = snd_intelmad_register_irq(intelmaddata);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_register_irq fail\n");
+		pr_err("snd_intelmad_register_irq fail\n");
 		goto free_allocs;
 	}
 
 	/* internal function call to register device with ALSA */
 	ret_val = snd_intelmad_create(intelmaddata, card);
 	if (ret_val) {
-		pr_err("sst: snd_intelmad_create failed\n");
+		pr_err("snd_intelmad_create failed\n");
 		goto free_allocs;
 	}
 	card->private_data = &intelmaddata;
 	snd_card_set_dev(card, &pdev->dev);
 	ret_val = snd_card_register(card);
 	if (ret_val) {
-		pr_err("sst: snd_card_register failed\n");
+		pr_err("snd_card_register failed\n");
 		goto free_allocs;
 	}
 
-	pr_debug("sst:snd_intelmad_probe complete\n");
+	pr_debug("snd_intelmad_probe complete\n");
 	return ret_val;
 
 free_mad_jack_wq:
 	destroy_workqueue(intelmaddata->mad_jack_wq);
 free_allocs:
-	pr_err("sst: probe failed\n");
+	pr_err("probe failed\n");
 	snd_card_free(card);
 	kfree(intelmaddata->sstdrv_ops);
 	kfree(intelmaddata);
@@ -1200,7 +1203,7 @@ static struct platform_driver snd_intelmad_driver = {
  */
 static int __init alsa_card_intelmad_init(void)
 {
-	pr_debug("sst: mad_init called\n");
+	pr_debug("mad_init called\n");
 	return platform_driver_register(&snd_intelmad_driver);
 }
 
@@ -1211,7 +1214,7 @@ static int __init alsa_card_intelmad_init(void)
  */
 static void __exit alsa_card_intelmad_exit(void)
 {
-	pr_debug("sst:mad_exit called\n");
+	pr_debug("mad_exit called\n");
 	return platform_driver_unregister(&snd_intelmad_driver);
 }
 
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index 03b4ece..0d91357 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -24,6 +24,9 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *  ALSA driver handling mixer controls for Intel MAD chipset
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <sound/core.h>
 #include <sound/control.h>
 #include "jack.h"
@@ -216,7 +219,7 @@ static int snd_intelmad_volume_get(struct snd_kcontrol *kcontrol,
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
 
-	pr_debug("sst: snd_intelmad_volume_get called\n");
+	pr_debug("snd_intelmad_volume_get called\n");
 
 	WARN_ON(!uval);
 	WARN_ON(!kcontrol);
@@ -273,7 +276,7 @@ static int snd_intelmad_mute_get(struct snd_kcontrol *kcontrol,
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
 
-	pr_debug("sst: Mute_get called\n");
+	pr_debug("Mute_get called\n");
 
 	WARN_ON(!uval);
 	WARN_ON(!kcontrol);
@@ -332,7 +335,7 @@ static int snd_intelmad_volume_set(struct snd_kcontrol *kcontrol,
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
 
-	pr_debug("sst: volume set called:%ld %ld\n",
+	pr_debug("volume set called:%ld %ld\n",
 			uval->value.integer.value[0],
 			uval->value.integer.value[1]);
 
@@ -387,7 +390,7 @@ static int snd_intelmad_mute_set(struct snd_kcontrol *kcontrol,
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
 
-	pr_debug("sst: snd_intelmad_mute_set called\n");
+	pr_debug("snd_intelmad_mute_set called\n");
 
 	WARN_ON(!uval);
 	WARN_ON(!kcontrol);
@@ -455,7 +458,7 @@ static int snd_intelmad_device_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
-	pr_debug("sst: device_get called\n");
+	pr_debug("device_get called\n");
 
 	WARN_ON(!uval);
 	WARN_ON(!kcontrol);
@@ -492,7 +495,7 @@ static int snd_intelmad_device_set(struct snd_kcontrol *kcontrol,
 	struct snd_pmic_ops *scard_ops;
 	int ret_val = 0, vendor, status;
 
-	pr_debug("sst: snd_intelmad_device_set called\n");
+	pr_debug("snd_intelmad_device_set called\n");
 
 	WARN_ON(!uval);
 	WARN_ON(!kcontrol);
diff --git a/drivers/staging/intel_sst/intelmid_msic_control.c b/drivers/staging/intel_sst/intelmid_msic_control.c
index 4d1755e..da093ed 100644
--- a/drivers/staging/intel_sst/intelmid_msic_control.c
+++ b/drivers/staging/intel_sst/intelmid_msic_control.c
@@ -24,6 +24,8 @@
  * This file contains the control operations of msic vendors
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/file.h>
 #include "intel_sst.h"
@@ -83,7 +85,7 @@ static int msic_init_card(void)
 	snd_msic_ops.cap_on = 0;
 	snd_msic_ops.input_dev_id = DMIC; /*def dev*/
 	snd_msic_ops.output_dev_id = STEREO_HEADPHONE;
-	pr_debug("sst: msic init complete!!\n");
+	pr_debug("msic init complete!!\n");
 	return 0;
 }
 
@@ -173,7 +175,7 @@ static int msic_power_up_pb(unsigned int device)
 			return retval;
 	}
 
-	pr_debug("sst: powering up pb.... Device %d\n", device);
+	pr_debug("powering up pb.... Device %d\n", device);
 	sst_sc_reg_access(sc_access1, PMIC_WRITE, 4);
 	switch (device) {
 	case SND_SST_DEVICE_HEADSET:
@@ -205,7 +207,7 @@ static int msic_power_up_pb(unsigned int device)
 		break;
 
 	default:
-		pr_warn("sst: Wrong Device %d, selected %d\n",
+		pr_warn("Wrong Device %d, selected %d\n",
 			       device, snd_msic_ops.output_dev_id);
 	}
 	return sst_sc_reg_access(sc_access_pcm2, PMIC_READ_MODIFY, 1);
@@ -268,7 +270,7 @@ static int msic_power_up_cp(unsigned int device)
 			return retval;
 	}
 
-	pr_debug("sst: powering up cp....%d\n", snd_msic_ops.input_dev_id);
+	pr_debug("powering up cp....%d\n", snd_msic_ops.input_dev_id);
 	sst_sc_reg_access(sc_access2, PMIC_READ_MODIFY, 1);
 	snd_msic_ops.cap_on = 1;
 	if (snd_msic_ops.input_dev_id == AMIC)
@@ -283,7 +285,7 @@ static int msic_power_down(void)
 {
 	int retval = 0;
 
-	pr_debug("sst: powering dn msic\n");
+	pr_debug("powering dn msic\n");
 	snd_msic_ops.pb_on = 0;
 	snd_msic_ops.cap_on = 0;
 	return retval;
@@ -293,7 +295,7 @@ static int msic_power_down_pb(void)
 {
 	int retval = 0;
 
-	pr_debug("sst: powering dn pb....\n");
+	pr_debug("powering dn pb....\n");
 	snd_msic_ops.pb_on = 0;
 	return retval;
 }
@@ -302,7 +304,7 @@ static int msic_power_down_cp(void)
 {
 	int retval = 0;
 
-	pr_debug("sst: powering dn cp....\n");
+	pr_debug("powering dn cp....\n");
 	snd_msic_ops.cap_on = 0;
 	return retval;
 }
@@ -311,7 +313,7 @@ static int msic_set_selected_output_dev(u8 value)
 {
 	int retval = 0;
 
-	pr_debug("sst: msic set selected output:%d\n", value);
+	pr_debug("msic set selected output:%d\n", value);
 	snd_msic_ops.output_dev_id = value;
 	if (snd_msic_ops.pb_on)
 		msic_power_up_pb(SND_SST_DEVICE_HEADSET);
@@ -330,15 +332,15 @@ static int msic_set_selected_input_dev(u8 value)
 	};
 	int retval = 0;
 
-	pr_debug("sst: msic_set_selected_input_dev:%d\n", value);
+	pr_debug("msic_set_selected_input_dev:%d\n", value);
 	snd_msic_ops.input_dev_id = value;
 	switch (value) {
 	case AMIC:
-		pr_debug("sst: Selecting AMIC1\n");
+		pr_debug("Selecting AMIC1\n");
 		retval = sst_sc_reg_access(sc_access_amic, PMIC_WRITE, 1);
 		break;
 	case DMIC:
-		pr_debug("sst: Selecting DMIC1\n");
+		pr_debug("Selecting DMIC1\n");
 		retval = sst_sc_reg_access(sc_access_dmic, PMIC_WRITE, 1);
 		break;
 	default:
diff --git a/drivers/staging/intel_sst/intelmid_pvt.c b/drivers/staging/intel_sst/intelmid_pvt.c
index 9ed9475..4f9bdf3 100644
--- a/drivers/staging/intel_sst/intelmid_pvt.c
+++ b/drivers/staging/intel_sst/intelmid_pvt.c
@@ -23,6 +23,9 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  * ALSA driver for Intel MID sound card chipset - holding private functions
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/io.h>
 #include <asm/intel_scu_ipc.h>
 #include <sound/core.h>
@@ -50,7 +53,7 @@ void period_elapsed(void *mad_substream)
 
 	if (stream->stream_status != RUNNING)
 		return;
-	pr_debug("sst: calling period elapsed\n");
+	pr_debug("calling period elapsed\n");
 	snd_pcm_period_elapsed(substream);
 	return;
 }
@@ -76,8 +79,8 @@ int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream)
 	param.uc.pcm_params.period_count = substream->runtime->period_size;
 	param.uc.pcm_params.ring_buffer_addr =
 				virt_to_phys(substream->runtime->dma_area);
-	pr_debug("sst: period_cnt = %d\n", param.uc.pcm_params.period_count);
-	pr_debug("sst: sfreq= %d, wd_sz = %d\n",
+	pr_debug("period_cnt = %d\n", param.uc.pcm_params.period_count);
+	pr_debug("sfreq= %d, wd_sz = %d\n",
 		 param.uc.pcm_params.sfreq, param.uc.pcm_params.pcm_wd_sz);
 
 	str_params.sparams = param;
@@ -85,16 +88,16 @@ int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream)
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		str_params.ops = STREAM_OPS_PLAYBACK;
-		pr_debug("sst: Playbck stream,Device %d\n", stream->device);
+		pr_debug("Playbck stream,Device %d\n", stream->device);
 	} else {
 		str_params.ops = STREAM_OPS_CAPTURE;
 		stream->device = SND_SST_DEVICE_CAPTURE;
-		pr_debug("sst: Capture stream,Device %d\n", stream->device);
+		pr_debug("Capture stream,Device %d\n", stream->device);
 	}
 	str_params.device_type = stream->device;
 	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_ALLOC,
 					&str_params);
-	pr_debug("sst: SST_SND_PLAY/CAPTURE ret_val = %x\n",
+	pr_debug("SST_SND_PLAY/CAPTURE ret_val = %x\n",
 			ret_val);
 	if (ret_val < 0)
 		return ret_val;
@@ -102,7 +105,7 @@ int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream)
 	stream->stream_info.str_id = ret_val;
 	stream->stream_status = INIT;
 	stream->stream_info.buffer_ptr = 0;
-	pr_debug("sst: str id :  %d\n", stream->stream_info.str_id);
+	pr_debug("str id :  %d\n", stream->stream_info.str_id);
 
 	return ret_val;
 }
@@ -113,7 +116,7 @@ int snd_intelmad_init_stream(struct snd_pcm_substream *substream)
 	struct snd_intelmad *intelmaddata = snd_pcm_substream_chip(substream);
 	int ret_val;
 
-	pr_debug("sst: setting buffer ptr param\n");
+	pr_debug("setting buffer ptr param\n");
 	stream->stream_info.period_elapsed = period_elapsed;
 	stream->stream_info.mad_substream = substream;
 	stream->stream_info.buffer_ptr = 0;
@@ -121,7 +124,7 @@ int snd_intelmad_init_stream(struct snd_pcm_substream *substream)
 	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_STREAM_INIT,
 					&stream->stream_info);
 	if (ret_val)
-		pr_err("sst: control_set ret error %d\n", ret_val);
+		pr_err("control_set ret error %d\n", ret_val);
 	return ret_val;
 
 }
@@ -146,7 +149,7 @@ int sst_sc_reg_access(struct sc_reg_access *sc_access,
 			retval = intel_scu_ipc_iowrite8(sc_access[i].reg_addr,
 							sc_access[i].value);
 			if (retval) {
-				pr_err("sst: IPC write failed!!! %d\n", retval);
+				pr_err("IPC write failed!!! %d\n", retval);
 				return retval;
 			}
 		}
@@ -155,7 +158,7 @@ int sst_sc_reg_access(struct sc_reg_access *sc_access,
 			retval = intel_scu_ipc_ioread8(sc_access[i].reg_addr,
 							&(sc_access[i].value));
 			if (retval) {
-				pr_err("sst: IPC read failed!!!!!%d\n", retval);
+				pr_err("IPC read failed!!!!!%d\n", retval);
 				return retval;
 			}
 		}
@@ -165,7 +168,7 @@ int sst_sc_reg_access(struct sc_reg_access *sc_access,
 				sc_access[i].reg_addr, sc_access[i].value,
 				sc_access[i].mask);
 			if (retval) {
-				pr_err("sst: IPC Modify failed!!!%d\n", retval);
+				pr_err("IPC Modify failed!!!%d\n", retval);
 				return retval;
 			}
 		}
diff --git a/drivers/staging/intel_sst/intelmid_v0_control.c b/drivers/staging/intel_sst/intelmid_v0_control.c
index f586d62..7859225 100644
--- a/drivers/staging/intel_sst/intelmid_v0_control.c
+++ b/drivers/staging/intel_sst/intelmid_v0_control.c
@@ -26,6 +26,8 @@
  *  This file contains the control operations of vendor 1
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/file.h>
 #include "intel_sst.h"
@@ -151,7 +153,7 @@ static int fs_power_up_pb(unsigned int port)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: in fs power up pb\n");
+	pr_debug("in fs power up pb\n");
 	return fs_enable_audiodac(UNMUTE);
 }
 
@@ -173,7 +175,7 @@ static int fs_power_down_pb(void)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: in fsl power down pb\n");
+	pr_debug("in fsl power down pb\n");
 	return fs_enable_audiodac(UNMUTE);
 }
 
@@ -380,7 +382,7 @@ static int fs_set_pcm_audio_params(int sfreq, int word_size, int num_channel)
 		sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 2);
 
 	}
-	pr_debug("sst: sfreq:%d,Register value = %x\n", sfreq, config1);
+	pr_debug("sfreq:%d,Register value = %x\n", sfreq, config1);
 
 	if (word_size == 24) {
 		sc_access[0].reg_addr  = AUDIOPORT1;
@@ -438,18 +440,18 @@ static int fs_set_selected_input_dev(u8 value)
 
 	switch (value) {
 	case AMIC:
-		pr_debug("sst: Selecting amic not supported in mono cfg\n");
+		pr_debug("Selecting amic not supported in mono cfg\n");
 		return sst_sc_reg_access(sc_access_mic, PMIC_READ_MODIFY, 2);
 		break;
 
 	case HS_MIC:
-		pr_debug("sst: Selecting hsmic\n");
+		pr_debug("Selecting hsmic\n");
 		return sst_sc_reg_access(sc_access_hsmic,
 				PMIC_READ_MODIFY, 2);
 		break;
 
 	case DMIC:
-		pr_debug("sst: Selecting dmic\n");
+		pr_debug("Selecting dmic\n");
 		return sst_sc_reg_access(sc_access_dmic, PMIC_READ_MODIFY, 2);
 		break;
 
@@ -505,7 +507,7 @@ static int fs_set_mute(int dev_id, u8 value)
 		return retval;
 
 
-	pr_debug("sst: dev_id:0x%x value:0x%x\n", dev_id, value);
+	pr_debug("dev_id:0x%x value:0x%x\n", dev_id, value);
 	switch (dev_id) {
 	case PMIC_SND_DMIC_MUTE:
 		sc_access[0].reg_addr = MICCTRL;
@@ -606,7 +608,7 @@ static int fs_set_vol(int dev_id, int value)
 
 	switch (dev_id) {
 	case PMIC_SND_LEFT_PB_VOL:
-		pr_debug("sst: PMIC_SND_LEFT_PB_VOL:%d\n", value);
+		pr_debug("PMIC_SND_LEFT_PB_VOL:%d\n", value);
 		sc_access[0].value = sc_access[1].value = value;
 		sc_access[0].reg_addr = AUD16;
 		sc_access[1].reg_addr = AUD15;
@@ -616,7 +618,7 @@ static int fs_set_vol(int dev_id, int value)
 		break;
 
 	case PMIC_SND_RIGHT_PB_VOL:
-		pr_debug("sst: PMIC_SND_RIGHT_PB_VOL:%d\n", value);
+		pr_debug("PMIC_SND_RIGHT_PB_VOL:%d\n", value);
 		sc_access[0].value = sc_access[1].value = value;
 		sc_access[0].reg_addr = AUD17;
 		sc_access[1].reg_addr = AUD15;
@@ -629,7 +631,7 @@ static int fs_set_vol(int dev_id, int value)
 		reg_num = 2;
 		break;
 	case PMIC_SND_CAPTURE_VOL:
-		pr_debug("sst: PMIC_SND_CAPTURE_VOL:%d\n", value);
+		pr_debug("PMIC_SND_CAPTURE_VOL:%d\n", value);
 		sc_access[0].reg_addr = MICLICTRL1;
 		sc_access[1].reg_addr = MICLICTRL2;
 		sc_access[2].reg_addr = DMICCTRL1;
@@ -726,17 +728,17 @@ static int fs_get_vol(int dev_id, int *value)
 
 	switch (dev_id) {
 	case PMIC_SND_CAPTURE_VOL:
-		pr_debug("sst: PMIC_SND_CAPTURE_VOL\n");
+		pr_debug("PMIC_SND_CAPTURE_VOL\n");
 		sc_access.reg_addr = MICLICTRL1;
 		mask = (MASK5|MASK4|MASK3|MASK2|MASK1|MASK0);
 		break;
 	case PMIC_SND_LEFT_PB_VOL:
-		pr_debug("sst: PMIC_SND_LEFT_PB_VOL\n");
+		pr_debug("PMIC_SND_LEFT_PB_VOL\n");
 		sc_access.reg_addr = AUD16;
 		mask = (MASK5|MASK4|MASK3|MASK2|MASK1|MASK0);
 		break;
 	case PMIC_SND_RIGHT_PB_VOL:
-		pr_debug("sst: PMIC_SND_RT_PB_VOL\n");
+		pr_debug("PMIC_SND_RT_PB_VOL\n");
 		sc_access.reg_addr = AUD17;
 		mask = (MASK5|MASK4|MASK3|MASK2|MASK1|MASK0);
 		break;
@@ -745,9 +747,9 @@ static int fs_get_vol(int dev_id, int *value)
 	}
 
 	retval = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
-	pr_debug("sst: value read = 0x%x\n", sc_access.value);
+	pr_debug("value read = 0x%x\n", sc_access.value);
 	*value = (int) (sc_access.value & mask);
-	pr_debug("sst: value returned = 0x%x\n", *value);
+	pr_debug("value returned = 0x%x\n", *value);
 	return retval;
 }
 
diff --git a/drivers/staging/intel_sst/intelmid_v1_control.c b/drivers/staging/intel_sst/intelmid_v1_control.c
index 9de86b2..62a932b 100644
--- a/drivers/staging/intel_sst/intelmid_v1_control.c
+++ b/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -25,6 +25,8 @@
  *  This file contains the control operations of vendor 2
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/file.h>
 #include <asm/mrst.h>
@@ -150,11 +152,11 @@ static int mx_init_capture_card(void)
 	retval = sst_sc_reg_access(sc_access, PMIC_WRITE, 8);
 	if (0 != retval) {
 		/* pmic communication fails */
-		pr_debug("sst: pmic commn failed\n");
+		pr_debug("pmic commn failed\n");
 		return retval;
 	}
 
-	pr_debug("sst: Capture configuration complete!!\n");
+	pr_debug("Capture configuration complete!!\n");
 	return 0;
 }
 
@@ -174,11 +176,11 @@ static int mx_init_playback_card(void)
 	retval = sst_sc_reg_access(sc_access, PMIC_WRITE, 9);
 	if (0 != retval) {
 		/* pmic communication fails */
-		pr_debug("sst: pmic commn failed\n");
+		pr_debug("pmic commn failed\n");
 		return retval;
 	}
 
-	pr_debug("sst: Playback configuration complete!!\n");
+	pr_debug("Playback configuration complete!!\n");
 	return 0;
 }
 
@@ -204,7 +206,7 @@ static int mx_enable_audiodac(int value)
 	retval = sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 2);
 	if (retval)
 		return retval;
-	pr_debug("sst: mute status = %d", snd_pmic_ops_mx.mute_status);
+	pr_debug("mute status = %d\n", snd_pmic_ops_mx.mute_status);
 	if (snd_pmic_ops_mx.mute_status == MUTE ||
 				snd_pmic_ops_mx.master_mute == MUTE)
 		return retval;
@@ -412,7 +414,7 @@ static int mx_set_pcm_voice_params(void)
 		if (retval)
 			return retval;
 	}
-	pr_debug("sst: SST DBG mx_set_pcm_voice_params called\n");
+	pr_debug("SST DBG:mx_set_pcm_voice_params called\n");
 	return sst_sc_reg_access(sc_access, PMIC_WRITE, 44);
 }
 
@@ -529,7 +531,7 @@ static int mx_set_selected_output_dev(u8 dev_id)
 			return retval;
 	}
 
-	pr_debug("sst: mx_set_selected_output_dev dev_id:0x%x\n", dev_id);
+	pr_debug("mx_set_selected_output_dev dev_id:0x%x\n", dev_id);
 	snd_pmic_ops_mx.output_dev_id = dev_id;
 	switch (dev_id) {
 	case STEREO_HEADPHONE:
@@ -549,7 +551,7 @@ static int mx_set_selected_output_dev(u8 dev_id)
 		num_reg = 1;
 		break;
 	case RECEIVER:
-		pr_debug("sst: RECEIVER Koski selected\n");
+		pr_debug("RECEIVER Koski selected\n");
 
 		/* configuration - AS enable, receiver enable */
 		sc_access[0].reg_addr = 0xFF;
@@ -559,7 +561,7 @@ static int mx_set_selected_output_dev(u8 dev_id)
 		num_reg = 1;
 		break;
 	default:
-		pr_err("sst: Not a valid output dev\n");
+		pr_err("Not a valid output dev\n");
 		return 0;
 	}
 	return sst_sc_reg_access(sc_access, PMIC_WRITE, num_reg);
@@ -598,7 +600,7 @@ static int mx_set_selected_input_dev(u8 dev_id)
 			return retval;
 	}
 	snd_pmic_ops_mx.input_dev_id = dev_id;
-	pr_debug("sst: mx_set_selected_input_dev dev_id:0x%x\n", dev_id);
+	pr_debug("mx_set_selected_input_dev dev_id:0x%x\n", dev_id);
 
 	switch (dev_id) {
 	case AMIC:
@@ -646,7 +648,7 @@ static int mx_set_mute(int dev_id, u8 value)
 	}
 
 
-	pr_debug("sst: set_mute dev_id:0x%x , value:%d\n", dev_id, value);
+	pr_debug("set_mute dev_id:0x%x , value:%d\n", dev_id, value);
 
 	switch (dev_id) {
 	case PMIC_SND_DMIC_MUTE:
@@ -760,7 +762,7 @@ static int mx_set_vol(int dev_id, int value)
 		if (retval)
 			return retval;
 	}
-	pr_debug("sst: set_vol dev_id:0x%x ,value:%d\n", dev_id, value);
+	pr_debug("set_vol dev_id:0x%x ,value:%d\n", dev_id, value);
 	switch (dev_id) {
 	case PMIC_SND_RECEIVER_VOL:
 		return 0;
@@ -875,7 +877,7 @@ static int mx_get_vol(int dev_id, int *value)
 	if (retval)
 		return retval;
 	*value = -(sc_access.value & mask);
-	pr_debug("sst: get volume value extracted %d\n", *value);
+	pr_debug("get volume value extracted %d\n", *value);
 	return retval;
 }
 
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 3a7de76..81cb9d7 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -26,6 +26,8 @@
  *  This file contains the control operations of vendor 3
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/file.h>
 #include "intel_sst.h"
@@ -120,7 +122,7 @@ static int nc_init_card(void)
 	snd_pmic_ops_nc.master_mute = UNMUTE;
 	snd_pmic_ops_nc.mute_status = UNMUTE;
 	sst_sc_reg_access(sc_access, PMIC_WRITE, 26);
-	pr_debug("sst: init complete!!\n");
+	pr_debug("init complete!!\n");
 	return 0;
 }
 
@@ -169,7 +171,7 @@ static int nc_power_up_pb(unsigned int port)
 	nc_enable_audiodac(MUTE);
 	msleep(30);
 
-	pr_debug("sst: powering up pb....\n");
+	pr_debug("powering up pb....\n");
 
 	sc_access[0].reg_addr = VAUDIOCNT;
 	sc_access[0].value = 0x27;
@@ -222,7 +224,7 @@ static int nc_power_up_cp(unsigned int port)
 		return retval;
 
 
-	pr_debug("sst: powering up cp....\n");
+	pr_debug("powering up cp....\n");
 
 	if (port == 0xFF)
 		return 0;
@@ -275,7 +277,7 @@ static int nc_power_down(void)
 	nc_enable_audiodac(MUTE);
 
 
-	pr_debug("sst: powering dn nc_power_down ....\n");
+	pr_debug("powering dn nc_power_down ....\n");
 
 	msleep(30);
 
@@ -324,7 +326,7 @@ static int nc_power_down_pb(void)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: powering dn pb....\n");
+	pr_debug("powering dn pb....\n");
 
 	nc_enable_audiodac(MUTE);
 
@@ -370,7 +372,7 @@ static int nc_power_down_cp(void)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: powering dn cp....\n");
+	pr_debug("powering dn cp....\n");
 	return sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 1);
 }
 
@@ -400,7 +402,7 @@ static int nc_set_pcm_voice_params(void)
 		return retval;
 
 	sst_sc_reg_access(sc_access, PMIC_WRITE, 14);
-	pr_debug("sst: Voice parameters set successfully!!\n");
+	pr_debug("Voice parameters set successfully!!\n");
 	return 0;
 }
 
@@ -451,20 +453,20 @@ static int nc_set_pcm_audio_params(int sfreq, int word_size, int num_channel)
 
 		sc_access.value = 0x07;
 		sc_access.reg_addr = RMUTE;
-		pr_debug("sst: RIGHT_HP_MUTE value%d\n", sc_access.value);
+		pr_debug("RIGHT_HP_MUTE value%d\n", sc_access.value);
 		sc_access.mask = MASK2;
 		sst_sc_reg_access(&sc_access, PMIC_READ_MODIFY, 1);
 	} else {
 		sc_access.value = 0x00;
 		sc_access.reg_addr = RMUTE;
-		pr_debug("sst: RIGHT_HP_MUTE value %d\n", sc_access.value);
+		pr_debug("RIGHT_HP_MUTE value %d\n", sc_access.value);
 		sc_access.mask = MASK2;
 		sst_sc_reg_access(&sc_access, PMIC_READ_MODIFY, 1);
 
 
 	}
 
-	pr_debug("sst: word_size = %d\n", word_size);
+	pr_debug("word_size = %d\n", word_size);
 
 	if (word_size == 24) {
 		sc_access.reg_addr = AUDIOPORT2;
@@ -477,7 +479,7 @@ static int nc_set_pcm_audio_params(int sfreq, int word_size, int num_channel)
 	}
 	sst_sc_reg_access(&sc_access, PMIC_READ_MODIFY, 1);
 
-	pr_debug("sst: word_size = %d\n", word_size);
+	pr_debug("word_size = %d\n", word_size);
 	sc_access.reg_addr = AUDIOPORT1;
 	sc_access.mask = MASK5|MASK4|MASK1|MASK0;
 	if (word_size == 16)
@@ -508,7 +510,7 @@ static int nc_set_selected_output_dev(u8 value)
 		retval = nc_init_card();
 	if (retval)
 		return retval;
-	pr_debug("sst: nc set selected output:%d\n", value);
+	pr_debug("nc set selected output:%d\n", value);
 	switch (value) {
 	case STEREO_HEADPHONE:
 		retval = sst_sc_reg_access(sc_access_HP, PMIC_WRITE, 2);
@@ -517,7 +519,7 @@ static int nc_set_selected_output_dev(u8 value)
 		retval = sst_sc_reg_access(sc_access_IS, PMIC_WRITE, 2);
 		break;
 	default:
-		pr_err("sst: rcvd illegal request: %d\n", value);
+		pr_err("rcvd illegal request: %d\n", value);
 		return -EINVAL;
 	}
 	return retval;
@@ -541,7 +543,7 @@ static int nc_audio_init(void)
 	};
 
 	sst_sc_reg_access(sc_access, PMIC_WRITE, 12);
-	pr_debug("sst: Audio Init successfully!!\n");
+	pr_debug("Audio Init successfully!!\n");
 
 	/*set output device */
 	nc_set_selected_output_dev(snd_pmic_ops_nc.output_dev_id);
@@ -549,13 +551,13 @@ static int nc_audio_init(void)
 	if (snd_pmic_ops_nc.num_channel == 1) {
 		sc_acces.value = 0x07;
 		sc_acces.reg_addr = RMUTE;
-		pr_debug("sst: RIGHT_HP_MUTE value%d\n", sc_acces.value);
+		pr_debug("RIGHT_HP_MUTE value%d\n", sc_acces.value);
 		sc_acces.mask = MASK2;
 		sst_sc_reg_access(&sc_acces, PMIC_READ_MODIFY, 1);
 	} else {
 		sc_acces.value = 0x00;
 		sc_acces.reg_addr = RMUTE;
-		pr_debug("sst: RIGHT_HP_MUTE value%d\n", sc_acces.value);
+		pr_debug("RIGHT_HP_MUTE value%d\n", sc_acces.value);
 		sc_acces.mask = MASK2;
 		sst_sc_reg_access(&sc_acces, PMIC_READ_MODIFY, 1);
 	}
@@ -629,11 +631,11 @@ static int nc_set_mute(int dev_id, u8 value)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: set device id::%d, value %d\n", dev_id, value);
+	pr_debug("set device id::%d, value %d\n", dev_id, value);
 
 	switch (dev_id) {
 	case PMIC_SND_MUTE_ALL:
-		pr_debug("sst: PMIC_SND_MUTE_ALL value %d\n", value);
+		pr_debug("PMIC_SND_MUTE_ALL value %d\n", value);
 		snd_pmic_ops_nc.mute_status = value;
 		snd_pmic_ops_nc.master_mute = value;
 		if (value == UNMUTE) {
@@ -669,7 +671,7 @@ static int nc_set_mute(int dev_id, u8 value)
 		}
 		break;
 	case PMIC_SND_HP_MIC_MUTE:
-		pr_debug("sst: PMIC_SND_HPMIC_MUTE value %d\n", value);
+		pr_debug("PMIC_SND_HPMIC_MUTE value %d\n", value);
 		if (value == UNMUTE) {
 			/* unmute the system, set the 6th bit to one */
 			sc_access[0].value = 0x00;
@@ -682,7 +684,7 @@ static int nc_set_mute(int dev_id, u8 value)
 		retval = sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 1);
 		break;
 	case PMIC_SND_AMIC_MUTE:
-		pr_debug("sst: PMIC_SND_AMIC_MUTE value %d\n", value);
+		pr_debug("PMIC_SND_AMIC_MUTE value %d\n", value);
 		if (value == UNMUTE) {
 			/* unmute the system, set the 6th bit to one */
 			sc_access[0].value = 0x00;
@@ -696,7 +698,7 @@ static int nc_set_mute(int dev_id, u8 value)
 		break;
 
 	case PMIC_SND_DMIC_MUTE:
-		pr_debug("sst: INPUT_MUTE_DMIC value%d\n", value);
+		pr_debug("INPUT_MUTE_DMIC value%d\n", value);
 		if (value == UNMUTE) {
 			/* unmute the system, set the 6th bit to one */
 			sc_access[1].value = 0x00;
@@ -724,13 +726,13 @@ static int nc_set_mute(int dev_id, u8 value)
 
 		if (dev_id == PMIC_SND_LEFT_HP_MUTE) {
 			sc_access[0].reg_addr = LMUTE;
-			pr_debug("sst: LEFT_HP_MUTE value %d\n",
+			pr_debug("LEFT_HP_MUTE value %d\n",
 					sc_access[0].value);
 		} else {
 			if (snd_pmic_ops_nc.num_channel == 1)
 				sc_access[0].value = 0x04;
 			sc_access[0].reg_addr = RMUTE;
-			pr_debug("sst: RIGHT_HP_MUTE value %d\n",
+			pr_debug("RIGHT_HP_MUTE value %d\n",
 					sc_access[0].value);
 		}
 		sc_access[0].mask = MASK2;
@@ -743,7 +745,7 @@ static int nc_set_mute(int dev_id, u8 value)
 		else
 			sc_access[0].value = 0x03;
 		sc_access[0].reg_addr = LMUTE;
-		pr_debug("sst: SPEAKER_MUTE %d\n", sc_access[0].value);
+		pr_debug("SPEAKER_MUTE %d\n", sc_access[0].value);
 		sc_access[0].mask = MASK1;
 		retval = sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 1);
 		break;
@@ -764,10 +766,10 @@ static int nc_set_vol(int dev_id, int value)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: set volume:%d\n", dev_id);
+	pr_debug("set volume:%d\n", dev_id);
 	switch (dev_id) {
 	case PMIC_SND_CAPTURE_VOL:
-		pr_debug("sst: PMIC_SND_CAPTURE_VOL:value::%d\n", value);
+		pr_debug("PMIC_SND_CAPTURE_VOL:value::%d\n", value);
 		sc_access[0].value = sc_access[1].value =
 					sc_access[2].value = -value;
 		sc_access[0].mask = sc_access[1].mask = sc_access[2].mask =
@@ -779,7 +781,7 @@ static int nc_set_vol(int dev_id, int value)
 		break;
 
 	case PMIC_SND_LEFT_PB_VOL:
-		pr_debug("sst: PMIC_SND_LEFT_HP_VOL %d\n", value);
+		pr_debug("PMIC_SND_LEFT_HP_VOL %d\n", value);
 		sc_access[0].value = -value;
 		sc_access[0].reg_addr  = AUDIOLVOL;
 		sc_access[0].mask =
@@ -788,7 +790,7 @@ static int nc_set_vol(int dev_id, int value)
 		break;
 
 	case PMIC_SND_RIGHT_PB_VOL:
-		pr_debug("sst: PMIC_SND_RIGHT_HP_VOL value %d\n", value);
+		pr_debug("PMIC_SND_RIGHT_HP_VOL value %d\n", value);
 		if (snd_pmic_ops_nc.num_channel == 1) {
 			sc_access[0].value = 0x04;
 		    sc_access[0].reg_addr = RMUTE;
@@ -821,11 +823,11 @@ static int nc_set_selected_input_dev(u8 value)
 		return retval;
 	snd_pmic_ops_nc.input_dev_id = value;
 
-	pr_debug("sst: nc set selected input:%d\n", value);
+	pr_debug("nc set selected input:%d\n", value);
 
 	switch (value) {
 	case AMIC:
-		pr_debug("sst: Selecting AMIC\n");
+		pr_debug("Selecting AMIC\n");
 		sc_access[0].reg_addr = 0x107;
 		sc_access[0].value = 0x40;
 		sc_access[0].mask =  MASK6|MASK4|MASK3|MASK1|MASK0;
@@ -842,7 +844,7 @@ static int nc_set_selected_input_dev(u8 value)
 		break;
 
 	case HS_MIC:
-		pr_debug("sst: Selecting HS_MIC\n");
+		pr_debug("Selecting HS_MIC\n");
 		sc_access[0].reg_addr = 0x107;
 		sc_access[0].mask =  MASK6|MASK4|MASK3|MASK1|MASK0;
 		sc_access[0].value = 0x10;
@@ -859,7 +861,7 @@ static int nc_set_selected_input_dev(u8 value)
 		break;
 
 	case DMIC:
-		pr_debug("sst: DMIC\n");
+		pr_debug("DMIC\n");
 		sc_access[0].reg_addr = 0x107;
 		sc_access[0].mask = MASK6|MASK4|MASK3|MASK1|MASK0;
 		sc_access[0].value = 0x0B;
@@ -890,23 +892,23 @@ static int nc_get_mute(int dev_id, u8 *value)
 	if (retval)
 		return retval;
 
-	pr_debug("sst: get mute::%d\n", dev_id);
+	pr_debug("get mute::%d\n", dev_id);
 
 	switch (dev_id) {
 	case PMIC_SND_AMIC_MUTE:
-		pr_debug("sst: PMIC_SND_INPUT_MUTE_MIC1\n");
+		pr_debug("PMIC_SND_INPUT_MUTE_MIC1\n");
 		sc_access.reg_addr = LILSEL;
 		mask = MASK6;
 		break;
 	case PMIC_SND_HP_MIC_MUTE:
-		pr_debug("sst: PMIC_SND_INPUT_MUTE_MIC2\n");
+		pr_debug("PMIC_SND_INPUT_MUTE_MIC2\n");
 		sc_access.reg_addr = LIRSEL;
 		mask = MASK6;
 		break;
 	case PMIC_SND_LEFT_HP_MUTE:
 	case PMIC_SND_RIGHT_HP_MUTE:
 		mask = MASK2;
-		pr_debug("sst: PMIC_SN_LEFT/RIGHT_HP_MUTE\n");
+		pr_debug("PMIC_SN_LEFT/RIGHT_HP_MUTE\n");
 		if (dev_id == PMIC_SND_RIGHT_HP_MUTE)
 			sc_access.reg_addr = RMUTE;
 		else
@@ -914,12 +916,12 @@ static int nc_get_mute(int dev_id, u8 *value)
 		break;
 
 	case PMIC_SND_LEFT_SPEAKER_MUTE:
-		pr_debug("sst: PMIC_MONO_EARPIECE_MUTE\n");
+		pr_debug("PMIC_MONO_EARPIECE_MUTE\n");
 		sc_access.reg_addr = RMUTE;
 		mask = MASK1;
 		break;
 	case PMIC_SND_DMIC_MUTE:
-		pr_debug("sst: PMIC_SND_INPUT_MUTE_DMIC\n");
+		pr_debug("PMIC_SND_INPUT_MUTE_DMIC\n");
 		sc_access.reg_addr = 0x105;
 		mask = MASK6;
 		break;
@@ -928,16 +930,16 @@ static int nc_get_mute(int dev_id, u8 *value)
 
 	}
 	retval = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
-	pr_debug("sst: reg value = %d\n", sc_access.value);
+	pr_debug("reg value = %d\n", sc_access.value);
 	if (retval)
 		return retval;
 	*value = (sc_access.value) & mask;
-	pr_debug("sst: masked value = %d\n", *value);
+	pr_debug("masked value = %d\n", *value);
 	if (*value)
 		*value = 0;
 	else
 		*value = 1;
-	pr_debug("sst: value returned = 0x%x\n", *value);
+	pr_debug("value returned = 0x%x\n", *value);
 	return retval;
 }
 
@@ -953,19 +955,19 @@ static int nc_get_vol(int dev_id, int *value)
 
 	switch (dev_id) {
 	case PMIC_SND_CAPTURE_VOL:
-		pr_debug("sst: PMIC_SND_INPUT_CAPTURE_VOL\n");
+		pr_debug("PMIC_SND_INPUT_CAPTURE_VOL\n");
 		sc_access.reg_addr =  LILSEL;
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5);
 		break;
 
 	case PMIC_SND_RIGHT_PB_VOL:
-		pr_debug("sst: GET_VOLUME_PMIC_LEFT_HP_VOL\n");
+		pr_debug("GET_VOLUME_PMIC_LEFT_HP_VOL\n");
 		sc_access.reg_addr = AUDIOLVOL;
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
 		break;
 
 	case PMIC_SND_LEFT_PB_VOL:
-		pr_debug("sst: GET_VOLUME_PMIC_RIGHT_HP_VOL\n");
+		pr_debug("GET_VOLUME_PMIC_RIGHT_HP_VOL\n");
 		sc_access.reg_addr = AUDIORVOL;
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
 		break;
@@ -975,9 +977,9 @@ static int nc_get_vol(int dev_id, int *value)
 
 	}
 	retval = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
-	pr_debug("sst: value read = 0x%x\n", sc_access.value);
+	pr_debug("value read = 0x%x\n", sc_access.value);
 	*value = -((sc_access.value) & mask);
-	pr_debug("sst: get vol value returned = %d\n", *value);
+	pr_debug("get vol value returned = %d\n", *value);
 	return retval;
 }
 


