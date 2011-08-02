Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1HBQWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:22:01 -0400
Received: from www17.your-server.de ([213.133.104.17]:43488 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1HBQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:21:56 -0400
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Aug 2011 12:21:55 EDT
Subject: [PATCH] Use kstrdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 02 Aug 2011 18:21:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312302089.2629.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/reiserfs/super.c b/fs/reiserfs/super.c
--- a/fs/reiserfs/super.c 2011-07-26 00:46:10.533500551 +0200
+++ b/fs/reiserfs/super.c 2011-08-01 20:57:26.561121140 +0200
@@ -1021,8 +1021,7 @@ static int reiserfs_parse_options(struct
 							 "on filesystem root.");
 					return 0;
 				}
-				qf_names[qtype] =
-				    kmalloc(strlen(arg) + 1, GFP_KERNEL);
+				qf_names[qtype] = kstrdup(arg, GFP_KERNEL);
 				if (!qf_names[qtype]) {
 					reiserfs_warning(s, "reiserfs-2502",
 							 "not enough memory "
@@ -1030,7 +1029,6 @@ static int reiserfs_parse_options(struct
 							 "quotafile name.");
 					return 0;
 				}
-				strcpy(qf_names[qtype], arg);
 				*mount_options |= 1 << REISERFS_QUOTA;
 			} else {
 				if (qf_names[qtype] !=
diff -u -p a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
--- a/drivers/message/i2o/memory.c 2010-03-27 23:39:49.118521162 +0100
+++ b/drivers/message/i2o/memory.c 2011-08-01 21:02:30.929472234 +0200
@@ -270,10 +270,9 @@ EXPORT_SYMBOL_GPL(i2o_dma_realloc);
 int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
 				 size_t size, int min_nr)
 {
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto exit;
-	strcpy(pool->name, name);
 
 	pool->slab =
 	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);
diff -u -p a/drivers/acpi/scan.c b/drivers/acpi/scan.c
--- a/drivers/acpi/scan.c 2011-05-04 19:24:51.386504770 +0200
+++ b/drivers/acpi/scan.c 2011-08-01 21:02:46.489387939 +0200
@@ -1062,13 +1062,12 @@ static void acpi_add_id(struct acpi_devi
 	if (!id)
 		return;
 
-	id->id = kmalloc(strlen(dev_id) + 1, GFP_KERNEL);
+	id->id = kstrdup(dev_id, GFP_KERNEL);
 	if (!id->id) {
 		kfree(id);
 		return;
 	}
 
-	strcpy(id->id, dev_id);
 	list_add_tail(&id->list, &device->pnp.ids);
 }
 
diff -u -p a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c 2011-05-27 19:17:04.559520123 +0200
+++ b/drivers/char/ipmi/ipmi_msghandler.c 2011-08-01 21:10:43.970134537 +0200
@@ -2030,12 +2030,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	entry->name = kmalloc(strlen(name)+1, GFP_KERNEL);
+	entry->name = kstrdup(name, GFP_KERNEL);
 	if (!entry->name) {
 		kfree(entry);
 		return -ENOMEM;
 	}
-	strcpy(entry->name, name);
 
 	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
 	if (!file) {
diff -u -p a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c 2011-07-28 15:32:17.849920483 +0200
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c 2011-08-01 21:13:55.222431768 +0200
@@ -944,7 +944,7 @@ void brcmf_c_pktfilter_offload_set(struc
 	int i = 0;
 	char *arg_save = 0, *arg_org = 0;
 
-	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
+	arg_save = kstrdup(arg, GFP_ATOMIC);
 	if (!arg_save) {
 		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -958,8 +958,6 @@ void brcmf_c_pktfilter_offload_set(struc
 		goto fail;
 	}
 
-	strcpy(arg_save, arg);
-
 	argv[i] = strsep(&arg_save, " ");
 	while (argv[i++])
 		argv[i] = strsep(&arg_save, " ");
diff -u -p a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
--- a/drivers/scsi/aic7xxx/aic7770_osm.c 2010-09-13 07:01:17.513861341 +0200
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c 2011-08-01 21:15:57.315103668 +0200
@@ -85,10 +85,9 @@ aic7770_probe(struct device *dev)
 	int	error;
 
 	sprintf(buf, "ahc_eisa:%d", eisaBase >> 12);
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(&aic7xxx_driver_template, name);
 	if (ahc == NULL)
 		return (ENOMEM);
diff -u -p a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c 2010-09-13 07:01:17.527194675 +0200
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c 2011-08-01 21:15:57.685101664 +0200
@@ -225,10 +225,9 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 		ahc_get_pci_bus(pci),
 		ahc_get_pci_slot(pci),
 		ahc_get_pci_function(pci));
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (-ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(NULL, name);
 	if (ahc == NULL)
 		return (-ENOMEM);
diff -u -p a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c 2010-09-13 07:01:17.520528007 +0200
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c 2011-08-01 21:15:58.925094946 +0200
@@ -178,10 +178,9 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 		ahd_get_pci_bus(pci),
 		ahd_get_pci_slot(pci),
 		ahd_get_pci_function(pci));
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (-ENOMEM);
-	strcpy(name, buf);
 	ahd = ahd_alloc(NULL, name);
 	if (ahd == NULL)
 		return (-ENOMEM);
diff -u -p a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
--- a/arch/arm/mach-omap2/mux.c 2011-06-10 21:39:11.837703903 +0200
+++ b/arch/arm/mach-omap2/mux.c 2011-08-01 21:25:41.888603428 +0200
@@ -821,11 +821,10 @@ static void __init omap_mux_set_cmdline_
 	if (!omap_mux_options)
 		return;
 
-	options = kmalloc(strlen(omap_mux_options) + 1, GFP_KERNEL);
+	options = kstrdup(omap_mux_options, GFP_KERNEL);
 	if (!options)
 		return;
 
-	strcpy(options, omap_mux_options);
 	next_opt = options;
 
 	while ((token = strsep(&next_opt, ",")) != NULL) {
@@ -855,24 +854,19 @@ static int __init omap_mux_copy_names(st
 
 	for (i = 0; i < OMAP_MUX_NR_MODES; i++) {
 		if (src->muxnames[i]) {
-			dst->muxnames[i] =
-				kmalloc(strlen(src->muxnames[i]) + 1,
-					GFP_KERNEL);
+			dst->muxnames[i] = kstrdup(src->muxnames[i],
+						   GFP_KERNEL);
 			if (!dst->muxnames[i])
 				goto free;
-			strcpy(dst->muxnames[i], src->muxnames[i]);
 		}
 	}
 
 #ifdef CONFIG_DEBUG_FS
 	for (i = 0; i < OMAP_MUX_NR_SIDES; i++) {
 		if (src->balls[i]) {
-			dst->balls[i] =
-				kmalloc(strlen(src->balls[i]) + 1,
-					GFP_KERNEL);
+			dst->balls[i] = kstrdup(src->balls[i], GFP_KERNEL);
 			if (!dst->balls[i])
 				goto free;
-			strcpy(dst->balls[i], src->balls[i]);
 		}
 	}
 #endif


