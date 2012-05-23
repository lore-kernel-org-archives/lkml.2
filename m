Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2EWHTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:19:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57208 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2EWHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:19:46 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] mm: fix NULL ptr deref when walking hugepages
Date: Wed, 23 May 2012 09:20:43 +0200
Message-Id: <1337757643-18302-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing vlidation of the value returned by find_vma() could cause a NULL ptr
dereference when walking the pagetable.

This is triggerable from usermode by a simple user by trying to read a
page info out of /proc/pid/pagemap which doesn't exist.

Introduced by commit 025c5b24 ("thp: optimize away unnecessary page table
locking").

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3e564f0..885830b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -820,7 +820,7 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
 
-- 
1.7.8.6

