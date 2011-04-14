Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1DNSaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:30:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:37967 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab1DNRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Alok Kataria <akataria@vmware.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 042/209] xen: don't bother to stop other cpus on shutdown/reboot
Date: Thu, 14 Apr 2011 13:41:12 -0400
Message-Id: <1302803039-9400-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/enlighten.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4d32089..25d787c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
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
-- 
1.7.4.4

