Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0H3DyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:54:11 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:60008 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0H3DyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:54:09 -0400
Date: Sun, 29 Aug 2010 23:55:51 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 2/9] sparc: convert various prom_* functions to use phandle
Message-ID: <20100829235551.41f64af5@debxo>
In-Reply-To: <20100829235100.6dcedcb8@debxo>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rather than passing around ints everywhere, use the
phandle type where appropriate for the various functions
that talk to the PROM.

Note: this has only been compile-tested for 64bit sparc.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/include/asm/floppy_32.h |    3 +-
 arch/sparc/include/asm/openprom.h  |   15 +++++----
 arch/sparc/include/asm/oplib_32.h  |   44 +++++++++++++-------------
 arch/sparc/include/asm/oplib_64.h  |   39 +++++++++++-----------
 arch/sparc/kernel/auxio_32.c       |    4 +-
 arch/sparc/kernel/btext.c          |    4 +-
 arch/sparc/kernel/devices.c        |   23 +++++++------
 arch/sparc/kernel/pcic.c           |    4 +-
 arch/sparc/kernel/setup_64.c       |    2 +-
 arch/sparc/kernel/starfire.c       |    2 +-
 arch/sparc/kernel/tadpole.c        |    2 +-
 arch/sparc/mm/init_64.c            |    2 +-
 arch/sparc/mm/srmmu.c              |    8 +++--
 arch/sparc/mm/sun4c.c              |    2 +-
 arch/sparc/prom/init_32.c          |    2 +-
 arch/sparc/prom/init_64.c          |    4 +-
 arch/sparc/prom/memory.c           |    3 +-
 arch/sparc/prom/misc_64.c          |    6 ++-
 arch/sparc/prom/ranges.c           |    6 ++--
 arch/sparc/prom/tree_32.c          |   58 +++++++++++++++++----------------
 arch/sparc/prom/tree_64.c          |   62 ++++++++++++++++++------------------
 drivers/sbus/char/jsflash.c        |    2 +-
 drivers/video/aty/atyfb_base.c     |    3 +-
 23 files changed, 156 insertions(+), 144 deletions(-)

diff --git a/arch/sparc/include/asm/floppy_32.h b/arch/sparc/include/asm/floppy_32.h
index c792830..86666f7 100644
--- a/arch/sparc/include/asm/floppy_32.h
+++ b/arch/sparc/include/asm/floppy_32.h
@@ -304,7 +304,8 @@ static struct linux_prom_registers fd_regs[2];
 static int sun_floppy_init(void)
 {
 	char state[128];
-	int tnode, fd_node, num_regs;
+	phandle tnode, fd_node;
+	int num_regs;
 	struct resource r;
 
 	use_virtual_dma = 1;
diff --git a/arch/sparc/include/asm/openprom.h b/arch/sparc/include/asm/openprom.h
index 963e1a4..667b226 100644
--- a/arch/sparc/include/asm/openprom.h
+++ b/arch/sparc/include/asm/openprom.h
@@ -6,6 +6,7 @@
  *
  * Copyright (C) 1995,1996 David S. Miller (davem@caip.rutgers.edu)
  */
+#include <linux/types.h>
 
 /* Empirical constants... */
 #define LINUX_OPPROM_MAGIC      0x10010407
@@ -26,7 +27,7 @@ struct linux_dev_v0_funcs {
 
 /* V2 and later prom device operations. */
 struct linux_dev_v2_funcs {
-	int (*v2_inst2pkg)(int d);	/* Convert ihandle to phandle */
+	phandle (*v2_inst2pkg)(int d);	/* Convert ihandle to phandle */
 	char * (*v2_dumb_mem_alloc)(char *va, unsigned sz);
 	void (*v2_dumb_mem_free)(char *va, unsigned sz);
 
@@ -168,12 +169,12 @@ struct linux_romvec {
 
 /* Routines for traversing the prom device tree. */
 struct linux_nodeops {
-	int (*no_nextnode)(int node);
-	int (*no_child)(int node);
-	int (*no_proplen)(int node, const char *name);
-	int (*no_getprop)(int node, const char *name, char *val);
-	int (*no_setprop)(int node, const char *name, char *val, int len);
-	char * (*no_nextprop)(int node, char *name);
+	phandle (*no_nextnode)(phandle node);
+	phandle (*no_child)(phandle node);
+	int (*no_proplen)(phandle node, const char *name);
+	int (*no_getprop)(phandle node, const char *name, char *val);
+	int (*no_setprop)(phandle node, const char *name, char *val, int len);
+	char * (*no_nextprop)(phandle node, char *name);
 };
 
 /* More fun PROM structures for device probing. */
diff --git a/arch/sparc/include/asm/oplib_32.h b/arch/sparc/include/asm/oplib_32.h
index 33e31ce..51296a6 100644
--- a/arch/sparc/include/asm/oplib_32.h
+++ b/arch/sparc/include/asm/oplib_32.h
@@ -30,7 +30,7 @@ extern unsigned int prom_rev, prom_prev;
 /* Root node of the prom device tree, this stays constant after
  * initialization is complete.
  */
-extern int prom_root_node;
+extern phandle prom_root_node;
 
 /* Pointer to prom structure containing the device tree traversal
  * and usage utility functions.  Only prom-lib should use these,
@@ -178,68 +178,68 @@ extern void prom_putsegment(int context, unsigned long virt_addr,
 /* PROM device tree traversal functions... */
 
 /* Get the child node of the given node, or zero if no child exists. */
-extern int prom_getchild(int parent_node);
+extern phandle prom_getchild(phandle parent_node);
 
 /* Get the next sibling node of the given node, or zero if no further
  * siblings exist.
  */
-extern int prom_getsibling(int node);
+extern phandle prom_getsibling(phandle node);
 
 /* Get the length, at the passed node, of the given property type.
  * Returns -1 on error (ie. no such property at this node).
  */
-extern int prom_getproplen(int thisnode, const char *property);
+extern int prom_getproplen(phandle thisnode, const char *property);
 
 /* Fetch the requested property using the given buffer.  Returns
  * the number of bytes the prom put into your buffer or -1 on error.
  */
-extern int __must_check prom_getproperty(int thisnode, const char *property,
+extern int __must_check prom_getproperty(phandle thisnode, const char *property,
 					 char *prop_buffer, int propbuf_size);
 
 /* Acquire an integer property. */
-extern int prom_getint(int node, char *property);
+extern int prom_getint(phandle node, char *property);
 
 /* Acquire an integer property, with a default value. */
-extern int prom_getintdefault(int node, char *property, int defval);
+extern int prom_getintdefault(phandle node, char *property, int defval);
 
 /* Acquire a boolean property, 0=FALSE 1=TRUE. */
-extern int prom_getbool(int node, char *prop);
+extern int prom_getbool(phandle node, char *prop);
 
 /* Acquire a string property, null string on error. */
-extern void prom_getstring(int node, char *prop, char *buf, int bufsize);
+extern void prom_getstring(phandle node, char *prop, char *buf, int bufsize);
 
 /* Does the passed node have the given "name"? YES=1 NO=0 */
-extern int prom_nodematch(int thisnode, char *name);
+extern int prom_nodematch(phandle thisnode, char *name);
 
 /* Search all siblings starting at the passed node for "name" matching
  * the given string.  Returns the node on success, zero on failure.
  */
-extern int prom_searchsiblings(int node_start, char *name);
+extern phandle prom_searchsiblings(phandle node_start, char *name);
 
 /* Return the first property type, as a string, for the given node.
  * Returns a null string on error.
  */
-extern char *prom_firstprop(int node, char *buffer);
+extern char *prom_firstprop(phandle node, char *buffer);
 
 /* Returns the next property after the passed property for the given
  * node.  Returns null string on failure.
  */
-extern char *prom_nextprop(int node, char *prev_property, char *buffer);
+extern char *prom_nextprop(phandle node, char *prev_property, char *buffer);
 
 /* Returns phandle of the path specified */
-extern int prom_finddevice(char *name);
+extern phandle prom_finddevice(char *name);
 
 /* Returns 1 if the specified node has given property. */
-extern int prom_node_has_property(int node, char *property);
+extern int prom_node_has_property(phandle node, char *property);
 
 /* Set the indicated property at the given node with the passed value.
  * Returns the number of bytes of your value that the prom took.
  */
-extern int prom_setprop(int node, const char *prop_name, char *prop_value,
+extern int prom_setprop(phandle node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(char *path);
-extern int prom_inst2pkg(int);
+extern phandle prom_pathtoinode(char *path);
+extern phandle prom_inst2pkg(int);
 
 /* Dorking with Bus ranges... */
 
@@ -247,13 +247,13 @@ extern int prom_inst2pkg(int);
 extern void prom_apply_obio_ranges(struct linux_prom_registers *obioregs, int nregs);
 
 /* Apply ranges of any prom node (and optionally parent node as well) to registers. */
-extern void prom_apply_generic_ranges(int node, int parent,
+extern void prom_apply_generic_ranges(phandle node, phandle parent,
 				      struct linux_prom_registers *sbusregs, int nregs);
 
 /* CPU probing helpers.  */
-int cpu_find_by_instance(int instance, int *prom_node, int *mid);
-int cpu_find_by_mid(int mid, int *prom_node);
-int cpu_get_hwmid(int prom_node);
+int cpu_find_by_instance(int instance, phandle *prom_node, int *mid);
+int cpu_find_by_mid(int mid, phandle *prom_node);
+int cpu_get_hwmid(phandle prom_node);
 
 extern spinlock_t prom_lock;
 
diff --git a/arch/sparc/include/asm/oplib_64.h b/arch/sparc/include/asm/oplib_64.h
index 3e0b2d6..c9cc078 100644
--- a/arch/sparc/include/asm/oplib_64.h
+++ b/arch/sparc/include/asm/oplib_64.h
@@ -16,7 +16,7 @@ extern char prom_version[];
 /* Root node of the prom device tree, this stays constant after
  * initialization is complete.
  */
-extern int prom_root_node;
+extern phandle prom_root_node;
 
 /* PROM stdin and stdout */
 extern int prom_stdin, prom_stdout;
@@ -24,7 +24,7 @@ extern int prom_stdin, prom_stdout;
 /* /chosen node of the prom device tree, this stays constant after
  * initialization is complete.
  */
-extern int prom_chosen_node;
+extern phandle prom_chosen_node;
 
 /* Helper values and strings in arch/sparc64/kernel/head.S */
 extern const char prom_peer_name[];
@@ -218,68 +218,69 @@ extern void prom_unmap(unsigned long size, unsigned long vaddr);
 /* PROM device tree traversal functions... */
 
 /* Get the child node of the given node, or zero if no child exists. */
-extern int prom_getchild(int parent_node);
+extern phandle prom_getchild(phandle parent_node);
 
 /* Get the next sibling node of the given node, or zero if no further
  * siblings exist.
  */
-extern int prom_getsibling(int node);
+extern phandle prom_getsibling(phandle node);
 
 /* Get the length, at the passed node, of the given property type.
  * Returns -1 on error (ie. no such property at this node).
  */
-extern int prom_getproplen(int thisnode, const char *property);
+extern int prom_getproplen(phandle thisnode, const char *property);
 
 /* Fetch the requested property using the given buffer.  Returns
  * the number of bytes the prom put into your buffer or -1 on error.
  */
-extern int prom_getproperty(int thisnode, const char *property,
+extern int prom_getproperty(phandle thisnode, const char *property,
 			    char *prop_buffer, int propbuf_size);
 
 /* Acquire an integer property. */
-extern int prom_getint(int node, const char *property);
+extern int prom_getint(phandle node, const char *property);
 
 /* Acquire an integer property, with a default value. */
-extern int prom_getintdefault(int node, const char *property, int defval);
+extern int prom_getintdefault(phandle node, const char *property, int defval);
 
 /* Acquire a boolean property, 0=FALSE 1=TRUE. */
-extern int prom_getbool(int node, const char *prop);
+extern int prom_getbool(phandle node, const char *prop);
 
 /* Acquire a string property, null string on error. */
-extern void prom_getstring(int node, const char *prop, char *buf, int bufsize);
+extern void prom_getstring(phandle node, const char *prop, char *buf,
+			   int bufsize);
 
 /* Does the passed node have the given "name"? YES=1 NO=0 */
-extern int prom_nodematch(int thisnode, const char *name);
+extern int prom_nodematch(phandle thisnode, const char *name);
 
 /* Search all siblings starting at the passed node for "name" matching
  * the given string.  Returns the node on success, zero on failure.
  */
-extern int prom_searchsiblings(int node_start, const char *name);
+extern phandle prom_searchsiblings(phandle node_start, const char *name);
 
 /* Return the first property type, as a string, for the given node.
  * Returns a null string on error. Buffer should be at least 32B long.
  */
-extern char *prom_firstprop(int node, char *buffer);
+extern char *prom_firstprop(phandle node, char *buffer);
 
 /* Returns the next property after the passed property for the given
  * node.  Returns null string on failure. Buffer should be at least 32B long.
  */
-extern char *prom_nextprop(int node, const char *prev_property, char *buffer);
+extern char *prom_nextprop(phandle node, const char *prev_property, char *buf);
 
 /* Returns 1 if the specified node has given property. */
-extern int prom_node_has_property(int node, const char *property);
+extern int prom_node_has_property(phandle node, const char *property);
 
 /* Returns phandle of the path specified */
-extern int prom_finddevice(const char *name);
+extern phandle prom_finddevice(const char *name);
 
 /* Set the indicated property at the given node with the passed value.
  * Returns the number of bytes of your value that the prom took.
  */
-extern int prom_setprop(int node, const char *prop_name, char *prop_value,
+extern int prom_setprop(phandle node, const char *prop_name, char *prop_value,
 			int value_size);
 
-extern int prom_pathtoinode(const char *path);
-extern int prom_inst2pkg(int);
+extern phandle prom_pathtoinode(const char *path);
+extern phandle prom_inst2pkg(int);
 extern int prom_service_exists(const char *service_name);
 extern void prom_sun4v_guest_soft_state(void);
 
diff --git a/arch/sparc/kernel/auxio_32.c b/arch/sparc/kernel/auxio_32.c
index ee8d214..35f4883 100644
--- a/arch/sparc/kernel/auxio_32.c
+++ b/arch/sparc/kernel/auxio_32.c
@@ -23,7 +23,7 @@ static DEFINE_SPINLOCK(auxio_lock);
 
 void __init auxio_probe(void)
 {
-	int node, auxio_nd;
+	phandle node, auxio_nd;
 	struct linux_prom_registers auxregs[1];
 	struct resource r;
 
@@ -113,7 +113,7 @@ volatile unsigned char * auxio_power_register = NULL;
 void __init auxio_power_probe(void)
 {
 	struct linux_prom_registers regs;
-	int node;
+	phandle node;
 	struct resource r;
 
 	/* Attempt to find the sun4m power control node. */
diff --git a/arch/sparc/kernel/btext.c b/arch/sparc/kernel/btext.c
index 8cc2d56..89aa4eb 100644
--- a/arch/sparc/kernel/btext.c
+++ b/arch/sparc/kernel/btext.c
@@ -40,7 +40,7 @@ static unsigned char *dispDeviceBase __force_data;
 
 static unsigned char vga_font[cmapsz];
 
-static int __init btext_initialize(unsigned int node)
+static int __init btext_initialize(phandle node)
 {
 	unsigned int width, height, depth, pitch;
 	unsigned long address = 0;
@@ -309,7 +309,7 @@ static struct console btext_console = {
 
 int __init btext_find_display(void)
 {
-	unsigned int node;
+	phandle node;
 	char type[32];
 	int ret;
 
diff --git a/arch/sparc/kernel/devices.c b/arch/sparc/kernel/devices.c
index 62dc7a0..d2eddd6 100644
--- a/arch/sparc/kernel/devices.c
+++ b/arch/sparc/kernel/devices.c
@@ -31,9 +31,9 @@ static char *cpu_mid_prop(void)
 	return "mid";
 }
 
-static int check_cpu_node(int nd, int *cur_inst,
-			  int (*compare)(int, int, void *), void *compare_arg,
-			  int *prom_node, int *mid)
+static int check_cpu_node(phandle nd, int *cur_inst,
+		int (*compare)(phandle, int, void *), void *compare_arg,
+		phandle *prom_node, int *mid)
 {
 	if (!compare(nd, *cur_inst, compare_arg)) {
 		if (prom_node)
@@ -51,8 +51,8 @@ static int check_cpu_node(int nd, int *cur_inst,
 	return -ENODEV;
 }
 
-static int __cpu_find_by(int (*compare)(int, int, void *), void *compare_arg,
-			 int *prom_node, int *mid)
+static int __cpu_find_by(int (*compare)(phandle, int, void *),
+		void *compare_arg, phandle *prom_node, int *mid)
 {
 	struct device_node *dp;
 	int cur_inst;
@@ -71,7 +71,7 @@ static int __cpu_find_by(int (*compare)(int, int, void *), void *compare_arg,
 	return -ENODEV;
 }
 
-static int cpu_instance_compare(int nd, int instance, void *_arg)
+static int cpu_instance_compare(phandle nd, int instance, void *_arg)
 {
 	int desired_instance = (int) _arg;
 
@@ -80,13 +80,13 @@ static int cpu_instance_compare(int nd, int instance, void *_arg)
 	return -ENODEV;
 }
 
-int cpu_find_by_instance(int instance, int *prom_node, int *mid)
+int cpu_find_by_instance(int instance, phandle *prom_node, int *mid)
 {
 	return __cpu_find_by(cpu_instance_compare, (void *)instance,
 			     prom_node, mid);
 }
 
-static int cpu_mid_compare(int nd, int instance, void *_arg)
+static int cpu_mid_compare(phandle nd, int instance, void *_arg)
 {
 	int desired_mid = (int) _arg;
 	int this_mid;
@@ -98,7 +98,7 @@ static int cpu_mid_compare(int nd, int instance, void *_arg)
 	return -ENODEV;
 }
 
-int cpu_find_by_mid(int mid, int *prom_node)
+int cpu_find_by_mid(int mid, phandle *prom_node)
 {
 	return __cpu_find_by(cpu_mid_compare, (void *)mid,
 			     prom_node, NULL);
@@ -108,7 +108,7 @@ int cpu_find_by_mid(int mid, int *prom_node)
  * address (0-3).  This gives us the true hardware mid, which might have
  * some other bits set.  On 4d hardware and software mids are the same.
  */
-int cpu_get_hwmid(int prom_node)
+int cpu_get_hwmid(phandle prom_node)
 {
 	return prom_getintdefault(prom_node, cpu_mid_prop(), -ENODEV);
 }
@@ -119,7 +119,8 @@ void __init device_scan(void)
 
 #ifndef CONFIG_SMP
 	{
-		int err, cpu_node;
+		phandle cpu_node;
+		int err;
 		err = cpu_find_by_instance(0, &cpu_node, NULL);
 		if (err) {
 			/* Probably a sun4e, Sun is trying to trick us ;-) */
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index d36a8d3..aeaa09a 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -284,7 +284,7 @@ int __init pcic_probe(void)
 	struct linux_prom_registers regs[PROMREG_MAX];
 	struct linux_pbm_info* pbm;
 	char namebuf[64];
-	int node;
+	phandle node;
 	int err;
 
 	if (pcic0_up) {
@@ -440,7 +440,7 @@ static int __devinit pdev_to_pnode(struct linux_pbm_info *pbm,
 {
 	struct linux_prom_pci_registers regs[PROMREG_MAX];
 	int err;
-	int node = prom_getchild(pbm->prom_node);
+	phandle node = prom_getchild(pbm->prom_node);
 
 	while(node) {
 		err = prom_getproperty(node, "reg", 
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 5f72de6..29bafe0 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -315,7 +315,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_IP_PNP
 	if (!ic_set_manually) {
-		int chosen = prom_finddevice ("/chosen");
+		phandle chosen = prom_finddevice("/chosen");
 		u32 cl, sv, gw;
 		
 		cl = prom_getintdefault (chosen, "client-ip", 0);
diff --git a/arch/sparc/kernel/starfire.c b/arch/sparc/kernel/starfire.c
index 060d0f3..a4446c0 100644
--- a/arch/sparc/kernel/starfire.c
+++ b/arch/sparc/kernel/starfire.c
@@ -23,7 +23,7 @@ int this_is_starfire = 0;
 
 void check_if_starfire(void)
 {
-	int ssnode = prom_finddevice("/ssp-serial");
+	phandle ssnode = prom_finddevice("/ssp-serial");
 	if (ssnode != 0 && ssnode != -1)
 		this_is_starfire = 1;
 }
diff --git a/arch/sparc/kernel/tadpole.c b/arch/sparc/kernel/tadpole.c
index f476a5f..9aba8bd 100644
--- a/arch/sparc/kernel/tadpole.c
+++ b/arch/sparc/kernel/tadpole.c
@@ -100,7 +100,7 @@ static void swift_clockstop(void)
 
 void __init clock_stop_probe(void)
 {
-	unsigned int node, clk_nd;
+	phandle node, clk_nd;
 	char name[20];
     
 	prom_getstring(prom_root_node, "name", name, sizeof(name));
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index f043451..9b020d6 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -88,7 +88,7 @@ static void __init read_obp_memory(const char *property,
 				   struct linux_prom64_registers *regs,
 				   int *num_ents)
 {
-	int node = prom_finddevice("/memory");
+	phandle node = prom_finddevice("/memory");
 	int prop_size = prom_getproplen(node, property);
 	int ents, ret, i;
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index b0b43aa..92319aa 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1262,7 +1262,8 @@ extern unsigned long bootmem_init(unsigned long *pages_avail);
 
 void __init srmmu_paging_init(void)
 {
-	int i, cpunode;
+	int i;
+	phandle cpunode;
 	char node_str[128];
 	pgd_t *pgd;
 	pmd_t *pmd;
@@ -1398,7 +1399,8 @@ static void __init srmmu_is_bad(void)
 
 static void __init init_vac_layout(void)
 {
-	int nd, cache_lines;
+	phandle nd;
+	int cache_lines;
 	char node_str[128];
 #ifdef CONFIG_SMP
 	int cpu = 0;
@@ -2082,7 +2084,7 @@ static void __init get_srmmu_type(void)
 
 	/* Next check for Fujitsu Swift. */
 	if(psr_typ == 0 && psr_vers == 4) {
-		int cpunode;
+		phandle cpunode;
 		char node_str[128];
 
 		/* Look if it is not a TurboSparc emulating Swift... */
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index 4289f90..ddd0d86 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -420,7 +420,7 @@ volatile unsigned long __iomem *sun4c_memerr_reg = NULL;
 
 void __init sun4c_probe_memerr_reg(void)
 {
-	int node;
+	phandle node;
 	struct linux_prom_registers regs[1];
 
 	node = prom_getchild(prom_root_node);
diff --git a/arch/sparc/prom/init_32.c b/arch/sparc/prom/init_32.c
index ccb36c7..d342dba 100644
--- a/arch/sparc/prom/init_32.c
+++ b/arch/sparc/prom/init_32.c
@@ -20,7 +20,7 @@ enum prom_major_version prom_vers;
 unsigned int prom_rev, prom_prev;
 
 /* The root node of the prom device tree. */
-int prom_root_node;
+phandle prom_root_node;
 EXPORT_SYMBOL(prom_root_node);
 
 /* Pointer to the device tree operations structure. */
diff --git a/arch/sparc/prom/init_64.c b/arch/sparc/prom/init_64.c
index 7b00f89..3ff911e 100644
--- a/arch/sparc/prom/init_64.c
+++ b/arch/sparc/prom/init_64.c
@@ -19,7 +19,7 @@ char prom_version[80];
 
 /* The root node of the prom device tree. */
 int prom_stdin, prom_stdout;
-int prom_chosen_node;
+phandle prom_chosen_node;
 
 /* You must call prom_init() before you attempt to use any of the
  * routines in the prom library.  It returns 0 on success, 1 on
@@ -30,7 +30,7 @@ extern void prom_cif_init(void *, void *);
 
 void __init prom_init(void *cif_handler, void *cif_stack)
 {
-	int node;
+	phandle node;
 
 	prom_cif_init(cif_handler, cif_stack);
 
diff --git a/arch/sparc/prom/memory.c b/arch/sparc/prom/memory.c
index fac7899..3f263a6 100644
--- a/arch/sparc/prom/memory.c
+++ b/arch/sparc/prom/memory.c
@@ -31,7 +31,8 @@ static int __init prom_meminit_v0(void)
 static int __init prom_meminit_v2(void)
 {
 	struct linux_prom_registers reg[64];
-	int node, size, num_ents, i;
+	phandle node;
+	int size, num_ents, i;
 
 	node = prom_searchsiblings(prom_getchild(prom_root_node), "memory");
 	size = prom_getproperty(node, "available", (char *) reg, sizeof(reg));
diff --git a/arch/sparc/prom/misc_64.c b/arch/sparc/prom/misc_64.c
index 6cb1581..d24bc44 100644
--- a/arch/sparc/prom/misc_64.c
+++ b/arch/sparc/prom/misc_64.c
@@ -183,7 +183,8 @@ unsigned char prom_get_idprom(char *idbuf, int num_bytes)
 
 int prom_get_mmu_ihandle(void)
 {
-	int node, ret;
+	phandle node;
+	int ret;
 
 	if (prom_mmu_ihandle_cache != 0)
 		return prom_mmu_ihandle_cache;
@@ -201,7 +202,8 @@ int prom_get_mmu_ihandle(void)
 static int prom_get_memory_ihandle(void)
 {
 	static int memory_ihandle_cache;
-	int node, ret;
+	phandle node;
+	int ret;
 
 	if (memory_ihandle_cache != 0)
 		return memory_ihandle_cache;
diff --git a/arch/sparc/prom/ranges.c b/arch/sparc/prom/ranges.c
index aeff43e..541fc82 100644
--- a/arch/sparc/prom/ranges.c
+++ b/arch/sparc/prom/ranges.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(prom_apply_obio_ranges);
 
 void __init prom_ranges_init(void)
 {
-	int node, obio_node;
+	phandle node, obio_node;
 	int success;
 
 	num_obio_ranges = 0;
@@ -89,8 +89,8 @@ void __init prom_ranges_init(void)
 		prom_printf("PROMLIB: obio_ranges %d\n", num_obio_ranges);
 }
 
-void
-prom_apply_generic_ranges (int node, int parent, struct linux_prom_registers *regs, int nregs)
+void prom_apply_generic_ranges(phandle node, phandle parent,
+		struct linux_prom_registers *regs, int nregs)
 {
 	int success;
 	int num_ranges;
diff --git a/arch/sparc/prom/tree_32.c b/arch/sparc/prom/tree_32.c
index b21592f..63e08e1 100644
--- a/arch/sparc/prom/tree_32.c
+++ b/arch/sparc/prom/tree_32.c
@@ -20,10 +20,10 @@ extern void restore_current(void);
 static char promlib_buf[128];
 
 /* Internal version of prom_getchild that does not alter return values. */
-int __prom_getchild(int node)
+phandle __prom_getchild(phandle node)
 {
 	unsigned long flags;
-	int cnode;
+	phandle cnode;
 
 	spin_lock_irqsave(&prom_lock, flags);
 	cnode = prom_nodeops->no_child(node);
@@ -36,9 +36,9 @@ int __prom_getchild(int node)
 /* Return the child of node 'node' or zero if no this node has no
  * direct descendent.
  */
-int prom_getchild(int node)
+phandle prom_getchild(phandle node)
 {
-	int cnode;
+	phandle cnode;
 
 	if (node == -1)
 		return 0;
@@ -52,10 +52,10 @@ int prom_getchild(int node)
 EXPORT_SYMBOL(prom_getchild);
 
 /* Internal version of prom_getsibling that does not alter return values. */
-int __prom_getsibling(int node)
+phandle __prom_getsibling(phandle node)
 {
 	unsigned long flags;
-	int cnode;
+	phandle cnode;
 
 	spin_lock_irqsave(&prom_lock, flags);
 	cnode = prom_nodeops->no_nextnode(node);
@@ -68,9 +68,9 @@ int __prom_getsibling(int node)
 /* Return the next sibling of node 'node' or zero if no more siblings
  * at this level of depth in the tree.
  */
-int prom_getsibling(int node)
+phandle prom_getsibling(phandle node)
 {
-	int sibnode;
+	phandle sibnode;
 
 	if (node == -1)
 		return 0;
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(prom_getsibling);
 /* Return the length in bytes of property 'prop' at node 'node'.
  * Return -1 on error.
  */
-int prom_getproplen(int node, const char *prop)
+int prom_getproplen(phandle node, const char *prop)
 {
 	int ret;
 	unsigned long flags;
@@ -106,7 +106,7 @@ EXPORT_SYMBOL(prom_getproplen);
  * 'buffer' which has a size of 'bufsize'.  If the acquisition
  * was successful the length will be returned, else -1 is returned.
  */
-int prom_getproperty(int node, const char *prop, char *buffer, int bufsize)
+int prom_getproperty(phandle node, const char *prop, char *buffer, int bufsize)
 {
 	int plen, ret;
 	unsigned long flags;
@@ -126,7 +126,7 @@ EXPORT_SYMBOL(prom_getproperty);
 /* Acquire an integer property and return its value.  Returns -1
  * on failure.
  */
-int prom_getint(int node, char *prop)
+int prom_getint(phandle node, char *prop)
 {
 	static int intprop;
 
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(prom_getint);
 /* Acquire an integer property, upon error return the passed default
  * integer.
  */
-int prom_getintdefault(int node, char *property, int deflt)
+int prom_getintdefault(phandle node, char *property, int deflt)
 {
 	int retval;
 
@@ -152,7 +152,7 @@ int prom_getintdefault(int node, char *property, int deflt)
 EXPORT_SYMBOL(prom_getintdefault);
 
 /* Acquire a boolean property, 1=TRUE 0=FALSE. */
-int prom_getbool(int node, char *prop)
+int prom_getbool(phandle node, char *prop)
 {
 	int retval;
 
@@ -166,7 +166,7 @@ EXPORT_SYMBOL(prom_getbool);
  * string on error.  The char pointer is the user supplied string
  * buffer.
  */
-void prom_getstring(int node, char *prop, char *user_buf, int ubuf_size)
+void prom_getstring(phandle node, char *prop, char *user_buf, int ubuf_size)
 {
 	int len;
 
@@ -180,7 +180,7 @@ EXPORT_SYMBOL(prom_getstring);
 /* Does the device at node 'node' have name 'name'?
  * YES = 1   NO = 0
  */
-int prom_nodematch(int node, char *name)
+int prom_nodematch(phandle node, char *name)
 {
 	int error;
 
@@ -194,10 +194,11 @@ int prom_nodematch(int node, char *name)
 /* Search siblings at 'node_start' for a node with name
  * 'nodename'.  Return node if successful, zero if not.
  */
-int prom_searchsiblings(int node_start, char *nodename)
+phandle prom_searchsiblings(phandle node_start, char *nodename)
 {
 
-	int thisnode, error;
+	phandle thisnode;
+	int error;
 
 	for(thisnode = node_start; thisnode;
 	    thisnode=prom_getsibling(thisnode)) {
@@ -213,7 +214,7 @@ int prom_searchsiblings(int node_start, char *nodename)
 EXPORT_SYMBOL(prom_searchsiblings);
 
 /* Interal version of nextprop that does not alter return values. */
-char * __prom_nextprop(int node, char * oprop)
+char *__prom_nextprop(phandle node, char * oprop)
 {
 	unsigned long flags;
 	char *prop;
@@ -228,7 +229,7 @@ char * __prom_nextprop(int node, char * oprop)
 
 /* Return the first property name for node 'node'. */
 /* buffer is unused argument, but as v9 uses it, we need to have the same interface */
-char * prom_firstprop(int node, char *bufer)
+char *prom_firstprop(phandle node, char *bufer)
 {
 	if (node == 0 || node == -1)
 		return "";
@@ -241,7 +242,7 @@ EXPORT_SYMBOL(prom_firstprop);
  * at node 'node' .  Returns empty string if no more
  * property types for this node.
  */
-char * prom_nextprop(int node, char *oprop, char *buffer)
+char *prom_nextprop(phandle node, char *oprop, char *buffer)
 {
 	if (node == 0 || node == -1)
 		return "";
@@ -250,11 +251,11 @@ char * prom_nextprop(int node, char *oprop, char *buffer)
 }
 EXPORT_SYMBOL(prom_nextprop);
 
-int prom_finddevice(char *name)
+phandle prom_finddevice(char *name)
 {
 	char nbuf[128];
 	char *s = name, *d;
-	int node = prom_root_node, node2;
+	phandle node = prom_root_node, node2;
 	unsigned int which_io, phys_addr;
 	struct linux_prom_registers reg[PROMREG_MAX];
 
@@ -298,7 +299,7 @@ int prom_finddevice(char *name)
 }
 EXPORT_SYMBOL(prom_finddevice);
 
-int prom_node_has_property(int node, char *prop)
+int prom_node_has_property(phandle node, char *prop)
 {
 	char *current_property = "";
 
@@ -314,7 +315,7 @@ EXPORT_SYMBOL(prom_node_has_property);
 /* Set property 'pname' at node 'node' to value 'value' which has a length
  * of 'size' bytes.  Return the number of bytes the prom accepted.
  */
-int prom_setprop(int node, const char *pname, char *value, int size)
+int prom_setprop(phandle node, const char *pname, char *value, int size)
 {
 	unsigned long flags;
 	int ret;
@@ -329,9 +330,9 @@ int prom_setprop(int node, const char *pname, char *value, int size)
 }
 EXPORT_SYMBOL(prom_setprop);
 
-int prom_inst2pkg(int inst)
+phandle prom_inst2pkg(int inst)
 {
-	int node;
+	phandle node;
 	unsigned long flags;
 	
 	spin_lock_irqsave(&prom_lock, flags);
@@ -345,9 +346,10 @@ int prom_inst2pkg(int inst)
 /* Return 'node' assigned to a particular prom 'path'
  * FIXME: Should work for v0 as well
  */
-int prom_pathtoinode(char *path)
+phandle prom_pathtoinode(char *path)
 {
-	int node, inst;
+	phandle node;
+	int inst;
 	
 	inst = prom_devopen (path);
 	if (inst == -1) return 0;
diff --git a/arch/sparc/prom/tree_64.c b/arch/sparc/prom/tree_64.c
index 9d3f913..691be68 100644
--- a/arch/sparc/prom/tree_64.c
+++ b/arch/sparc/prom/tree_64.c
@@ -16,7 +16,7 @@
 #include <asm/oplib.h>
 #include <asm/ldc.h>
 
-static int prom_node_to_node(const char *type, int node)
+static phandle prom_node_to_node(const char *type, phandle node)
 {
 	unsigned long args[5];
 
@@ -28,20 +28,20 @@ static int prom_node_to_node(const char *type, int node)
 
 	p1275_cmd_direct(args);
 
-	return (int) args[4];
+	return (phandle) args[4];
 }
 
 /* Return the child of node 'node' or zero if no this node has no
  * direct descendent.
  */
-inline int __prom_getchild(int node)
+inline phandle __prom_getchild(phandle node)
 {
 	return prom_node_to_node("child", node);
 }
 
-inline int prom_getchild(int node)
+inline phandle prom_getchild(phandle node)
 {
-	int cnode;
+	phandle cnode;
 
 	if (node == -1)
 		return 0;
@@ -52,9 +52,9 @@ inline int prom_getchild(int node)
 }
 EXPORT_SYMBOL(prom_getchild);
 
-inline int prom_getparent(int node)
+inline phandle prom_getparent(phandle node)
 {
-	int cnode;
+	phandle cnode;
 
 	if (node == -1)
 		return 0;
@@ -67,14 +67,14 @@ inline int prom_getparent(int node)
 /* Return the next sibling of node 'node' or zero if no more siblings
  * at this level of depth in the tree.
  */
-inline int __prom_getsibling(int node)
+inline phandle __prom_getsibling(phandle node)
 {
 	return prom_node_to_node(prom_peer_name, node);
 }
 
-inline int prom_getsibling(int node)
+inline phandle prom_getsibling(phandle node)
 {
-	int sibnode;
+	phandle sibnode;
 
 	if (node == -1)
 		return 0;
@@ -89,7 +89,7 @@ EXPORT_SYMBOL(prom_getsibling);
 /* Return the length in bytes of property 'prop' at node 'node'.
  * Return -1 on error.
  */
-inline int prom_getproplen(int node, const char *prop)
+inline int prom_getproplen(phandle node, const char *prop)
 {
 	unsigned long args[6];
 
@@ -113,7 +113,7 @@ EXPORT_SYMBOL(prom_getproplen);
  * 'buffer' which has a size of 'bufsize'.  If the acquisition
  * was successful the length will be returned, else -1 is returned.
  */
-inline int prom_getproperty(int node, const char *prop,
+inline int prom_getproperty(phandle node, const char *prop,
 			    char *buffer, int bufsize)
 {
 	unsigned long args[8];
@@ -141,7 +141,7 @@ EXPORT_SYMBOL(prom_getproperty);
 /* Acquire an integer property and return its value.  Returns -1
  * on failure.
  */
-inline int prom_getint(int node, const char *prop)
+inline int prom_getint(phandle node, const char *prop)
 {
 	int intprop;
 
@@ -156,7 +156,7 @@ EXPORT_SYMBOL(prom_getint);
  * integer.
  */
 
-int prom_getintdefault(int node, const char *property, int deflt)
+int prom_getintdefault(phandle node, const char *property, int deflt)
 {
 	int retval;
 
@@ -169,7 +169,7 @@ int prom_getintdefault(int node, const char *property, int deflt)
 EXPORT_SYMBOL(prom_getintdefault);
 
 /* Acquire a boolean property, 1=TRUE 0=FALSE. */
-int prom_getbool(int node, const char *prop)
+int prom_getbool(phandle node, const char *prop)
 {
 	int retval;
 
@@ -184,7 +184,8 @@ EXPORT_SYMBOL(prom_getbool);
  * string on error.  The char pointer is the user supplied string
  * buffer.
  */
-void prom_getstring(int node, const char *prop, char *user_buf, int ubuf_size)
+void prom_getstring(phandle node, const char *prop, char *user_buf,
+		int ubuf_size)
 {
 	int len;
 
@@ -198,7 +199,7 @@ EXPORT_SYMBOL(prom_getstring);
 /* Does the device at node 'node' have name 'name'?
  * YES = 1   NO = 0
  */
-int prom_nodematch(int node, const char *name)
+int prom_nodematch(phandle node, const char *name)
 {
 	char namebuf[128];
 	prom_getproperty(node, "name", namebuf, sizeof(namebuf));
@@ -210,10 +211,10 @@ int prom_nodematch(int node, const char *name)
 /* Search siblings at 'node_start' for a node with name
  * 'nodename'.  Return node if successful, zero if not.
  */
-int prom_searchsiblings(int node_start, const char *nodename)
+phandle prom_searchsiblings(phandle node_start, const char *nodename)
 {
-
-	int thisnode, error;
+	phandle thisnode;
+	int error;
 	char promlib_buf[128];
 
 	for(thisnode = node_start; thisnode;
@@ -234,7 +235,7 @@ static const char *prom_nextprop_name = "nextprop";
 /* Return the first property type for node 'node'.
  * buffer should be at least 32B in length
  */
-inline char *prom_firstprop(int node, char *buffer)
+inline char *prom_firstprop(phandle node, char *buffer)
 {
 	unsigned long args[7];
 
@@ -260,7 +261,7 @@ EXPORT_SYMBOL(prom_firstprop);
  * at node 'node' .  Returns NULL string if no more
  * property types for this node.
  */
-inline char *prom_nextprop(int node, const char *oprop, char *buffer)
+inline char *prom_nextprop(phandle node, const char *oprop, char *buffer)
 {
 	unsigned long args[7];
 	char buf[32];
@@ -288,8 +289,7 @@ inline char *prom_nextprop(int node, const char *oprop, char *buffer)
 }
 EXPORT_SYMBOL(prom_nextprop);
 
-int
-prom_finddevice(const char *name)
+phandle prom_finddevice(const char *name)
 {
 	unsigned long args[5];
 
@@ -307,7 +307,7 @@ prom_finddevice(const char *name)
 }
 EXPORT_SYMBOL(prom_finddevice);
 
-int prom_node_has_property(int node, const char *prop)
+int prom_node_has_property(phandle node, const char *prop)
 {
 	char buf [32];
         
@@ -325,7 +325,7 @@ EXPORT_SYMBOL(prom_node_has_property);
  * of 'size' bytes.  Return the number of bytes the prom accepted.
  */
 int
-prom_setprop(int node, const char *pname, char *value, int size)
+prom_setprop(phandle node, const char *pname, char *value, int size)
 {
 	unsigned long args[8];
 
@@ -355,10 +355,10 @@ prom_setprop(int node, const char *pname, char *value, int size)
 }
 EXPORT_SYMBOL(prom_setprop);
 
-inline int prom_inst2pkg(int inst)
+inline phandle prom_inst2pkg(int inst)
 {
 	unsigned long args[5];
-	int node;
+	phandle node;
 	
 	args[0] = (unsigned long) "instance-to-package";
 	args[1] = 1;
@@ -377,10 +377,10 @@ inline int prom_inst2pkg(int inst)
 /* Return 'node' assigned to a particular prom 'path'
  * FIXME: Should work for v0 as well
  */
-int
-prom_pathtoinode(const char *path)
+phandle prom_pathtoinode(const char *path)
 {
-	int node, inst;
+	phandle node;
+	int inst;
 
 	inst = prom_devopen (path);
 	if (inst == 0)
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 4942050..5139371 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -459,7 +459,7 @@ static int jsflash_init(void)
 {
 	int rc;
 	struct jsflash *jsf;
-	int node;
+	phandle node;
 	char banner[128];
 	struct linux_prom_registers reg0;
 
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index f8d69ad..5bf9123 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2970,7 +2970,8 @@ static int __devinit atyfb_setup_sparc(struct pci_dev *pdev,
 	struct atyfb_par *par = info->par;
 	struct device_node *dp;
 	char prop[128];
-	int node, len, i, j, ret;
+	phandle node;
+	int len, i, j, ret;
 	u32 mem, chip_id;
 
 	/*
-- 
1.5.6.5

