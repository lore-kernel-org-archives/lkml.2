Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0DZRAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:00:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0DZRAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:00:03 -0400
Date: Mon, 26 Apr 2010 12:33:03 -0400
From: Rik van Riel <riel@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH] mmap: check ->vm_ops before dereferencing
Message-ID: <20100426123303.5ef4ac01@annuminas.surriel.com>
In-Reply-To: <20100426100305.GP29093@bicker>
References: <20100426100305.GP29093@bicker>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether the VMA has a vm_ops before calling close, just
like we check vm_ops before calling open a few dozen lines
higher up in the function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dan Carpenter <error27@gmail.com>

diff --git a/mm/mmap.c b/mm/mmap.c
index f90ea92..456ec6f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1977,7 +1977,8 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 		return 0;
 
 	/* Clean everything up if vma_adjust failed. */
-	new->vm_ops->close(new);
+	if (new->vm_ops && new->vm_ops->close)
+		new->vm_ops->close(new);
 	if (new->vm_file) {
 		if (vma->vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(mm);

