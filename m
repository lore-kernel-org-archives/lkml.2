Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1DYUYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34282 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab1DYUYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:44 -0400
Message-Id: <20110425200237.338334544@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 100/173] powerpc: rtas_flash needs to use rtas_data_buf
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milton Miller <miltonm@us.ibm.com>

commit bd2b64a12bf55bec0d1b949e3dca3f8863409646 upstream.

When trying to flash a machine via the update_flash command, Anton received the
following error:

    Restarting system.
    FLASH: kernel bug...flash list header addr above 4GB

The code in question has a comment that the flash list should be in
the kernel data and therefore under 4GB:

        /* NOTE: the "first" block list is a global var with no data
         * blocks in the kernel data segment.  We do this because
         * we want to ensure this block_list addr is under 4GB.
         */

Unfortunately the Kconfig option is marked tristate which means the variable
may not be in the kernel data and could be above 4GB.

Instead of relying on the data segment being below 4GB, use the static
data buffer allocated by the kernel for use by rtas.  Since we don't
use the header struct directly anymore, convert it to a simple pointer.

Reported-By: Anton Blanchard <anton@samba.org>
Signed-Off-By: Milton Miller <miltonm@bga.com>
Tested-By: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/rtas_flash.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -93,12 +93,8 @@ struct flash_block_list {
 	struct flash_block_list *next;
 	struct flash_block blocks[FLASH_BLOCKS_PER_NODE];
 };
-struct flash_block_list_header { /* just the header of flash_block_list */
-	unsigned long num_blocks;
-	struct flash_block_list *next;
-};
 
-static struct flash_block_list_header rtas_firmware_flash_list = {0, NULL};
+static struct flash_block_list *rtas_firmware_flash_list;
 
 /* Use slab cache to guarantee 4k alignment */
 static struct kmem_cache *flash_block_cache = NULL;
@@ -107,13 +103,14 @@ static struct kmem_cache *flash_block_ca
 
 /* Local copy of the flash block list.
  * We only allow one open of the flash proc file and create this
- * list as we go.  This list will be put in the
- * rtas_firmware_flash_list var once it is fully read.
+ * list as we go.  The rtas_firmware_flash_list varable will be
+ * set once the data is fully read.
  *
  * For convenience as we build the list we use virtual addrs,
  * we do not fill in the version number, and the length field
  * is treated as the number of entries currently in the block
- * (i.e. not a byte count).  This is all fixed on release.
+ * (i.e. not a byte count).  This is all fixed when calling
+ * the flash routine.
  */
 
 /* Status int must be first member of struct */
@@ -200,16 +197,16 @@ static int rtas_flash_release(struct ino
 	if (uf->flist) {    
 		/* File was opened in write mode for a new flash attempt */
 		/* Clear saved list */
-		if (rtas_firmware_flash_list.next) {
-			free_flash_list(rtas_firmware_flash_list.next);
-			rtas_firmware_flash_list.next = NULL;
+		if (rtas_firmware_flash_list) {
+			free_flash_list(rtas_firmware_flash_list);
+			rtas_firmware_flash_list = NULL;
 		}
 
 		if (uf->status != FLASH_AUTH)  
 			uf->status = flash_list_valid(uf->flist);
 
 		if (uf->status == FLASH_IMG_READY) 
-			rtas_firmware_flash_list.next = uf->flist;
+			rtas_firmware_flash_list = uf->flist;
 		else
 			free_flash_list(uf->flist);
 
@@ -592,7 +589,7 @@ static void rtas_flash_firmware(int rebo
 	unsigned long rtas_block_list;
 	int i, status, update_token;
 
-	if (rtas_firmware_flash_list.next == NULL)
+	if (rtas_firmware_flash_list == NULL)
 		return;		/* nothing to do */
 
 	if (reboot_type != SYS_RESTART) {
@@ -609,20 +606,25 @@ static void rtas_flash_firmware(int rebo
 		return;
 	}
 
-	/* NOTE: the "first" block list is a global var with no data
-	 * blocks in the kernel data segment.  We do this because
-	 * we want to ensure this block_list addr is under 4GB.
+	/*
+	 * NOTE: the "first" block must be under 4GB, so we create
+	 * an entry with no data blocks in the reserved buffer in
+	 * the kernel data segment.
 	 */
-	rtas_firmware_flash_list.num_blocks = 0;
-	flist = (struct flash_block_list *)&rtas_firmware_flash_list;
+	spin_lock(&rtas_data_buf_lock);
+	flist = (struct flash_block_list *)&rtas_data_buf[0];
+	flist->num_blocks = 0;
+	flist->next = rtas_firmware_flash_list;
 	rtas_block_list = virt_to_abs(flist);
 	if (rtas_block_list >= 4UL*1024*1024*1024) {
 		printk(KERN_ALERT "FLASH: kernel bug...flash list header addr above 4GB\n");
+		spin_unlock(&rtas_data_buf_lock);
 		return;
 	}
 
 	printk(KERN_ALERT "FLASH: preparing saved firmware image for flash\n");
 	/* Update the block_list in place. */
+	rtas_firmware_flash_list = NULL; /* too hard to backout on error */
 	image_size = 0;
 	for (f = flist; f; f = next) {
 		/* Translate data addrs to absolute */
@@ -663,6 +665,7 @@ static void rtas_flash_firmware(int rebo
 		printk(KERN_ALERT "FLASH: unknown flash return code %d\n", status);
 		break;
 	}
+	spin_unlock(&rtas_data_buf_lock);
 }
 
 static void remove_flash_pde(struct proc_dir_entry *dp)


