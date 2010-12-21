Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0LUViL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25115 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0LUViG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/10] xen/mmu: Bugfix. Fill the top entry page with appropriate middle layer pointers.
Date: Tue, 21 Dec 2010 16:37:38 -0500
Message-Id: <1292967460-15709-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we swapped over from using an p2m_mid_identical to p2m_mid_missing
(earlier call to set_phys_to_machine) and then started going through the
PFNs in descending order to program a new MFN (balloon worker), we would
end up in this code path. At that point we would set up new page filled with
pointers to p2m_identity instead of p2m_missing. This had the disastrous
effect that get_phys_to_machine on that PFN would return an 1-1 mapping
instead of INVALID_P2M_ENTRY resulting in hitting a BUG check in balloon driver.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 92f4fec..a917439 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -480,7 +480,10 @@ static bool alloc_p2m(unsigned long pfn)
 		if (!mid)
 			return false;
 
-		p2m_mid_init(mid, p2m_identity);
+		if (mid == p2m_mid_identity)
+			p2m_mid_init(mid, p2m_identity);
+		else
+			p2m_mid_init(mid, p2m_missing);
 
 		if (cmpxchg(top_p, mid_orig, mid) != mid_orig)
 			free_p2m_page(mid);
-- 
1.7.1

