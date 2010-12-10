Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0LJBHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:07:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:5875 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab0LJBHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:07:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,322,1288594800"; 
   d="scan'208";a="359656467"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 01/11] sep: remove virtual address being passed to user space application
Date: Thu,  9 Dec 2010 17:14:15 -0800
Message-Id: <1291943655-26558-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c     |   23 +++++------------------
 drivers/staging/sep/sep_driver_api.h |   14 +-------------
 2 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index f2c216d..a5c0443 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2541,12 +2541,9 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
  *	This function sets the bus and virtual addresses of the static pool
  *	and returns the virtual address
  */
-static int sep_get_static_pool_addr_handler(struct sep_device *sep,
-	unsigned long arg)
+static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 {
-	struct stat_pool_addr_struct command_args;
 	u32 *static_pool_addr = NULL;
-	unsigned long addr_hold;
 
 	dev_dbg(&sep->pdev->dev, "sep_get_static_pool_addr_handler start\n");
 
@@ -2554,21 +2551,11 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep,
 		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
 
 	static_pool_addr[0] = SEP_STATIC_POOL_VAL_TOKEN;
-	static_pool_addr[1] = sep->shared_bus +
+	static_pool_addr[1] = (u32)sep->shared_bus +
 		SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
 
-	addr_hold = (unsigned long)
-		(sep->shared_addr + SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES);
-	command_args.static_virt_address = (aligned_u64)addr_hold;
-
-	dev_dbg(&sep->pdev->dev, "static pool: physical %x virtual %x\n",
-		(u32)static_pool_addr[1],
-		(u32)command_args.static_virt_address);
-
-	/* Send the parameters to user application */
-	if (copy_to_user((void __user *) arg, &command_args,
-		sizeof(struct stat_pool_addr_struct)))
-		return -EFAULT;
+	dev_dbg(&sep->pdev->dev, "static pool: physical %x\n",
+		(u32)static_pool_addr[1]);
 
 	dev_dbg(&sep->pdev->dev, "sep_get_static_pool_addr_handler end\n");
 
@@ -3064,7 +3051,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	case SEP_IOCGETSTATICPOOLADDR:
 		/* Get the physical and virtual addresses of the static pool */
-		error = sep_get_static_pool_addr_handler(sep, arg);
+		error = sep_get_static_pool_addr_handler(sep);
 		break;
 	case SEP_IOCENDTRANSACTION:
 		error = sep_end_transaction_handler(sep);
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 1207722..5508769 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -114,18 +114,6 @@ struct bld_syn_tab_struct {
 
 };
 
-/*
- * command struct for static pool addresses
- * Please note that this is a kernel virtual
- * address; this will be removed at the next
- * release of the Discretix middleware
- */
-struct stat_pool_addr_struct {
-	/* virtual address of the static pool */
-	aligned_u64 static_virt_address;
-};
-
-
 /* command struct for getting caller id value and address */
 struct caller_id_struct {
 	/* pid of the process */
@@ -275,7 +263,7 @@ struct sep_lli_entry {
 
 /* set the static pool area address and give to SEP (internal to driver) */
 #define SEP_IOCGETSTATICPOOLADDR	\
-	_IOR(SEP_IOC_MAGIC_NUMBER, 8, struct stat_pool_addr_struct)
+	_IO(SEP_IOC_MAGIC_NUMBER, 8)
 
 /* start sep command */
 #define SEP_IOCSEPSTART	 \
-- 
1.6.3.3

