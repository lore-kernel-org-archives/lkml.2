Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0DTT00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0DTT0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:26:24 -0400
Date: Tue, 20 Apr 2010 21:24:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] rmap: anon_vma_prepare() can leak anon_vma_chain
Message-ID: <20100420192420.GA20840@redhat.com>
References: <20100415120940.GA31762@redhat.com> <4BCD0E78.9050904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCD0E78.9050904@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If find_mergeable_anon_vma() succeeds but another thread installs
->anon_vma before we take ptl, then allocated == NULL but avc should
be freed. Change the code to check avc != NULL to detect this case.

Also, a couple of whitespace changes to make the critical section more
visible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 mm/rmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- 34-rc1/mm/rmap.c~AVP_AVC_LEAK	2010-03-11 13:11:50.000000000 +0100
+++ 34-rc1/mm/rmap.c	2010-04-20 21:05:24.000000000 +0200
@@ -133,8 +133,8 @@ int anon_vma_prepare(struct vm_area_stru
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
 		}
-		spin_lock(&anon_vma->lock);
 
+		spin_lock(&anon_vma->lock);
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
@@ -144,14 +144,15 @@ int anon_vma_prepare(struct vm_area_stru
 			list_add(&avc->same_vma, &vma->anon_vma_chain);
 			list_add(&avc->same_anon_vma, &anon_vma->head);
 			allocated = NULL;
+			avc = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
-
 		spin_unlock(&anon_vma->lock);
-		if (unlikely(allocated)) {
+
+		if (unlikely(allocated))
 			anon_vma_free(allocated);
+		if (unlikely(avc))
 			anon_vma_chain_free(avc);
-		}
 	}
 	return 0;
 

