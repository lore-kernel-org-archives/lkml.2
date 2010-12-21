Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0LUViV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25466 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0LUViT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/10] xen/mmu: Warn against races.
Date: Tue, 21 Dec 2010 16:37:40 -0500
Message-Id: <1292967460-15709-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial bootup code uses set_phys_to_machine quite a lot, and after
bootup it would be the balloon driver. The balloon driver does have
mutex lock so this should not be necessary - but just in case, add
a warning if we do hit this scenario.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b2b8733..86d3bd3 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -549,13 +549,15 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	idx = p2m_index(pfn);
 
 	if (mfn == INVALID_P2M_ENTRY) {
-		/* If it is INVALID, swap over.. */
+		/* Ballon lock should inhibit racing, but just in case.*/
 		if (p2m_top[topidx] == p2m_mid_identity) {
-			p2m_top[topidx] = p2m_mid_missing;
+			WARN_ON(cmpxchg(&p2m_top[topidx], p2m_mid_identity,
+				p2m_mid_missing) != p2m_mid_identity);
 			return 1;
 		}
 		if (p2m_top[topidx][mididx] == p2m_identity) {
-			p2m_top[topidx][mididx] = p2m_missing;
+			WARN_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_identity,
+				p2m_missing) != p2m_identity);
 			return 1;
 		}
 	}
-- 
1.7.1

