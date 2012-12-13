Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2LMOqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:46:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2LMOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 109/241] fix virtual aliasing issue in get_shared_area()
Date: Thu, 13 Dec 2012 11:57:54 -0200
Message-Id: <1355407206-17100-110-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 949a05d03490e39e773e8652ccab9157e6f595b4 upstream.

On Thu, 2012-11-01 at 16:45 -0700, Michel Lespinasse wrote:
> Looking at the arch/parisc/kernel/sys_parisc.c implementation of
> get_shared_area(), I do have a concern though. The function basically
> ignores the pgoff argument, so that if one creates a shared mapping of
> pages 0-N of a file, and then a separate shared mapping of pages 1-N
> of that same file, both will have the same cache offset for their
> starting address.
>
> This looks like this would create obvious aliasing issues. Am I
> misreading this ? I can't understand how this could work good enough
> to be undetected, so there must be something I'm missing here ???

This turns out to be correct and we need to pay attention to the pgoff as
well as the address when creating the virtual address for the area.
Fortunately, the bug is rarely triggered as most applications which use pgoff
tend to use large values (git being the primary one, and it uses pgoff in
multiples of 16MB) which are larger than our cache coherency modulus, so the
problem isn't often seen in practise.

Reported-by: Michel Lespinasse <walken@google.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/parisc/kernel/sys_parisc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index c9b9322..7ea75d1 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -73,6 +73,8 @@ static unsigned long get_shared_area(struct address_space *mapping,
 	struct vm_area_struct *vma;
 	int offset = mapping ? get_offset(mapping) : 0;
 
+	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+
 	addr = DCACHE_ALIGN(addr - offset) + offset;
 
 	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {
-- 
1.7.9.5

