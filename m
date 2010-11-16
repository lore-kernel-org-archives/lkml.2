Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0KPWmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:42:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38110 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab0KPWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZSHwhCJcJ56IVPcSI+30X/wEIc4KkAPeR7L50WILAeyYdymrHGs31zAE4X9MUWlYYU
         gC8hjarJLduhqg5W6fASAfxZl1XgkWYVkjrIVh//BDWXmkVPMmhwxqp71DEB9McvFgQi
         XPqOXsFHBFriYhbwVB3vLOHJdHYpTL2dzFByE=
From: dirk.brandewie@gmail.com
To: devicetree-discuss@lists.ozlabs.org
Cc: sodaville@linutronix.de, arjan@linux.intel.com, dirk.brandewie@gmail.com,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] of/fdt: add kernel command line option for dtb_compat string
Date: Tue, 16 Nov 2010 14:41:37 -0800
Message-Id: <348d48851a244bbd60bbfc4d60bee330e5c91eae.1289943240.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Adds a kernel command line option "dtb_compat=<string>" and functions
for architecture/platform specific code to retrieve the command line
string and locate the compatible DTB linked into the kernel

of_flat_dt_get_dtb_compatible_string() returns a pointer string passed
from the command line or a pointer to an empty string.

of_flat_dt_find_compatible_dtb() returns a pointer to a DTB that is
compatible with the "compatible" string or a NULL pointer if no
matching DTB is present.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 Documentation/kernel-parameters.txt |    7 +++++
 drivers/of/fdt.c                    |   52 +++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h              |    4 +++
 3 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ed45e98..f9b77fa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -655,6 +655,13 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	dscc4.setup=	[NET]
 
+	dtb_compat=	[KNL]
+			Specify the "compatible" string for the device
+			tree blob present in the kernel image.  This
+			string will be used to select the first device
+			tree blob whose compatible property matches
+			the string passed on the kernel commandline.
+
 	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
 			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
 			These can also be switched on/off via
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index c1360e0..c0858ce 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -15,6 +15,8 @@
 #include <linux/of_fdt.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <asm-generic/vmlinux.lds.h>
+
 
 #ifdef CONFIG_PPC
 #include <asm/machdep.h>
@@ -604,3 +606,53 @@ void __init unflatten_device_tree(void)
 
 	pr_debug(" <- unflatten_device_tree()\n");
 }
+
+#define MAX_DTB_COMPAT_STR 64
+char dtb_compat_name[MAX_DTB_COMPAT_STR] = "";
+
+char __init *of_flat_dt_get_dtb_compatible_string(void)
+{
+	return dtb_compat_name;
+}
+
+
+extern uint8_t __dtb_start[];
+extern uint8_t __dtb_end[];
+void __init *of_flat_dt_find_compatible_dtb(char *name)
+{
+	void *rc = NULL;
+	unsigned long root, size;
+	struct boot_param_header  *orig_initial_boot_params;
+	uint8_t *blob;
+
+	orig_initial_boot_params = initial_boot_params;
+	blob = __dtb_start;
+	initial_boot_params = (struct boot_param_header *)blob;
+
+	while (blob < __dtb_end &&
+		(be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER)) {
+		root = of_get_flat_dt_root();
+		if (of_flat_dt_is_compatible(root, name) > 0) {
+			rc = blob;
+			break;
+		}
+
+		size =  be32_to_cpu(initial_boot_params->totalsize);
+		blob =  PTR_ALIGN(blob + size, DTB_ALIGNMENT);
+		initial_boot_params = (struct boot_param_header *)blob;
+	}
+
+	if (rc == NULL)
+		initial_boot_params = orig_initial_boot_params;
+	return rc;
+}
+
+
+static int __init of_flat_dtb_compat_setup(char *line)
+{
+	strncpy(dtb_compat_name, line, MAX_DTB_COMPAT_STR);
+	return 1;
+}
+
+early_param("dtb_compat", of_flat_dtb_compat_setup);
+
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 7bbf5b3..29561f4 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -58,6 +58,7 @@ struct boot_param_header {
 };
 
 #if defined(CONFIG_OF_FLATTREE)
+
 /* TBD: Temporary export of fdt globals - remove when code fully merged */
 extern int __initdata dt_root_addr_cells;
 extern int __initdata dt_root_size_cells;
@@ -82,6 +83,9 @@ extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern u64 early_init_dt_alloc_memory_arch(u64 size, u64 align);
 extern u64 dt_mem_next_cell(int s, __be32 **cellp);
 
+extern char *of_flat_dt_get_dtb_compatible_string(void);
+extern void *of_flat_dt_find_compatible_dtb(char *name);
+
 /*
  * If BLK_DEV_INITRD, the fdt early init code will call this function,
  * to be provided by the arch code. start and end are specified as
-- 
1.7.2.3

