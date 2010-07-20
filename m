Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0GTAYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:24:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61123 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0GTAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:24:15 -0400
Date: Mon, 19 Jul 2010 17:23:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Scott Smedley <ss@aao.gov.au>,
        gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andrew Lunn <andrew@lunn.ch>, b.a.t.m.a.n@lists.open-mesh.net
Subject: [PATCH -next] staging: don't use default init_module/cleanup_module
 function names
Message-Id: <20100719172310.87625ce4.randy.dunlap@oracle.com>
In-Reply-To: <20100719133841.babc9ccb.sfr@canb.auug.org.au>
References: <20100719133841.babc9ccb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C44EC93.00FF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fromy: Randy Dunlap <randy.dunlap@oracle.com>

Fix two staging drivers to use module_init()/module_exit()
instead of default init_module() and cleanup_module() function names
so that there are no name conflicts when both are built-in.

drivers/staging/dt3155/built-in.o: In function `cleanup_module':
(.text+0xc0): multiple definition of `cleanup_module'
drivers/staging/batman-adv/built-in.o:(.text+0x330): first defined here
drivers/staging/dt3155/built-in.o: In function `init_module':
(.text+0xe60): multiple definition of `init_module'
drivers/staging/batman-adv/built-in.o:(.text+0x400): first defined here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Scott Smedley <ss@aao.gov.au>
Cc: Marek  Lindner  <lindner_marek@yahoo.de>
Cc: Simon  Wunderlich  <siwu@hrz.tu-chemnitz.de>
Cc:	Andrew Lunn <andrew@lunn.ch>
Cc:	b.a.t.m.a.n@lists.open-mesh.net
Cc:	Greg Kroah-Hartman <gregkh@suse.de
---
 drivers/staging/batman-adv/main.c   |    7 +++++--
 drivers/staging/dt3155/dt3155_drv.c |   23 ++++++++++-------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- linux-next-20100719.orig/drivers/staging/batman-adv/main.c
+++ linux-next-20100719/drivers/staging/batman-adv/main.c
@@ -59,7 +59,7 @@ static struct packet_type batman_adv_pac
 
 struct workqueue_struct *bat_event_workqueue;
 
-int init_module(void)
+int batman_init(void)
 {
 	int retval;
 
@@ -131,7 +131,7 @@ end:
 	return -ENOMEM;
 }
 
-void cleanup_module(void)
+void batman_exit(void)
 {
 	deactivate_module();
 
@@ -273,6 +273,9 @@ int is_mcast(uint8_t *addr)
 	return *addr & 0x01;
 }
 
+module_init(batman_init);
+module_exit(batman_exit);
+
 MODULE_LICENSE("GPL");
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
--- linux-next-20100719.orig/drivers/staging/dt3155/dt3155_drv.c
+++ linux-next-20100719/drivers/staging/dt3155/dt3155_drv.c
@@ -47,7 +47,7 @@ MA 02111-1307 USA
  + might want to get rid of MAXboards for allocating initial buffer.
     confusing and not necessary
 
- + in cleanup_module the MOD_IN_USE looks like it is check after it should
+ + in dt3155_exit the MOD_IN_USE looks like it is check after it should
 
  * GFP_DMA should not be set with a PCI system (pg 291)
 
@@ -166,7 +166,7 @@ static void quick_stop (int minor)
  *
  * - looks like this isr supports IRQ sharing (or could) JML
  * - Assumes irq's are disabled, via SA_INTERRUPT flag
- * being set in request_irq() call from init_module()
+ * being set in request_irq() call from dt3155_init()
  *****************************************************/
 static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
@@ -836,7 +836,7 @@ dt3155_unlocked_ioctl(struct file *file,
 
 /*****************************************************
  * file operations supported by DT3155 driver
- *  needed by init_module
+ *  needed by dt3155_init
  *  register_chrdev
  *****************************************************/
 static struct file_operations dt3155_fops = {
@@ -937,10 +937,8 @@ err:
 
 u32 allocatorAddr = 0;
 
-/*****************************************************
- * init_module()
- *****************************************************/
-int init_module(void)
+
+int dt3155_init(void)
 {
   struct dt3155_status *dts;
   int index;
@@ -1059,16 +1057,13 @@ int init_module(void)
   return 0;
 }
 
-/*****************************************************
- * cleanup_module(void)
- *
- *****************************************************/
-void cleanup_module(void)
+
+void dt3155_exit(void)
 {
   struct dt3155_status *dts;
   int index;
 
-  printk("DT3155:  cleanup_module called\n");
+  printk("DT3155:  dt3155_exit called\n");
 
   /* removed DMA allocated with the allocator */
 #ifdef STANDALONE_ALLOCATOR
@@ -1092,3 +1087,5 @@ void cleanup_module(void)
     }
 }
 
+module_init(dt3155_init);
+module_exit(dt3155_exit);
