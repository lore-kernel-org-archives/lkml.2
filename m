Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab1KHVRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:17:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:65039 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1KHVRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:17:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de
Cc: mingo@redhat.com, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH 3/3] x86/paravirt: Use pte_val instead of pte_flags on CPA pageattr_test
Date: Tue,  8 Nov 2011 16:15:14 -0500
Message-Id: <1320786914-10541-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020B.4EB99BF9.00D5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For details refer to patch "x86/paravirt: Use pte_attrs instead of
pte_flags on CPA/set_p.._wb/wc operations." which explains that
some pages have the _PAGE_PWT bit set in the _PAGE_PSE field
when running under Xen.

When pageattr_test is running it uses pte_flags to check whether
it succedded in setting _PAGE_UNUSED1 bit, but also whether the
page had _PAGE_PSE. This can happen when one of the randomly selected
pages to be tested is a page that has been set to be _PAGE_WC
as under Xen, that field is under _PAGE_PSE. Since the 'pte_huge'
call is using the pte_flags(x) macro, which extracts the "raw" contents
of the PTE, the translation of _PAGE_PSE -> _PAGE_PWT does not happen
and we incorrectly identify the PTE as bad.

Using the 'pte_val' instead of 'pte_flags' fixes the problem and
this patch does that.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stable@kernel.org
---
 arch/x86/mm/pageattr-test.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index b008656..da853e3 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -38,6 +38,10 @@ static int pte_testbit(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_UNUSED1;
 }
+static int pte_testhuge(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_PSE;
+}
 
 struct split_state {
 	long lpg, gpg, spg, exec;
@@ -180,7 +184,7 @@ static int pageattr_test(void)
 		}
 
 		pte = lookup_address(addr[i], &level);
-		if (!pte || !pte_testbit(*pte) || pte_huge(*pte)) {
+		if (!pte || !pte_testbit(*pte) || pte_testhuge(*pte)) {
 			printk(KERN_ERR "CPA %lx: bad pte %Lx\n", addr[i],
 				pte ? (u64)pte_val(*pte) : 0ULL);
 			failed++;
-- 
1.7.7.1

