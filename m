Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0LHCQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:16:38 -0500
Received: from kroah.org ([198.145.64.141]:45981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab0LHAqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:54 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.261053308@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Alok Kataria <akataria@vmware.com>
Subject: [029/127] xen: dont bother to stop other cpus on shutdown/reboot
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/x86/xen/enlighten.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -997,10 +997,6 @@ static void xen_reboot(int reason)
 {
 	struct sched_shutdown r = { .reason = reason };
 
-#ifdef CONFIG_SMP
-	stop_other_cpus();
-#endif
-
 	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
 		BUG();
 }


