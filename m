Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DSUQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:16:48 -0400
Received: from kroah.org ([198.145.64.141]:47520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab1DSUQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:43 2011
Message-Id: <20110419201043.293822047@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [01/70] vm: fix vm_pgoff wrap in stack expansion
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a626ca6a656450e9f4df91d0dda238fff23285f4 upstream.

Commit 982134ba6261 ("mm: avoid wrapping vm_pgoff in mremap()") fixed
the case of a expanding mapping causing vm_pgoff wrapping when you used
mremap.  But there was another case where we expand mappings hiding in
plain sight: the automatic stack expansion.

This fixes that case too.

This one also found by Robert Święcki, using his nasty system call
fuzzer tool.  Good job.

Reported-and-tested-by: Robert Święcki <robert@swiecki.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1814,11 +1814,14 @@ static int expand_downwards(struct vm_ar
 		size = vma->vm_end - address;
 		grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
-		error = acct_stack_growth(vma, size, grow);
-		if (!error) {
-			vma->vm_start = address;
-			vma->vm_pgoff -= grow;
-			perf_event_mmap(vma);
+		error = -ENOMEM;
+		if (grow <= vma->vm_pgoff) {
+			error = acct_stack_growth(vma, size, grow);
+			if (!error) {
+				vma->vm_start = address;
+				vma->vm_pgoff -= grow;
+				perf_event_mmap(vma);
+			}
 		}
 	}
 	vma_unlock_anon_vma(vma);


