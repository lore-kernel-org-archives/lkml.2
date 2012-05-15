Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965892Ab2EOC5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:57:41 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53279 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990Ab2EOCRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 076/179] ksm: fix NULL pointer dereference in scan_get_next_rmap_item()
Date: Mon, 14 May 2012 22:12:52 -0400
Message-ID: <1337048075-6132-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/ksm.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 956880f..5e8e222 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1270,6 +1270,12 @@ static struct rmap_item *scan_get_next_rmap_item(struct page **page)
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
-- 
1.7.9.6

