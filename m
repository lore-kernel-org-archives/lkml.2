Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0IYXeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 19:34:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46854 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0IYXe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 19:34:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
Date: Sat, 25 Sep 2010 16:34:25 -0700
In-Reply-To: <m1sk0x9z62.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sat, 25 Sep 2010 16:33:09 -0700")
Message-ID: <m1iq1t9z3y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMMoneyMeta_00 Subject Contains Money Spam
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 2/3] mm: Consolidate vma destruction into remove_vma.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Consolidate vma destruction in remove_vma.   This is slightly
better for code size and for code maintenance.  Avoiding the pain
of 3 copies of everything needed to tear down a vma.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 mm/mmap.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6128dc8..17dd003 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -643,16 +643,10 @@ again:			remove_next = 1 + (end > next->vm_end);
 		spin_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
-		if (file) {
-			fput(file);
-			if (next->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(mm);
-		}
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
+		remove_vma(next);
 		mm->map_count--;
-		mpol_put(vma_policy(next));
-		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
 		 * we must remove another next too. It would clutter
@@ -2002,19 +1996,14 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 		return 0;
 
 	/* Clean everything up if vma_adjust failed. */
-	if (new->vm_ops && new->vm_ops->close)
-		new->vm_ops->close(new);
-	if (new->vm_file) {
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-		fput(new->vm_file);
-	}
+	remove_vma(new);
+ out_err:
+	return err;
  out_free_mpol:
 	mpol_put(pol);
  out_free_vma:
 	kmem_cache_free(vm_area_cachep, new);
- out_err:
-	return err;
+	goto out_err;
 }
 
 /*
-- 
1.7.2.3

