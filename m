Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1CEQut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:50:49 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:38312 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1CEQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:21 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 18/24] sys_swapon: call swap_cgroup_swapon earlier
Date: Sat,  5 Mar 2011 13:42:19 -0300
Message-Id: <1299343345-3984-19-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to swap_cgroup_swapon is in the middle of loading the swap map
and extents. As it only does memory allocation and does not depend on
the swapfile layout (map/extents), it can be called earlier (or later).

Move it to just after the allocation of swap_map, since it is
conceptually similar (allocates a map).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 13c13bd..7ac81fe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2074,6 +2074,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap;
 	}
 
+	error = swap_cgroup_swapon(p->type, maxpages);
+	if (error)
+		goto bad_swap;
+
 	nr_good_pages = maxpages - 1;	/* omit header page */
 
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -2088,10 +2092,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = swap_cgroup_swapon(p->type, maxpages);
-	if (error)
-		goto bad_swap;
-
 	if (nr_good_pages) {
 		swap_map[0] = SWAP_MAP_BAD;
 		p->max = maxpages;
-- 
1.7.4

