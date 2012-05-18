Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031080Ab2ERDFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:05:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40481 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762590Ab2ERCwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:34 -0400
Message-Id: <20120518023258.434675334@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        Meelis Roos <mroos@linux.ee>
Subject: [ 30/53] sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a5a737e090e25981e99d69f01400e3a80356581c ]

%g2 is meant to hold the CPUID number throughout this routine, since
at the very beginning, and at the very end, we use %g2 to calculate
indexes into per-cpu arrays.

However we erroneously clobber it in order to hold the %cwp register
value mid-stream.

Fix this code to use %g3 for the %cwp read and related calulcations
instead.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/central.c |    2 +-
 arch/sparc/mm/ultra.S       |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index 38d48a5..9708851 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -269,4 +269,4 @@ static int __init sunfire_init(void)
 	return 0;
 }
 
-subsys_initcall(sunfire_init);
+fs_initcall(sunfire_init);
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index b57a594..874162a 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -495,11 +495,11 @@ xcall_fetch_glob_regs:
 	stx		%o7, [%g1 + GR_SNAP_O7]
 	stx		%i7, [%g1 + GR_SNAP_I7]
 	/* Don't try this at home kids... */
-	rdpr		%cwp, %g2
-	sub		%g2, 1, %g7
+	rdpr		%cwp, %g3
+	sub		%g3, 1, %g7
 	wrpr		%g7, %cwp
 	mov		%i7, %g7
-	wrpr		%g2, %cwp
+	wrpr		%g3, %cwp
 	stx		%g7, [%g1 + GR_SNAP_RPC]
 	sethi		%hi(trap_block), %g7
 	or		%g7, %lo(trap_block), %g7
-- 
1.7.10.1



