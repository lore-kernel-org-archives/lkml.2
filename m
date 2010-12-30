Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0L3TvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:51:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39053 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0L3TuT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:50:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/8] xen/mmu: Warn against races.
Date: Thu, 30 Dec 2010 14:48:33 -0500
Message-Id: <1293738517-7287-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial bootup code uses set_phys_to_machine quite a lot, and after
bootup it would be used by the balloon driver. The balloon driver does have
mutex lock so this should not be necessary - but just in case, add
a warning if we do hit this scenario.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 667901f..36bdd2d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -553,11 +553,13 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 		/* Swap over from MISSING to IDENTITY if needed. */
 		if (p2m_top[topidx] == p2m_mid_missing) {
-			p2m_top[topidx] = p2m_mid_identity;
+			WARN_ON(cmpxchg(&p2m_top[topidx], p2m_mid_missing,
+				p2m_mid_identity) != p2m_mid_missing);
 			return 1;
 		}
 		if (p2m_top[topidx][mididx] == p2m_missing) {
-			p2m_top[topidx][mididx] = p2m_identity;
+			WARN_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_missing,
+				p2m_identity) != p2m_missing);
 			return 1;
 		}
 	}
-- 
1.7.1

