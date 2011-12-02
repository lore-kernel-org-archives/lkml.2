Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1LBCsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:48:17 -0500
Received: from ozlabs.org ([203.10.76.45]:49062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab1LBCsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:48:16 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Greg KH <greg@kroah.com>, Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, siglesia@cern.ch, manohar.vanga@cern.ch,
        dave.martin@linaro.org
Subject: Re: [RFC PATCH V2 0/1] making order in file2alias
In-Reply-To: <20111202000350.GA6507@kroah.com>
References: <cover.1322781825.git.rubini@gnudd.com> <20111202000350.GA6507@kroah.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 02 Dec 2011 13:16:38 +1030
Message-ID: <87pqg7r8q9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 16:03:50 -0800, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 02, 2011 at 12:45:25AM +0100, Alessandro Rubini wrote:
> > (this message is the RFC, the patch itself is expected to be fine)
> > 
> > This is a repost of what I've sent on Nov 4th.  Since Rusty asked to
> > only do the first step, here it is.  I rebased on next-20111201 and it
> > still works fine.
> 
> Well, some of us disagree with Rusty :)

These patches are bikeshedding, but I am genuinely curious about your
reasoning, especially since you invoked Linus and Andrew in support.

The first patch makes it more compact, but a bit less simple.  Hard to
care either way.

And notice that it broke serio.  Big lose for a "tidyup".

But splitting 15-line functions into separate files?  Less compact, less
simple.  And now you have to patch two files.  The argument that this is
symmetric with how we write new drivers is pretty bogus IMHO: adding a
dozen lines to one file is definitely easier than a new file and adding
all the boilerplate.

> As he's still the maintainer of the module code, I'll defer to him
> though.

Well, modpost is kind of a no-mans-land, but I'm happy to own this.

If you want to get rid of the table, how's this (below, on top of my
previous patch).  A bit marginal, but keeps things together.

> > Thus, I may prepare three smaller steps, if that's acceptable (greg?)
> > 
> >   step 1: create the ELF section so ENTRY() lines can leave the array
> >           (and change name accordingly).
> > 
> >   step 2: each ENTRY() line can be moved just after the associated code
> >           (this means that a new bus is just a single hunk, not 2 of them)
> > 
> >   step 3: I create the headers needed to move code and ENTRY in separate
> >           files. This is some movement around, not trivial so it may
> >           deserve a patch in itself.
> > 
> >   step 4 and later ones: Individual busses may reach their own external file,
> >          conditionally compiled per Kconfig rules.
> > 
> > If that's something worth evaluating, I can do that over the weekend.
> 
> That sounds very reasonable to me.

If you *really* want to use separate files, then this patch will let you
do it.  You'll need to expose some stuff in a header though.

Thanks,
Rusty.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: modpost: use linker section to generate table.

This means (most) future busses need only have one hunk in their
patch.  Also took the opportunity to check that function matches the
type.

Again, inspired by Alessandro's patch series.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alessandro Rubini <rubini@gnudd.com>

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -39,6 +39,35 @@ typedef unsigned char	__u8;
  * we handle those differences explicitly below */
 #include "../../include/linux/mod_devicetable.h"
 
+/* This array collects all instances that use the generic do_table */
+struct devtable {
+	const char *device_id; /* name of table, __mod_<name>_device_table. */
+	unsigned long id_size;
+	void *function;
+};
+
+/* We construct a table of pointers in an ELF section (pointers generally
+ * go unpadded by gcc).  ld creates boundary syms for us. */
+extern struct devtable *__start___devtable[], *__stop___devtable[];
+#define ___cat(a,b) a ## b
+#define __cat(a,b) ___cat(a,b)
+
+#if __GNUC__ == 3 && __GNUC_MINOR__ < 3
+# define __used			__attribute__((__unused__))
+#else
+# define __used			__attribute__((__used__))
+#endif
+
+/* Add a table entry.  We test function type matches while we're here. */
+#define ADD_TO_DEVTABLE(device_id, type, function) \
+	static struct devtable __cat(devtable,__LINE__) = {	\
+		device_id + 0*sizeof((function)((const char *)NULL,	\
+						(type *)NULL,		\
+						(char *)NULL)),		\
+		sizeof(type), (function) };				\
+	static struct devtable *__attribute__((section("__devtable"))) \
+		__used __cat(devtable_ptr,__LINE__) = &__cat(devtable,__LINE__)
+
 #define ADD(str, sep, cond, field)                              \
 do {                                                            \
         strcat(str, sep);                                       \
@@ -290,6 +319,7 @@ static int do_hid_entry(const char *file
 
 	return 1;
 }
+ADD_TO_DEVTABLE("hid", struct hid_device_id, do_hid_entry);
 
 /* Looks like: ieee1394:venNmoNspNverN */
 static int do_ieee1394_entry(const char *filename,
@@ -314,6 +344,7 @@ static int do_ieee1394_entry(const char 
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("ieee1394", struct ieee1394_device_id, do_ieee1394_entry);
 
 /* Looks like: pci:vNdNsvNsdNbcNscNiN. */
 static int do_pci_entry(const char *filename,
@@ -357,6 +388,7 @@ static int do_pci_entry(const char *file
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("pci", struct pci_device_id, do_pci_entry);
 
 /* looks like: "ccw:tNmNdtNdmN" */
 static int do_ccw_entry(const char *filename,
@@ -380,6 +412,7 @@ static int do_ccw_entry(const char *file
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("ccw", struct ccw_device_id, do_ccw_entry);
 
 /* looks like: "ap:tN" */
 static int do_ap_entry(const char *filename,
@@ -388,6 +421,7 @@ static int do_ap_entry(const char *filen
 	sprintf(alias, "ap:t%02X*", id->dev_type);
 	return 1;
 }
+ADD_TO_DEVTABLE("ap", struct ap_device_id, do_ap_entry);
 
 /* looks like: "css:tN" */
 static int do_css_entry(const char *filename,
@@ -396,6 +430,7 @@ static int do_css_entry(const char *file
 	sprintf(alias, "css:t%01X", id->type);
 	return 1;
 }
+ADD_TO_DEVTABLE("css", struct css_device_id, do_css_entry);
 
 /* Looks like: "serio:tyNprNidNexN" */
 static int do_serio_entry(const char *filename,
@@ -415,6 +450,7 @@ static int do_serio_entry(const char *fi
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("serio", struct serio_device_id, do_serio_entry);
 
 /* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" or "acpi:LNXVIDEO" */
 static int do_acpi_entry(const char *filename,
@@ -423,6 +459,7 @@ static int do_acpi_entry(const char *fil
 	sprintf(alias, "acpi*:%s:*", id->id);
 	return 1;
 }
+ADD_TO_DEVTABLE("acpi", struct acpi_device_id, do_acpi_entry);
 
 /* looks like: "pnp:dD" */
 static void do_pnp_device_entry(void *symval, unsigned long size,
@@ -545,8 +582,7 @@ static int do_pcmcia_entry(const char *f
 	add_wildcard(alias);
        return 1;
 }
-
-
+ADD_TO_DEVTABLE("pcmcia", struct pcmcia_device_id, do_pcmcia_entry);
 
 static int do_of_entry (const char *filename, struct of_device_id *of, char *alias)
 {
@@ -569,6 +605,7 @@ static int do_of_entry (const char *file
     add_wildcard(alias);
     return 1;
 }
+ADD_TO_DEVTABLE("of", struct of_device_id, do_of_entry);
 
 static int do_vio_entry(const char *filename, struct vio_device_id *vio,
 		char *alias)
@@ -586,6 +623,7 @@ static int do_vio_entry(const char *file
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("vio", struct vio_device_id, do_vio_entry);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
@@ -641,6 +679,7 @@ static int do_input_entry(const char *fi
 		do_input(alias, id->swbit, 0, INPUT_DEVICE_ID_SW_MAX);
 	return 1;
 }
+ADD_TO_DEVTABLE("input", struct input_device_id, do_input_entry);
 
 static int do_eisa_entry(const char *filename, struct eisa_device_id *eisa,
 		char *alias)
@@ -651,6 +690,7 @@ static int do_eisa_entry(const char *fil
 		strcat(alias, "*");
 	return 1;
 }
+ADD_TO_DEVTABLE("eisa", struct eisa_device_id, do_eisa_entry);
 
 /* Looks like: parisc:tNhvNrevNsvN */
 static int do_parisc_entry(const char *filename, struct parisc_device_id *id,
@@ -670,6 +710,7 @@ static int do_parisc_entry(const char *f
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("parisc", struct parisc_device_id, do_parisc_entry);
 
 /* Looks like: sdio:cNvNdN. */
 static int do_sdio_entry(const char *filename,
@@ -686,6 +727,7 @@ static int do_sdio_entry(const char *fil
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("sdio", struct sdio_device_id, do_sdio_entry);
 
 /* Looks like: ssb:vNidNrevN. */
 static int do_ssb_entry(const char *filename,
@@ -702,6 +744,7 @@ static int do_ssb_entry(const char *file
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("ssb", struct ssb_device_id, do_ssb_entry);
 
 /* Looks like: bcma:mNidNrevNclN. */
 static int do_bcma_entry(const char *filename,
@@ -720,6 +763,7 @@ static int do_bcma_entry(const char *fil
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("bcma", struct bcma_device_id, do_bcma_entry);
 
 /* Looks like: virtio:dNvN */
 static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
@@ -735,6 +779,7 @@ static int do_virtio_entry(const char *f
 	add_wildcard(alias);
 	return 1;
 }
+ADD_TO_DEVTABLE("virtio", struct virtio_device_id, do_virtio_entry);
 
 /*
  * Looks like: vmbus:guid
@@ -756,6 +801,7 @@ static int do_vmbus_entry(const char *fi
 
 	return 1;
 }
+ADD_TO_DEVTABLE("vmbus", struct hv_vmbus_device_id, do_vmbus_entry);
 
 /* Looks like: i2c:S */
 static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
@@ -765,6 +811,7 @@ static int do_i2c_entry(const char *file
 
 	return 1;
 }
+ADD_TO_DEVTABLE("i2c", struct i2c_device_id, do_i2c_entry);
 
 /* Looks like: spi:S */
 static int do_spi_entry(const char *filename, struct spi_device_id *id,
@@ -774,6 +821,7 @@ static int do_spi_entry(const char *file
 
 	return 1;
 }
+ADD_TO_DEVTABLE("spi", struct spi_device_id, do_spi_entry);
 
 static const struct dmifield {
 	const char *prefix;
@@ -828,6 +876,7 @@ static int do_dmi_entry(const char *file
 	strcat(alias, ":");
 	return 1;
 }
+ADD_TO_DEVTABLE("dmi", struct dmi_system_id, do_dmi_entry);
 
 static int do_platform_entry(const char *filename,
 			     struct platform_device_id *id, char *alias)
@@ -835,6 +884,7 @@ static int do_platform_entry(const char 
 	sprintf(alias, PLATFORM_MODULE_PREFIX "%s", id->name);
 	return 1;
 }
+ADD_TO_DEVTABLE("platform", struct platform_device_id, do_platform_entry);
 
 static int do_mdio_entry(const char *filename,
 			 struct mdio_device_id *id, char *alias)
@@ -857,6 +907,7 @@ static int do_mdio_entry(const char *fil
 
 	return 1;
 }
+ADD_TO_DEVTABLE("mdio", struct mdio_device_id, do_mdio_entry);
 
 /* Looks like: zorro:iN. */
 static int do_zorro_entry(const char *filename, struct zorro_device_id *id,
@@ -867,6 +918,7 @@ static int do_zorro_entry(const char *fi
 	ADD(alias, "i", id->id != ZORRO_WILDCARD, id->id);
 	return 1;
 }
+ADD_TO_DEVTABLE("zorro", struct zorro_device_id, do_zorro_entry);
 
 /* looks like: "pnp:dD" */
 static int do_isapnp_entry(const char *filename,
@@ -880,6 +932,7 @@ static int do_isapnp_entry(const char *f
 		(id->function >> 12) & 0x0f, (id->function >> 8) & 0x0f);
 	return 1;
 }
+ADD_TO_DEVTABLE("isa", struct isapnp_device_id, do_isapnp_entry);
 
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
@@ -912,42 +965,6 @@ static void do_table(void *symval, unsig
 	}
 }
 
-/* This array collects all instances that use the generic do_table above */
-struct devtable_switch {
-	const char *device_id; /* name of table, __mod_<name>_device_table. */
-	unsigned long id_size;
-	void *function;
-};
-
-static const struct devtable_switch devtable_switch[] = {
-	{ "acpi", sizeof(struct acpi_device_id), do_acpi_entry },
-	{ "ap", sizeof(struct ap_device_id), do_ap_entry },
-	{ "bcma", sizeof(struct bcma_device_id), do_bcma_entry },
-	{ "ccw", sizeof(struct ccw_device_id), do_ccw_entry },
-	{ "css", sizeof(struct css_device_id), do_css_entry },
-	{ "dmi", sizeof(struct dmi_system_id), do_dmi_entry },
-	{ "eisa", sizeof(struct eisa_device_id), do_eisa_entry },
-	{ "hid", sizeof(struct hid_device_id), do_hid_entry },
-	{ "i2c", sizeof(struct i2c_device_id), do_i2c_entry },
-	{ "ieee1394", sizeof(struct ieee1394_device_id), do_ieee1394_entry },
-	{ "input", sizeof(struct input_device_id), do_input_entry },
-	{ "isa", sizeof(struct isapnp_device_id), do_isapnp_entry },
-	{ "mdio", sizeof(struct mdio_device_id), do_mdio_entry },
-	{ "of", sizeof(struct of_device_id), do_of_entry },
-	{ "parisc", sizeof(struct parisc_device_id), do_parisc_entry },
-	{ "pci", sizeof(struct pci_device_id), do_pci_entry },
-	{ "pcmcia", sizeof(struct pcmcia_device_id), do_pcmcia_entry },
-	{ "platform", sizeof(struct platform_device_id), do_platform_entry },
-	{ "sdio", sizeof(struct sdio_device_id), do_sdio_entry },
-	{ "serio", sizeof(struct serio_device_id), do_serio_entry },
-	{ "spi", sizeof(struct spi_device_id), do_spi_entry },
-	{ "ssb", sizeof(struct ssb_device_id), do_ssb_entry },
-	{ "vio", sizeof(struct vio_device_id), do_vio_entry },
-	{ "virtio", sizeof(struct virtio_device_id), do_virtio_entry },
-	{ "vmbus", sizeof(struct hv_vmbus_device_id), do_vmbus_entry },
-	{ "zorro", sizeof(struct zorro_device_id), do_zorro_entry },
-};
-
 /* Create MODULE_ALIAS() statements.
  * At this time, we cannot write the actual output C source yet,
  * so we write into the mod->dev_table_buf buffer. */
@@ -993,13 +1010,12 @@ void handle_moddevtable(struct module *m
 	else if (sym_is(name, namelen, "pnp_card"))
 		do_pnp_card_entries(symval, sym->st_size, mod);
 	else {
-		const struct devtable_switch *p = devtable_switch;
-		unsigned int i;
+		struct devtable **p;
 
-		for (i = 0; i < ARRAY_SIZE(devtable_switch); i++, p++) {
-			if (sym_is(name, namelen, p->device_id)) {
-				do_table(symval, sym->st_size, p->id_size,
-					 p->device_id, p->function, mod);
+		for (p = __start___devtable; p < __stop___devtable; p++) {
+			if (sym_is(name, namelen, (*p)->device_id)) {
+				do_table(symval, sym->st_size, (*p)->id_size,
+					 (*p)->device_id, (*p)->function, mod);
 				break;
 			}
 		}
