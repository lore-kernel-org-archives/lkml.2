Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234Ab2FVQ0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:26:32 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45046 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2FVQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:26:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336348800"; 
   d="scan'208";a="13175139"
Date: Fri, 22 Jun 2012 17:26:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/events: fix unmask_evtchn for PV on HVM guests
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmask_evtchn is called, if we already have an event pending, we
just set evtchn_pending_sel waiting for local_irq_enable to be called.
That is because PV guests set the irq_enable pvops to
xen_irq_enable_direct that also handles pending events.

However HVM guests (and ARM guests) do not change or do not have the
irq_enable pvop, so evtchn_unmask cannot work properly for them.

Considering that having the pending_irq bit set when unmask_evtchn is
called is not very common, and it is simpler to keep the
native_irq_enable implementation for HVM guests (and ARM guests), the
best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
re-injects pending events in response).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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
