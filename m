Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0I1MRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:37 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47172 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0I1MRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:35 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729377"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 09/12] xen: make hvc_xen console work for dom0.
Date: Tue, 28 Sep 2010 13:16:55 +0100
Message-Id: <1285676218-26218-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:16.0870 (UTC) FILETIME=[17312E60:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use the console hypercalls for dom0 console.

[ Impact: Add Xen dom0 console ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/char/hvc_xen.c |   98 ++++++++++++++++++++++++++++++++----------------
 drivers/xen/events.c   |    2 +-
 include/xen/events.h   |    1 +
 3 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index 60446f8..cc21c97 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -78,7 +78,7 @@ static int __write_console(const char *data, int len)
 	return sent;
 }
 
-static int write_console(uint32_t vtermno, const char *data, int len)
+static int domU_write_console(uint32_t vtermno, const char *data, int len)
 {
 	int ret = len;
 
@@ -101,7 +101,7 @@ static int write_console(uint32_t vtermno, const char *data, int len)
 	return ret;
 }
 
-static int read_console(uint32_t vtermno, char *buf, int len)
+static int domU_read_console(uint32_t vtermno, char *buf, int len)
 {
 	struct xencons_interface *intf = xencons_interface();
 	XENCONS_RING_IDX cons, prod;
@@ -122,28 +122,62 @@ static int read_console(uint32_t vtermno, char *buf, int len)
 	return recv;
 }
 
-static const struct hv_ops hvc_ops = {
-	.get_chars = read_console,
-	.put_chars = write_console,
+static struct hv_ops domU_hvc_ops = {
+	.get_chars = domU_read_console,
+	.put_chars = domU_write_console,
 	.notifier_add = notifier_add_irq,
 	.notifier_del = notifier_del_irq,
 	.notifier_hangup = notifier_hangup_irq,
 };
 
-static int __init xen_init(void)
+static int dom0_read_console(uint32_t vtermno, char *buf, int len)
+{
+	return HYPERVISOR_console_io(CONSOLEIO_read, len, buf);
+}
+
+/*
+ * Either for a dom0 to write to the system console, or a domU with a
+ * debug version of Xen
+ */
+static int dom0_write_console(uint32_t vtermno, const char *str, int len)
+{
+	int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
+	if (rc < 0)
+		return 0;
+
+	return len;
+}
+
+static struct hv_ops dom0_hvc_ops = {
+	.get_chars = dom0_read_console,
+	.put_chars = dom0_write_console,
+	.notifier_add = notifier_add_irq,
+	.notifier_del = notifier_del_irq,
+	.notifier_hangup = notifier_hangup_irq,
+};
+
+static int __init xen_hvc_init(void)
 {
 	struct hvc_struct *hp;
+	struct hv_ops *ops;
 
-	if (!xen_pv_domain() ||
-	    xen_initial_domain() ||
-	    !xen_start_info->console.domU.evtchn)
+	if (!xen_pv_domain())
 		return -ENODEV;
 
-	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+	if (xen_initial_domain()) {
+		ops = &dom0_hvc_ops;
+		xencons_irq = bind_virq_to_irq(VIRQ_CONSOLE, 0);
+	} else {
+		if (!xen_start_info->console.domU.evtchn)
+			return -ENODEV;
+
+		ops = &domU_hvc_ops;
+		xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+	}
 	if (xencons_irq < 0)
 		xencons_irq = 0; /* NO_IRQ */
 
-	hp = hvc_alloc(HVC_COOKIE, xencons_irq, &hvc_ops, 256);
+	hp = hvc_alloc(HVC_COOKIE, xencons_irq, ops, 256);
 	if (IS_ERR(hp))
 		return PTR_ERR(hp);
 
@@ -160,7 +194,7 @@ void xen_console_resume(void)
 		rebind_evtchn_irq(xen_start_info->console.domU.evtchn, xencons_irq);
 }
 
-static void __exit xen_fini(void)
+static void __exit xen_hvc_fini(void)
 {
 	if (hvc)
 		hvc_remove(hvc);
@@ -168,29 +202,24 @@ static void __exit xen_fini(void)
 
 static int xen_cons_init(void)
 {
+	struct hv_ops *ops;
+
 	if (!xen_pv_domain())
 		return 0;
 
-	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
+	if (xen_initial_domain())
+		ops = &dom0_hvc_ops;
+	else
+		ops = &domU_hvc_ops;
+
+	hvc_instantiate(HVC_COOKIE, 0, ops);
 	return 0;
 }
 
-module_init(xen_init);
-module_exit(xen_fini);
+module_init(xen_hvc_init);
+module_exit(xen_hvc_fini);
 console_initcall(xen_cons_init);
 
-static void raw_console_write(const char *str, int len)
-{
-	while(len > 0) {
-		int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
-		if (rc <= 0)
-			break;
-
-		str += rc;
-		len -= rc;
-	}
-}
-
 #ifdef CONFIG_EARLY_PRINTK
 static void xenboot_write_console(struct console *console, const char *string,
 				  unsigned len)
@@ -198,19 +227,22 @@ static void xenboot_write_console(struct console *console, const char *string,
 	unsigned int linelen, off = 0;
 	const char *pos;
 
-	raw_console_write(string, len);
+	dom0_write_console(0, string, len);
+
+	if (xen_initial_domain())
+		return;
 
-	write_console(0, "(early) ", 8);
+	dumU_write_console(0, "(early) ", 8);
 	while (off < len && NULL != (pos = strchr(string+off, '\n'))) {
 		linelen = pos-string+off;
 		if (off + linelen > len)
 			break;
-		write_console(0, string+off, linelen);
-		write_console(0, "\r\n", 2);
+		dumU_write_console(0, string+off, linelen);
+		dumU_write_console(0, "\r\n", 2);
 		off += linelen + 1;
 	}
 	if (off < len)
-		write_console(0, string+off, len-off);
+		dumU_write_console(0, string+off, len-off);
 }
 
 struct console xenboot_console = {
@@ -222,7 +254,7 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	raw_console_write(str, strlen(str));
+	dom0_write_console(str, strlen(str));
 }
 
 void xen_raw_printk(const char *fmt, ...)
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index b83918a..90744d5 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -832,7 +832,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 }
 
 
-static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
+int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_bind_virq bind_virq;
 	int evtchn, irq;
diff --git a/include/xen/events.h b/include/xen/events.h
index 8cd18a5..3d2b0af 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -12,6 +12,7 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,
 			      void *dev_id);
+int bind_virq_to_irq(unsigned int virq, unsigned int cpu);
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname,
-- 
1.5.6.5

