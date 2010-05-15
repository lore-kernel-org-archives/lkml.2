Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0EOVZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:25:39 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44703 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0EOVZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:25:36 -0400
Date: Sat, 15 May 2010 23:25:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 37/37] drivers/parport: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152324080.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/parport/parport_gsc.c    |    4 ++--
 drivers/parport/parport_sunbpp.c |    5 ++---
 drivers/parport/procfs.c         |    6 ++----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff -u -p a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -247,14 +247,14 @@ struct parport *__devinit parport_gsc_pr
 		printk (KERN_DEBUG "parport (0x%lx): no memory!\n", base);
 		return NULL;
 	}
-	ops = kmalloc (sizeof (struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_gsc_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
 	if (!ops) {
 		printk (KERN_DEBUG "parport (0x%lx): no memory for ops!\n",
 			base);
 		kfree (priv);
 		return NULL;
 	}
-	memcpy (ops, &parport_gsc_ops, sizeof (struct parport_operations));
 	priv->ctr = 0xc;
 	priv->ctr_writable = 0xff;
 	priv->dma_buf = 0;
diff -u -p a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -305,12 +305,11 @@ static int __devinit bpp_probe(struct of
 	size = resource_size(&op->resource[0]);
 	dma = PARPORT_DMA_NONE;
 
-	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_sunbpp_ops, sizeof(struct parport_operations),
+		      GFP_KERNEL);
         if (!ops)
 		goto out_unmap;
 
-        memcpy (ops, &parport_sunbpp_ops, sizeof(struct parport_operations));
-
 	dprintk(("register_port\n"));
 	if (!(p = parport_register_port((unsigned long)base, irq, dma, ops)))
 		goto out_free_ops;
diff -u -p a/drivers/parport/procfs.c b/drivers/parport/procfs.c
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -476,10 +476,9 @@ int parport_proc_register(struct parport
 	struct parport_sysctl_table *t;
 	int i;
 
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_sysctl_template, sizeof(*t));
 
 	t->device_dir[0].extra1 = port;
 
@@ -523,10 +522,9 @@ int parport_device_proc_register(struct 
 	struct parport_device_sysctl_table *t;
 	struct parport * port = device->port;
 	
-	t = kmalloc(sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&parport_device_sysctl_template, sizeof(*t), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
-	memcpy(t, &parport_device_sysctl_template, sizeof(*t));
 
 	t->dev_dir[0].child = t->parport_dir;
 	t->parport_dir[0].child = t->port_dir;
