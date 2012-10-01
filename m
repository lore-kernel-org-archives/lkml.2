Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab2JAXAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:34 -0400
Received: from 1wt.eu ([62.212.114.60]:35169 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab2JAXAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:30 -0400
Message-Id: <20121001225203.673011691@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 143/180] xen: correctly check for pending events when restoring irq flags
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/xen/xen-asm.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.2.1.45.g54fbc



