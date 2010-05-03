Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0ECSCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:02:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1832 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab0ECSCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:02:46 -0400
Subject: Re: [PATCH -next] staging: fix cxt1e1 module names
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, support@sbei.com,
       support@onestopsystems.com
In-Reply-To: <20100503100902.517c146f.randy.dunlap@oracle.com>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
	 <20100503100902.517c146f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 11:02:44 -0700
Message-ID: <1272909764.30040.92.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 10:09 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Lots of cxt1e1 source code uses THIS_MODULE->name, which won't build
> when CONFIG_MODULES is not enabled, so use KBUILD_MODNAME instead.

Perhaps a conversion to pr_<level> is better?

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/cxt1e1/functions.c           |    4 ++-
 drivers/staging/cxt1e1/hwprobe.c             |   28 ++++++++++---------
 drivers/staging/cxt1e1/linux.c               |   38 +++++++++++++-------------
 drivers/staging/cxt1e1/musycc.c              |   13 +++++----
 drivers/staging/cxt1e1/pmcc4_drv.c           |   16 ++++++-----
 drivers/staging/cxt1e1/sbecom_inline_linux.h |    2 +-
 drivers/staging/cxt1e1/sbeproc.c             |    8 +++---
 7 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index c95c62d..738129d 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -11,6 +11,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
@@ -117,7 +119,7 @@ watchdog_func (unsigned long arg)
     if (drvr_state != SBE_DRVR_AVAILABLE)
     {
         if (log_level >= LOG_MONITOR)
-            printk (KERN_WARNING "watchdog_func: drvr not available (%x)\n", drvr_state);
+            pr_warning("%s: drvr not available (%x)\n", __func__, drvr_state);
         return;
     }
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 0f9d653..571fa1f 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -12,6 +12,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/netdevice.h>
 #include <linux/hdlc.h>
 #include <linux/if_arp.h>
@@ -230,7 +232,7 @@ c4_hdw_init (struct pci_dev * pdev, int found)
     /* our MUSYCC chip supports two functions, 0 & 1 */
     if ((fun = PCI_FUNC (pdev->devfn)) > 1)
     {
-        printk (KERN_WARNING "%s: unexpected devfun: 0x%x\n", THIS_MODULE->name, pdev->devfn);
+        pr_warning("unexpected devfun: 0x%x\n", pdev->devfn);
         return 0;
     }
     if (pdev->bus)                  /* obtain bus number */
@@ -259,8 +261,7 @@ c4_hdw_init (struct pci_dev * pdev, int found)
     if (i == MAX_BOARDS)            /* no match in above loop means MAX
                                      * exceeded */
     {
-        printk (KERN_WARNING "%s: exceeded number of allowed devices (>%d)?\n",
-                THIS_MODULE->name, MAX_BOARDS);
+        pr_warning("exceeded number of allowed devices (>%d)?\n", MAX_BOARDS);
         return 0;
     }
     if (pdev->bus)
@@ -319,7 +320,7 @@ c4hw_attach_all (void)
     }
     if (!found)
     {
-        printk (KERN_WARNING "%s: No boards found.\n", THIS_MODULE->name);
+        pr_warning("No boards found\n");
         return ENODEV;
     }
     /* sanity check for consistant hardware found */
@@ -327,7 +328,8 @@ c4hw_attach_all (void)
     {
         if (hi->pci_slot != 0xff && (!hi->addr[0] || !hi->addr[1]))
         {
-            printk (KERN_WARNING "%s: something very wrong with pci_get_device.\n", hi->devname);
+            pr_warning("%s: something very wrong with pci_get_device\n",
+                       hi->devname);
             return EIO;
         }
     }
@@ -340,22 +342,22 @@ c4hw_attach_all (void)
         {
             if (request_mem_region (hi->addr[j], hi->len[j], hi->devname) == 0)
             {
-                printk (KERN_WARNING "%s: memory in use, addr=0x%lx, len=0x%lx ?\n",
-                        hi->devname, hi->addr[j], hi->len[j]);
+                pr_warning("%s: memory in use, addr=0x%lx, len=0x%lx ?\n",
+                           hi->devname, hi->addr[j], hi->len[j]);
                 cleanup_ioremap ();
                 return ENOMEM;
             }
             hi->addr_mapped[j] = (unsigned long) ioremap (hi->addr[j], hi->len[j]);
             if (!hi->addr_mapped[j])
             {
-                printk (KERN_WARNING "%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
-                        hi->devname, hi->addr[j], hi->len[j]);
+                pr_warning("%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
+                           hi->devname, hi->addr[j], hi->len[j]);
                 cleanup_ioremap ();
                 return ENOMEM;
             }
 #ifdef SBE_MAP_DEBUG
-            printk (KERN_WARNING "%s: io remapped from phys %x to virt %x\n",
-                    hi->devname, (u_int32_t) hi->addr[j], (u_int32_t) hi->addr_mapped[j]);
+            pr_warning("%s: io remapped from phys %x to virt %x\n",
+                       hi->devname, (u_int32_t) hi->addr[j], (u_int32_t) hi->addr_mapped[j]);
 #endif
         }
     }
@@ -371,8 +373,8 @@ c4hw_attach_all (void)
             pci_enable_device (hi->pdev[1]))
         {
             drvr_state = SBE_DRVR_DOWN;
-            printk (KERN_WARNING "%s: failed to enable card %d slot %d\n",
-                    hi->devname, i, hi->pci_slot);
+            pr_warning("%s: failed to enable card %d slot %d\n",
+                       hi->devname, i, hi->pci_slot);
             cleanup_devs ();
             cleanup_ioremap ();
             return EIO;
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index aee7018..ce2942c 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -12,6 +12,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/hdlc.h>
@@ -563,13 +565,13 @@ create_chan (struct net_device * ndev, ci_t * ci,
         priv = OS_kmalloc (sizeof (struct c4_priv));
         if (!priv)
         {
-            printk (KERN_WARNING "%s: no memory for net_device !\n", ci->devname);
+            pr_warning("%s: no memory for net_device !\n", ci->devname);
             return 0;
         }
         dev = alloc_hdlcdev (priv);
         if (!dev)
         {
-            printk (KERN_WARNING "%s: no memory for hdlc_device !\n", ci->devname);
+            pr_warning("%s: no memory for hdlc_device !\n", ci->devname);
             OS_kfree (priv);
             return 0;
         }
@@ -1111,7 +1113,7 @@ c4_add_dev (hdw_info_t * hi, int brdno, unsigned long f0, unsigned long f1,
     ndev = alloc_netdev(sizeof(ci_t), SBE_IFACETMPL, c4_setup);
     if (!ndev)
     {
-        printk (KERN_WARNING "%s: no memory for struct net_device !\n", hi->devname);
+        pr_warning("%s: no memory for struct net_device !\n", hi->devname);
         error_flag = ENOMEM;
         return 0;
     }
@@ -1177,8 +1179,7 @@ c4_add_dev (hdw_info_t * hi, int brdno, unsigned long f0, unsigned long f1,
 #endif
                      ndev->name, ndev))
     {
-        printk (KERN_WARNING "%s: MUSYCC could not get irq: %d\n",
-                ndev->name, irq0);
+        pr_warning("%s: MUSYCC could not get irq: %d\n", ndev->name, irq0);
         unregister_netdev (ndev);
         OS_kfree (netdev_priv(ndev));
         OS_kfree (ndev);
@@ -1188,8 +1189,7 @@ c4_add_dev (hdw_info_t * hi, int brdno, unsigned long f0, unsigned long f1,
 #ifdef CONFIG_SBE_PMCC4_NCOMM
     if (request_irq (irq1, &c4_ebus_interrupt, IRQF_SHARED, ndev->name, ndev))
     {
-        printk (KERN_WARNING "%s: EBUS could not get irq: %d\n",
-                hi->devname, irq1);
+        pr_warning("%s: EBUS could not get irq: %d\n", hi->devname, irq1);
         unregister_netdev (ndev);
         free_irq (irq0, ndev);
         OS_kfree (netdev_priv(ndev));
@@ -1263,33 +1263,33 @@ c4_mod_init (void)
 {
     int         rtn;
 
-    printk (KERN_WARNING "%s: %s\n", THIS_MODULE->name, pmcc4_OSSI_release);
+    pr_warning("%s\n", pmcc4_OSSI_release);
     if ((rtn = c4hw_attach_all ()))
         return -rtn;                /* installation failure - see system log */
 
     /* housekeeping notifications */
     if (log_level != log_level_default)
-        printk (KERN_INFO "%s NOTE: driver parameter <log_level> changed from default %d to %d.\n",
-                THIS_MODULE->name, log_level_default, log_level);
+        pr_info("NOTE: driver parameter <log_level> changed from default %d to %d.\n",
+                log_level_default, log_level);
     if (max_mru != max_mru_default)
-        printk (KERN_INFO "%s NOTE: driver parameter <max_mru> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_mru_default, max_mru);
+        pr_info("NOTE: driver parameter <max_mru> changed from default %d to %d.\n",
+                max_mru_default, max_mru);
     if (max_mtu != max_mtu_default)
-        printk (KERN_INFO "%s NOTE: driver parameter <max_mtu> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_mtu_default, max_mtu);
+        pr_info("NOTE: driver parameter <max_mtu> changed from default %d to %d.\n",
+                max_mtu_default, max_mtu);
     if (max_rxdesc_used != max_rxdesc_default)
     {
         if (max_rxdesc_used > 2000)
             max_rxdesc_used = 2000; /* out-of-bounds reset */
-        printk (KERN_INFO "%s NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_rxdesc_default, max_rxdesc_used);
+        pr_info("NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
+                max_rxdesc_default, max_rxdesc_used);
     }
     if (max_txdesc_used != max_txdesc_default)
     {
         if (max_txdesc_used > 1000)
             max_txdesc_used = 1000; /* out-of-bounds reset */
-        printk (KERN_INFO "%s NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_txdesc_default, max_txdesc_used);
+        pr_info("NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
+                max_txdesc_default, max_txdesc_used);
     }
     return 0;                       /* installation success */
 }
@@ -1331,7 +1331,7 @@ c4_mod_remove (void)
     cleanup_devs ();
     c4_cleanup ();
     cleanup_ioremap ();
-    printk (KERN_INFO "SBE %s - driver removed.\n", THIS_MODULE->name);
+    pr_info("SBE - driver removed.\n");
 }
 
 module_init (c4_mod_init);
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 650c9c0..7a6d92a 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -71,6 +71,7 @@ unsigned int max_bh = 0;
 char        SBEid_pmcc4_musyccc[] =
 "@(#)musycc.c - $Revision: 2.1 $      (c) Copyright 2004-2006 SBE, Inc.";
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
 #include "pmcc4_sysdep.h"
@@ -681,8 +682,8 @@ rewrite:
     }
     if (rcnt > MUSYCC_SR_RETRY_CNT)
     {
-        printk (KERN_WARNING "%s: failed service request (#%d)= %x, group %d.\n",
-                pi->up->devname, MUSYCC_SR_RETRY_CNT, req, pi->portnum);
+        pr_warning("%s: failed service request (#%d)= %x, group %d.\n",
+                   pi->up->devname, MUSYCC_SR_RETRY_CNT, req, pi->portnum);
         SD_SEM_GIVE (&pi->sr_sem_busy); /* allow any next request */
         return;
     }
@@ -959,14 +960,14 @@ musycc_init (ci_t * ci)
 
     if (max_mru > 0xffe)
     {
-        printk (KERN_WARNING "%s: Maximum allowed MRU exceeded, resetting %d to %d.\n",
-                THIS_MODULE->name, max_mru, 0xffe);
+        pr_warning("Maximum allowed MRU exceeded, resetting %d to %d.\n",
+                   max_mru, 0xffe);
         max_mru = 0xffe;
     }
     if (max_mtu > 0xffe)
     {
-        printk (KERN_WARNING "%s: Maximum allowed MTU exceeded, resetting %d to %d.\n",
-                THIS_MODULE->name, max_mtu, 0xffe);
+        pr_warning("Maximum allowed MTU exceeded, resetting %d to %d.\n",
+                   max_mtu, 0xffe);
         max_mtu = 0xffe;
     }
 #ifdef SBE_WAN256T3_ENABLE
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index ada80d0..1617333 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -83,6 +83,7 @@
 char        OSSIid_pmcc4_drvc[] =
 "@(#)pmcc4_drv.c - $Revision: 3.1 $   (c) Copyright 2002-2007 One Stop Systems, Inc.";
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #if defined (__FreeBSD__) || defined (__NetBSD__)
 #include <sys/param.h>
@@ -207,8 +208,8 @@ c4_new (void *hi)
     ci_t       *ci;
 
 #ifdef SBE_MAP_DEBUG
-    printk (KERN_WARNING "%s: c4_new() entered, ci needs %u.\n",
-            THIS_MODULE->name, (unsigned int) sizeof (ci_t));
+    pr_warning("c4_new() entered, ci needs %u.\n",
+               (unsigned int) sizeof (ci_t));
 #endif
 
     ci = (ci_t *) OS_kmalloc (sizeof (ci_t));
@@ -220,8 +221,8 @@ c4_new (void *hi)
         c4_list = ci;
         ci->brdno = ci->next ? ci->next->brdno + 1 : 0;
     } else
-        printk (KERN_WARNING "%s: failed CI malloc, size %u.\n",
-                THIS_MODULE->name, (unsigned int) sizeof (ci_t));
+        pr_warning("failed CI malloc, size %u.\n",
+                   (unsigned int) sizeof (ci_t));
 
     if (CI == 0)
         CI = ci;                    /* DEBUG, only board 0 usage */
@@ -805,7 +806,8 @@ c4_init (ci_t * ci, u_char *func0, u_char *func1)
             break;
         default:
             ci->max_port = 0;
-            printk (KERN_WARNING "%s: illegal port configuration (%x)\n", ci->devname, pmsk);
+            pr_warning("%s: illegal port configuration (%x)\n",
+                       ci->devname, pmsk);
             return SBE_DRVR_FAIL;
         }
 #ifdef SBE_MAP_DEBUG
@@ -847,8 +849,8 @@ c4_init (ci_t * ci, u_char *func0, u_char *func1)
                 ch->p.mode_56k = 0; /* default is 64kbps mode */
             } else
             {
-                printk (KERN_WARNING "%s: failed mch_t malloc, port %d channel %d size %u.\n",
-                        THIS_MODULE->name, portnum, j, (unsigned int) sizeof (mch_t));
+                pr_warning("failed mch_t malloc, port %d channel %d size %u.\n",
+                           portnum, j, (unsigned int) sizeof (mch_t));
                 break;
             }
         }
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index 2ab1eb1..44229a9 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -164,7 +164,7 @@ OS_mem_token_alloc (size_t size)
     skb = dev_alloc_skb (size);
     if (!skb)
     {
-        //printk (KERN_WARNING "no mem in OS_mem_token_alloc !");
+        //pr_warning("no mem in OS_mem_token_alloc !\n");
         return 0;
     }
     return skb;
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 61ca639..92f6f5c 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -11,6 +11,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -318,16 +320,14 @@ sbecom_proc_brd_init (ci_t * ci)
     ci->dir_dev = proc_mkdir(dir, NULL);
     if (!ci->dir_dev)
     {
-        printk (KERN_ERR "%s: Unable to create directory /proc/driver/%s\n",
-                THIS_MODULE->name, ci->devname);
+        pr_err("Unable to create directory /proc/driver/%s\n", ci->devname);
         goto fail;
     }
     e = create_proc_read_entry ("info", S_IFREG | S_IRUGO,
                                 ci->dir_dev, sbecom_proc_get_sbe_info, ci);
     if (!e)
     {
-        printk (KERN_ERR "%s: Unable to create entry /proc/driver/%s/info\n",
-                THIS_MODULE->name, ci->devname);
+        pr_err("Unable to create entry /proc/driver/%s/info\n", ci->devname);
         goto fail;
     }
     return 0;


