Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2JKKSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:18:46 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63789 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab2JKKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:18:42 -0400
Subject: [PATCH] mm: fix null vm_ops dereference in sys_remap_file_pages
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 11 Oct 2012 14:18:34 +0400
Message-ID: <20121011101834.1793.7213.stgit@zurg>
In-Reply-To: <5074ACDA.2060705@gmail.com>
References: <5074ACDA.2060705@gmail.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes bug introduced in commit "mm: kill vma flag VM_CAN_NONLINEAR",
vma->vm_ops must be checked before checking vm_ops->remap_pages.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 3899a86..a0aaf0e 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -169,7 +169,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
 		goto out;
 
-	if (!vma->vm_ops->remap_pages)
+	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
 		goto out;
 
 	if (start < vma->vm_start || start + size > vma->vm_end)

