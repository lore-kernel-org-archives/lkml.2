Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1BIWFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:05:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:35067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab1BIWFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:05:19 -0500
Date: Wed, 9 Feb 2011 22:05:17 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.27.58
Message-ID: <20110209220517.GA18751@hera.kernel.org>
References: <20110209220430.GA17820@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209220430.GA17820@hera.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Feb 2011 22:05:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 379c5d9..e690b11 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .57
+EXTRAVERSION = .58
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4d6ef0a..e86da4a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -25,7 +25,7 @@ targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
 
 export CPPFLAGS_vdso.lds += -P -C
 
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -Wl,-soname=linux-vdso.so.1 \
+VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 		      	-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
@@ -69,7 +69,7 @@ vdso32.so-$(VDSO32-y)		+= sysenter
 vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
+VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-soname=linux-gate.so.1
 
 # This makes sure the $(obj) subdirectory exists even though vdso32/
 # is not a kbuild sub-make subdirectory.
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 369612e..13136bc 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -449,7 +449,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 8c030d9..b88f6b3 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -196,11 +196,14 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
+	int ret;
 
+	mutex_lock(&minors_lock);
 	if (!hidraw_table[minor]) {
 		printk(KERN_EMERG "hidraw device with minor %d doesn't exist\n",
 				minor);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	list_del(&list->node);
@@ -211,10 +214,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
 		else
 			kfree(list->hidraw);
 	}
-
 	kfree(list);
+	ret = 0;
+unlock:
+	mutex_unlock(&minors_lock);
 
-	return 0;
+	return ret;
 }
 
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 7fe2441..f7a743f 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -922,27 +922,27 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *attr,
 	int nr = sensor_attr->index;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1026_data *data = i2c_get_clientdata(client);
-	int val, orig_div, new_div, shift;
+	int val, orig_div, new_div;
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
-	if (new_div == 0) {
-		return -EINVAL;
-	}
+
 	mutex_lock(&data->update_lock);
 	orig_div = data->fan_div[nr];
 	data->fan_div[nr] = DIV_FROM_REG(new_div);
 
 	if (nr < 4) { /* 0 <= nr < 4 */
-		shift = 2 * nr;
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_0_3,
-			((DIV_TO_REG(orig_div) & (~(0x03 << shift))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[0]) << 0) |
+				    (DIV_TO_REG(data->fan_div[1]) << 2) |
+				    (DIV_TO_REG(data->fan_div[2]) << 4) |
+				    (DIV_TO_REG(data->fan_div[3]) << 6));
 	} else { /* 3 < nr < 8 */
-		shift = 2 * (nr - 4);
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_4_7,
-			((DIV_TO_REG(orig_div) & (~(0x03 << (2 * shift)))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[4]) << 0) |
+				    (DIV_TO_REG(data->fan_div[5]) << 2) |
+				    (DIV_TO_REG(data->fan_div[6]) << 4) |
+				    (DIV_TO_REG(data->fan_div[7]) << 6));
 	}
 
 	if (data->fan_div[nr] != orig_div) {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 56feab6..fadfdf0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -875,68 +875,81 @@ out:
 	return ret ? ret : in_len;
 }
 
+static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
+{
+	struct ib_uverbs_wc tmp;
+
+	tmp.wr_id		= wc->wr_id;
+	tmp.status		= wc->status;
+	tmp.opcode		= wc->opcode;
+	tmp.vendor_err		= wc->vendor_err;
+	tmp.byte_len		= wc->byte_len;
+	tmp.ex.imm_data		= (__u32 __force) wc->ex.imm_data;
+	tmp.qp_num		= wc->qp->qp_num;
+	tmp.src_qp		= wc->src_qp;
+	tmp.wc_flags		= wc->wc_flags;
+	tmp.pkey_index		= wc->pkey_index;
+	tmp.slid		= wc->slid;
+	tmp.sl			= wc->sl;
+	tmp.dlid_path_bits	= wc->dlid_path_bits;
+	tmp.port_num		= wc->port_num;
+	tmp.reserved		= 0;
+
+	if (copy_to_user(dest, &tmp, sizeof tmp))
+		return -EFAULT;
+
+	return 0;
+}
+
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
-	struct ib_uverbs_poll_cq_resp *resp;
+	struct ib_uverbs_poll_cq_resp  resp;
+	u8 __user                     *header_ptr;
+	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
-	struct ib_wc                  *wc;
-	int                            ret = 0;
-	int                            i;
-	int                            rsize;
+	struct ib_wc                   wc;
+	int                            ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	wc = kmalloc(cmd.ne * sizeof *wc, GFP_KERNEL);
-	if (!wc)
-		return -ENOMEM;
-
-	rsize = sizeof *resp + cmd.ne * sizeof(struct ib_uverbs_wc);
-	resp = kmalloc(rsize, GFP_KERNEL);
-	if (!resp) {
-		ret = -ENOMEM;
-		goto out_wc;
-	}
-
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
-	if (!cq) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!cq)
+		return -EINVAL;
 
-	resp->count = ib_poll_cq(cq, cmd.ne, wc);
+	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
+	header_ptr = (void __user *)(unsigned long) cmd.response;
+	data_ptr = header_ptr + sizeof resp;
 
-	put_cq_read(cq);
+	memset(&resp, 0, sizeof resp);
+	while (resp.count < cmd.ne) {
+		ret = ib_poll_cq(cq, 1, &wc);
+		if (ret < 0)
+			goto out_put;
+		if (!ret)
+			break;
+
+		ret = copy_wc_to_user(data_ptr, &wc);
+		if (ret)
+			goto out_put;
 
-	for (i = 0; i < resp->count; i++) {
-		resp->wc[i].wr_id 	   = wc[i].wr_id;
-		resp->wc[i].status 	   = wc[i].status;
-		resp->wc[i].opcode 	   = wc[i].opcode;
-		resp->wc[i].vendor_err 	   = wc[i].vendor_err;
-		resp->wc[i].byte_len 	   = wc[i].byte_len;
-		resp->wc[i].ex.imm_data    = (__u32 __force) wc[i].ex.imm_data;
-		resp->wc[i].qp_num 	   = wc[i].qp->qp_num;
-		resp->wc[i].src_qp 	   = wc[i].src_qp;
-		resp->wc[i].wc_flags 	   = wc[i].wc_flags;
-		resp->wc[i].pkey_index 	   = wc[i].pkey_index;
-		resp->wc[i].slid 	   = wc[i].slid;
-		resp->wc[i].sl 		   = wc[i].sl;
-		resp->wc[i].dlid_path_bits = wc[i].dlid_path_bits;
-		resp->wc[i].port_num 	   = wc[i].port_num;
+		data_ptr += sizeof(struct ib_uverbs_wc);
+		++resp.count;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
+	if (copy_to_user(header_ptr, &resp, sizeof resp)) {
 		ret = -EFAULT;
+		goto out_put;
+	}
 
-out:
-	kfree(resp);
+	ret = in_len;
 
-out_wc:
-	kfree(wc);
-	return ret ? ret : in_len;
+out_put:
+	put_cq_read(cq);
+	return ret;
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4d96950..2c84cc9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4300,7 +4300,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
 			    info->raid_disk < mddev->raid_disks)
@@ -4310,7 +4310,10 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		} else
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
-		rdev->saved_raid_disk = rdev->raid_disk;
+		if (test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = rdev->raid_disk;
+		else
+			rdev->saved_raid_disk = -1;
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index f1255b0..e225a95 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -774,6 +774,8 @@ static struct usb_device_id uss720_table [] = {
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 17e9626..41f8d2a 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -608,6 +608,13 @@ UNUSUAL_DEV(  0x04e8, 0x507c, 0x0220, 0x0220,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64),
 
+/* Reported by Vitaly Kuznetsov <vitty@altlinux.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
+		"Samsung",
+		"YP-CP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.
diff --git a/fs/exec.c b/fs/exec.c
index fc30de0..12e7ad2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -257,6 +257,11 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 4a57a0f..e5a0874 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -552,6 +552,7 @@ static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
+	unsigned int saved_type = fl->fl_type;
 
 	lock_kernel();
 	/* Try local locking first */
@@ -560,6 +561,7 @@ static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
 		/* found a conflict */
 		goto out;
 	}
+	fl->fl_type = saved_type;
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_noconflict;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 17d0dd9..05569c7 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -272,9 +272,11 @@ void fill_post_wcc(struct svc_fh *fhp)
 
 	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
-	if (err)
+	if (err) {
 		fhp->fh_post_saved = 0;
-	else
+		/* Grab the ctime anyway - set_change_info might use it */
+		fhp->fh_post_attr.ctime = fhp->fh_dentry->d_inode->i_ctime;
+	} else
 		fhp->fh_post_saved = 1;
 }
 
diff --git a/include/linux/nfsd/xdr4.h b/include/linux/nfsd/xdr4.h
index 27bd3e3..dca69e3 100644
--- a/include/linux/nfsd/xdr4.h
+++ b/include/linux/nfsd/xdr4.h
@@ -424,8 +424,8 @@ struct nfsd4_compoundres {
 static inline void
 set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
-	BUG_ON(!fhp->fh_pre_saved || !fhp->fh_post_saved);
-	cinfo->atomic = 1;
+	BUG_ON(!fhp->fh_pre_saved);
+	cinfo->atomic = fhp->fh_post_saved;
 	cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
 	cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
 	cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 029a54a..22757ba 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -277,6 +277,7 @@ int sctp_do_sm(sctp_event_t event_type, sctp_subtype_t subtype,
 /* 2nd level prototypes */
 void sctp_generate_t3_rtx_event(unsigned long peer);
 void sctp_generate_heartbeat_event(unsigned long peer);
+void sctp_generate_proto_unreach_event(unsigned long peer);
 
 void sctp_ootb_pkt_free(struct sctp_packet *);
 
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0594330..35c42e9 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -998,6 +998,9 @@ struct sctp_transport {
 	/* Heartbeat timer is per destination. */
 	struct timer_list hb_timer;
 
+	/* Timer to handle ICMP proto unreachable envets */
+	struct timer_list proto_unreach_timer;
+
 	/* Since we're using per-destination retransmission timers
 	 * (see above), we're also using per-destination "transmitted"
 	 * queues.  This probably ought to be a private struct
diff --git a/kernel/exit.c b/kernel/exit.c
index ac5ab8c..7a5901a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -94,6 +94,14 @@ static void __exit_signal(struct task_struct *tsk)
 		posix_cpu_timers_exit_group(tsk);
 	else {
 		/*
+		 * This can only happen if the caller is de_thread().
+		 * FIXME: this is the temporary hack, we should teach
+		 * posix-cpu-timers to handle this case correctly.
+		 */
+		if (unlikely(has_group_leader_pid(tsk)))
+			posix_cpu_timers_exit_group(tsk);
+
+		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
diff --git a/kernel/power/user.c b/kernel/power/user.c
index a6332a3..2453399 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -129,7 +129,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	free_all_swap_pages(data->swap);
 	if (data->frozen)
 		thaw_processes();
-	pm_notifier_call_chain(data->mode == O_WRONLY ?
+	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dfe3995..f937f5d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2041,17 +2041,25 @@ static int show_traces_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+{
+	if (file->f_mode & FMODE_READ)
+		return seq_lseek(file, offset, origin);
+	else
+		return 0;
+}
+
 static struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_seek,
 	.release	= tracing_release,
 };
 
 static struct file_operations tracing_lt_fops = {
 	.open		= tracing_lt_open,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_seek,
 	.release	= tracing_release,
 };
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 17d640d..707ce0f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2253,6 +2253,7 @@ int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
+	int ret;
 	struct vm_area_struct *vma;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
@@ -2269,14 +2270,21 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
-	if (unlikely(insert_vm_struct(mm, vma))) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -ENOMEM;
-	}
+	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (ret)
+		goto out;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
 	return 0;
+
+out:
+	kmem_cache_free(vm_area_cachep, vma);
+	return ret;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
diff --git a/net/sctp/input.c b/net/sctp/input.c
index be736af..f917029 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -425,11 +425,25 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 {
 	SCTP_DEBUG_PRINTK("%s\n",  __func__);
 
-	sctp_do_sm(SCTP_EVENT_T_OTHER,
-		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
-		   asoc->state, asoc->ep, asoc, t,
-		   GFP_ATOMIC);
+	if (sock_owned_by_user(sk)) {
+		if (timer_pending(&t->proto_unreach_timer))
+			return;
+		else {
+			if (!mod_timer(&t->proto_unreach_timer,
+						jiffies + (HZ/20)))
+				sctp_association_hold(asoc);
+		}
 
+	} else {
+		if (timer_pending(&t->proto_unreach_timer) &&
+		    del_timer(&t->proto_unreach_timer))
+			sctp_association_put(asoc);
+
+		sctp_do_sm(SCTP_EVENT_T_OTHER,
+			   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+			   asoc->state, asoc->ep, asoc, t,
+			   GFP_ATOMIC);
+	}
 }
 
 /* Common lookup code for icmp/icmpv6 error handler. */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 9732c79..06757c4 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -397,6 +397,41 @@ out_unlock:
 	sctp_transport_put(transport);
 }
 
+/* Handle the timeout of the ICMP protocol unreachable timer.  Trigger
+ * the correct state machine transition that will close the association.
+ */
+void sctp_generate_proto_unreach_event(unsigned long data)
+{
+	struct sctp_transport *transport = (struct sctp_transport *) data;
+	struct sctp_association *asoc = transport->asoc;
+
+	sctp_bh_lock_sock(asoc->base.sk);
+	if (sock_owned_by_user(asoc->base.sk)) {
+		SCTP_DEBUG_PRINTK("%s:Sock is busy.\n", __func__);
+
+		/* Try again later.  */
+		if (!mod_timer(&transport->proto_unreach_timer,
+				jiffies + (HZ/20)))
+			sctp_association_hold(asoc);
+		goto out_unlock;
+	}
+
+	/* Is this structure just waiting around for us to actually
+	 * get destroyed?
+	 */
+	if (asoc->base.dead)
+		goto out_unlock;
+
+	sctp_do_sm(SCTP_EVENT_T_OTHER,
+		   SCTP_ST_OTHER(SCTP_EVENT_ICMP_PROTO_UNREACH),
+		   asoc->state, asoc->ep, asoc, transport, GFP_ATOMIC);
+
+out_unlock:
+	sctp_bh_unlock_sock(asoc->base.sk);
+	sctp_association_put(asoc);
+}
+
+
 /* Inject a SACK Timeout event into the state machine.  */
 static void sctp_generate_sack_event(unsigned long data)
 {
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e745c11..cbcae4e 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -107,6 +107,8 @@ static struct sctp_transport *sctp_transport_init(struct sctp_transport *peer,
 			(unsigned long)peer);
 	setup_timer(&peer->hb_timer, sctp_generate_heartbeat_event,
 			(unsigned long)peer);
+	setup_timer(&peer->proto_unreach_timer,
+		    sctp_generate_proto_unreach_event, (unsigned long)peer);
 
 	/* Initialize the 64-bit random nonce sent with heartbeat. */
 	get_random_bytes(&peer->hb_nonce, sizeof(peer->hb_nonce));
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 4c772de..5c80d52 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -172,6 +172,7 @@ int svc_create_xprt(struct svc_serv *serv, char *xprt_name, unsigned short port,
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -192,8 +193,9 @@ int svc_create_xprt(struct svc_serv *serv, char *xprt_name, unsigned short port,
 		spin_lock_bh(&serv->sv_lock);
 		list_add(&newxprt->xpt_list, &serv->sv_permsocks);
 		spin_unlock_bh(&serv->sv_lock);
+		newport = svc_xprt_local_port(newxprt);
 		clear_bit(XPT_BUSY, &newxprt->xpt_flags);
-		return svc_xprt_local_port(newxprt);
+		return newport;
 	}
  err:
 	spin_unlock(&svc_xprt_class_lock);
@@ -386,8 +388,13 @@ void svc_xprt_received(struct svc_xprt *xprt)
 {
 	BUG_ON(!test_bit(XPT_BUSY, &xprt->xpt_flags));
 	xprt->xpt_pool = NULL;
+	/* As soon as we clear busy, the xprt could be closed and
+	 * 'put', so we need a reference to call svc_xprt_enqueue with:
+	 */
+	svc_xprt_get(xprt);
 	clear_bit(XPT_BUSY, &xprt->xpt_flags);
 	svc_xprt_enqueue(xprt);
+	svc_xprt_put(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_received);
 
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 7d89c08..3b4bd9f 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -87,7 +87,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	int             i, n;
 
 	for (i = 0; i < num_mixer_volumes; i++) {
-		if (strcmp(name, mixer_vols[i].name) == 0) {
+		if (strncmp(name, mixer_vols[i].name, 32) == 0) {
 			if (present)
 				mixer_vols[i].num = i;
 			return mixer_vols[i].levels;
@@ -99,7 +99,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	}
 	n = num_mixer_volumes++;
 
-	strcpy(mixer_vols[n].name, name);
+	strncpy(mixer_vols[n].name, name, 32);
 
 	if (present)
 		mixer_vols[n].num = n;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0b93ef6..d7a0451 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1966,6 +1966,8 @@ static int azx_dev_free(struct snd_device *device)
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x0470, "Dell Inspiron 1120", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	{}
 };
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2581b8c..e70bb7d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3154,6 +3154,7 @@ static struct snd_pci_quirk alc880_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),
