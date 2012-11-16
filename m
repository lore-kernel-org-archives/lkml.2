Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2KPOUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:20:34 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33543 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2KPOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:20:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: [PATCH v2] drivers/of: Constify device_node->name and ->path_component_name
Date: Fri, 16 Nov 2012 14:20:25 +0000
Message-Id: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither of these should ever be changed once set. Make them const and
fix up the users that try to modify it in-place. In one case
kmalloc+memcpy is replaced with kstrdup() to avoid modifying the string.

Build tested with defconfigs on ARM, PowerPC, Sparc, MIPS, x86 among
others.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Julian Calaby <julian.calaby@gmail.com>
---

v2 - fill out more information in the commit text.

 arch/powerpc/platforms/powermac/pfunc_core.c |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c    |    3 +--
 arch/powerpc/sysdev/fsl_pci.c                |    2 +-
 arch/sparc/kernel/pci_impl.h                 |    2 +-
 drivers/of/fdt.c                             |   10 +++++-----
 include/linux/of.h                           |    4 ++--
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/pfunc_core.c b/arch/powerpc/platforms/powermac/pfunc_core.c
index b0c3777..d588e48 100644
--- a/arch/powerpc/platforms/powermac/pfunc_core.c
+++ b/arch/powerpc/platforms/powermac/pfunc_core.c
@@ -686,7 +686,7 @@ static int pmf_add_functions(struct pmf_device *dev, void *driverdata)
 	int count = 0;
 
 	for (pp = dev->node->properties; pp != 0; pp = pp->next) {
-		char *name;
+		const char *name;
 		if (strncmp(pp->name, PP_PREFIX, plen) != 0)
 			continue;
 		name = pp->name + plen;
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 39f71fb..2f46681 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -281,12 +281,11 @@ static struct property *new_property(const char *name, const int length,
 	if (!new)
 		return NULL;
 
-	if (!(new->name = kmalloc(strlen(name) + 1, GFP_KERNEL)))
+	if (!(new->name = kstrdup(name, GFP_KERNEL)))
 		goto cleanup;
 	if (!(new->value = kmalloc(length + 1, GFP_KERNEL)))
 		goto cleanup;
 
-	strcpy(new->name, name);
 	memcpy(new->value, value, length);
 	*(((char *)new->value) + length) = 0;
 	new->length = length;
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index ffb93ae..01b62a6 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -136,7 +136,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 	u32 pcicsrbar = 0, pcicsrbar_sz;
 	u32 piwar = PIWAR_EN | PIWAR_PF | PIWAR_TGI_LOCAL |
 			PIWAR_READ_SNOOP | PIWAR_WRITE_SNOOP;
-	char *name = hose->dn->full_name;
+	const char *name = hose->dn->full_name;
 	const u64 *reg;
 	int len;
 
diff --git a/arch/sparc/kernel/pci_impl.h b/arch/sparc/kernel/pci_impl.h
index 918a203..5f68853 100644
--- a/arch/sparc/kernel/pci_impl.h
+++ b/arch/sparc/kernel/pci_impl.h
@@ -88,7 +88,7 @@ struct pci_pbm_info {
 	int				chip_revision;
 
 	/* Name used for top-level resources. */
-	char				*name;
+	const char			*name;
 
 	/* OBP specific information. */
 	struct platform_device		*op;
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index c2b08dc..c8be326 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -199,10 +199,10 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
 	if (allnextpp) {
+		char *fn;
 		memset(np, 0, sizeof(*np));
-		np->full_name = ((char *)np) + sizeof(struct device_node);
+		np->full_name = fn = ((char *)np) + sizeof(*np);
 		if (new_format) {
-			char *fn = np->full_name;
 			/* rebuild full path for new format */
 			if (dad && dad->parent) {
 				strcpy(fn, dad->full_name);
@@ -216,9 +216,9 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				fn += strlen(fn);
 			}
 			*(fn++) = '/';
-			memcpy(fn, pathp, l);
-		} else
-			memcpy(np->full_name, pathp, l);
+		}
+		memcpy(fn, pathp, l);
+
 		prev_pp = &np->properties;
 		**allnextpp = np;
 		*allnextpp = &np->allnext;
diff --git a/include/linux/of.h b/include/linux/of.h
index b4e50d5..857dde9 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -46,7 +46,7 @@ struct device_node {
 	const char *name;
 	const char *type;
 	phandle phandle;
-	char	*full_name;
+	const char *full_name;
 
 	struct	property *properties;
 	struct	property *deadprops;	/* removed properties */
@@ -60,7 +60,7 @@ struct device_node {
 	unsigned long _flags;
 	void	*data;
 #if defined(CONFIG_SPARC)
-	char	*path_component_name;
+	const char *path_component_name;
 	unsigned int unique_id;
 	struct of_irq_controller *irq_trans;
 #endif
-- 
1.7.10.4

