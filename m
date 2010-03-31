Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0CaFXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:23:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:36905 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0CaFXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:23:02 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIt5skurR7Ht/2dsb2JhbACbKHGmTpkThQAEgyA
X-IronPort-AV: E=Sophos;i="4.51,339,1267401600"; 
   d="scan'208";a="505832657"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
References: <201003242240.54907.arnd@arndb.de>
	<adavdclz8sc.fsf@roland-alpha.cisco.com>
	<201003242259.58535.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Mar 2010 22:22:57 -0700
In-Reply-To: <201003242259.58535.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 24 Mar 2010 22:59:57 +0100")
Message-ID: <adapr2lt68e.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I added the following to my tree, currently queued in my for-next
branch for 2.6.35:


IB: Explicitly rule out llseek to avoid BKL in default_llseek()

Several RDMA user-access drivers have file_operations structures with
no .llseek method set.  None of the drivers actually do anything with
f_pos, so this means llseek is essentially a NOP, instead of returning
an error as leaving other file_operations methods unimplemented would
do.  This is mostly harmless, except that a NULL .llseek means that
default_llseek() is used, and this function grabs the BKL, which we
would like to avoid.

Since llseek does nothing useful on these files, we would like it to
return an error to userspace instead of silently grabbing the BKL and
succeeding.  For nearly all of the file types, we take the
belt-and-suspenders approach of setting the .llseek method to
no_llseek and also calling nonseekable_open(); the exception is the
uverbs_event files, which are created with anon_inode_getfile(), which
already sets f_mode the same way as nonseekable_open() would.

This work is motivated by Arnd Bergmann's bkl-removal tree.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/core/ucm.c         |    3 ++-
 drivers/infiniband/core/ucma.c        |    4 +++-
 drivers/infiniband/core/user_mad.c    |   12 ++++++++----
 drivers/infiniband/core/uverbs_main.c |   11 +++++++----
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 017d6e2..7ef3954 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1180,7 +1180,7 @@ static int ib_ucm_open(struct inode *inode, struct file *filp)
 	file->filp = filp;
 	file->device = container_of(inode->i_cdev, struct ib_ucm_device, cdev);
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 static int ib_ucm_close(struct inode *inode, struct file *filp)
@@ -1228,6 +1228,7 @@ static const struct file_operations ucm_fops = {
 	.release = ib_ucm_close,
 	.write	 = ib_ucm_write,
 	.poll    = ib_ucm_poll,
+	.llseek	 = no_llseek,
 };
 
 static ssize_t show_ibdev(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b2e16c3..09d4a3b 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1219,7 +1219,8 @@ static int ucma_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = file;
 	file->filp = filp;
-	return 0;
+
+	return nonseekable_open(inode, filp);
 }
 
 static int ucma_close(struct inode *inode, struct file *filp)
@@ -1249,6 +1250,7 @@ static const struct file_operations ucma_fops = {
 	.release = ucma_close,
 	.write	 = ucma_write,
 	.poll    = ucma_poll,
+	.llseek	 = no_llseek,
 };
 
 static struct miscdevice ucma_misc = {
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 04b585e..2bb9703 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -780,7 +780,7 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 {
 	struct ib_umad_port *port;
 	struct ib_umad_file *file;
-	int ret = 0;
+	int ret;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
 	if (port)
@@ -813,6 +813,8 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 
 	list_add_tail(&file->port_list, &port->file_list);
 
+	ret = nonseekable_open(inode, filp);
+
 out:
 	mutex_unlock(&port->file_mutex);
 	return ret;
@@ -865,7 +867,8 @@ static const struct file_operations umad_fops = {
 	.compat_ioctl	= ib_umad_compat_ioctl,
 #endif
 	.open		= ib_umad_open,
-	.release	= ib_umad_close
+	.release	= ib_umad_close,
+	.llseek		= no_llseek,
 };
 
 static int ib_umad_sm_open(struct inode *inode, struct file *filp)
@@ -902,7 +905,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = port;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 
 fail:
 	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
@@ -932,7 +935,8 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 static const struct file_operations umad_sm_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = ib_umad_sm_open,
-	.release = ib_umad_sm_close
+	.release = ib_umad_sm_close,
+	.llseek	 = no_llseek,
 };
 
 static struct ib_client umad_client = {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 1444f95..a16a91e 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -385,7 +385,8 @@ static const struct file_operations uverbs_event_fops = {
 	.read	 = ib_uverbs_event_read,
 	.poll    = ib_uverbs_event_poll,
 	.release = ib_uverbs_event_close,
-	.fasync  = ib_uverbs_event_fasync
+	.fasync  = ib_uverbs_event_fasync,
+	.llseek	 = no_llseek,
 };
 
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
@@ -639,7 +640,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = file;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 
 err_module:
 	module_put(dev->ib_dev->owner);
@@ -667,7 +668,8 @@ static const struct file_operations uverbs_fops = {
 	.owner	 = THIS_MODULE,
 	.write	 = ib_uverbs_write,
 	.open	 = ib_uverbs_open,
-	.release = ib_uverbs_close
+	.release = ib_uverbs_close,
+	.llseek	 = no_llseek,
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -675,7 +677,8 @@ static const struct file_operations uverbs_mmap_fops = {
 	.write	 = ib_uverbs_write,
 	.mmap    = ib_uverbs_mmap,
 	.open	 = ib_uverbs_open,
-	.release = ib_uverbs_close
+	.release = ib_uverbs_close,
+	.llseek	 = no_llseek,
 };
 
 static struct ib_client uverbs_client = {
-- 
1.7.0.3


-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
