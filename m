Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2E1Dat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:30:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab2E1D3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:55 -0400
Message-Id: <20120528031216.233571155@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 097/117] xen: do not map the same GSI twice in PVHVM guests.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/pci/xen.c   |    4 ++++
 drivers/xen/events.c |    5 +++--
 include/xen/events.h |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 7415aa9..56ab749 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -64,6 +64,10 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
 	int shareable = 0;
 	char *name;
 
+	irq = xen_irq_from_gsi(gsi);
+	if (irq > 0)
+		return irq;
+
 	if (set_pirq)
 		pirq = gsi;
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4b33acd..faae2f9 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -611,7 +611,7 @@ static void disable_pirq(struct irq_data *data)
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
@@ -644,7 +645,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = find_irq_by_gsi(gsi);
+	irq = xen_irq_from_gsi(gsi);
 	if (irq != -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
diff --git a/include/xen/events.h b/include/xen/events.h
index 0f77370..04399b2 100644
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
 


