Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1LZLvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:51:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1LZLvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:51:31 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Eric B Munson <emunson@mgebm.net>, Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] swapfile: swap_info_get: Check for swap_info[type] == NULL
Date: Mon, 26 Dec 2011 17:26:39 +0530
Message-Id: <1324900599-20804-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>

If the swapfile type encoded within entry.val is corrupted in
such a way that the swap_info[type] == NULL, then the code in
swap_info_get will cause a NULL pointer exception.

Assuming that the code in swap_info_get attempts to validate the
swapfile type by checking its range, another bad_nofile check would
be to check for check whether the swap_info[type] pointer is NULL.

Adding a NULL check for swap_info[type] to be reagrded as a "bad_nofile"
error scenario.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/swapfile.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b1cd120..7bdbe91 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -483,6 +483,8 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 	if (type >= nr_swapfiles)
 		goto bad_nofile;
 	p = swap_info[type];
+	if (!p)
+		goto bad_nofile;
 	if (!(p->flags & SWP_USED))
 		goto bad_device;
 	offset = swp_offset(entry);
-- 
1.7.6

