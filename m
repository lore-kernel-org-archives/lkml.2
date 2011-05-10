Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab1EJAop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:44:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1EJAoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=lkE6LVL3T6y1W/4BZZjn+ARqdowlmBgJ+ungutTEXnUlBskgmD4audE4NmFOxStLVV
         B/QZ89QFSy4LFeulntFQ==
Date: Mon, 9 May 2011 17:44:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Robert Swiecki <robert@swiecki.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org
Subject: [PATCH] vm: fix vm_pgoff wrap in upward expansion
Message-ID: <alpine.LSU.2.00.1105091739140.7047@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a626ca6a6564 ("vm: fix vm_pgoff wrap in stack expansion") fixed
the case of an expanding mapping causing vm_pgoff wrapping when you had
downward stack expansion.  But there was another case where IA64 and
PA-RISC expand mappings: upward expansion.

This fixes that case too.

Signed-off-by: Hugh Dickins <hughd@google.com.>
Cc: stable@kernel.org
---
On April 12th you asked "Guys, can you think of any other thing
that might expand a mapping?": this is the only one I thought of.

 mm/mmap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- 2.6.39-rc6/mm/mmap.c	2011-05-04 12:10:31.477543104 -0700
+++ linux/mm/mmap.c	2011-05-09 17:16:34.251725877 -0700
@@ -1767,10 +1767,13 @@ int expand_upwards(struct vm_area_struct
 		size = address - vma->vm_start;
 		grow = (address - vma->vm_end) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error) {
-			vma->vm_end = address;
-			perf_event_mmap(vma);
+		error = -ENOMEM;
+		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				vma->vm_end = address;
+				perf_event_mmap(vma);
+			}
 		}
 	}
 	vma_unlock_anon_vma(vma);
