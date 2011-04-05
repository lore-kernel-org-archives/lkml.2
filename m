Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1DERJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:09:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:40760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab1DERJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,305,1299484800"; 
   d="scan'208";a="905875525"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, eugene.epshteyn@intel.com
Subject: [PATCH 1/1] staging: sep: remove dependency on memrar driver
Date: Tue,  5 Apr 2011 10:09:53 -0700
Message-Id: <1302023393-28057-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |   59 +------------------------------------
 1 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 71a5fbc..ad29cd5 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -55,8 +55,6 @@
 #include <linux/jiffies.h>
 #include <linux/rar_register.h>
 
-#include "../memrar/memrar.h"
-
 #include "sep_driver_hw_defs.h"
 #include "sep_driver_config.h"
 #include "sep_driver_api.h"
@@ -1097,6 +1095,8 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	if (num_pages > 1) {
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
+		if (lli_array[num_pages - 1].block_size == 0)
+			lli_array[num_pages - 1].block_size = PAGE_SIZE;
 
 		dev_warn(&sep->pdev->dev,
 			"lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
@@ -2359,58 +2359,6 @@ static int sep_free_dcb_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_rar_prepare_output_msg_handler - prepare an output message
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to user parameters
- *
- *	This function will retrieve the RAR buffer physical addresses, type
- *	& size corresponding to the RAR handles provided in the buffers vector.
- */
-static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
-	unsigned long arg)
-{
-	int error = 0;
-	/* Command args */
-	struct rar_hndl_to_bus_struct command_args;
-	struct RAR_buffer rar_buf;
-	/* Bus address */
-	dma_addr_t  rar_bus = 0;
-	/* Holds the RAR address in the system memory offset */
-	u32 *rar_addr;
-
-	/* Copy the data */
-	if (copy_from_user(&command_args, (void __user *)arg,
-						sizeof(command_args))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Call to translation function only if user handle is not NULL */
-	if (command_args.rar_handle) {
-		memset(&rar_buf, 0, sizeof(rar_buf));
-		rar_buf.info.handle = (u32)command_args.rar_handle;
-
-		if (rar_handle_to_bus(&rar_buf, 1) != 1) {
-			error = -EFAULT;
-			goto end_function;
-		}
-		rar_bus = rar_buf.bus_address;
-	}
-	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
-
-	/* Set value in the SYSTEM MEMORY offset */
-	rar_addr = (u32 *)(sep->shared_addr +
-		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
-
-	/* Copy the physical address to the System Area for the SEP */
-	rar_addr[0] = SEP_RAR_VAL_TOKEN;
-	rar_addr[1] = rar_bus;
-
-end_function:
-	return error;
-}
-
-/**
  *	sep_ioctl - ioctl api
  *	@filp: pointer to struct file
  *	@cmd: command
@@ -2456,9 +2404,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case SEP_IOCENDTRANSACTION:
 		error = sep_end_transaction_handler(sep);
 		break;
-	case SEP_IOCRARPREPAREMESSAGE:
-		error = sep_rar_prepare_output_msg_handler(sep, arg);
-		break;
 	case SEP_IOCPREPAREDCB:
 		error = sep_prepare_dcb_handler(sep, arg);
 		break;
-- 
1.7.0.4

