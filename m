Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1FBRg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:36:27 -0400
Received: from sous-sol.org ([216.99.217.87]:43545 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753148Ab1FBRg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:36:26 -0400
Date: Thu, 2 Jun 2011 10:35:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrea Righi <andrea@betterlinux.com>, CAI Qian <caiqian@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Izik Eidus <ieidus@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ksm: fix race between ksmd and exiting task
Message-ID: <20110602173549.GL23047@sequoia.sous-sol.org>
References: <20110601222032.GA2858@thinkpad>
 <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <20110602141927.GA2011@thinkpad>
 <20110602164841.GK23047@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602164841.GK23047@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi reported a case where an exiting task can race against
ksmd.

ksm_scan.mm_slot == the only registered mm
CPU 1 (bug program)		CPU 2 (ksmd)
 				list_empty() is false
lock
ksm_scan.mm_slot
list_del
unlock
 				slot == &ksm_mm_head (but list is now empty_)

Close this race by revalidating that the new slot is not simply the list
head again.

Reported-by: Andrea Righi <andrea@betterlinux.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/ksm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 942dfc7..0373ce4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1301,6 +1301,9 @@ static struct rmap_item *scan_get_next_rmap_item(struct page **page)
 		slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
 		ksm_scan.mm_slot = slot;
 		spin_unlock(&ksm_mmlist_lock);
+		/* We raced against exit of last slot on the list */
+		if (slot == &ksm_mm_head)
+			return NULL;
 next_mm:
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &slot->rmap_list;
