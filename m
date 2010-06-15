Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab0FOShr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915Ab0FOShq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:37:46 -0400
Date: Tue, 15 Jun 2010 20:35:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Salman <sqazi@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       tytso@google.com, torvalds@linux-foundation.org, walken@google.com
Subject: [PATCH 1/1] pids: alloc_pidmap: remove the unnecessary boundary
	checks
Message-ID: <20100615183556.GB24577@redhat.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com> <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com> <20100615183525.GA24577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615183525.GA24577@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pidmap() calculates max_scan so that if the initial offset != 0
we inspect the first map->page twice. This is correct, we want to find
the unused bits < offset in this bitmap block. Add the comment.

But it doesn't make any sense to stop the find_next_offset() loop when
we are looking into this map->page for the second time. We have already
already checked the bits >= offset during the first attempt, it is fine
to do this again, no matter if we succeed this time or not.

Remove this hard-to-understand code. It optimizes the very unlikely case
when we are going to fail, but slows down the more likely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/pid.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- 35-rc2/kernel/pid.c~PID_CLEANUP	2010-06-15 19:33:14.000000000 +0200
+++ 35-rc2/kernel/pid.c	2010-06-15 19:52:03.000000000 +0200
@@ -169,7 +169,12 @@ static int alloc_pidmap(struct pid_names
 		pid = RESERVED_PIDS;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	/*
+	 * If last_pid points into the middle of the map->page we
+	 * want to scan this bitmap block twice, the second time
+	 * we start with offset == 0 (or RESERVED_PIDS).
+	 */
+	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		if (unlikely(!map->page)) {
 			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -196,15 +201,7 @@ static int alloc_pidmap(struct pid_names
 				}
 				offset = find_next_offset(map, offset);
 				pid = mk_pid(pid_ns, map, offset);
-			/*
-			 * find_next_offset() found a bit, the pid from it
-			 * is in-bounds, and if we fell back to the last
-			 * bitmap block and the final block was the same
-			 * as the starting point, pid is before last_pid.
-			 */
-			} while (offset < BITS_PER_PAGE && pid < pid_max &&
-					(i != max_scan || pid < last ||
-					    !((last+1) & BITS_PER_PAGE_MASK)));
+			} while (offset < BITS_PER_PAGE && pid < pid_max);
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;

