Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0LIHuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:50:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0LIHuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GvSV1bdkFDOCiOzBfz8A4K3YdoBLeEvGPdGoVMlIv7hAMy+2DcvO0NcHZ3Hg+wMVNa
         GJJeesVYuvyhxAg/nFZQ==
From: Michel Lespinasse <walken@google.com>
To: Nick Piggin <npiggin@kernel.dk>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mlock: do not munlock pages in __do_fault()
Date: Wed,  8 Dec 2010 23:49:39 -0800
Message-Id: <1291880979-16309-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291880979-16309-1-git-send-email-walken@google.com>
References: <1291880979-16309-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the page is going to be written to, __do_page needs to break COW.
However, the old page (before breaking COW) was never mapped mapped into
the current pte (__do_fault is only called when the pte is not present),
so vmscan can't have marked the old page as PageMlocked due to being
mapped in __do_fault's VMA. Therefore, __do_fault() does not need to worry
about clearing PageMlocked() on the old page.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/memory.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 68f2dbe..7befd03 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3015,12 +3015,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 				goto out;
 			}
 			charged = 1;
-			/*
-			 * Don't let another task, with possibly unlocked vma,
-			 * keep the mlocked page.
-			 */
-			if (vma->vm_flags & VM_LOCKED)
-				clear_page_mlock(vmf.page);
 			copy_user_highpage(page, vmf.page, address, vma);
 			__SetPageUptodate(page);
 		} else {
-- 
1.7.3.1

