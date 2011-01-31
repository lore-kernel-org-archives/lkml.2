Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1AaXJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22873 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab1AaXJT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/11] xen/mmu: BUG_ON when racing to swap middle leaf.
Date: Mon, 31 Jan 2011 17:44:29 -0500
Message-Id: <1296513876-31415-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial bootup code uses set_phys_to_machine quite a lot, and after
bootup it would be used by the balloon driver. The balloon driver does have
mutex lock so this should not be necessary - but just in case, add
a BUG_ON if we do hit this scenario.

[v2: Change from WARN to BUG_ON]
[v3: Rebased on top of xen->p2m code split]
Reviewed-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 19b0a65..fbbd2ab 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -478,7 +478,8 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
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

