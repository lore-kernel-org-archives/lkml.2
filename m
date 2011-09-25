Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1IYLAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:00:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35522 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1IYLAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:00:30 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] vmscan.c: Invalid strict_strtoul check in write_scan_unevictable_node
Date: Sun, 25 Sep 2011 16:29:40 +0530
Message-Id: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_scan_unavictable_node checks the value req returned by
strict_strtoul and returns 1 if req is 0.

However, when strict_strtoul returns 0, it means successful conversion
of buf to unsigned long.

Due to this, the function was not proceeding to scan the zones for
unevictable pages even though we write a valid value to the 
scan_unevictable_pages sys file.

Changing this if check slightly to check for invalid value 
in buf as well as 0 value stored in res after successful conversion
via strict_strtoul.
In both cases, we do not perform the scanning of this node's zones.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/vmscan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b55699c..73996e6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3450,8 +3450,8 @@ static ssize_t write_scan_unevictable_node(struct sys_device *dev,
 	unsigned long res;
 	unsigned long req = strict_strtoul(buf, 10, &res);
 
-	if (!req)
-		return 1;	/* zero is no-op */
+	if (req || !res)
+		return 1; /* Invalid input or zero is no-op */
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
-- 
1.7.4.1

