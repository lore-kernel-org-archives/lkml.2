Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0IAAbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:31:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0IAAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:31:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100901092430.9741.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 09:31:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
Also he was bisected first bad commit is below

  commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
  Date:   Fri Jun 4 14:15:05 2010 -0700

     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure

At first impression, this seemed very strange because the above commit only
chenged function return value and hibernate_preallocate_memory() ignore
return value of shrink_all_memory(). But it's related.

Now, page allocation from hibernation code may enter infinite loop if
the system has highmem.

The reasons are two. 1) hibernate_preallocate_memory() call
alloc_pages() wrong order 2) vmscan don't care enough OOM case when
oom_killer_disabled.

This patch only fix (2). Why is oom_killer_disabled so special?
because when hibernation case, zone->all_unreclaimable never be turned on.
hibernation freeze all tasks at first, then kswapd can't works in this
case, and zone->all_unreclaimable is only turned from kswapd.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: M. Vefa Bicakci <bicave@superonline.com>
Cc: stable@kernel.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c391c32..1919d8a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -40,6 +40,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1931,7 +1932,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (scanning_global_lru(sc) && !all_unreclaimable)
+	if (scanning_global_lru(sc) && !all_unreclaimable && !oom_killer_disabled)
 		return 1;
 
 	return 0;
-- 
1.6.5.2



