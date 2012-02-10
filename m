Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2BJTmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:42:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61948 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab2BJTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:42:36 -0500
Subject: [PATCH 4/4] mm: use swap readahead at swapoff
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 23:42:33 +0400
Message-ID: <20120210194233.6492.86917.stgit@zurg>
In-Reply-To: <20120210193249.6492.18768.stgit@zurg>
References: <20120210193249.6492.18768.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_unuse() iterates over swap-entries sequentially,
thus readahead here will not hurt.

Test results:
Virtual machine: without patch 7 seconds, with patch 4 seconds.
Real hardware: without patch 100 seconds, with patch 70 seconds.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/swapfile.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d999f09..4c99689 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1106,8 +1106,7 @@ static int try_to_unuse(unsigned int type)
 		 */
 		swap_map = &si->swap_map[i];
 		entry = swp_entry(type, i);
-		page = read_swap_cache_async(entry,
-					GFP_HIGHUSER_MOVABLE, NULL, 0);
+		page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, NULL, 0);
 		if (!page) {
 			/*
 			 * Either swap_duplicate() failed because entry

