Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab1CIRnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:43:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab1CIRli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432599"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 04/14] xen: events: remove unused public functions
Date: Wed,  9 Mar 2011 17:41:16 +0000
Message-Id: <1299692486-28634-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:38.0118 (UTC) FILETIME=[3DEB7660:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was unable to find any user of these functions in either the
functionality pending for 2.6.39 or the xen/next-2.6.32 branch of
xen.git

An exception to this was xen_gsi_from_irq which did appear to be used
in xen/next-2.6.32's pciback. However in the 2.6.39 version of pciback
xen_pirq_from_irq is, correctly AFAICT, used instead.

Only a minority of functions in events.h use "extern" so drop it from
those places for consistency.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   20 --------------------
 include/xen/events.h |   12 +++---------
 2 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a9c154d..d52defd 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -222,16 +222,6 @@ static unsigned gsi_from_irq(unsigned irq)
 	return info->u.pirq.gsi;
 }
 
-static unsigned vector_from_irq(unsigned irq)
-{
-	struct irq_info *info = info_for_irq(irq);
-
-	BUG_ON(info == NULL);
-	BUG_ON(info->type != IRQT_PIRQ);
-
-	return info->u.pirq.vector;
-}
-
 static enum xen_irq_type type_from_irq(unsigned irq)
 {
 	return info_for_irq(irq)->type;
@@ -716,16 +706,6 @@ out:
 	return rc;
 }
 
-int xen_vector_from_irq(unsigned irq)
-{
-	return vector_from_irq(irq);
-}
-
-int xen_gsi_from_irq(unsigned irq)
-{
-	return gsi_from_irq(irq);
-}
-
 int xen_irq_from_pirq(unsigned pirq)
 {
 	return pirq_to_irq[pirq];
diff --git a/include/xen/events.h b/include/xen/events.h
index f6fed94..99a64f0 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -41,9 +41,9 @@ static inline void notify_remote_via_evtchn(int port)
 	(void)HYPERVISOR_event_channel_op(EVTCHNOP_send, &send);
 }
 
-extern void notify_remote_via_irq(int irq);
+void notify_remote_via_irq(int irq);
 
-extern void xen_irq_resume(void);
+void xen_irq_resume(void);
 
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
@@ -62,7 +62,7 @@ void xen_poll_irq_timeout(int irq, u64 timeout);
 unsigned irq_from_evtchn(unsigned int evtchn);
 
 /* Xen HVM evtchn vector callback */
-extern void xen_hvm_callback_vector(void);
+void xen_hvm_callback_vector(void);
 extern int xen_have_vector_callback;
 int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
@@ -81,12 +81,6 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
 
-/* Return vector allocated to pirq */
-int xen_vector_from_irq(unsigned pirq);
-
-/* Return gsi allocated to pirq */
-int xen_gsi_from_irq(unsigned pirq);
-
 /* Return irq from pirq */
 int xen_irq_from_pirq(unsigned pirq);
 
-- 
1.5.6.5

