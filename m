Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2EIFzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:55:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756891Ab2EIFx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:57 -0400
Message-Id: <20120509055043.039869687@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 096/167] [PATCH] xen: correctly check for pending events when restoring irq
 flags
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 7eb7ce4d2e8991aff4ecb71a81949a907ca755ac upstream.

In xen_restore_fl_direct(), xen_force_evtchn_callback() was being
called even if no events were pending.  This resulted in (depending on
workload) about a 100 times as many xen_version hypercalls as
necessary.

Fix this by correcting the sense of the conditional jump.

This seems to give a significant performance benefit for some
workloads.

There is some subtle tricksy "..since the check here is trying to
check both pending and masked in a single cmpw, but I think this is
correct. It will call check_events now only when the combined
mask+pending word is 0x0001 (aka unmasked, pending)." (Ian)

Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/xen-asm.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 79d7362..3e45aa0 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -96,7 +96,7 @@ ENTRY(xen_restore_fl_direct)
 
 	/* check for unmasked and pending */
 	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
-	jz 1f
+	jnz 1f
 2:	call check_events
 1:
 ENDPATCH(xen_restore_fl_direct)
-- 
1.7.10



