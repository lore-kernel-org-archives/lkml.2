Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab2EDUo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:44:27 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab2EDUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:44:23 -0400
Message-Id: <20120504204225.311017362@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 11/75] xen: correctly check for pending events when restoring irq flags
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/x86/xen/xen-asm.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


