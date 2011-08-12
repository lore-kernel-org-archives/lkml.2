Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1HNQJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab1HNQJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.419347511@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [72/90] sparc: Set reboot-cmd using reboot data hypervisor call if available.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit ea5e7447ea9d555558e0f13798f5143dd51a915a ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/hypervisor.h |    7 +++++++
 arch/sparc/kernel/ds.c              |   30 ++++++++++++++++++++++++++++--
 arch/sparc/kernel/hvcalls.S         |    7 +++++++
 arch/sparc/kernel/kernel.h          |    9 +++++++++
 arch/sparc/kernel/sstate.c          |    9 ++-------
 5 files changed, 53 insertions(+), 9 deletions(-)

--- a/arch/sparc/include/asm/hypervisor.h
+++ b/arch/sparc/include/asm/hypervisor.h
@@ -2927,6 +2927,13 @@ extern unsigned long sun4v_ncs_request(u
 #define HV_FAST_FIRE_GET_PERFREG	0x120
 #define HV_FAST_FIRE_SET_PERFREG	0x121
 
+#define HV_FAST_REBOOT_DATA_SET		0x172
+
+#ifndef __ASSEMBLY__
+extern unsigned long sun4v_reboot_data_set(unsigned long ra,
+					   unsigned long len);
+#endif
+
 /* Function numbers for HV_CORE_TRAP.  */
 #define HV_CORE_SET_VER			0x00
 #define HV_CORE_PUTCHAR			0x01
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -15,12 +15,15 @@
 #include <linux/reboot.h>
 #include <linux/cpu.h>
 
+#include <asm/hypervisor.h>
 #include <asm/ldc.h>
 #include <asm/vio.h>
 #include <asm/mdesc.h>
 #include <asm/head.h>
 #include <asm/irq.h>
 
+#include "kernel.h"
+
 #define DRV_MODULE_NAME		"ds"
 #define PFX DRV_MODULE_NAME	": "
 #define DRV_MODULE_VERSION	"1.0"
@@ -828,18 +831,32 @@ void ldom_set_var(const char *var, const
 	}
 }
 
+static char full_boot_str[256] __attribute__((aligned(32)));
+static int reboot_data_supported;
+
 void ldom_reboot(const char *boot_command)
 {
 	/* Don't bother with any of this if the boot_command
 	 * is empty.
 	 */
 	if (boot_command && strlen(boot_command)) {
-		char full_boot_str[256];
+		unsigned long len;
 
 		strcpy(full_boot_str, "boot ");
 		strcpy(full_boot_str + strlen("boot "), boot_command);
+		len = strlen(full_boot_str);
 
-		ldom_set_var("reboot-command", full_boot_str);
+		if (reboot_data_supported) {
+			unsigned long ra = kimage_addr_to_ra(full_boot_str);
+			unsigned long hv_ret;
+
+			hv_ret = sun4v_reboot_data_set(ra, len);
+			if (hv_ret != HV_EOK)
+				pr_err("SUN4V: Unable to set reboot data "
+				       "hv_ret=%lu\n", hv_ret);
+		} else {
+			ldom_set_var("reboot-command", full_boot_str);
+		}
 	}
 	sun4v_mach_sir();
 }
@@ -1237,6 +1254,15 @@ static struct vio_driver ds_driver = {
 
 static int __init ds_init(void)
 {
+	unsigned long hv_ret, major, minor;
+
+	hv_ret = sun4v_get_version(HV_GRP_REBOOT_DATA, &major, &minor);
+	if (hv_ret == HV_EOK) {
+		pr_info("SUN4V: Reboot data supported (maj=%lu,min=%lu).\n",
+			major, minor);
+		reboot_data_supported = 1;
+	}
+
 	kthread_run(ds_thread, NULL, "kldomd");
 
 	return vio_register_driver(&ds_driver);
--- a/arch/sparc/kernel/hvcalls.S
+++ b/arch/sparc/kernel/hvcalls.S
@@ -798,3 +798,10 @@ ENTRY(sun4v_niagara2_setperf)
 	retl
 	 nop
 ENDPROC(sun4v_niagara2_setperf)
+
+ENTRY(sun4v_reboot_data_set)
+	mov	HV_FAST_REBOOT_DATA_SET, %o5
+	ta	HV_FAST_TRAP
+	retl
+	 nop
+ENDPROC(sun4v_reboot_data_set)
--- a/arch/sparc/kernel/kernel.h
+++ b/arch/sparc/kernel/kernel.h
@@ -4,6 +4,8 @@
 #include <linux/interrupt.h>
 
 #include <asm/traps.h>
+#include <asm/head.h>
+#include <asm/io.h>
 
 /* cpu.c */
 extern const char *sparc_pmu_type;
@@ -14,6 +16,13 @@ extern int ncpus_probed;
 /* setup_64.c */
 struct seq_file;
 extern void cpucap_info(struct seq_file *);
+
+static inline unsigned long kimage_addr_to_ra(const char *p)
+{
+	unsigned long val = (unsigned long) p;
+
+	return kern_base + (val - KERNBASE);
+}
 #endif
 
 #ifdef CONFIG_SPARC32
--- a/arch/sparc/kernel/sstate.c
+++ b/arch/sparc/kernel/sstate.c
@@ -14,14 +14,9 @@
 #include <asm/head.h>
 #include <asm/io.h>
 
-static int hv_supports_soft_state;
-
-static unsigned long kimage_addr_to_ra(const char *p)
-{
-	unsigned long val = (unsigned long) p;
+#include "kernel.h"
 
-	return kern_base + (val - KERNBASE);
-}
+static int hv_supports_soft_state;
 
 static void do_set_sstate(unsigned long state, const char *msg)
 {


