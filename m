Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2JWSYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:24:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47647 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2JWSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/10] xen/pvh: Fix PVHVM 32-bit bootup problems.
Date: Tue, 23 Oct 2012 14:12:03 -0400
Message-Id: <1351015931-16991-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the split of the 'unsigned int space' in a 'u16 space'
and 'u16 foreign_domid' in xen_add_to_physmap the compiler
won't write the full 32-bit value in 'space'. Instead
it will write a 16-bit value - which is OK. The problem
is that we allocate the xen_add_to_physmap structure from
the stack which can (and it has) various garbage on it.

The end result is that without this patch we end up
providing this to the hypervisor:

   xatp.space = 0xc1310001;
instead of:
   xatp.space = 0x1;

Forcing the foreign_domid to 0, will over-write the garbage
that was on the stack.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c  |    1 +
 drivers/xen/grant-table.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e3497f2..b679f86 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1509,6 +1509,7 @@ void __ref xen_hvm_init_shared_info(void)
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
+	xatp.foreign_domid = 0;
 	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index b2b0a37..cbfd929 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1044,6 +1044,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		do {
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
+			xatp.foreign_domid = 0;
 			xatp.space = XENMAPSPACE_grant_table;
 			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
-- 
1.7.7.6

