Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762568Ab2FVQPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:15:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762509Ab2FVQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336363200"; 
   d="scan'208";a="199722616"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <tim@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH WIP 5/6] xen: fix unmask_evtchn for HVM guests
Date: Fri, 22 Jun 2012 17:14:44 +0100
Message-ID: <1340381685-22529-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmask_evtchn is called, if we already have an event pending, we
just set evtchn_pending_sel waiting for irq to be re-enabled. That is
because x86 pv guests overwrite the irq_enable pvops with
xen_irq_enable_direct that also handles pending events.

However x86 HVM guests and ARM guests do not change or do not have the
irq_enable pvop, so this scheme doesn't work properly for them.
Considering that having a pending irq when unmask_evtchn is called is
not very common, and it is better to keep the native_irq_enable
implementation for HVM guests and ARM guests, the best thing to do is
just using the EVTCHNOP_unmask callback (Xen re-injects pending
events in response).

Considering that this patch fixes a bug on x86 for current PV on HVM
guests, I'll resend it separately.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index eae0d0b..0132505 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -372,8 +372,11 @@ static void unmask_evtchn(int port)
 
 	BUG_ON(!irqs_disabled());
 
-	/* Slow path (hypercall) if this is a non-local port. */
-	if (unlikely(cpu != cpu_from_evtchn(port))) {
+	/* Slow path (hypercall) if this is a non-local port or if this is
+	 * an hvm domain and an event is pending (hvm domains don't have
+	 * their own implementation of irq_enable). */
+	if (unlikely((cpu != cpu_from_evtchn(port)) ||
+			(xen_hvm_domain() && sync_test_bit(port, &s->evtchn_pending[0])))) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	} else {
-- 
1.7.2.5

