Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1C1N5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:57:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:46222 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1C1N5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G9uY303jeDDfGaZgTNTroad48lLLPtD3BjzmhUQ+oChci7vIRtmXpI0GHV5Hko+4F7
         aO0lFeH2VenBz5xt1WeX2JCx33fS6co7lyoo8EIqqxwj/ic26J5hmivOkk5MxBPtP6B9
         G9ROTFOswH1YZQ8FskOq2loNU2iZeUpBrcSiA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] nommu: check the vma list when unmapping file-mapped vma
Date: Mon, 28 Mar 2011 22:56:45 +0900
Message-Id: <1301320607-7259-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have the sorted vma list, use it in do_munmap() to check that
we have an exact match.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/nommu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 6c5a13b507b4..33f5d23c6d44 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1659,7 +1659,6 @@ static int shrink_vma(struct mm_struct *mm,
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *rb;
 	unsigned long end = start + len;
 	int ret;
 
@@ -1692,9 +1691,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 			}
 			if (end == vma->vm_end)
 				goto erase_whole_vma;
-			rb = rb_next(&vma->vm_rb);
-			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
-		} while (rb);
+			vma = vma->vm_next;
+		} while (vma);
 		kleave(" = -EINVAL [split file]");
 		return -EINVAL;
 	} else {
-- 
1.7.4

