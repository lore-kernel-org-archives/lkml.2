Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1GIGA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:00:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48291 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab1GIFyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:15 -0400
X-Sasl-enc: dQapEWriYzt3QJgpvg1bkPyq6I3Bf/JuY9AS83Hzmklv 1310190855
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:19 2011
Message-Id: <20110708225118.932348601@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:49:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [01/35] ksm: fix NULL pointer dereference in scan_get_next_rmap_item()
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 mm/ksm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1215,6 +1215,12 @@ static struct rmap_item *scan_get_next_r
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
 		ksm_scan.rmap_item = list_entry(&slot->rmap_list,


