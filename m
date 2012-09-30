Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab2I3Xdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:33:47 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37003 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2I3Xdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:33:46 -0400
Date: Sun, 30 Sep 2012 17:33:45 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20120930233345.GJ30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to use the TPM is really a user space policy choice, if the
environment wants to use middleware then fine, but it is possible to
make correct TPM apps without using middleware.

So, remove the kernel restriction that only one process may open the TPM.
- TPM low level functions (in kernel users) are already locked proprely
  and can run in parallel with the user space interface anyhow.
- Move the user space data buffer and related goop into a
  struct tpm_file, create one struct tpm_file per open file.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |   97 +++++++++++++++++++++---------------------------
 drivers/char/tpm/tpm.h |   23 ++++++-----
 2 files changed, 55 insertions(+), 65 deletions(-)

This is rebase, retest, resend of a patch I sent two years ago. The
discussion on that earlier patch fizzled out. Resending incase there
is renewed interest :)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 60e8442..a161be9 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -33,7 +33,6 @@
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
 };
 
@@ -333,19 +332,19 @@ static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
 
 static void user_reader_timeout(unsigned long ptr)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+	struct tpm_file *fl = (struct tpm_file *) ptr;
 
-	schedule_work(&chip->work);
+	schedule_work(&fl->work);
 }
 
 static void timeout_work(struct work_struct *work)
 {
-	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
+	struct tpm_file *fl = container_of(work, struct tpm_file, work);
 
-	mutex_lock(&chip->buffer_mutex);
-	atomic_set(&chip->data_pending, 0);
-	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	mutex_unlock(&chip->buffer_mutex);
+	mutex_lock(&fl->buffer_mutex);
+	atomic_set(&fl->data_pending, 0);
+	memset(fl->data_bufferx, 0, sizeof(fl->data_bufferx));
+	mutex_unlock(&fl->buffer_mutex);
 }
 
 /*
@@ -384,9 +383,6 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz > TPM_BUFSIZE)
-		bufsiz = TPM_BUFSIZE;
-
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
@@ -1161,6 +1157,7 @@ int tpm_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
+	struct tpm_file *fl;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
@@ -1175,22 +1172,19 @@ int tpm_open(struct inode *inode, struct file *file)
 	if (!chip)
 		return -ENODEV;
 
-	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		put_device(chip->dev);
-		return -EBUSY;
-	}
-
-	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
-	if (chip->data_buffer == NULL) {
-		clear_bit(0, &chip->is_open);
+	fl = kzalloc(sizeof(*fl), GFP_KERNEL);
+	if (fl == NULL) {
 		put_device(chip->dev);
 		return -ENOMEM;
 	}
 
-	atomic_set(&chip->data_pending, 0);
+	fl->chip = chip;
+	mutex_init(&fl->buffer_mutex);
+	setup_timer(&fl->user_read_timer, user_reader_timeout,
+			(unsigned long)fl);
+	INIT_WORK(&fl->work, timeout_work);
 
-	file->private_data = chip;
+	file->private_data = fl;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
@@ -1200,14 +1194,14 @@ EXPORT_SYMBOL_GPL(tpm_open);
  */
 int tpm_release(struct inode *inode, struct file *file)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
+	struct tpm_chip *chip = fl->chip;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work_sync(&chip->work);
+	del_singleshot_timer_sync(&fl->user_read_timer);
+	flush_work_sync(&fl->work);
+	mutex_destroy(&fl->buffer_mutex);
+	kfree(file->private_data);
 	file->private_data = NULL;
-	atomic_set(&chip->data_pending, 0);
-	kfree(chip->data_buffer);
-	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	return 0;
 }
@@ -1216,33 +1210,33 @@ EXPORT_SYMBOL_GPL(tpm_release);
 ssize_t tpm_write(struct file *file, const char __user *buf,
 		  size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
 	size_t in_size = size, out_size;
 
 	/* cannot perform a write until the read has cleared
 	   either via tpm_read or a user_read_timer timeout */
-	while (atomic_read(&chip->data_pending) != 0)
+	while (atomic_read(&fl->data_pending) != 0)
 		msleep(TPM_TIMEOUT);
 
-	mutex_lock(&chip->buffer_mutex);
+	mutex_lock(&fl->buffer_mutex);
 
-	if (in_size > TPM_BUFSIZE)
-		in_size = TPM_BUFSIZE;
+	in_size = min(sizeof(fl->data_bufferx), in_size);
 
 	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		mutex_unlock(&chip->buffer_mutex);
+	    (fl->data_bufferx, (void __user *) buf, in_size)) {
+		mutex_unlock(&fl->buffer_mutex);
 		return -EFAULT;
 	}
 
 	/* atomic tpm command send and result receive */
-	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	out_size = tpm_transmit(fl->chip, fl->data_bufferx,
+				sizeof(fl->data_bufferx));
 
-	atomic_set(&chip->data_pending, out_size);
-	mutex_unlock(&chip->buffer_mutex);
+	atomic_set(&fl->data_pending, out_size);
+	mutex_unlock(&fl->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
+	mod_timer(&fl->user_read_timer, jiffies + (60 * HZ));
 
 	return in_size;
 }
@@ -1251,26 +1245,25 @@ EXPORT_SYMBOL_GPL(tpm_write);
 ssize_t tpm_read(struct file *file, char __user *buf,
 		 size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct tpm_file *fl = file->private_data;
 	ssize_t ret_size;
 	int rc;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work_sync(&chip->work);
-	ret_size = atomic_read(&chip->data_pending);
-	atomic_set(&chip->data_pending, 0);
+	del_singleshot_timer_sync(&fl->user_read_timer);
+	flush_work_sync(&fl->work);
+	ret_size = atomic_read(&fl->data_pending);
+	atomic_set(&fl->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
 		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
-		mutex_lock(&chip->buffer_mutex);
-		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, orig_ret_size);
+		mutex_lock(&fl->buffer_mutex);
+		rc = copy_to_user(buf, fl->data_bufferx, ret_size);
+		memset(fl->data_bufferx, 0, orig_ret_size);
 		if (rc)
 			ret_size = -EFAULT;
-
-		mutex_unlock(&chip->buffer_mutex);
+		mutex_unlock(&fl->buffer_mutex);
 	}
 
 	return ret_size;
@@ -1413,15 +1406,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (chip == NULL || devname == NULL)
 		goto out_free;
 
-	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	INIT_WORK(&chip->work, timeout_work);
-
-	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
-
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2d583ef..58bde7c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -106,16 +106,6 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
-	unsigned long is_open;	/* only one allowed */
-	int time_expired;
-
-	/* Data passed to and from the tpm via the read/write calls */
-	u8 *data_buffer;
-	atomic_t data_pending;
-	struct mutex buffer_mutex;
-
-	struct timer_list user_read_timer;	/* user needs to claim result */
-	struct work_struct work;
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	struct tpm_vendor_specific vendor;
@@ -132,6 +122,19 @@ static inline void tpm_chip_put(struct tpm_chip *chip)
 {
 	module_put(chip->dev->driver->owner);
 }
+/* Private data structure for struct file */
+struct tpm_file {
+	struct tpm_chip *chip;
+
+	/* Data passed to and from the tpm via the read/write calls */
+	atomic_t data_pending;
+	struct mutex buffer_mutex;
+
+	struct timer_list user_read_timer;	/* user needs to claim result */
+	struct work_struct work;
+
+	u8 data_bufferx[2048];
+};
 
 static inline int tpm_read_index(int base, int index)
 {
-- 
1.7.4.1

