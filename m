Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031034Ab2CFU33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:29:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55489 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229Ab2CFU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:29:28 -0500
Date: Tue, 6 Mar 2012 12:28:52 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mmap: EINVAL not ENOMEM when rejecting VM_GROWS
Message-ID: <alpine.LSU.2.00.1203061225500.17918@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently error is -ENOMEM when rejecting VM_GROWSDOWN|VM_GROWSUP
from shared anonymous: hoist the file case's -EINVAL up for both.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.3.0-rc6+/mm/mmap.c	2012-03-05 16:38:23.741975593 -0800
+++ linux/mm/mmap.c	2012-03-06 12:14:32.704674576 -0800
@@ -1266,8 +1266,9 @@ munmap_back:
 	vma->vm_pgoff = pgoff;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
+	error = -EINVAL;	/* when rejecting VM_GROWSDOWN|VM_GROWSUP */
+
 	if (file) {
-		error = -EINVAL;
 		if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
 			goto free_vma;
 		if (vm_flags & VM_DENYWRITE) {
