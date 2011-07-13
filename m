Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1GMTmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1GMTmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:42:22 -0400
Date: Wed, 13 Jul 2011 21:39:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt.fleming@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acct_arg_size: ptl is no longer needed for add_mm_counter()
Message-ID: <20110713193935.GA18026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acct_arg_size() takes ->page_table_lock around add_mm_counter()
if !SPLIT_RSS_COUNTING. This is no needed after 172703b0
"mm: delete non-atomic mm counter implementation".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |    7 -------
 1 file changed, 7 deletions(-)

--- ptrace/fs/exec.c~acct_arg_size-no-ptl	2011-07-10 16:20:01.000000000 +0200
+++ ptrace/fs/exec.c	2011-07-13 21:36:29.000000000 +0200
@@ -181,14 +181,7 @@ static void acct_arg_size(struct linux_b
 		return;
 
 	bprm->vma_pages = pages;
-
-#ifdef SPLIT_RSS_COUNTING
 	add_mm_counter(mm, MM_ANONPAGES, diff);
-#else
-	spin_lock(&mm->page_table_lock);
-	add_mm_counter(mm, MM_ANONPAGES, diff);
-	spin_unlock(&mm->page_table_lock);
-#endif
 }
 
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,

