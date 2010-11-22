Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0KVSYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:24:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab0KVSY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:24:29 -0500
Date: Mon, 22 Nov 2010 13:24:28 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Subject: [RFT][PATCH] Poke ACPI about connected floppy drives
Message-ID: <20101122182428.GR22651@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've gotten a few complaints because I removed the floppy module
modaliases in Fedora, which means people with ancient junk need
to manually probe it. (Some modern machines spend a good few seconds
probing non-existant floppy drives otherwise.)

Re-organize floppy.ko a bit to allow us to, in the case of CONFIG_ACPI,
poke the ACPI _FDE object to see how many floppy drives are connected,
and not bother probing if there are none.

I'd appreciate it if people could test this patch, and let me know how
many floppy drives they actually have, versus how many are reported
from the ACPI object. My 965-era Asus lies through its teeth about the
table, so I'm not entirely convinced this method is tenable, but it's my
olive branch to the floppy users.

If !CONFIG_ACPI, it should have the ordinary pnp ids and bind that way.

Not-yet-signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3951020..9208596 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -193,6 +193,9 @@ static int print_unex = 1;
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
  * It's been recommended that take about 1/4 of the default speed
@@ -4548,6 +4551,110 @@ static void __init parse_floppy_cfg_string(char *cfg)
 	}
 }
 
+static void __exit floppy_module_exit(void);
+
+#if defined(CONFIG_ACPI)
+
+#define MAX_ACPI_FLOPPIES	4
+struct fde_ret {
+	u32 floppies[MAX_ACPI_FLOPPIES];
+	u32 tape;
+};
+
+static int acpi_fde_add(struct acpi_device *dev)
+{
+	struct acpi_buffer out = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	struct fde_ret *fde;
+	acpi_status status;
+	int i, c = 0;
+
+	status = acpi_evaluate_object(dev->handle, "_FDE", NULL, &out);
+	if (ACPI_FAILURE(status)) {	/* fallback */
+		pr_info("acpi_fde: failed to evaluate _FDE\n");
+		goto probe_floppies;
+	}
+
+	obj = out.pointer;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		pr_info("acpi_fde: bad return from _FDE method\n");
+		goto probe_floppies;
+	}
+
+	fde = (struct fde_ret *)obj->buffer.pointer;
+
+	for (i = 0; i < MAX_ACPI_FLOPPIES; i++)
+		if (fde->floppies[i])
+			c++;
+
+	pr_info("acpi_fde: firmware reports %d floppies attached\n", c);
+	if (!c)
+		return 0;
+
+	/* fallthrough, we had floppies... */
+probe_floppies:
+	kfree(out.pointer);
+
+	if (floppy)
+		parse_floppy_cfg_string(floppy);
+	return floppy_init();
+}
+
+static const struct acpi_device_id fde_pnpids[] = {
+	{ "PNP0700", 0 },
+	{ "PNP0701", 0 },
+	{ "", 0 }
+};
+MODULE_DEVICE_TABLE(acpi, fde_pnpids);
+
+static struct acpi_driver acpi_fde_driver = {
+	.name = "fde",
+	.class = "floppy",
+	.ids = fde_pnpids,
+	.ops = {
+		.add = acpi_fde_add,
+	},
+};
+
+static int __init acpi_fde_init(void)
+{
+	int err;
+
+	if (acpi_disabled) {
+		if (floppy)
+			parse_floppy_cfg_string(floppy);
+		return floppy_init();
+	}
+
+	err = acpi_bus_register_driver(&acpi_fde_driver);
+	if (err) {
+		pr_info("error register acpi floppy\n");
+		return err;
+	}
+
+	pr_info("floppy: loaded\n");
+
+	return 0;
+}
+module_init(acpi_fde_init);
+
+static void __exit acpi_fde_fini(void) {
+	acpi_bus_unregister_driver(&acpi_fde_driver);
+	floppy_module_exit();
+	pr_info("floppy: unloaded\n");
+}
+module_exit(acpi_fde_fini);
+
+#else /*!CONFIG_ACPI*/
+
+/* This doesn't actually get used other than for module information */
+static const struct pnp_device_id floppy_pnpids[] = {
+	{"PNP0700", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
+
 static int __init floppy_module_init(void)
 {
 	if (floppy)
@@ -4556,6 +4663,10 @@ static int __init floppy_module_init(void)
 }
 module_init(floppy_module_init);
 
+module_exit(floppy_module_exit);
+
+#endif /*CONFIG_ACPI*/
+
 static void __exit floppy_module_exit(void)
 {
 	int drive;
@@ -4587,8 +4698,6 @@ static void __exit floppy_module_exit(void)
 	fd_eject(0);
 }
 
-module_exit(floppy_module_exit);
-
 module_param(floppy, charp, 0);
 module_param(FLOPPY_IRQ, int, 0);
 module_param(FLOPPY_DMA, int, 0);
@@ -4596,14 +4705,6 @@ MODULE_AUTHOR("Alain L. Knaff");
 MODULE_SUPPORTED_DEVICE("fd");
 MODULE_LICENSE("GPL");
 
-/* This doesn't actually get used other than for module information */
-static const struct pnp_device_id floppy_pnpids[] = {
-	{"PNP0700", 0},
-	{}
-};
-
-MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
-
 #else
 
 __setup("floppy=", floppy_setup);
