Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1LTGoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:44:39 -0500
Received: from 206-223-182-18.beanfield.net ([206.223.182.18]:38091 "EHLO
	dev.gridcentric.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1LTGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:44:16 -0500
From: Adin Scannell <adin@scannell.ca>
To: xen-devel@lists.xensource.com
Cc: konrad@darnok.org, andres@gridcentric.ca, adin@gridcentric.com,
        olaf@aepfle.de, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        Adin Scannell <adin@scannell.ca>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 1/3] Make xen_remap_domain_mfn_range return value meaningful in case of error
Date: Tue, 20 Dec 2011 01:36:51 -0500
Message-Id: <1324363013-11031-2-git-send-email-adin@scannell.ca>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1324363013-11031-1-git-send-email-adin@scannell.ca>
References: <1324363013-11031-1-git-send-email-adin@scannell.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original patch from Olaf Hering <ohering@novell.com>

This change fixes the xc_map_foreign_bulk interface, which would
otherwise cause SIGBUS when pages are gone because -ENOENT is not
returned as expected by the IOCTL_PRIVCMD_MMAPBATCH_V2 ioctl.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

This is a port to the mainline Linux tree.  Functions were refactored and
renamed.  I believe that this is the only required change to match the
semantics of the original patch.

Signed-off-by: Adin Scannell <adin@scannell.ca>
---
 arch/x86/xen/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 87f6673..288a7fc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2350,8 +2350,8 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 		if (err)
 			goto out;
 
-		err = -EFAULT;
-		if (HYPERVISOR_mmu_update(mmu_update, batch, NULL, domid) < 0)
+		err = HYPERVISOR_mmu_update(mmu_update, batch, NULL, domid);
+		if (err < 0)
 			goto out;
 
 		nr -= batch;
-- 
1.6.2.5

