Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2GWBqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:46:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54502 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab2GWBnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:50 -0400
Message-Id: <20120723010654.723525227@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>
Subject: [ 021/108] KVM: Fix buffer overflow in kvm_set_irq()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

commit f2ebd422f71cda9c791f76f85d2ca102ae34a1ed upstream.

kvm_set_irq() has an internal buffer of three irq routing entries, allowing
connecting a GSI to three IRQ chips or on MSI.  However setup_routing_entry()
does not properly enforce this, allowing three irqchip routes followed by
an MSI route to overflow the buffer.

Fix by ensuring that an MSI entry is added to an empty list.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/irq_comm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a6a0365..5afb431 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -332,6 +332,7 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
 	 */
 	hlist_for_each_entry(ei, n, &rt->map[ue->gsi], link)
 		if (ei->type == KVM_IRQ_ROUTING_MSI ||
+		    ue->type == KVM_IRQ_ROUTING_MSI ||
 		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
 			return r;
 


