Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2JSD1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:27:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:54355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab2JSDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kouei Abe <kouei.abe.cp@rms.renesas.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Simon Horman <horms@verge.net.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 07/37] ARM: 7541/1: Add ARM ERRATA 775420 workaround
Date: Thu, 18 Oct 2012 20:16:30 -0700
Message-Id: <20121019031304.013691385@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@verge.net.au>

commit 7253b85cc62d6ff84143d96fe6cd54f73736f4d7 upstream.

arm: Add ARM ERRATA 775420 workaround

Workaround for the 775420 Cortex-A9 (r2p2, r2p6,r2p8,r2p10,r3p0) erratum.
In case a date cache maintenance operation aborts with MMU exception, it
might cause the processor to deadlock. This workaround puts DSB before
executing ISB if an abort may occur on cache maintenance.

Based on work by Kouei Abe and feedback from Catalin Marinas.

Signed-off-by: Kouei Abe <kouei.abe.cp@rms.renesas.com>
[ horms@verge.net.au: Changed to implementation
  suggested by catalin.marinas@arm.com ]
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig       |   10 ++++++++++
 arch/arm/mm/cache-v7.S |    3 +++
 2 files changed, 13 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1260,6 +1260,16 @@ config PL310_ERRATA_769419
 	  on systems with an outer cache, the store buffer is drained
 	  explicitly.
 
+config ARM_ERRATA_775420
+       bool "ARM errata: A data cache maintenance operation which aborts, might lead to deadlock"
+       depends on CPU_V7
+       help
+	 This option enables the workaround for the 775420 Cortex-A9 (r2p2,
+	 r2p6,r2p8,r2p10,r3p0) erratum. In case a date cache maintenance
+	 operation aborts with MMU exception, it might cause the processor
+	 to deadlock. This workaround puts DSB before executing ISB if
+	 an abort may occur on cache maintenance.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -211,6 +211,9 @@ ENTRY(v7_coherent_user_range)
  * isn't mapped, just try the next page.
  */
 9001:
+#ifdef CONFIG_ARM_ERRATA_775420
+	dsb
+#endif
 	mov	r12, r12, lsr #12
 	mov	r12, r12, lsl #12
 	add	r12, r12, #4096


