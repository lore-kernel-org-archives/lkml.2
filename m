Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0LAS1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:27:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13052 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0LAS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:27:47 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288584000"; 
   d="scan'208";a="124875757"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/2] hvc_xen: support PV on HVM consoles
Date: Wed,  1 Dec 2010 18:26:41 +0000
Message-Id: <1291228002-15309-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
X-OriginalArrivalTime: 01 Dec 2010 18:26:53.0793 (UTC) FILETIME=[541B1510:01CB9185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/char/hvc_xen.c             |   79 +++++++++++++++++++++++++++++------
 include/xen/interface/hvm/params.h |    6 ++-
 2 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index 3740e32..dfcd939 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -24,9 +24,12 @@
 #include <linux/init.h>
 #include <linux/types.h>
 
+#include <asm/io.h>
 #include <asm/xen/hypervisor.h>
 
 #include <xen/xen.h>
+#include <xen/interface/xen.h>
+#include <xen/hvm.h>
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
@@ -42,9 +45,13 @@ static int xencons_irq;
 /* ------------------------------------------------------------------ */
 
 static unsigned long console_pfn = ~0ul;
+static unsigned int console_evtchn = ~0;
+static struct xencons_interface *xencons_if = NULL;
 
 static inline struct xencons_interface *xencons_interface(void)
 {
+	if (xencons_if != NULL)
+		return xencons_if;
 	if (console_pfn == ~0ul)
 		return mfn_to_virt(xen_start_info->console.domU.mfn);
 	else
@@ -54,7 +61,10 @@ static inline struct xencons_interface *xencons_interface(void)
 static inline void notify_daemon(void)
 {
 	/* Use evtchn: this is called early, before irq is set up. */
-	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
+	if (console_evtchn == ~0ul)
+		notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
+	else
+		notify_remote_via_evtchn(console_evtchn);
 }
 
 static int __write_console(const char *data, int len)
@@ -157,26 +167,63 @@ static struct hv_ops dom0_hvc_ops = {
 	.notifier_hangup = notifier_hangup_irq,
 };
 
+static int xen_hvm_console_init(void)
+{
+	int r;
+	uint64_t v = 0;
+	unsigned long mfn;
+
+	if (!xen_hvm_domain())
+		return -ENODEV;
+
+	if (xencons_if != NULL)
+		return -EBUSY;
+
+	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
+	if (r < 0)
+		return -ENODEV;
+	console_evtchn = v;
+	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
+	if (r < 0)
+		return -ENODEV;
+	mfn = v;
+	xencons_if = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
+	if (xencons_if == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
 static int __init xen_hvc_init(void)
 {
 	struct hvc_struct *hp;
 	struct hv_ops *ops;
+	int r;
 
-	if (!xen_pv_domain())
+	if (!xen_domain())
+		return -ENODEV;
+
+	if (xen_pv_domain() && !xen_initial_domain() &&
+			!xen_start_info->console.domU.evtchn)
 		return -ENODEV;
 
 	if (xen_initial_domain()) {
 		ops = &dom0_hvc_ops;
 		xencons_irq = bind_virq_to_irq(VIRQ_CONSOLE, 0);
 	} else {
-		if (!xen_start_info->console.domU.evtchn)
-			return -ENODEV;
-
 		ops = &domU_hvc_ops;
-		xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+		if (xen_pv_domain()) {
+			console_pfn = mfn_to_pfn(xen_start_info->console.domU.mfn);
+			console_evtchn = xen_start_info->console.domU.evtchn;
+		} else {
+			r = xen_hvm_console_init();
+			if (r < 0)
+				return r;
+		}
+		xencons_irq = bind_evtchn_to_irq(console_evtchn);
+		if (xencons_irq < 0)
+			xencons_irq = 0; /* NO_IRQ */
 	}
-	if (xencons_irq < 0)
-		xencons_irq = 0; /* NO_IRQ */
 
 	hp = hvc_alloc(HVC_COOKIE, xencons_irq, ops, 256);
 	if (IS_ERR(hp))
@@ -184,15 +231,13 @@ static int __init xen_hvc_init(void)
 
 	hvc = hp;
 
-	console_pfn = mfn_to_pfn(xen_start_info->console.domU.mfn);
-
 	return 0;
 }
 
 void xen_console_resume(void)
 {
 	if (xencons_irq)
-		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
+		rebind_evtchn_irq(console_evtchn, xencons_irq);
 }
 
 static void __exit xen_hvc_fini(void)
@@ -203,16 +248,22 @@ static void __exit xen_hvc_fini(void)
 
 static int xen_cons_init(void)
 {
-	struct hv_ops *ops;
+	const struct hv_ops *ops;
 
-	if (!xen_pv_domain())
+	if (!xen_domain())
 		return 0;
 
 	if (xen_initial_domain())
 		ops = &dom0_hvc_ops;
-	else
+	else {
 		ops = &domU_hvc_ops;
 
+		if (xen_pv_domain())
+			console_evtchn = xen_start_info->console.domU.evtchn;
+		else
+			xen_hvm_console_init();
+	}
+
 	hvc_instantiate(HVC_COOKIE, 0, ops);
 	return 0;
 }
diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index 1888d8c..1b4f923 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -90,6 +90,10 @@
 /* Boolean: Enable aligning all periodic vpts to reduce interrupts */
 #define HVM_PARAM_VPT_ALIGN    16
 
-#define HVM_NR_PARAMS          17
+/* Console debug shared memory ring and event channel */
+#define HVM_PARAM_CONSOLE_PFN    17
+#define HVM_PARAM_CONSOLE_EVTCHN 18
+
+#define HVM_NR_PARAMS          19
 
 #endif /* __XEN_PUBLIC_HVM_PARAMS_H__ */
-- 
1.5.6.5

