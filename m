Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2IDU1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:27:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19930 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2IDU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:27:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/p2m: Fix one by off error in checking the P2M tree directory.
Date: Tue,  4 Sep 2012 16:17:14 -0400
Message-Id: <1346789834-30618-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would the full P2M top directory from 0->MAX_DOMAIN_PAGES (inclusive).

Which meant that if the kernel was compiled with MAX_DOMAIN_PAGES=512
we would try to use the 512th entry. Fortunately for us the p2m_top_index
has a check for this:

 BUG_ON(pfn >= MAX_P2M_PFN);

which we hit and saw this:

(XEN) domain_crash_sync called from entry.S
(XEN) Domain 0 (vcpu#0) crashed on cpu#0:
(XEN) ----[ Xen-4.1.2-OVM  x86_64  debug=n  Tainted:    C ]----
(XEN) CPU:    0
(XEN) RIP:    e033:[<ffffffff819cadeb>]
(XEN) RFLAGS: 0000000000000212   EM: 1   CONTEXT: pv guest
(XEN) rax: ffffffff81db5000   rbx: ffffffff81db4000   rcx: 0000000000000000
(XEN) rdx: 0000000000480211   rsi: 0000000000000000   rdi: ffffffff81db4000
(XEN) rbp: ffffffff81793db8   rsp: ffffffff81793d38   r8:  0000000008000000
(XEN) r9:  4000000000000000   r10: 0000000000000000   r11: ffffffff81db7000
(XEN) r12: 0000000000000ff8   r13: ffffffff81df1ff8   r14: ffffffff81db6000
(XEN) r15: 0000000000000ff8   cr0: 000000008005003b   cr4: 00000000000026f0
(XEN) cr3: 0000000661795000   cr2: 0000000000000000

Fixes-Oracle-Bug: 14570662
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 0bfaf5b..af11f00 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -695,7 +695,7 @@ bool __init early_can_reuse_p2m_middle(unsigned long set_pfn, unsigned long set_
 	if (p2m_index(set_pfn))
 		return false;
 
-	for (pfn = 0; pfn <= MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
+	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
 		topidx = p2m_top_index(pfn);
 
 		if (!p2m_top[topidx])
-- 
1.7.7.6

