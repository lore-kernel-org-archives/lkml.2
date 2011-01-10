Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1AJRSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:18:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28484 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1AJRS1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 12:18:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xensource.com,
        Jan Beulich <JBeulich@novell.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/7] xen/mmu: BUG_ON when racing to swap middle leaf.
Date: Mon, 10 Jan 2011 12:17:36 -0500
Message-Id: <1294679859-30029-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
References: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial bootup code uses set_phys_to_machine quite a lot, and after
bootup it would be used by the balloon driver. The balloon driver does have
mutex lock so this should not be necessary - but just in case, add
a BUG_ON if we do hit this scenario.

[v2: Change from WARN to BUG_ON]
Reviewed-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6d5b49b..0cce0c2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -613,7 +613,8 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 		/* Swap over from MISSING to IDENTITY if needed. */
 		if (p2m_top[topidx][mididx] == p2m_missing) {
-			p2m_top[topidx][mididx] = p2m_identity;
+			BUG_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_missing,
+				p2m_identity) != p2m_missing);
 			return true;
 		}
 	}
-- 
1.7.1

