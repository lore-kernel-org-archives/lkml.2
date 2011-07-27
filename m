Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1G0V4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:56:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:13692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1G0VtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274752"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hughd@google.com, andrea@betterlinux.com, aarcange@redhat.com,
        chrisw@sous-sol.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [65/99] ksm: fix NULL pointer dereference in scan_get_next_rmap_item()
Message-Id: <20110727214904.7A3D82403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hugh Dickins <hughd@google.com>

commit 2b472611a32a72f4a118c069c2d62a1a3f087afd upstream.

Andrea Righi reported a case where an exiting task can race against
ksmd::scan_get_next_rmap_item (http://lkml.org/lkml/2011/6/1/742) easily
triggering a NULL pointer dereference in ksmd.

ksm_scan.mm_slot == &ksm_mm_head with only one registered mm

CPU 1 (__ksm_exit)		CPU 2 (scan_get_next_rmap_item)
 				list_empty() is false
lock				slot == &ksm_mm_head
list_del(slot->mm_list)
(list now empty)
unlock
				lock
				slot = list_entry(slot->mm_list.next)
				(list is empty, so slot is still ksm_mm_head)
				unlock
				slot->mm == NULL ... Oops

Close this race by revalidating that the new slot is not simply the list
head again.

Andrea's test case:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define BUFSIZE getpagesize()

int main(int argc, char **argv)
{
	void *ptr;

	if (posix_memalign(&ptr, getpagesize(), BUFSIZE) < 0) {
		perror("posix_memalign");
		exit(1);
	}
	if (madvise(ptr, BUFSIZE, MADV_MERGEABLE) < 0) {
		perror("madvise");
		exit(1);
	}
	*(char *)NULL = 0;

	return 0;
}

Reported-by: Andrea Righi <andrea@betterlinux.com>
Tested-by: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/ksm.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.35.y/mm/ksm.c
===================================================================
--- linux-2.6.35.y.orig/mm/ksm.c
+++ linux-2.6.35.y/mm/ksm.c
@@ -1272,6 +1272,12 @@ static struct rmap_item *scan_get_next_r
 		slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
 		ksm_scan.mm_slot = slot;
 		spin_unlock(&ksm_mmlist_lock);
+		/*
+		 * Although we tested list_empty() above, a racing __ksm_exit
+		 * of the last mm on the list may have removed it since then.
+		 */
+		if (slot == &ksm_mm_head)
+			return NULL;
 next_mm:
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &slot->rmap_list;
