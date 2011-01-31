Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1AaXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22725 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1AaXJO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/11] xen/m2p: Check whether the MFN has IDENTITY_FRAME bit set..
Date: Mon, 31 Jan 2011 17:44:36 -0500
Message-Id: <1296513876-31415-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D474115.01E1:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

If we have the IDENTITY_FRAME bit set from the P2M, there
is no point in looking up MFN in the M2P override. This is
b/c the MFN is a physical MFN.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index ed46ec2..e6f7f37 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -81,6 +81,7 @@ static inline int phys_to_machine_mapping_valid(unsigned long pfn)
 static inline unsigned long mfn_to_pfn(unsigned long mfn)
 {
 	unsigned long pfn;
+	unsigned long p2m_mfn;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
@@ -102,7 +103,12 @@ try_override:
 	 * doesn't map back to the mfn), then check the local override
 	 * table to see if there's a better pfn to use.
 	 */
-	if (get_phys_to_machine(pfn) != mfn)
+	p2m_mfn = get_phys_to_machine(pfn);
+
+	if (p2m_mfn == IDENTITY_FRAME(mfn))
+		return pfn;
+
+	if (p2m_mfn != mfn)
 		pfn = m2p_find_override_pfn(mfn, pfn);
 
 	return pfn;
-- 
1.7.1

