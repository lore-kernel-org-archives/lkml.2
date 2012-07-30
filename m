Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2G3Rd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:33:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2G3RdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:33:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Shi <alex.shi@intel.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
Subject: =?UTF-8?q?=5B=2027/41=5D=20kswapd=3A=20assign=20new=5Forder=20and=20new=5Fclasszone=5Fidx=20after=20wakeup=20in=20sleeping?=
Date: Mon, 30 Jul 2012 10:31:26 -0700
Message-Id: <20120730172903.434761737@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Shi <alex.shi@intel.com>

commit f0dfcde099453aa4c0dc42473828d15a6d492936 upstream.

Stable note: Fixes https://bugzilla.redhat.com/show_bug.cgi?id=712019.  This
	patch reduces kswapd CPU usage.

There 2 places to read pgdat in kswapd.  One is return from a successful
balance, another is waked up from kswapd sleeping.  The new_order and
new_classzone_idx represent the balance input order and classzone_idx.

But current new_order and new_classzone_idx are not assigned after
kswapd_try_to_sleep(), that will cause a bug in the following scenario.

1: after a successful balance, kswapd goes to sleep, and new_order = 0;
   new_classzone_idx = __MAX_NR_ZONES - 1;

2: kswapd waked up with order = 3 and classzone_idx = ZONE_NORMAL

3: in the balance_pgdat() running, a new balance wakeup happened with
   order = 5, and classzone_idx = ZONE_NORMAL

4: the first wakeup(order = 3) finished successufly, return order = 3
   but, the new_order is still 0, so, this balancing will be treated as a
   failed balance.  And then the second tighter balancing will be missed.

So, to avoid the above problem, the new_order and new_classzone_idx need
to be assigned for later successful comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2908,6 +2908,8 @@ static int kswapd(void *p)
 						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
+			new_order = order;
+			new_classzone_idx = classzone_idx;
 			pgdat->kswapd_max_order = 0;
 			pgdat->classzone_idx = pgdat->nr_zones - 1;
 		}


