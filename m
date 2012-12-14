Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2LNLBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:01:18 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53302 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2LNLBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:16 -0500
Subject: [PATCH] mm/swap: abort swapoff after disk error
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>
Date: Fri, 14 Dec 2012 15:01:10 +0400
Message-ID: <20121214110110.8181.70783.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content of non-uptodate pages completely random, we cannot expose them into
userspace. This leads to information leak and will crash userspace for sure.
Probably we can reuse hwpoison entries here, but tmpfs already too complex.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Original-patch-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 mm/swapfile.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e97a0e5..98fc2fd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1127,6 +1127,22 @@ int try_to_unuse(unsigned int type, bool frontswap,
 		wait_on_page_writeback(page);
 
 		/*
+		 * If read failed we cannot map not-uptodate page to
+		 * user space. Actually, we are in serious troubles,
+		 * we do not even know what process to kill. So, the only
+		 * variant remains: to stop swapoff() and allow someone
+		 * to kill processes to zap invalid pages.
+		 *
+		 * TODO replace page with hwpoison entry in pte and shmem.
+		 */
+		if (unlikely(!PageUptodate(page))) {
+			unlock_page(page);
+			page_cache_release(page);
+			retval = -EIO;
+			break;
+		}
+
+		/*
 		 * Remove all references to entry.
 		 */
 		swcount = *swap_map;

