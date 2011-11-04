Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1KDMXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:23:16 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63242 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1KDMXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:23:14 -0400
Date: Fri, 4 Nov 2011 13:23:11 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: siglesia@cern.ch, manohar.vanga@cern.ch
Subject: [RFC PATCH 1/2] modpost: use table-lookup to build module aliases
Message-ID: <072193c0ded6f17d106fe7fdd6ddb1323b6440ea.1320408578.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1320408578.git.rubini@gnudd.com>
In-Reply-To: <cover.1320408578.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function handle_moddevtable was a huge "else if" thing. This
patch places the lookup in a table to reduce code and increase data.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Samuel I. Gonsalvez <siglesia@cern.ch>
Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 scripts/mod/file2alias.c |  166 +++++++++++++++++-----------------------------
 1 files changed, 60 insertions(+), 106 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f936d1f..1247bc9 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -913,6 +913,51 @@ static void do_table(void *symval, unsigned long size,
 	}
 }
 
+/* This array collects all instances that use the generic do_table above */
+struct devtable_switch {
+	const char *device_id;
+	const char *symname;
+	unsigned long id_size;
+	void *function;
+};
+#define E(id, name, structname, f) {id, name, sizeof(struct structname), f}
+
+static struct devtable_switch devtable_switch[] = {
+	E("pci", "__mod_pci_device_table", pci_device_id, do_pci_entry),
+	E("hid", "__mod_hid_device_table", hid_device_id, do_hid_entry),
+	E("ieee1394", "__mod_ieee1394_device_table",
+	  ieee1394_device_id, do_ieee1394_entry),
+	E("ccw", "__mod_ccw_device_table", ccw_device_id, do_ccw_entry),
+	E("ap", "__mod_ap_device_table", ap_device_id, do_ap_entry),
+	E("css", "__mod_css_device_table", css_device_id, do_css_entry),
+	E("seio", "__mod_serio_device_table", serio_device_id, do_serio_entry),
+	E("acpi", "__mod_acpi_device_table", acpi_device_id, do_acpi_entry),
+	E("pcmcia", "__mod_pcmcia_device_table",
+	  pcmcia_device_id, do_pcmcia_entry),
+	E("of", "__mod_of_device_table", of_device_id, do_of_entry),
+	E("vio", "__mod_vio_device_table", vio_device_id, do_vio_entry),
+	E("input", "__mod_input_device_table", input_device_id, do_input_entry),
+	E("eisa", "__mod_eisa_device_table", eisa_device_id, do_eisa_entry),
+	E("parisc", "__mod_parisc_device_table",
+	  parisc_device_id, do_parisc_entry),
+	E("sdio", "__mod_sdio_device_table", sdio_device_id, do_sdio_entry),
+	E("ssb", "__mod_ssb_device_table", ssb_device_id, do_ssb_entry),
+	E("bcma", "__mod_bcma_device_table", bcma_device_id, do_bcma_entry),
+	E("virtio", "__mod_virtio_device_table",
+	  virtio_device_id, do_virtio_entry),
+	E("vmbus", "__mod_vmbus_device_table",
+	  hv_vmbus_device_id, do_vmbus_entry),
+	E("i2c", "__mod_i2c_device_table", i2c_device_id, do_i2c_entry),
+	E("spi", "__mod_spi_device_table", spi_device_id, do_spi_entry),
+	E("dmi", "__mod_dmi_device_table", dmi_system_id, do_dmi_entry),
+	E("platform", "__mod_platform_device_table",
+	  platform_device_id, do_platform_entry),
+	E("mdio", "__mod_mdio_device_table", mdio_device_id, do_mdio_entry),
+	E("zorro", "__mod_zorro_device_table", zorro_device_id, do_zorro_entry),
+	E("isa", "__mod_isapnp_device_table",
+	  isapnp_device_id, do_isapnp_entry)
+};
+
 /* Create MODULE_ALIAS() statements.
  * At this time, we cannot write the actual output C source yet,
  * so we write into the mod->dev_table_buf buffer. */
@@ -936,117 +981,26 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 			+ sym->st_value;
 	}
 
-	if (sym_is(symname, "__mod_pci_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct pci_device_id), "pci",
-			 do_pci_entry, mod);
-	else if (sym_is(symname, "__mod_usb_device_table"))
-		/* special case to handle bcdDevice ranges */
+	/* First handle the "special" cases */
+	if (sym_is(symname, "__mod_usb_device_table"))
 		do_usb_table(symval, sym->st_size, mod);
-	else if (sym_is(symname, "__mod_hid_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct hid_device_id), "hid",
-			 do_hid_entry, mod);
-	else if (sym_is(symname, "__mod_ieee1394_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct ieee1394_device_id), "ieee1394",
-			 do_ieee1394_entry, mod);
-	else if (sym_is(symname, "__mod_ccw_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct ccw_device_id), "ccw",
-			 do_ccw_entry, mod);
-	else if (sym_is(symname, "__mod_ap_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct ap_device_id), "ap",
-			 do_ap_entry, mod);
-	else if (sym_is(symname, "__mod_css_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct css_device_id), "css",
-			 do_css_entry, mod);
-	else if (sym_is(symname, "__mod_serio_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct serio_device_id), "serio",
-			 do_serio_entry, mod);
-	else if (sym_is(symname, "__mod_acpi_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct acpi_device_id), "acpi",
-			 do_acpi_entry, mod);
 	else if (sym_is(symname, "__mod_pnp_device_table"))
 		do_pnp_device_entry(symval, sym->st_size, mod);
 	else if (sym_is(symname, "__mod_pnp_card_device_table"))
 		do_pnp_card_entries(symval, sym->st_size, mod);
-	else if (sym_is(symname, "__mod_pcmcia_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct pcmcia_device_id), "pcmcia",
-			 do_pcmcia_entry, mod);
-        else if (sym_is(symname, "__mod_of_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct of_device_id), "of",
-			 do_of_entry, mod);
-        else if (sym_is(symname, "__mod_vio_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct vio_device_id), "vio",
-			 do_vio_entry, mod);
-	else if (sym_is(symname, "__mod_input_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct input_device_id), "input",
-			 do_input_entry, mod);
-	else if (sym_is(symname, "__mod_eisa_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct eisa_device_id), "eisa",
-			 do_eisa_entry, mod);
-	else if (sym_is(symname, "__mod_parisc_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct parisc_device_id), "parisc",
-			 do_parisc_entry, mod);
-	else if (sym_is(symname, "__mod_sdio_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct sdio_device_id), "sdio",
-			 do_sdio_entry, mod);
-	else if (sym_is(symname, "__mod_ssb_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct ssb_device_id), "ssb",
-			 do_ssb_entry, mod);
-	else if (sym_is(symname, "__mod_bcma_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct bcma_device_id), "bcma",
-			 do_bcma_entry, mod);
-	else if (sym_is(symname, "__mod_virtio_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct virtio_device_id), "virtio",
-			 do_virtio_entry, mod);
-	else if (sym_is(symname, "__mod_vmbus_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct hv_vmbus_device_id), "vmbus",
-			 do_vmbus_entry, mod);
-	else if (sym_is(symname, "__mod_i2c_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct i2c_device_id), "i2c",
-			 do_i2c_entry, mod);
-	else if (sym_is(symname, "__mod_spi_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct spi_device_id), "spi",
-			 do_spi_entry, mod);
-	else if (sym_is(symname, "__mod_dmi_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct dmi_system_id), "dmi",
-			 do_dmi_entry, mod);
-	else if (sym_is(symname, "__mod_platform_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct platform_device_id), "platform",
-			 do_platform_entry, mod);
-	else if (sym_is(symname, "__mod_mdio_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct mdio_device_id), "mdio",
-			 do_mdio_entry, mod);
-	else if (sym_is(symname, "__mod_zorro_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct zorro_device_id), "zorro",
-			 do_zorro_entry, mod);
-	else if (sym_is(symname, "__mod_isapnp_device_table"))
-		do_table(symval, sym->st_size,
-			sizeof(struct isapnp_device_id), "isa",
-			do_isapnp_entry, mod);
+	else {
+		struct devtable_switch *p = devtable_switch;
+		int i;
+
+		/* scan the array */
+		for (i = 0; i < ARRAY_SIZE(devtable_switch); i++, p++) {
+			if (sym_is(symname, p->symname)) {
+				do_table(symval, sym->st_size, p->id_size,
+					 p->device_id, p->function, mod);
+				break;
+			}
+		}
+	}
 	free(zeros);
 }
 
-- 
1.6.0.2
