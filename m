Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972Ab2E0BTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:19:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35469 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2E0BTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:38 -0400
Message-Id: <20120527002522.601392563@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:18 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 72/91] xen: do not map the same GSI twice in PVHVM guests.
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 68c2c39a76b094e9b2773e5846424ea674bf2c46 upstream.

PV on HVM guests map GSIs into event channels. At restore time the
event channels are resumed by restore_pirqs.

Device drivers might try to register the same GSI again through ACPI at
restore time, but the GSI has already been mapped and bound by
restore_pirqs. This patch detects these situations and avoids
 mapping the same GSI multiple times.

Without this patch we get:
(XEN) irq.c:2235: dom4: pirq 23 or emuirq 28 already mapped
and waste a pirq.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/xen.c   |    4 ++++
 drivers/xen/events.c |    5 +++--
 include/xen/events.h |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -64,6 +64,10 @@ static int xen_register_pirq(u32 gsi, in
 	int shareable = 0;
 	char *name;
 
+	irq = xen_irq_from_gsi(gsi);
+	if (irq > 0)
+		return irq;
+
 	if (set_pirq)
 		pirq = gsi;
 
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -611,7 +611,7 @@ static void disable_pirq(struct irq_data
 	disable_dynirq(data);
 }
 
-static int find_irq_by_gsi(unsigned gsi)
+int xen_irq_from_gsi(unsigned gsi)
 {
 	struct irq_info *info;
 
@@ -625,6 +625,7 @@ static int find_irq_by_gsi(unsigned gsi)
 
 	return -1;
 }
+EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 
 /*
  * Do not make any assumptions regarding the relationship between the
@@ -644,7 +645,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = find_irq_by_gsi(gsi);
+	irq = xen_irq_from_gsi(gsi);
 	if (irq != -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -103,6 +103,9 @@ int xen_irq_from_pirq(unsigned pirq);
 /* Return the pirq allocated to the irq. */
 int xen_pirq_from_irq(unsigned irq);
 
+/* Return the irq allocated to the gsi */
+int xen_irq_from_gsi(unsigned gsi);
+
 /* Determine whether to ignore this IRQ if it is passed to a guest. */
 int xen_test_irq_shared(int irq);
 


