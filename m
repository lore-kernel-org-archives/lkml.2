Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0JEMu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:50:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15680 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0JEMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:50:56 -0400
X-IronPort-AV: E=Sophos;i="4.57,284,1283745600"; 
   d="scan'208";a="116690266"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] xen: do not initialize PV timers on HVM if !xen_have_vector_callback
Date: Tue,  5 Oct 2010 13:50:58 +0100
Message-Id: <1286283058-12011-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010051243300.2440@kaball-desktop>
References: <alpine.DEB.2.00.1010051243300.2440@kaball-desktop>
X-OriginalArrivalTime: 05 Oct 2010 12:50:36.0674 (UTC) FILETIME=[E80F4E20:01CB648B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

if !xen_have_vector_callback do not initialize PV timer unconditionally
because we still don't know how many cpus are available and if there is
more than one we won't be able to receive the timer interrupts on
cpu > 0.

This patch fixes an hang at boot when Xen does not support vector
callbacks and the guest has multiple vcpus.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/time.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 1a5353a..b2bb5aa 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -489,8 +489,9 @@ static void xen_hvm_setup_cpu_clockevents(void)
 __init void xen_hvm_init_time_ops(void)
 {
 	/* vector callback is needed otherwise we cannot receive interrupts
-	 * on cpu > 0 */
-	if (!xen_have_vector_callback && num_present_cpus() > 1)
+	 * on cpu > 0 and at this point we don't know how many cpus are
+	 * available */
+	if (!xen_have_vector_callback)
 		return;
 	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
 		printk(KERN_INFO "Xen doesn't support pvclock on HVM,"
-- 
1.5.6.5

