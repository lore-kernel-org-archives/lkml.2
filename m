Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1DEGYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:24:35 -0400
Received: from ozlabs.org ([203.10.76.45]:40131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1DEGYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:24:32 -0400
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <hughd@google.com>, <walken@google.com>,
        <aarcange@redhat.com>, <riel@redhat.com>,
        Andrew Morton <akpm@osdl.org>, <linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <c4f5166f98cb703742191eb74f583bb8011f9cdf.1301984663.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] mm: Check we have the right vma in access_process_vm()
Date: Tue,  5 Apr 2011 16:24:31 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In access_process_vm() we need to check that we have found the right
vma, not the following vma, before we try to access it. Otherwise
we might call the vma's access routine with an address which does
not fall inside the vma.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 mm/memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5823698..7e6f17b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3619,7 +3619,7 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 			 */
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
-			if (!vma)
+			if (!vma || vma->vm_start > addr)
 				break;
 			if (vma->vm_ops && vma->vm_ops->access)
 				ret = vma->vm_ops->access(vma, addr, buf,
-- 
1.7.1

