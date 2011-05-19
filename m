Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab1ESSIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38596 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933884Ab1ESSIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:00 -0400
X-Sasl-enc: GKMoaKwXV1LUfjsRtJtnvmBnl0J25GX1uNjt0PzO+808 1305828480
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.630829390@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [14/71] vm: fix vm_pgoff wrap in upward expansion
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 42c36f63ac1366ab0ecc2d5717821362c259f517 upstream.

Commit a626ca6a6564 ("vm: fix vm_pgoff wrap in stack expansion") fixed
the case of an expanding mapping causing vm_pgoff wrapping when you had
downward stack expansion.  But there was another case where IA64 and
PA-RISC expand mappings: upward expansion.

This fixes that case too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
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


