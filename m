Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1FQL3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:29:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:38201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1FQL3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:29:42 -0400
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>
	 <20110615161827.GA11769@tassilo.jf.intel.com>
	 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
	 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
	 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
	 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com>
	 <1308255972.17300.450.camel@schen9-DESK>
	 <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com>
	 <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
	 <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
	 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
	 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Jun 2011 13:28:00 +0200
Message-ID: <1308310080.2355.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 20:58 -0700, Linus Torvalds wrote:
> Ok, I'm still thinking. I have an approach that I think will handle it
> fairly cleanly, but that involves walking the same_vma list twice:
> once to actually unlink the anon_vma's under the lock, and then a
> second pass that does the rest. It should work. 

Something like so? Compiles and runs the benchmark in question.

---
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -324,36 +324,52 @@ int anon_vma_fork(struct vm_area_struct
 	return -ENOMEM;
 }
 
-static void anon_vma_unlink(struct anon_vma_chain *anon_vma_chain)
+static int anon_vma_unlink(struct anon_vma_chain *anon_vma_chain, struct anon_vma *anon_vma)
 {
-	struct anon_vma *anon_vma = anon_vma_chain->anon_vma;
-	int empty;
-
-	/* If anon_vma_fork fails, we can get an empty anon_vma_chain. */
-	if (!anon_vma)
-		return;
-
-	anon_vma_lock(anon_vma);
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head);
-	anon_vma_unlock(anon_vma);
+	if (list_empty(&anon_vma->head))
+		return 1;
 
-	if (empty)
-		put_anon_vma(anon_vma);
+	return 0;
 }
 
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
+	struct anon_vma *root = NULL;
 
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
 	 */
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		anon_vma_unlink(avc);
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		/* If anon_vma_fork fails, we can get an empty anon_vma_chain. */
+		if (anon_vma) {
+			root = lock_anon_vma_root(root, anon_vma);
+			/* Leave empty anon_vmas on the list. */
+			if (anon_vma_unlink(avc, anon_vma))
+				continue;
+		}
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
+	unlock_anon_vma_root(root);
+
+	/*
+	 * Iterate the list once more, it now only contains empty and unlinked
+	 * anon_vmas, destroy them. Could not do before due to anon_vma_free()
+	 * needing to acquire the anon_vma->root->mutex.
+	 */
+	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		if (anon_vma)
+			put_anon_vma(anon_vma);
+
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}

