Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2HVQUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:20:32 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35720 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab2HVQUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:20:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336363200"; 
   d="scan'208";a="35465042"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/6] xen/events: fix unmask_evtchn for PV on HVM guests
Date: Wed, 22 Aug 2012 17:20:11 +0100
Message-ID: <1345652416-27181-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmask_evtchn is called, if we already have an event pending, we
just set evtchn_pending_sel waiting for local_irq_enable to be called.
That is because PV guests set the irq_enable pvops to
xen_irq_enable_direct in xen_setup_vcpu_info_placement:
xen_irq_enable_direct is implemented in assembly in
arch/x86/xen/xen-asm.S and call xen_force_evtchn_callback if
XEN_vcpu_info_pending is set.

However HVM guests (and ARM guests) do not change or do not have the
irq_enable pvop, so evtchn_unmask cannot work properly for them.

Considering that having the pending_irq bit set when unmask_evtchn is
called is not very common, and it is simpler to keep the
native_irq_enable implementation for HVM guests (and ARM guests), the
best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
re-injects pending events in response).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7595581..36bf17d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -373,11 +373,22 @@ static void unmask_evtchn(int port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
 	unsigned int cpu = get_cpu();
+	int do_hypercall = 0, evtchn_pending = 0;
 
 	BUG_ON(!irqs_disabled());
 
-	/* Slow path (hypercall) if this is a non-local port. */
-	if (unlikely(cpu != cpu_from_evtchn(port))) {
+	if (unlikely((cpu != cpu_from_evtchn(port))))
+		do_hypercall = 1;
+	else
+		evtchn_pending = sync_test_bit(port, &s->evtchn_pending[0]);
+
+	if (unlikely(evtchn_pending && xen_hvm_domain()))
+		do_hypercall = 1;
+
+	/* Slow path (hypercall) if this is a non-local port or if this is
+	 * an hvm domain and an event is pending (hvm domains don't have
+	 * their own implementation of irq_enable). */
+	if (do_hypercall) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	} else {
@@ -390,7 +401,7 @@ static void unmask_evtchn(int port)
 		 * 'hw_resend_irq'. Just like a real IO-APIC we 'lose
 		 * the interrupt edge' if the channel is masked.
 		 */
-		if (sync_test_bit(port, &s->evtchn_pending[0]) &&
+		if (evtchn_pending &&
 		    !sync_test_and_set_bit(port / BITS_PER_LONG,
 					   &vcpu_info->evtchn_pending_sel))
 			vcpu_info->evtchn_upcall_pending = 1;
-- 
1.7.2.5

