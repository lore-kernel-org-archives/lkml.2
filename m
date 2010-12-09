Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0LIVAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:00:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64030 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0LIVAx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 9 Dec 2010 16:00:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/irq: Don't fall over when nr_irqs_gsi > nr_irqs.
Date: Thu,  9 Dec 2010 16:01:37 -0500
Message-Id: <1291928497-5599-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
References: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This scenario where the nr_irq_gsi is greater than nr_irqs
is rather strange but lets still try to survive. Make sure
to print a warning so the user wouldn't be surprised in case
things don't work.

Solves a bootup-crash when booting Xen and Linux under QEMU.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4d4a23d..11687dd 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -411,6 +411,7 @@ static int find_unbound_irq(void)
 	if (bottom == nr_irqs)
 		goto no_irqs;
 
+retry:
 	/* This loop starts from the top of IRQ space and goes down.
 	 * We need this b/c if we have a PCI device in a Xen PV guest
 	 * we do not have an IO-APIC (though the backend might have them)
@@ -434,6 +435,14 @@ static int find_unbound_irq(void)
 		goto no_irqs;
 
 	res = irq_alloc_desc_at(irq, -1);
+	if (res == -EEXIST) {
+		top--;
+		if (bottom > top)
+			printk(KERN_ERR "Eating in GSI/MSI space (%ld)!" \
+				" Your PCI device might not work!\n", top);
+		if (top > NR_IRQS_LEGACY)
+			goto retry;
+	}
 
 	if (WARN_ON(res != irq))
 		return -1;
-- 
1.7.1

