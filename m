Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0LMAQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:16:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0LLXqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:20 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: ian.campbell@citrix.com, jeremy@goop.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [80/223] xen: ensure that all event channels start off bound to VCPU 0
Message-Id: <20101212234619.5D10BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ian Campbell <ian.campbell@citrix.com>

commit b0097adeec27e30223c989561ab0f7aa60d1fe93 upstream.

All event channels startbound to VCPU 0 so ensure that cpu_evtchn_mask
is initialised to reflect this. Otherwise there is a race after registering an
event channel but before the affinity is explicitly set where the event channel
can be delivered. If this happens then the event channel remains pending in the
L1 (evtchn_pending) array but is cleared in L2 (evtchn_pending_sel), this means
the event channel cannot be reraised until another event channel happens to
trigger the same L2 entry on that VCPU.

sizeof(cpu_evtchn_mask(0))==sizeof(unsigned long*) which is not correct, and
causes only the first 32 or 64 event channels (depending on architecture) to be
initially bound to VCPU0. Use sizeof(struct cpu_evtchn_s) instead.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/xen/events.c
===================================================================
--- linux.orig/drivers/xen/events.c
+++ linux/drivers/xen/events.c
@@ -256,7 +256,7 @@ static void init_evtchn_cpu_bindings(voi
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
 }
 
 static inline void clear_evtchn(int port)
