Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1ETWrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:47:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24427 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1ETWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:47:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=UuDhREefkgLPxSaU5H2E+IZoa9R0i7X2AHPk1FPW0fSSFxhskJG49BMDK9KYdZje9A
         zmbOxGVtGPOQSmPIC0fw==
Date: Fri, 20 May 2011 15:47:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Nitin Gupta <ngupta@vflare.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] tmpfs: fix highmem swapoff crash regression
Message-ID: <alpine.LSU.2.00.1105201535530.1899@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 778dd893ae78 "tmpfs: fix race between umount and swapoff"
forgot the new rules for strict atomic kmap nesting, causing
WARNING: at arch/x86/mm/highmem_32.c:81 from __kunmap_atomic(), then
BUG: unable to handle kernel paging request at fffb9000 from shmem_swp_set()
when shmem_unuse_inode() is handling swapoff with highmem in use.
My disgrace again.  See https://bugzilla.kernel.org/show_bug.cgi?id=35352

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.39/mm/shmem.c	2011-05-18 21:06:34.000000000 -0700
+++ linux/mm/shmem.c	2011-05-20 13:57:20.778870967 -0700
@@ -916,11 +916,12 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
+			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
+				ptr = shmem_swp_map(subdir);
 				goto found;
 			}
-			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:
