Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2HIMVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:21:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52226 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2HIMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:21:38 -0400
MIME-Version: 1.0
Date: Thu, 9 Aug 2012 20:21:37 +0800
Message-ID: <CAJd=RBAjGaOXfQQ_NX+ax6=tJJ0eg7EXCFHz3rdvSR3j1K3qHA@mail.gmail.com>
Subject: [patch] mmap: feed back correct prev vma when finding vma
From: Hillf Danton <dhillf@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After walking rb tree, if vma is determined, prev vma has to be determined
based on vma; and rb_prev should be considered only if no vma determined.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/mmap.c	Fri Aug  3 07:38:10 2012
+++ b/mm/mmap.c	Mon Aug  6 20:10:18 2012
@@ -385,9 +385,13 @@ find_vma_prepare(struct mm_struct *mm, u
 		}
 	}

-	*pprev = NULL;
-	if (rb_prev)
-		*pprev = rb_entry(rb_prev, struct vm_area_struct, vm_rb);
+	if (vma) {
+		*pprev = vma->vm_prev;
+	} else {
+		*pprev = NULL;
+		if (rb_prev)
+			*pprev = rb_entry(rb_prev, struct vm_area_struct, vm_rb);
+	}
 	*rb_link = __rb_link;
 	*rb_parent = __rb_parent;
 	return vma;
--
