Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab0EZW2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:28:18 -0400
Received: from kroah.org ([198.145.64.141]:58610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab0EZW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:27:11 -0400
Date: Wed, 26 May 2010 15:23:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.47
Message-ID: <20100526222340.GB29493@kroah.com>
References: <20100526222323.GA29493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526222323.GA29493@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ff8d4a3..efc948f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .46
+EXTRAVERSION = .47
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 876e918..f459e3e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -283,16 +283,12 @@ static void c1e_idle(void)
 		if (!cpu_isset(cpu, c1e_mask)) {
 			cpu_set(cpu, c1e_mask);
 			/*
-			 * Force broadcast so ACPI can not interfere. Needs
-			 * to run with interrupts enabled as it uses
-			 * smp_function_call.
+			 * Force broadcast so ACPI can not interfere.
 			 */
-			local_irq_enable();
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 					   &cpu);
 			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
 			       cpu);
-			local_irq_disable();
 		}
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5639e27..94483a2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -317,8 +317,9 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 		pr->power.timer_broadcast_on_state = state;
 }
 
-static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
+static void __lapic_timer_propagate_broadcast(void *arg)
 {
+	struct acpi_processor *pr = (struct acpi_processor *) arg;
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
@@ -327,6 +328,12 @@ static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 	clockevents_notify(reason, &pr->id);
 }
 
+static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
+{
+	smp_call_function_single(pr->id, __lapic_timer_propagate_broadcast,
+				 (void *)pr, 1);
+}
+
 /* Power(C) State timer broadcast control */
 static void acpi_state_timer_broadcast(struct acpi_processor *pr,
 				       struct acpi_processor_cx *cx,
@@ -347,7 +354,7 @@ static void acpi_state_timer_broadcast(struct acpi_processor *pr,
 
 static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cstate) { }
-static void acpi_propagate_timer_broadcast(struct acpi_processor *pr) { }
+static void lapic_timer_propagate_broadcast(struct acpi_processor *pr) { }
 static void acpi_state_timer_broadcast(struct acpi_processor *pr,
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
@@ -1177,7 +1184,7 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 			working++;
 	}
 
-	acpi_propagate_timer_broadcast(pr);
+	lapic_timer_propagate_broadcast(pr);
 
 	return (working);
 }
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 22995d7..9358fa6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1497,6 +1497,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	}
 
 	/* okay, this error is ours */
+	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
 		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
@@ -1900,8 +1901,9 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 			qc->err_mask &= ~(AC_ERR_DEV | AC_ERR_OTHER);
 
 		/* determine whether the command is worth retrying */
-		if (!(qc->err_mask & AC_ERR_INVALID) &&
-		    ((qc->flags & ATA_QCFLAG_IO) || qc->err_mask != AC_ERR_DEV))
+		if (qc->flags & ATA_QCFLAG_IO ||
+		    (!(qc->err_mask & AC_ERR_INVALID) &&
+		     qc->err_mask != AC_ERR_DEV))
 			qc->flags |= ATA_QCFLAG_RETRY;
 
 		/* accumulate error info */
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e6788f4..f325128 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1893,6 +1893,8 @@ static void release_one_tty(struct tty_struct *tty, int idx)
 	list_del_init(&tty->tty_files);
 	file_list_unlock();
 
+	put_pid(tty->pgrp);
+	put_pid(tty->session);
 	free_tty_struct(tty);
 }
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
index f942ecd..0af9a2c 100644
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1797,17 +1797,17 @@ static int __init
 w83781d_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
-
-	/* We have to request the region in two parts because some
-	   boards declare base+4 to base+7 as a PNP device */
-	if (!request_region(address, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request low part of region\n");
-		return 0;
-	}
-	if (!request_region(address + 4, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request high part of region\n");
-		release_region(address, 4);
-		return 0;
+	int port;
+
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + W83781D_EXTENT; port++) {
+		if (!request_region(port, 1, "w83781d")) {
+			pr_debug("w83781d: Failed to request port 0x%x\n",
+				 port);
+			goto release;
+		}
 	}
 
 #define REALLY_SLOW_IO
@@ -1881,8 +1881,8 @@ w83781d_isa_found(unsigned short address)
 			val == 0x30 ? "W83782D" : "W83781D", (int)address);
 
  release:
-	release_region(address + 4, 4);
-	release_region(address, 4);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index dc7ea32..177346e 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -413,9 +413,11 @@ static int i801_block_transaction(union i2c_smbus_data *data, char read_write,
 		data->block[0] = 32;	/* max for SMBus block reads */
 	}
 
+	/* Experience has shown that the block buffer can only be used for
+	   SMBus (not I2C) block transactions, even though the datasheet
+	   doesn't mention this limitation. */
 	if ((i801_features & FEATURE_BLOCK_BUFFER)
-	 && !(command == I2C_SMBUS_I2C_BLOCK_DATA
-	      && read_write == I2C_SMBUS_READ)
+	 && command != I2C_SMBUS_I2C_BLOCK_DATA
 	 && i801_set_block_buffer_mode() == 0)
 		result = i801_block_transaction_by_block(data, read_write,
 							 hwpec);
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index b1c050f..e29b6d5 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/types.h>
 
 /* include interfaces to usb layer */
 #include <linux/usb.h>
@@ -31,8 +32,8 @@
 #define CMD_I2C_IO_END		(1<<1)
 
 /* i2c bit delay, default is 10us -> 100kHz */
-static int delay = 10;
-module_param(delay, int, 0);
+static unsigned short delay = 10;
+module_param(delay, ushort, 0);
 MODULE_PARM_DESC(delay, "bit delay in microseconds, "
 		 "e.g. 10 for 100kHz (default is 100kHz)");
 
@@ -109,7 +110,7 @@ static int usb_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs, int num)
 
 static u32 usb_func(struct i2c_adapter *adapter)
 {
-	u32 func;
+	__le32 func;
 
 	/* get functionality from adapter */
 	if (usb_read(adapter, CMD_GET_FUNC, 0, 0, &func, sizeof(func)) !=
@@ -118,7 +119,7 @@ static u32 usb_func(struct i2c_adapter *adapter)
 		return 0;
 	}
 
-	return func;
+	return le32_to_cpu(func);
 }
 
 /* This is the actual algorithm we define */
@@ -216,8 +217,7 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 		 "i2c-tiny-usb at bus %03d device %03d",
 		 dev->usb_dev->bus->busnum, dev->usb_dev->devnum);
 
-	if (usb_write(&dev->adapter, CMD_SET_DELAY,
-		      cpu_to_le16(delay), 0, NULL, 0) != 0) {
+	if (usb_write(&dev->adapter, CMD_SET_DELAY, delay, 0, NULL, 0) != 0) {
 		dev_err(&dev->adapter.dev,
 			"failure setting delay to %dus\n", delay);
 		retval = -EIO;
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 3d3fb00..5ba06d9 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1269,14 +1269,24 @@ static int i2c_detect_address(struct i2c_client *temp_client, int kind,
 
 	/* Make sure there is something at this address, unless forced */
 	if (kind < 0) {
-		if (i2c_smbus_xfer(adapter, addr, 0, 0, 0,
-				   I2C_SMBUS_QUICK, NULL) < 0)
-			return 0;
+		if (addr == 0x73 && (adapter->class & I2C_CLASS_HWMON)) {
+			/* Special probe for FSC hwmon chips */
+			union i2c_smbus_data dummy;
 
-		/* prevent 24RF08 corruption */
-		if ((addr & ~0x0f) == 0x50)
-			i2c_smbus_xfer(adapter, addr, 0, 0, 0,
-				       I2C_SMBUS_QUICK, NULL);
+			if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_READ, 0,
+					   I2C_SMBUS_BYTE_DATA, &dummy) < 0)
+				return 0;
+		} else {
+			if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_WRITE, 0,
+					   I2C_SMBUS_QUICK, NULL) < 0)
+				return 0;
+
+			/* Prevent 24RF08 corruption */
+			if ((addr & ~0x0f) == 0x50)
+				i2c_smbus_xfer(adapter, addr, 0,
+					       I2C_SMBUS_WRITE, 0,
+					       I2C_SMBUS_QUICK, NULL);
+		}
 	}
 
 	/* Finally call the custom detection function */
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 4c3f124..342df4a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3292,6 +3292,7 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
 	int i;
 	int error = 0;
+	compat_uptr_t ptr;
 
 	if (clear_user(ioc, sizeof(*ioc)))
 		return -EFAULT;
@@ -3304,9 +3305,22 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
 		return -EFAULT;
 
-	for (i = 0; i < MAX_IOCTL_SGE; i++) {
-		compat_uptr_t ptr;
+	/*
+	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
+	 * sense_len is not null, so prepare the 64bit value under
+	 * the same condition.
+	 */
+	if (ioc->sense_len) {
+		void __user **sense_ioc_ptr =
+			(void __user **)(ioc->frame.raw + ioc->sense_off);
+		compat_uptr_t *sense_cioc_ptr =
+			(compat_uptr_t *)(cioc->frame.raw + cioc->sense_off);
+		if (get_user(ptr, sense_cioc_ptr) ||
+		    put_user(compat_ptr(ptr), sense_ioc_ptr))
+			return -EFAULT;
+	}
 
+	for (i = 0; i < MAX_IOCTL_SGE; i++) {
 		if (get_user(ptr, &cioc->sgl[i].iov_base) ||
 		    put_user(compat_ptr(ptr), &ioc->sgl[i].iov_base) ||
 		    copy_in_user(&ioc->sgl[i].iov_len,
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 83887ff..2c3cdbd 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -510,13 +510,13 @@ static int fs_create_by_name (const char *name, mode_t mode,
 	*dentry = NULL;
 	mutex_lock(&parent->d_inode->i_mutex);
 	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
+	if (!IS_ERR(*dentry)) {
 		if ((mode & S_IFMT) == S_IFDIR)
 			error = usbfs_mkdir (parent->d_inode, *dentry, mode);
 		else 
 			error = usbfs_create (parent->d_inode, *dentry, mode);
 	} else
-		error = PTR_ERR(dentry);
+		error = PTR_ERR(*dentry);
 	mutex_unlock(&parent->d_inode->i_mutex);
 
 	return error;
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8b7c776..532f8cc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1754,6 +1754,44 @@ out:
 	return ret;
 }
 
+int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks)
+{
+	s64 free_blocks, dirty_blocks;
+	ext4_fsblk_t root_blocks = 0;
+	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
+
+	free_blocks  = percpu_counter_read_positive(fbc);
+	dirty_blocks = percpu_counter_read_positive(dbc);
+
+	if (!capable(CAP_SYS_RESOURCE) &&
+		sbi->s_resuid != current->fsuid &&
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		root_blocks = ext4_r_blocks_count(sbi->s_es);
+
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
+						EXT4_FREEBLOCKS_WATERMARK) {
+		free_blocks  = percpu_counter_sum(fbc);
+		dirty_blocks = percpu_counter_sum(dbc);
+		if (dirty_blocks < 0) {
+			printk(KERN_CRIT "Dirty block accounting "
+					"went wrong %lld\n",
+					dirty_blocks);
+		}
+	}
+	/* Check whether we have space after
+	 * accounting for current dirty blocks
+	 */
+	if (free_blocks < ((s64)(root_blocks + nblocks) + dirty_blocks))
+		/* we don't have free space */
+		return -ENOSPC;
+
+	/* Add the blocks to nblocks */
+	percpu_counter_add(dbc, nblocks);
+	return 0;
+}
+
 /**
  * ext4_has_free_blocks()
  * @sbi:	in-core super block structure.
@@ -1766,27 +1804,31 @@ out:
 ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks)
 {
-	ext4_fsblk_t free_blocks;
+	ext4_fsblk_t free_blocks, dirty_blocks;
 	ext4_fsblk_t root_blocks = 0;
+	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	free_blocks  = percpu_counter_read_positive(fbc);
+	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
-#ifdef CONFIG_SMP
-	if (free_blocks - root_blocks < FBC_BATCH)
-		free_blocks =
-			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
-#endif
-	if (free_blocks <= root_blocks)
+
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
+						EXT4_FREEBLOCKS_WATERMARK) {
+		free_blocks  = percpu_counter_sum_positive(fbc);
+		dirty_blocks = percpu_counter_sum_positive(dbc);
+	}
+	if (free_blocks <= (root_blocks + dirty_blocks))
 		/* we don't have free space */
 		return 0;
-	if (free_blocks - root_blocks < nblocks)
+	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
- }
+}
 
 
 /**
@@ -1865,14 +1907,17 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		*count = ext4_has_free_blocks(sbi, *count);
-	}
-	if (*count == 0) {
-		*errp = -ENOSPC;
-		return 0;	/*return with ENOSPC error */
+		while (*count && ext4_claim_free_blocks(sbi, *count)) {
+			/* let others to free the space */
+			yield();
+			*count = *count >> 1;
+		}
+		if (!*count) {
+			*errp = -ENOSPC;
+			return 0;	/*return with ENOSPC error */
+		}
+		num = *count;
 	}
-	num = *count;
-
 	/*
 	 * Check quota for allocation of this block.
 	 */
@@ -2067,9 +2112,14 @@ allocated:
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
+	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
+	/*
+	 * Now reduce the dirty block count also. Should not go negative
+	 */
 	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
-		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
-
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, *count);
+	else
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, num);
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
 		spin_lock(sb_bgl_lock(sbi, flex_group));
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1985721..7b666b2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1015,6 +1015,8 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks);
 extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
@@ -1245,6 +1247,17 @@ do {								\
 		__ext4_std_error((sb), __func__, (errno));	\
 } while (0)
 
+#ifdef CONFIG_SMP
+/* Each CPU can accumulate FBC_BATCH blocks in their local
+ * counters. So we need to make sure we have free blocks more
+ * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+ */
+#define EXT4_FREEBLOCKS_WATERMARK (4 * (FBC_BATCH * nr_cpu_ids))
+#else
+#define EXT4_FREEBLOCKS_WATERMARK 0
+#endif
+
+
 /*
  * Inodes and files operations
  */
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index f20df8a..6d096d5 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -60,6 +60,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
+	struct percpu_counter s_dirtyblocks_counter;
 	struct blockgroup_lock s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aeebfc2..a67f837 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1032,19 +1032,20 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	/* Account for allocated meta_blocks */
-	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
-
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+	if (mdb_free) {
+		/* Account for allocated meta_blocks */
+		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+
+		/* update fs dirty blocks counter */
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
+		EXT4_I(inode)->i_allocated_meta_blocks = 0;
+		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+	}
 
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
 
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
@@ -1548,6 +1549,7 @@ static int ext4_journalled_write_end(struct file *file,
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
+	int retries = 0;
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
        unsigned long md_needed, mdblocks, total = 0;
 
@@ -1556,6 +1558,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
+repeat:
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_calc_metadata_amount(inode, total);
@@ -1564,13 +1567,14 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	if (ext4_has_free_blocks(sbi, total) < total) {
+	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			yield();
+			goto repeat;
+		}
 		return -ENOSPC;
 	}
-	/* reduce fs free blocks counter */
-	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
-
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
 	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
 
@@ -1612,8 +1616,8 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 
 	release = to_free + mdb_free;
 
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, release);
+	/* update fs dirty blocks counter for truncate case */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
 
 	/* update per-inode reservations */
 	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
@@ -1657,6 +1661,7 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	int io_done;
 	long pages_written;
+	int retval;
 };
 
 /*
@@ -1694,17 +1699,23 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		/*
+		 * We can use PAGECACHE_TAG_DIRTY lookup here because
+		 * even though we have cleared the dirty flag on the page
+		 * We still keep the page in the radix tree with tag
+		 * PAGECACHE_TAG_DIRTY. See clear_page_dirty_for_io.
+		 * The PAGECACHE_TAG_DIRTY is cleared in set_page_writeback
+		 * which is called via the below writepage callback.
+		 */
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					PAGECACHE_TAG_DIRTY,
+					min(end - index,
+					(pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			index = page->index;
-			if (index > end)
-				break;
-			index++;
-
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 
@@ -1821,6 +1832,57 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
 		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
 }
 
+static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
+					sector_t logical, long blk_cnt)
+{
+	int nr_pages, i;
+	pgoff_t index, end;
+	struct pagevec pvec;
+	struct inode *inode = mpd->inode;
+	struct address_space *mapping = inode->i_mapping;
+
+	index = logical >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	end   = (logical + blk_cnt - 1) >>
+				(PAGE_CACHE_SHIFT - inode->i_blkbits);
+	while (index <= end) {
+		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		if (nr_pages == 0)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+			index = page->index;
+			if (index > end)
+				break;
+			index++;
+
+			BUG_ON(!PageLocked(page));
+			BUG_ON(PageWriteback(page));
+			block_invalidatepage(page, 0);
+			ClearPageUptodate(page);
+			unlock_page(page);
+		}
+	}
+	return;
+}
+
+static void ext4_print_free_blocks(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	printk(KERN_EMERG "Total free blocks count %lld\n",
+			ext4_count_free_blocks(inode->i_sb));
+	printk(KERN_EMERG "Free/Dirty block details\n");
+	printk(KERN_EMERG "free_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_freeblocks_counter));
+	printk(KERN_EMERG "dirty_blocks=%lld\n",
+			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+	printk(KERN_EMERG "Block reservation details\n");
+	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_data_blocks);
+	printk(KERN_EMERG "i_reserved_meta_blocks=%lu\n",
+			EXT4_I(inode)->i_reserved_meta_blocks);
+	return;
+}
+
 /*
  * mpage_da_map_blocks - go through given space
  *
@@ -1830,32 +1892,69 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  * The function skips space we know is already mapped to disk blocks.
  *
  */
-static void mpage_da_map_blocks(struct mpage_da_data *mpd)
+static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
 	int err = 0;
-	struct buffer_head *lbh = &mpd->lbh;
-	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
+	struct buffer_head *lbh = &mpd->lbh;
+	sector_t next;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
-		return;
-
+		return 0;
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
-
+	next = lbh->b_blocknr;
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
 	 */
 	if (!new.b_size)
-		return;
+		return 0;
 	err = mpd->get_block(mpd->inode, next, &new, 1);
-	if (err)
-		return;
+	if (err) {
+
+		/* If get block returns with error
+		 * we simply return. Later writepage
+		 * will redirty the page and writepages
+		 * will find the dirty page again
+		 */
+		if (err == -EAGAIN)
+			return 0;
+
+		if (err == -ENOSPC &&
+				ext4_count_free_blocks(mpd->inode->i_sb)) {
+			mpd->retval = err;
+			return 0;
+		}
+
+		/*
+		 * get block failure will cause us
+		 * to loop in writepages. Because
+		 * a_ops->writepage won't be able to
+		 * make progress. The page will be redirtied
+		 * by writepage and writepages will again
+		 * try to write the same.
+		 */
+		printk(KERN_EMERG "%s block allocation failed for inode %lu "
+				  "at logical offset %llu with max blocks "
+				  "%zd with error %d\n",
+				  __func__, mpd->inode->i_ino,
+				  (unsigned long long)next,
+				  lbh->b_size >> mpd->inode->i_blkbits, err);
+		printk(KERN_EMERG "This should not happen.!! "
+					"Data will be lost\n");
+		if (err == -ENOSPC) {
+			ext4_print_free_blocks(mpd->inode);
+		}
+		/* invlaidate all the pages */
+		ext4_da_block_invalidatepages(mpd, next,
+				lbh->b_size >> mpd->inode->i_blkbits);
+		return err;
+	}
 	BUG_ON(new.b_size == 0);
 
 	if (buffer_new(&new))
@@ -1868,7 +1967,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (buffer_delay(lbh) || buffer_unwritten(lbh))
 		mpage_put_bnr_to_bhs(mpd, next, &new);
 
-	return;
+	return 0;
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
@@ -1937,8 +2036,8 @@ flush_it:
 	 * We couldn't merge the block to our extent, so we
 	 * need to flush current  extent and start new one
 	 */
-	mpage_da_map_blocks(mpd);
-	mpage_da_submit_io(mpd);
+	if (mpage_da_map_blocks(mpd) == 0)
+		mpage_da_submit_io(mpd);
 	mpd->io_done = 1;
 	return;
 }
@@ -1980,8 +2079,8 @@ static int __mpage_da_writepage(struct page *page,
 		 * and start IO on them using writepage()
 		 */
 		if (mpd->next_page != mpd->first_page) {
-			mpage_da_map_blocks(mpd);
-			mpage_da_submit_io(mpd);
+			if (mpage_da_map_blocks(mpd) == 0)
+				mpage_da_submit_io(mpd);
 			/*
 			 * skip rest of the page in the page_vec
 			 */
@@ -2074,39 +2173,36 @@ static int __mpage_da_writepage(struct page *page,
  */
 static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
-			       get_block_t get_block)
+			       struct mpage_da_data *mpd)
 {
-	struct mpage_da_data mpd;
 	long to_write;
 	int ret;
 
-	if (!get_block)
+	if (!mpd->get_block)
 		return generic_writepages(mapping, wbc);
 
-	mpd.wbc = wbc;
-	mpd.inode = mapping->host;
-	mpd.lbh.b_size = 0;
-	mpd.lbh.b_state = 0;
-	mpd.lbh.b_blocknr = 0;
-	mpd.first_page = 0;
-	mpd.next_page = 0;
-	mpd.get_block = get_block;
-	mpd.io_done = 0;
-	mpd.pages_written = 0;
+	mpd->lbh.b_size = 0;
+	mpd->lbh.b_state = 0;
+	mpd->lbh.b_blocknr = 0;
+	mpd->first_page = 0;
+	mpd->next_page = 0;
+	mpd->io_done = 0;
+	mpd->pages_written = 0;
+	mpd->retval = 0;
 
 	to_write = wbc->nr_to_write;
 
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, &mpd);
+	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
 
 	/*
 	 * Handle last extent of pages
 	 */
-	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-		mpage_da_map_blocks(&mpd);
-		mpage_da_submit_io(&mpd);
+	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
+		if (mpage_da_map_blocks(mpd) == 0)
+			mpage_da_submit_io(mpd);
 	}
 
-	wbc->nr_to_write = to_write - mpd.pages_written;
+	wbc->nr_to_write = to_write - mpd->pages_written;
 	return ret;
 }
 
@@ -2352,7 +2448,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
 	handle_t *handle = NULL;
-	loff_t range_start = 0;
+	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
 	long to_write, pages_skipped = 0;
@@ -2390,16 +2486,12 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
 
-	if (!wbc->range_cyclic)
-		/*
-		 * If range_cyclic is not set force range_cont
-		 * and save the old writeback_index
-		 */
-		wbc->range_cont = 1;
 
-	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
+	mpd.wbc = wbc;
+	mpd.inode = mapping->host;
+
 restart_loop:
 	to_write = wbc->nr_to_write;
 	while (!ret && to_write > 0) {
@@ -2435,11 +2527,17 @@ restart_loop:
 				goto out_writepages;
 			}
 		}
-
 		to_write -= wbc->nr_to_write;
-		ret = mpage_da_writepages(mapping, wbc,
-					  ext4_da_get_block_write);
+
+		mpd.get_block = ext4_da_get_block_write;
+		ret = mpage_da_writepages(mapping, wbc, &mpd);
+
 		ext4_journal_stop(handle);
+
+		if (mpd.retval == -ENOSPC)
+			jbd2_journal_force_commit_nested(sbi->s_journal);
+
+		/* reset the retry count */
 		if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
@@ -2459,9 +2557,8 @@ restart_loop:
 		wbc->nr_to_write = to_write;
 	}
 
-	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
+	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
 		/* We skipped pages in this loop */
-		wbc->range_start = range_start;
 		wbc->nr_to_write = to_write +
 				wbc->pages_skipped - pages_skipped;
 		wbc->pages_skipped = pages_skipped;
@@ -2470,7 +2567,6 @@ restart_loop:
 
 out_writepages:
 	wbc->nr_to_write = to_write - nr_to_writebump;
-	wbc->range_start = range_start;
 	return ret;
 }
 
@@ -2488,7 +2584,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
-
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c7dc115..453589d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3100,7 +3100,7 @@ void exit_ext4_mballoc(void)
  */
 static noinline_for_stack int
 ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
-				handle_t *handle)
+				handle_t *handle, unsigned long reserv_blks)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_super_block *es;
@@ -3188,15 +3188,16 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-
+	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 	/*
-	 * free blocks account has already be reduced/reserved
-	 * at write_begin() time for delayed allocation
-	 * do not double accounting
+	 * Now reduce the dirty block count also. Should not go negative
 	 */
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
-		percpu_counter_sub(&sbi->s_freeblocks_counter,
-					ac->ac_b_ex.fe_len);
+		/* release all the reserved blocks if non delalloc */
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
+	else
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						ac->ac_b_ex.fe_len);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4630,12 +4631,13 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				 struct ext4_allocation_request *ar, int *errp)
 {
+	int freed;
 	struct ext4_allocation_context *ac = NULL;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
-	int freed;
-	int inquota;
+	unsigned long inquota;
+	unsigned long reserv_blks = 0;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
@@ -4649,14 +4651,17 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		ar->len = ext4_has_free_blocks(sbi, ar->len);
-	}
-
-	if (ar->len == 0) {
-		*errp = -ENOSPC;
-		return 0;
+		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+			/* let others to free the space */
+			yield();
+			ar->len = ar->len >> 1;
+		}
+		if (!ar->len) {
+			*errp = -ENOSPC;
+			return 0;
+		}
+		reserv_blks = ar->len;
 	}
-
 	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
 		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
 		ar->len--;
@@ -4701,7 +4706,7 @@ repeat:
 			ext4_mb_new_preallocation(ac);
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		*errp = ext4_mb_mark_diskspace_used(ac, handle);
+		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
 		if (*errp ==  -EAGAIN) {
 			/*
 			 * drop the reference that we took
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index baacaf8..2bca22d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -521,6 +521,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -2280,6 +2281,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 				ext4_count_dirs(sb));
 	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	}
 	if (err) {
 		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
 		goto failed_mount3;
@@ -2517,6 +2521,7 @@ failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
@@ -3208,7 +3213,8 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = EXT4_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
+		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
 	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 9d6a0e4..710645c 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -826,6 +826,8 @@ out_error:
 static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_server *source)
 {
 	target->flags = source->flags;
+	target->rsize = source->rsize;
+	target->wsize = source->wsize;
 	target->acregmin = source->acregmin;
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e195f67..ee7ed21 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -826,6 +826,8 @@ out_zap_parent:
 		/* If we have submounts, don't unhash ! */
 		if (have_submounts(dentry))
 			goto out_valid;
+		if (dentry->d_flags & DCACHE_DISCONNECTED)
+			goto out_valid;
 		shrink_dcache_parent(dentry);
 	}
 	d_drop(dentry);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index abffc90..6203c81 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -179,10 +179,10 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	argp->p = page_address(argp->pagelist[0]);
 	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
-		argp->end = p + (argp->pagelen>>2);
+		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
 	} else {
-		argp->end = p + (PAGE_SIZE>>2);
+		argp->end = argp->p + (PAGE_SIZE>>2);
 		argp->pagelen -= PAGE_SIZE;
 	}
 	memcpy(((char*)p)+avail, argp->p, (nbytes - avail));
@@ -1115,10 +1115,10 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			argp->p = page_address(argp->pagelist[0]);
 			argp->pagelist++;
 			if (argp->pagelen < PAGE_SIZE) {
-				argp->end = p + (argp->pagelen>>2);
+				argp->end = argp->p + (argp->pagelen>>2);
 				argp->pagelen = 0;
 			} else {
-				argp->end = p + (PAGE_SIZE>>2);
+				argp->end = argp->p + (PAGE_SIZE>>2);
 				argp->pagelen -= PAGE_SIZE;
 			}
 		}
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 2083888..9007ccd 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -44,19 +44,13 @@ static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
-	s64 ret = __percpu_counter_sum(fbc, 0);
+	s64 ret = __percpu_counter_sum(fbc);
 	return ret < 0 ? 0 : ret;
 }
 
-static inline s64 percpu_counter_sum_and_set(struct percpu_counter *fbc)
-{
-	return __percpu_counter_sum(fbc, 1);
-}
-
-
 static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 {
-	return __percpu_counter_sum(fbc, 0);
+	return __percpu_counter_sum(fbc);
 }
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
diff --git a/include/linux/security.h b/include/linux/security.h
index 1638afd..0601e71 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1590,6 +1590,7 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
+int security_vm_enough_memory_kern(long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
 void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
@@ -1822,14 +1823,23 @@ static inline int security_settime(struct timespec *ts, struct timezone *tz)
 
 static inline int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return cap_vm_enough_memory(current->mm, pages);
 }
 
 static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	WARN_ON(mm == NULL);
 	return cap_vm_enough_memory(mm, pages);
 }
 
+static inline int security_vm_enough_memory_kern(long pages)
+{
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return cap_vm_enough_memory(current->mm, pages);
+}
+
 static inline int security_bprm_alloc(struct linux_binprm *bprm)
 {
 	return 0;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index c2835bb..cc0e6d9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index f8d9680..ae51d5e 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -124,11 +124,12 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
  */
 int clockevents_register_notifier(struct notifier_block *nb)
 {
+	unsigned long flags;
 	int ret;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 
 	return ret;
 }
@@ -165,6 +166,8 @@ static void clockevents_notify_released(void)
  */
 void clockevents_register_device(struct clock_event_device *dev)
 {
+	unsigned long flags;
+
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 	/*
 	 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
@@ -175,13 +178,13 @@ void clockevents_register_device(struct clock_event_device *dev)
 		WARN_ON(1);
 	}
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 
 	list_add(&dev->list, &clockevent_devices);
 	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	clockevents_notify_released();
 
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 
 /*
@@ -228,8 +231,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
 void clockevents_notify(unsigned long reason, void *arg)
 {
 	struct list_head *node, *tmp;
+	unsigned long flags;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
 
 	switch (reason) {
@@ -244,7 +248,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 	default:
 		break;
 	}
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 #endif
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index cb01cd8..d1b3216 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -205,11 +205,11 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
  */
-static void tick_do_broadcast_on_off(void *why)
+static void tick_do_broadcast_on_off(unsigned long *reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
-	unsigned long flags, *reason = why;
+	unsigned long flags;
 	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -276,8 +276,7 @@ void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
-		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1);
+		tick_do_broadcast_on_off(&reason);
 }
 
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..dfe3995 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3018,7 +3018,6 @@ static int trace_free_page(void)
 		ClearPageLRU(page);
 		list_del(&page->lru);
 		tracing_pages_allocated--;
-		tracing_pages_allocated--;
 		__free_page(page);
 
 		tracing_reset(data);
@@ -3036,6 +3035,7 @@ static int trace_free_page(void)
 		page = list_entry(p, struct page, lru);
 		ClearPageLRU(page);
 		list_del(&page->lru);
+		tracing_pages_allocated--;
 		__free_page(page);
 
 		tracing_reset(data);
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 4a8ba4b..a866389 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -62,11 +62,9 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		if (set)
-			*pcount = 0;
+		*pcount = 0;
 	}
-	if (set)
-		fbc->count = ret;
+	fbc->count = ret;
 
 	spin_unlock(&fbc->lock);
 	return ret;
diff --git a/mm/mmap.c b/mm/mmap.c
index 8b5aa8e..f3e5bfe 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -178,7 +178,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff --git a/mm/nommu.c b/mm/nommu.c
index 4bf7686..7122331 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1432,7 +1432,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5f7cdc2..e5c4ca2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1027,8 +1027,6 @@ continue_unlock:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = done_index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
diff --git a/mm/shmem.c b/mm/shmem.c
index 04fb4f1..c088da1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -163,8 +163,8 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_ACCOUNT)?
-		security_vm_enough_memory(VM_ACCT(size)): 0;
+	return (flags & VM_ACCOUNT) ?
+		security_vm_enough_memory_kern(VM_ACCT(size)) : 0;
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -181,8 +181,8 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
  */
 static inline int shmem_acct_block(unsigned long flags)
 {
-	return (flags & VM_ACCOUNT)?
-		0: security_vm_enough_memory(VM_ACCT(PAGE_CACHE_SIZE));
+	return (flags & VM_ACCOUNT) ?
+		0 : security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index e46c825..4c772de 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -810,6 +810,11 @@ static void svc_age_temp_xprts(unsigned long closure)
 void svc_delete_xprt(struct svc_xprt *xprt)
 {
 	struct svc_serv	*serv = xprt->xpt_server;
+	struct svc_deferred_req *dr;
+
+	/* Only do this once */
+	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags))
+		return;
 
 	dprintk("svc: svc_delete_xprt(%p)\n", xprt);
 	xprt->xpt_ops->xpo_detach(xprt);
@@ -824,12 +829,16 @@ void svc_delete_xprt(struct svc_xprt *xprt)
 	 * while still attached to a queue, the queue itself
 	 * is about to be destroyed (in svc_destroy).
 	 */
-	if (!test_and_set_bit(XPT_DEAD, &xprt->xpt_flags)) {
-		BUG_ON(atomic_read(&xprt->xpt_ref.refcount) < 2);
-		if (test_bit(XPT_TEMP, &xprt->xpt_flags))
-			serv->sv_tmpcnt--;
+	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
+		serv->sv_tmpcnt--;
+
+	for (dr = svc_deferred_dequeue(xprt); dr;
+	     dr = svc_deferred_dequeue(xprt)) {
 		svc_xprt_put(xprt);
+		kfree(dr);
 	}
+
+	svc_xprt_put(xprt);
 	spin_unlock_bh(&serv->sv_lock);
 }
 
@@ -875,17 +884,19 @@ static void svc_revisit(struct cache_deferred_req *dreq, int too_many)
 		container_of(dreq, struct svc_deferred_req, handle);
 	struct svc_xprt *xprt = dr->xprt;
 
-	if (too_many) {
+	spin_lock(&xprt->xpt_lock);
+	set_bit(XPT_DEFERRED, &xprt->xpt_flags);
+	if (too_many || test_bit(XPT_DEAD, &xprt->xpt_flags)) {
+		spin_unlock(&xprt->xpt_lock);
+		dprintk("revisit canceled\n");
 		svc_xprt_put(xprt);
 		kfree(dr);
 		return;
 	}
 	dprintk("revisit queued\n");
 	dr->xprt = NULL;
-	spin_lock(&xprt->xpt_lock);
 	list_add(&dr->handle.recent, &xprt->xpt_deferred);
 	spin_unlock(&xprt->xpt_lock);
-	set_bit(XPT_DEFERRED, &xprt->xpt_flags);
 	svc_xprt_enqueue(xprt);
 	svc_xprt_put(xprt);
 }
diff --git a/security/security.c b/security/security.c
index 27a315d..50b61ae 100644
--- a/security/security.c
+++ b/security/security.c
@@ -195,14 +195,23 @@ int security_settime(struct timespec *ts, struct timezone *tz)
 
 int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return security_ops->vm_enough_memory(current->mm, pages);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	WARN_ON(mm == NULL);
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
+int security_vm_enough_memory_kern(long pages)
+{
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
 int security_bprm_alloc(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_alloc_security(bprm);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 7e83131..62ebff5 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1160,13 +1160,15 @@ static long snd_mixart_BA0_read(struct snd_info_entry *entry, void *file_private
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos >= MIXART_BA0_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA0_SIZE)
-		count = (long)(MIXART_BA0_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_MEM( mgr, pos ), count))
+	maxsize = MIXART_BA0_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_MEM(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }
@@ -1179,13 +1181,15 @@ static long snd_mixart_BA1_read(struct snd_info_entry *entry, void *file_private
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos > MIXART_BA1_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA1_SIZE)
-		count = (long)(MIXART_BA1_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_REG( mgr, pos ), count))
+	maxsize = MIXART_BA1_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_REG(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }
