Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1DZJDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:03:07 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:44285 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1DZJDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:03:04 -0400
Date: Tue, 26 Apr 2011 11:03:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39-rc4
Message-ID: <20110426110300.6da0b684@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Carsten Otte (1):
      [S390] kvm-390: Let kernel exit SIE instruction on work

Heiko Carstens (1):
      [S390] pfault: fix token handling

Jan Glauber (3):
      [S390] prng: prevent access beyond end of stack
      [S390] fix page table walk for changing page attributes
      [S390] qdio: reset error states immediately

Stefan Weinhuber (2):
      [S390] dasd: fix race between open and offline
      [S390] dasd: check sense type in device change handler

 arch/s390/crypto/prng.c          |    2 +-
 arch/s390/kvm/sie64a.S           |    4 +-
 arch/s390/mm/fault.c             |    4 +-
 arch/s390/mm/pageattr.c          |    5 +-
 drivers/s390/block/dasd.c        |   40 +++++++-----
 drivers/s390/block/dasd_devmap.c |   30 +++++++++
 drivers/s390/block/dasd_eckd.c   |    5 +-
 drivers/s390/block/dasd_genhd.c  |    2 +-
 drivers/s390/block/dasd_int.h    |    3 +
 drivers/s390/block/dasd_ioctl.c  |  128 ++++++++++++++++++++++++++------------
 drivers/s390/cio/qdio_main.c     |   17 ++++--
 11 files changed, 166 insertions(+), 74 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 975e3ab..44bca3f 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -76,7 +76,7 @@ static void prng_seed(int nbytes)
 
 	/* Add the entropy */
 	while (nbytes >= 8) {
-		*((__u64 *)parm_block) ^= *((__u64 *)buf+i*8);
+		*((__u64 *)parm_block) ^= *((__u64 *)buf+i);
 		prng_add_entropy();
 		i += 8;
 		nbytes -= 8;
diff --git a/arch/s390/kvm/sie64a.S b/arch/s390/kvm/sie64a.S
index 7e9d30d..ab0e041 100644
--- a/arch/s390/kvm/sie64a.S
+++ b/arch/s390/kvm/sie64a.S
@@ -48,10 +48,10 @@ sie_irq_handler:
 	tm	__TI_flags+7(%r2),_TIF_EXIT_SIE
 	jz	0f
 	larl	%r2,sie_exit			# work pending, leave sie
-	stg	%r2,__LC_RETURN_PSW+8
+	stg	%r2,SPI_PSW+8(0,%r15)
 	br	%r14
 0:	larl	%r2,sie_reenter			# re-enter with guest id
-	stg	%r2,__LC_RETURN_PSW+8
+	stg	%r2,SPI_PSW+8(0,%r15)
 1:	br	%r14
 
 /*
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 9217e33..4cf85fe 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned int ext_int_code,
 	 * Get the token (= address of the task structure of the affected task).
 	 */
 #ifdef CONFIG_64BIT
-	tsk = *(struct task_struct **) param64;
+	tsk = (struct task_struct *) param64;
 #else
-	tsk = *(struct task_struct **) param32;
+	tsk = (struct task_struct *) param32;
 #endif
 
 	if (subcode & 0x0080) {
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 122ffbd..0607e4b 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -24,12 +24,13 @@ static void change_page_attr(unsigned long addr, int numpages,
 			WARN_ON_ONCE(1);
 			continue;
 		}
-		ptep = pte_offset_kernel(pmdp, addr + i * PAGE_SIZE);
+		ptep = pte_offset_kernel(pmdp, addr);
 
 		pte = *ptep;
 		pte = set(pte);
-		ptep_invalidate(&init_mm, addr + i * PAGE_SIZE, ptep);
+		ptep_invalidate(&init_mm, addr, ptep);
 		*ptep = pte;
+		addr += PAGE_SIZE;
 	}
 }
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 4d2df2f..475e603 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2314,15 +2314,14 @@ static void dasd_flush_request_queue(struct dasd_block *block)
 
 static int dasd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct dasd_block *block = bdev->bd_disk->private_data;
 	struct dasd_device *base;
 	int rc;
 
-	if (!block)
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
 		return -ENODEV;
 
-	base = block->base;
-	atomic_inc(&block->open_count);
+	atomic_inc(&base->block->open_count);
 	if (test_bit(DASD_FLAG_OFFLINE, &base->flags)) {
 		rc = -ENODEV;
 		goto unlock;
@@ -2355,21 +2354,28 @@ static int dasd_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
+	dasd_put_device(base);
 	return 0;
 
 out:
 	module_put(base->discipline->owner);
 unlock:
-	atomic_dec(&block->open_count);
+	atomic_dec(&base->block->open_count);
+	dasd_put_device(base);
 	return rc;
 }
 
 static int dasd_release(struct gendisk *disk, fmode_t mode)
 {
-	struct dasd_block *block = disk->private_data;
+	struct dasd_device *base;
 
-	atomic_dec(&block->open_count);
-	module_put(block->base->discipline->owner);
+	base = dasd_device_from_gendisk(disk);
+	if (!base)
+		return -ENODEV;
+
+	atomic_dec(&base->block->open_count);
+	module_put(base->discipline->owner);
+	dasd_put_device(base);
 	return 0;
 }
 
@@ -2378,20 +2384,20 @@ static int dasd_release(struct gendisk *disk, fmode_t mode)
  */
 static int dasd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	struct dasd_block *block;
 	struct dasd_device *base;
 
-	block = bdev->bd_disk->private_data;
-	if (!block)
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
 		return -ENODEV;
-	base = block->base;
 
 	if (!base->discipline ||
-	    !base->discipline->fill_geometry)
+	    !base->discipline->fill_geometry) {
+		dasd_put_device(base);
 		return -EINVAL;
-
-	base->discipline->fill_geometry(block, geo);
-	geo->start = get_start_sect(bdev) >> block->s2b_shift;
+	}
+	base->discipline->fill_geometry(base->block, geo);
+	geo->start = get_start_sect(bdev) >> base->block->s2b_shift;
+	dasd_put_device(base);
 	return 0;
 }
 
@@ -2528,7 +2534,6 @@ void dasd_generic_remove(struct ccw_device *cdev)
 	dasd_set_target_state(device, DASD_STATE_NEW);
 	/* dasd_delete_device destroys the device reference. */
 	block = device->block;
-	device->block = NULL;
 	dasd_delete_device(device);
 	/*
 	 * life cycle of block is bound to device, so delete it after
@@ -2650,7 +2655,6 @@ int dasd_generic_set_offline(struct ccw_device *cdev)
 	dasd_set_target_state(device, DASD_STATE_NEW);
 	/* dasd_delete_device destroys the device reference. */
 	block = device->block;
-	device->block = NULL;
 	dasd_delete_device(device);
 	/*
 	 * life cycle of block is bound to device, so delete it after
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 42e1bf3..d71511c 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -674,6 +674,36 @@ dasd_device_from_cdev(struct ccw_device *cdev)
 	return device;
 }
 
+void dasd_add_link_to_gendisk(struct gendisk *gdp, struct dasd_device *device)
+{
+	struct dasd_devmap *devmap;
+
+	devmap = dasd_find_busid(dev_name(&device->cdev->dev));
+	if (IS_ERR(devmap))
+		return;
+	spin_lock(&dasd_devmap_lock);
+	gdp->private_data = devmap;
+	spin_unlock(&dasd_devmap_lock);
+}
+
+struct dasd_device *dasd_device_from_gendisk(struct gendisk *gdp)
+{
+	struct dasd_device *device;
+	struct dasd_devmap *devmap;
+
+	if (!gdp->private_data)
+		return NULL;
+	device = NULL;
+	spin_lock(&dasd_devmap_lock);
+	devmap = gdp->private_data;
+	if (devmap && devmap->device) {
+		device = devmap->device;
+		dasd_get_device(device);
+	}
+	spin_unlock(&dasd_devmap_lock);
+	return device;
+}
+
 /*
  * SECTION: files in sysfs
  */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index db8005d..3ebdf5f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2037,7 +2037,7 @@ static void dasd_eckd_check_for_device_change(struct dasd_device *device,
 		return;
 
 	/* summary unit check */
-	if ((sense[7] == 0x0D) &&
+	if ((sense[27] & DASD_SENSE_BIT_0) && (sense[7] == 0x0D) &&
 	    (scsw_dstat(&irb->scsw) & DEV_STAT_UNIT_CHECK)) {
 		dasd_alias_handle_summary_unit_check(device, irb);
 		return;
@@ -2053,7 +2053,8 @@ static void dasd_eckd_check_for_device_change(struct dasd_device *device,
 	/* loss of device reservation is handled via base devices only
 	 * as alias devices may be used with several bases
 	 */
-	if (device->block && (sense[7] == 0x3F) &&
+	if (device->block && (sense[27] & DASD_SENSE_BIT_0) &&
+	    (sense[7] == 0x3F) &&
 	    (scsw_dstat(&irb->scsw) & DEV_STAT_UNIT_CHECK) &&
 	    test_bit(DASD_FLAG_IS_RESERVED, &device->flags)) {
 		if (device->features & DASD_FEATURE_FAILONSLCK)
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 5505bc0..19a1ff0 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -73,7 +73,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	if (base->features & DASD_FEATURE_READONLY ||
 	    test_bit(DASD_FLAG_DEVICE_RO, &base->flags))
 		set_disk_ro(gdp, 1);
-	gdp->private_data = block;
+	dasd_add_link_to_gendisk(gdp, base);
 	gdp->queue = block->request_queue;
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index df9f699..d1e4f2c 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -686,6 +686,9 @@ struct dasd_device *dasd_device_from_cdev(struct ccw_device *);
 struct dasd_device *dasd_device_from_cdev_locked(struct ccw_device *);
 struct dasd_device *dasd_device_from_devindex(int);
 
+void dasd_add_link_to_gendisk(struct gendisk *, struct dasd_device *);
+struct dasd_device *dasd_device_from_gendisk(struct gendisk *);
+
 int dasd_parse(void);
 int dasd_busid_known(const char *);
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 26075e9..72261e4 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -42,16 +42,22 @@ dasd_ioctl_api_version(void __user *argp)
 static int
 dasd_ioctl_enable(struct block_device *bdev)
 {
-	struct dasd_block *block = bdev->bd_disk->private_data;
+	struct dasd_device *base;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	dasd_enable_device(block->base);
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
+		return -ENODEV;
+
+	dasd_enable_device(base);
 	/* Formatting the dasd device can change the capacity. */
 	mutex_lock(&bdev->bd_mutex);
-	i_size_write(bdev->bd_inode, (loff_t)get_capacity(block->gdp) << 9);
+	i_size_write(bdev->bd_inode,
+		     (loff_t)get_capacity(base->block->gdp) << 9);
 	mutex_unlock(&bdev->bd_mutex);
+	dasd_put_device(base);
 	return 0;
 }
 
@@ -62,11 +68,14 @@ dasd_ioctl_enable(struct block_device *bdev)
 static int
 dasd_ioctl_disable(struct block_device *bdev)
 {
-	struct dasd_block *block = bdev->bd_disk->private_data;
+	struct dasd_device *base;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
+		return -ENODEV;
 	/*
 	 * Man this is sick. We don't do a real disable but only downgrade
 	 * the device to DASD_STATE_BASIC. The reason is that dasdfmt uses
@@ -75,7 +84,7 @@ dasd_ioctl_disable(struct block_device *bdev)
 	 * using the BIODASDFMT ioctl. Therefore the correct state for the
 	 * device is DASD_STATE_BASIC that allows to do basic i/o.
 	 */
-	dasd_set_target_state(block->base, DASD_STATE_BASIC);
+	dasd_set_target_state(base, DASD_STATE_BASIC);
 	/*
 	 * Set i_size to zero, since read, write, etc. check against this
 	 * value.
@@ -83,6 +92,7 @@ dasd_ioctl_disable(struct block_device *bdev)
 	mutex_lock(&bdev->bd_mutex);
 	i_size_write(bdev->bd_inode, 0);
 	mutex_unlock(&bdev->bd_mutex);
+	dasd_put_device(base);
 	return 0;
 }
 
@@ -191,26 +201,36 @@ static int dasd_format(struct dasd_block *block, struct format_data_t *fdata)
 static int
 dasd_ioctl_format(struct block_device *bdev, void __user *argp)
 {
-	struct dasd_block *block = bdev->bd_disk->private_data;
+	struct dasd_device *base;
 	struct format_data_t fdata;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (!argp)
 		return -EINVAL;
-
-	if (block->base->features & DASD_FEATURE_READONLY ||
-	    test_bit(DASD_FLAG_DEVICE_RO, &block->base->flags))
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
+		return -ENODEV;
+	if (base->features & DASD_FEATURE_READONLY ||
+	    test_bit(DASD_FLAG_DEVICE_RO, &base->flags)) {
+		dasd_put_device(base);
 		return -EROFS;
-	if (copy_from_user(&fdata, argp, sizeof(struct format_data_t)))
+	}
+	if (copy_from_user(&fdata, argp, sizeof(struct format_data_t))) {
+		dasd_put_device(base);
 		return -EFAULT;
+	}
 	if (bdev != bdev->bd_contains) {
 		pr_warning("%s: The specified DASD is a partition and cannot "
 			   "be formatted\n",
-			   dev_name(&block->base->cdev->dev));
+			   dev_name(&base->cdev->dev));
+		dasd_put_device(base);
 		return -EINVAL;
 	}
-	return dasd_format(block, &fdata);
+	rc = dasd_format(base->block, &fdata);
+	dasd_put_device(base);
+	return rc;
 }
 
 #ifdef CONFIG_DASD_PROFILE
@@ -340,8 +360,8 @@ static int dasd_ioctl_information(struct dasd_block *block,
 static int
 dasd_ioctl_set_ro(struct block_device *bdev, void __user *argp)
 {
-	struct dasd_block *block =  bdev->bd_disk->private_data;
-	int intval;
+	struct dasd_device *base;
+	int intval, rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -350,10 +370,17 @@ dasd_ioctl_set_ro(struct block_device *bdev, void __user *argp)
 		return -EINVAL;
 	if (get_user(intval, (int __user *)argp))
 		return -EFAULT;
-	if (!intval && test_bit(DASD_FLAG_DEVICE_RO, &block->base->flags))
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
+		return -ENODEV;
+	if (!intval && test_bit(DASD_FLAG_DEVICE_RO, &base->flags)) {
+		dasd_put_device(base);
 		return -EROFS;
+	}
 	set_disk_ro(bdev->bd_disk, intval);
-	return dasd_set_feature(block->base->cdev, DASD_FEATURE_READONLY, intval);
+	rc = dasd_set_feature(base->cdev, DASD_FEATURE_READONLY, intval);
+	dasd_put_device(base);
+	return rc;
 }
 
 static int dasd_ioctl_readall_cmb(struct dasd_block *block, unsigned int cmd,
@@ -372,59 +399,78 @@ static int dasd_ioctl_readall_cmb(struct dasd_block *block, unsigned int cmd,
 int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 	       unsigned int cmd, unsigned long arg)
 {
-	struct dasd_block *block = bdev->bd_disk->private_data;
+	struct dasd_block *block;
+	struct dasd_device *base;
 	void __user *argp;
+	int rc;
 
 	if (is_compat_task())
 		argp = compat_ptr(arg);
 	else
 		argp = (void __user *)arg;
 
-	if (!block)
-                return -ENODEV;
-
 	if ((_IOC_DIR(cmd) != _IOC_NONE) && !arg) {
 		PRINT_DEBUG("empty data ptr");
 		return -EINVAL;
 	}
 
+	base = dasd_device_from_gendisk(bdev->bd_disk);
+	if (!base)
+		return -ENODEV;
+	block = base->block;
+	rc = 0;
 	switch (cmd) {
 	case BIODASDDISABLE:
-		return dasd_ioctl_disable(bdev);
+		rc = dasd_ioctl_disable(bdev);
+		break;
 	case BIODASDENABLE:
-		return dasd_ioctl_enable(bdev);
+		rc = dasd_ioctl_enable(bdev);
+		break;
 	case BIODASDQUIESCE:
-		return dasd_ioctl_quiesce(block);
+		rc = dasd_ioctl_quiesce(block);
+		break;
 	case BIODASDRESUME:
-		return dasd_ioctl_resume(block);
+		rc = dasd_ioctl_resume(block);
+		break;
 	case BIODASDFMT:
-		return dasd_ioctl_format(bdev, argp);
+		rc = dasd_ioctl_format(bdev, argp);
+		break;
 	case BIODASDINFO:
-		return dasd_ioctl_information(block, cmd, argp);
+		rc = dasd_ioctl_information(block, cmd, argp);
+		break;
 	case BIODASDINFO2:
-		return dasd_ioctl_information(block, cmd, argp);
+		rc = dasd_ioctl_information(block, cmd, argp);
+		break;
 	case BIODASDPRRD:
-		return dasd_ioctl_read_profile(block, argp);
+		rc = dasd_ioctl_read_profile(block, argp);
+		break;
 	case BIODASDPRRST:
-		return dasd_ioctl_reset_profile(block);
+		rc = dasd_ioctl_reset_profile(block);
+		break;
 	case BLKROSET:
-		return dasd_ioctl_set_ro(bdev, argp);
+		rc = dasd_ioctl_set_ro(bdev, argp);
+		break;
 	case DASDAPIVER:
-		return dasd_ioctl_api_version(argp);
+		rc = dasd_ioctl_api_version(argp);
+		break;
 	case BIODASDCMFENABLE:
-		return enable_cmf(block->base->cdev);
+		rc = enable_cmf(base->cdev);
+		break;
 	case BIODASDCMFDISABLE:
-		return disable_cmf(block->base->cdev);
+		rc = disable_cmf(base->cdev);
+		break;
 	case BIODASDREADALLCMB:
-		return dasd_ioctl_readall_cmb(block, cmd, argp);
+		rc = dasd_ioctl_readall_cmb(block, cmd, argp);
+		break;
 	default:
 		/* if the discipline has an ioctl method try it. */
-		if (block->base->discipline->ioctl) {
-			int rval = block->base->discipline->ioctl(block, cmd, argp);
-			if (rval != -ENOIOCTLCMD)
-				return rval;
-		}
-
-		return -EINVAL;
+		if (base->discipline->ioctl) {
+			rc = base->discipline->ioctl(block, cmd, argp);
+			if (rc == -ENOIOCTLCMD)
+				rc = -EINVAL;
+		} else
+			rc = -EINVAL;
 	}
+	dasd_put_device(base);
+	return rc;
 }
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index c532ba9..e8f267e 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -407,8 +407,11 @@ static inline void account_sbals(struct qdio_q *q, int count)
 	q->q_stats.nr_sbals[pos]++;
 }
 
-static void announce_buffer_error(struct qdio_q *q, int count)
+static void process_buffer_error(struct qdio_q *q, int count)
 {
+	unsigned char state = (q->is_input_q) ? SLSB_P_INPUT_NOT_INIT :
+					SLSB_P_OUTPUT_NOT_INIT;
+
 	q->qdio_error |= QDIO_ERROR_SLSB_STATE;
 
 	/* special handling for no target buffer empty */
@@ -426,6 +429,12 @@ static void announce_buffer_error(struct qdio_q *q, int count)
 	DBF_ERROR("F14:%2x F15:%2x",
 		  q->sbal[q->first_to_check]->element[14].flags & 0xff,
 		  q->sbal[q->first_to_check]->element[15].flags & 0xff);
+
+	/*
+	 * Interrupts may be avoided as long as the error is present
+	 * so change the buffer state immediately to avoid starvation.
+	 */
+	set_buf_states(q, q->first_to_check, state, count);
 }
 
 static inline void inbound_primed(struct qdio_q *q, int count)
@@ -506,8 +515,7 @@ static int get_inbound_buffer_frontier(struct qdio_q *q)
 			account_sbals(q, count);
 		break;
 	case SLSB_P_INPUT_ERROR:
-		announce_buffer_error(q, count);
-		/* process the buffer, the upper layer will take care of it */
+		process_buffer_error(q, count);
 		q->first_to_check = add_buf(q->first_to_check, count);
 		atomic_sub(count, &q->nr_buf_used);
 		if (q->irq_ptr->perf_stat_enabled)
@@ -677,8 +685,7 @@ static int get_outbound_buffer_frontier(struct qdio_q *q)
 			account_sbals(q, count);
 		break;
 	case SLSB_P_OUTPUT_ERROR:
-		announce_buffer_error(q, count);
-		/* process the buffer, the upper layer will take care of it */
+		process_buffer_error(q, count);
 		q->first_to_check = add_buf(q->first_to_check, count);
 		atomic_sub(count, &q->nr_buf_used);
 		if (q->irq_ptr->perf_stat_enabled)
