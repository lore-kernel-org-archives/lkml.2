Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1AaXJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22922 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab1AaXJX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/11] xen/m2p: No need to catch exceptions when we know that there is no RAM
Date: Mon, 31 Jan 2011 17:44:35 -0500
Message-Id: <1296513876-31415-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. beyound what we think is the end of memory. However there might
be more System RAM - but assigned to a guest. Hence jump to the
M2P override check and consult.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 7b17fc5..ed46ec2 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -85,6 +85,10 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
 
+	if (unlikely((mfn >> machine_to_phys_order) != 0)) {
+		pfn = ~0;
+		goto try_override;
+	}
 	pfn = 0;
 	/*
 	 * The array access can fail (e.g., device space beyond end of RAM).
@@ -92,7 +96,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	 * but we must handle the fault without crashing!
 	 */
 	__get_user(pfn, &machine_to_phys_mapping[mfn]);
-
+try_override:
 	/*
 	 * If this appears to be a foreign mfn (because the pfn
 	 * doesn't map back to the mfn), then check the local override
-- 
1.7.1

