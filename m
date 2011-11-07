Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1KGEWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 23:22:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56737 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1KGEWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 23:22:07 -0500
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] mremap: skip page table lookup for non-faulted anonymous VMAs
Date: Mon, 7 Nov 2011 12:21:35 +0800
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic-pae; KDE/4.6.5; i686; ; )
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201111071221.35403.nai.xia@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an anonymous vma has not yet been faulted, move_page_tables() in move_vma()
is not necessary for it.

Signed-off-by: Nai Xia <nai.xia@gmail.com>
---
diff --git a/mm/mremap.c b/mm/mremap.c
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -200,6 +200,10 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	if (!new_vma)
 		return -ENOMEM;
 
+	/* An anonymous vma has not been faulted, no pagetables lookup. */
+	if (!vma->vm_file && !vma->anon_vma)
+		goto page_tables_ok;
+
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
 	if (moved_len < old_len) {
 		/*
@@ -213,6 +217,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		old_addr = new_addr;
 		new_addr = -ENOMEM;
 	}
+page_tables_ok:
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
 	if (vm_flags & VM_ACCOUNT) {

