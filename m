Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0LMAQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:16:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0LLXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:21 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jeremy.fitzhardinge@citrix.com, akataria@vmware.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [81/223] xen: don't bother to stop other cpus on shutdown/reboot
Message-Id: <20101212234620.6B47AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 31e323cca9d5c8afd372976c35a5d46192f540d1 upstream.

Xen will shoot all the VCPUs when we do a shutdown hypercall, so there's
no need to do it manually.

In any case it will fail because all the IPI irqs have been pulled
down by this point, so the cross-CPU calls will simply hang forever.

Until change 76fac077db6b34e2c6383a7b4f3f4f7b7d06d8ce the function calls
were not synchronously waited for, so this wasn't apparent.  However after
that change the calls became synchronous leading to a hang on shutdown
on multi-VCPU guests.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/xen/enlighten.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/x86/xen/enlighten.c
===================================================================
--- linux.orig/arch/x86/xen/enlighten.c
+++ linux/arch/x86/xen/enlighten.c
@@ -1000,10 +1000,6 @@ static void xen_reboot(int reason)
 {
 	struct sched_shutdown r = { .reason = reason };
 
-#ifdef CONFIG_SMP
-	stop_other_cpus();
-#endif
-
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
 		BUG();
 }
