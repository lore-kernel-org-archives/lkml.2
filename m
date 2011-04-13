Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab1DMV6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:58:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47037 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1DMV6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:58:17 -0400
Date: Wed, 13 Apr 2011 14:56:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Mark A. Allyn" <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
        jayant.mangalampalli@intel.com, venkat.r.gokulrangan@intel.com
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Message-Id: <20110413145607.3257c83b.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DA61C73.0004:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 14:29:35 -0700 (PDT) Mark A. Allyn wrote:

> Sorry, I had an incorrect return address config in alpine. . .
> 
> What else needs to be done to the sep driver in order for it to be moved 
> to the kernel from staging?


1.  It's usually better for loops like this to have some hw-independent escape,
like a timeout or iteration counter exit.

static inline void sep_wait_sram_write(struct sep_device *dev)
{
	u32 reg_val;
	do {
		reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
	} while (!(reg_val & 1));
}


2.  Update Documentation/ioctl/ioctl-number.txt based on sep_driver_api.h.


and apply the following cleanup patch (I have not looked at sep_driver.c yet).

---
From: Randy Dunlap <randy.dunlap@oracle.com>

sep_driver cleanups: fix some coding style & typos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/sep/Kconfig              |    2 -
 drivers/staging/sep/Makefile             |    1 
 drivers/staging/sep/TODO                 |    2 -
 drivers/staging/sep/sep_dev.h            |    3 --
 drivers/staging/sep/sep_driver_api.h     |   26 ++++++++-------------
 drivers/staging/sep/sep_driver_config.h  |   26 ++++++++-------------
 drivers/staging/sep/sep_driver_hw_defs.h |    1 
 7 files changed, 25 insertions(+), 36 deletions(-)

--- linux-next-20110413.orig/drivers/staging/sep/Kconfig
+++ linux-next-20110413/drivers/staging/sep/Kconfig
@@ -3,7 +3,7 @@ config DX_SEP
 	depends on PCI
 	help
 	  Discretix SEP driver; used for the security processor subsystem
-	  on bard the Intel Mobile Internet Device.
+	  on board the Intel Mobile Internet Device.
 
 	  The driver's name is sep_driver.
 
--- linux-next-20110413.orig/drivers/staging/sep/Makefile
+++ linux-next-20110413/drivers/staging/sep/Makefile
@@ -1,2 +1 @@
 obj-$(CONFIG_DX_SEP) := sep_driver.o
-
--- linux-next-20110413.orig/drivers/staging/sep/TODO
+++ linux-next-20110413/drivers/staging/sep/TODO
@@ -1,4 +1,4 @@
 Todo's so far (from Alan Cox)
 - Check whether it can be plugged into any of the kernel crypto API
   interfaces - Crypto API 'glue' is still not ready to submit
-- Clean up un-needed debug prints - Started to work on this
+- Clean up unneeded debug prints - Started to work on this
--- linux-next-20110413.orig/drivers/staging/sep/sep_dev.h
+++ linux-next-20110413/drivers/staging/sep/sep_dev.h
@@ -103,7 +103,6 @@ struct sep_device {
 	u32 nr_dcb_creat;
 
 	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
-
 };
 
 static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
@@ -118,7 +117,7 @@ static inline u32 sep_read_reg(struct se
 	return readl(addr);
 }
 
-/* wait for SRAM write complete(indirect write */
+/* wait for SRAM write complete (indirect write) */
 static inline void sep_wait_sram_write(struct sep_device *dev)
 {
 	u32 reg_val;
--- linux-next-20110413.orig/drivers/staging/sep/sep_driver_api.h
+++ linux-next-20110413/drivers/staging/sep/sep_driver_api.h
@@ -38,10 +38,6 @@
 #define SEP_DRIVER_SRC_PRINTF		3
 
 
-/*-------------------------------------------
-    TYPEDEFS
-----------------------------------------------*/
-
 struct alloc_struct {
 	/* offset from start of shared pool area */
 	u32  offset;
@@ -60,8 +56,8 @@ struct caller_id_struct {
 };
 
 /*
-  structure that represents DCB
-*/
+ * structure that represents DCB
+ */
 struct sep_dcblock {
 	/* physical address of the first input mlli */
 	u32	input_mlli_address;
@@ -89,8 +85,8 @@ struct sep_caller_id_entry {
 };
 
 /*
-	command structure for building dcb block (currently for ext app only
-*/
+ * command structure for building dcb block (currently for ext app only)
+ */
 struct build_dcb_struct {
 	/* address value of the data in */
 	aligned_u64 app_in_address;
@@ -106,13 +102,11 @@ struct build_dcb_struct {
 	u32  tail_block_size;
 };
 
-/**
+/*
  * @struct sep_dma_map
  *
  * Structure that contains all information needed for mapping the user pages
  *	     or kernel buffers for dma operations
- *
- *
  */
 struct sep_dma_map {
 	/* mapped dma address */
@@ -150,8 +144,10 @@ struct sep_dma_resource {
 };
 
 
-/* command struct for translating rar handle to bus address
-   and setting it at predefined location */
+/*
+ * command struct for translating rar handle to bus address
+ * and setting it at predefined location
+ */
 struct rar_hndl_to_bus_struct {
 
 	/* rar handle */
@@ -159,8 +155,8 @@ struct rar_hndl_to_bus_struct {
 };
 
 /*
-  structure that represent one entry in the DMA LLI table
-*/
+ * structure that represent one entry in the DMA LLI table
+ */
 struct sep_lli_entry {
 	/* physical address */
 	u32 bus_address;
--- linux-next-20110413.orig/drivers/staging/sep/sep_driver_config.h
+++ linux-next-20110413/drivers/staging/sep/sep_driver_config.h
@@ -33,9 +33,7 @@
 #define __SEP_DRIVER_CONFIG_H__
 
 
-/*--------------------------------------
-  DRIVER CONFIGURATION FLAGS
-  -------------------------------------*/
+/* DRIVER CONFIGURATION FLAGS */
 
 /* if flag is on , then the driver is running in polling and
 	not interrupt mode */
@@ -48,9 +46,7 @@
 /* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
 #define SEP_DRIVER_ARM_DEBUG_MODE                       0
 
-/*-------------------------------------------
-	INTERNAL DATA CONFIGURATION
-	-------------------------------------------*/
+/* INTERNAL DATA CONFIGURATION */
 
 /* flag for the input array */
 #define SEP_DRIVER_IN_FLAG                              0
@@ -64,11 +60,11 @@
 /* minimum data size of the MLLI table */
 #define SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE		16
 
-/* flag that signifies tah the lock is
+/* flag that signifies that the lock is
 currently held by the process (struct file) */
 #define SEP_DRIVER_OWN_LOCK_FLAG                        1
 
-/* flag that signifies tah the lock is currently NOT
+/* flag that signifies that the lock is currently NOT
 held by the process (struct file) */
 #define SEP_DRIVER_DISOWN_LOCK_FLAG                     0
 
@@ -109,9 +105,9 @@ held by the process (struct file) */
 
 
 /*
-	the maximum length of the message - the rest of the message shared
-	area will be dedicated to the dma lli tables
-*/
+ * the maximum length of the message - the rest of the message shared
+ *area will be dedicated to the dma lli tables
+ */
 #define SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES			(8 * 1024)
 
 /* the size of the message shared area in pages */
@@ -142,9 +138,9 @@ held by the process (struct file) */
 	DATA POOL areas. area must be module 4k */
 #define SEP_DRIVER_MMMAP_AREA_SIZE				(1024 * 28)
 
-/*-----------------------------------------------
-	offsets of the areas starting from the shared area start address
-*/
+/*
+ * offsets of the areas starting from the shared area start address
+ */
 
 /* message area offset */
 #define SEP_DRIVER_MESSAGE_AREA_OFFSET_IN_BYTES			0
@@ -205,7 +201,7 @@ held by the process (struct file) */
 /* size of the caller id hash (sha2) */
 #define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
 
-/* size of the caller id hash (sha2) in 32 bit words */
+/* size of the caller id hash (sha2) in 32-bit words */
 #define SEP_CALLER_ID_HASH_SIZE_IN_WORDS                8
 
 /* maximum number of entries in the caller id table */
--- linux-next-20110413.orig/drivers/staging/sep/sep_driver_hw_defs.h
+++ linux-next-20110413/drivers/staging/sep/sep_driver_hw_defs.h
@@ -37,7 +37,6 @@
 
 /*----------------------- */
 /* HW Registers Defines.  */
-/*                        */
 /*---------------------- -*/
 
 
