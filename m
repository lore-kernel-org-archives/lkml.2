Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab1JaK47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:56:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45560 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab1JaK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:56:58 -0400
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 18:56:57 +0800
Message-ID: <CAGW+__+9jOaSdmqGcdCTi+EnRyyNcZ3hFqdqpf3Nxjqb8ZQPbw@mail.gmail.com>
Subject: [PATCH][mm/memory.c]: transparent hugepage check condition missed
From: GuanJun He <heguanbo@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the transparent hugepage module still does not support
tmpfs and cache,the check condition should always be checked
to make sure that it only affect the anonymous maps, the
original check condition missed this, this patch is to fix this.
Otherwise,the hugepage may affect the file-backed maps,
then the cache for the small-size pages will be unuseful,
and till now there is still no implementation for hugepage's cache.

Signed-off-by: Guanjun He <gjhe@suse.com>
---
 mm/memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index a56e3ba..79b85fe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct
vm_area_struct *vma,
 		if (pmd_trans_huge(orig_pmd)) {
 			if (flags & FAULT_FLAG_WRITE &&
 			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
+			    !pmd_trans_splitting(orig_pmd) &&
+			    !vma->vm_ops)
 				return do_huge_pmd_wp_page(mm, vma, address,
 							   pmd, orig_pmd);
 			return 0;
--
