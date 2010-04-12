Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0DLU2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:28:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383Ab0DLU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:28:33 -0400
Date: Mon, 12 Apr 2010 13:23:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 3/4] anon_vma: clone the anon_vma chain in the right order
In-Reply-To: <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com>
 <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Apr 2010 17:15:03 -0700
Subject: [PATCH 3/4] anon_vma: clone the anon_vma chain in the right order

We want to walk the chain in reverse order when cloning it, so that the
order of the result chain will be the same as the order in the source
chain.  When we add entries to the chain, they go at the head of the
chain, so we want to add the source head last.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/rmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..ee97d38 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -182,7 +182,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 
-	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		avc = anon_vma_chain_alloc();
 		if (!avc)
 			goto enomem_failure;
-- 
1.7.1.rc1.dirty

