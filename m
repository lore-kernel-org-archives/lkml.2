Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab1DORif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:38:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43366 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1DORid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:38:33 -0400
Subject: [RFC][PATCH 3/3] use pte pages in OOM score
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 10:38:24 -0700
References: <20110415173821.62660715@kernel>
In-Reply-To: <20110415173821.62660715@kernel>
Message-Id: <20110415173824.79D354F4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PTE pages eat up memory just like anything else, but we do
not account for them in any way in the OOM scores.  They
are also _guaranteed_ to get freed up when a process is OOM
killed, while RSS is not.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/mm/oom_kill.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~use-pte-pages-in-oom-scire mm/oom_kill.c
--- linux-2.6.git/mm/oom_kill.c~use-pte-pages-in-oom-scire	2011-04-15 10:37:13.184831585 -0700
+++ linux-2.6.git-dave/mm/oom_kill.c	2011-04-15 10:37:13.192831581 -0700
@@ -192,8 +192,10 @@ unsigned int oom_badness(struct task_str
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss and swap space use.
 	 */
-	points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS)) * 1000 /
-			totalpages;
+	points = (get_mm_rss(p->mm) +
+		  get_mm_counter(p->mm, MM_SWAPENTS) +
+		  get_mm_counter(p->mm, MM_PTEPAGES))
+		 * 1000 / totalpages;
 	task_unlock(p);
 
 	/*
_
