Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0IESdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0IESdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o1Uia/h4ZzVqKYUfQkuMLNElWWCnI4MT0PCm3Xc3V09yvs0OPvqJGT0e9+VSx9IUwn
         Eiyx0i27miqmPQnFNN+O42oHf8t3D52IZySb3PAwAfWJXR9SncfiQTpcLtjcDWN4vDOY
         LcPZKPknYr6gQmXTD2t9cxR9wpNCEDxIiRmIE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 13/14] mm: mempolicy: Check return code of check_range
Date: Sun,  5 Sep 2010 22:33:08 +0400
Message-Id: <1283711588-7628-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function check_range may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 mm/mempolicy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f969da5..b73f02c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -924,12 +924,15 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
+	struct vm_area_struct *vma;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist))
 		err = migrate_pages(&pagelist, new_node_page, dest, 0);
-- 
1.7.0.4

