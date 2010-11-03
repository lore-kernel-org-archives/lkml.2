Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0KCPbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab0KCPa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 42 of 66] khugepaged vma merge
X-Mercurial-Node: faf02e40e7c56b202ef727a4930f6b43dc6ec335
Message-Id: <faf02e40e7c56b202ef7.1288798097@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:17 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

register in khugepaged if the vma grows.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/perf_event.h>
 #include <linux/audit.h>
+#include <linux/khugepaged.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -815,6 +816,7 @@ struct vm_area_struct *vma_merge(struct 
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
+		khugepaged_enter_vma_merge(prev);
 		return prev;
 	}
 
@@ -833,6 +835,7 @@ struct vm_area_struct *vma_merge(struct 
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
+		khugepaged_enter_vma_merge(area);
 		return area;
 	}
 
@@ -1761,6 +1764,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	vma_unlock_anon_vma(vma);
+	khugepaged_enter_vma_merge(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1808,6 +1812,7 @@ static int expand_downwards(struct vm_ar
 		}
 	}
 	vma_unlock_anon_vma(vma);
+	khugepaged_enter_vma_merge(vma);
 	return error;
 }
 
