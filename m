Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2CSJS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:18:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52338 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2CSJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:18:25 -0400
Subject: [PATCH] mm: forbid lumpy-reclaim in shrink_active_list()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 13:18:21 +0400
Message-ID: <20120319091821.17716.54031.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reset reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC.
(sync/async sign is used only in shrink_page_list and does not affect shrink_active_list)

Currenly shrink_active_list() sometimes works in lumpy-reclaim mode,
if RECLAIM_MODE_LUMPYRECLAIM left over from earlier shrink_inactive_list().
Meanwhile, in age_active_anon() sc->reclaim_mode is totally zero.
So, current behavior is too complex and confusing, all this looks like bug.

In general, shrink_active_list() populate inactive list for next shrink_inactive_list().
Lumpy shring_inactive_list() isolate pages around choosen one from both active and
inactive lists. So, there no reasons for lumpy-isolation in shrink_active_list()

Proposed-by: Hugh Dickins <hughd@google.com>
Link: https://lkml.org/lkml/2012/3/15/583
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 57d8ef6..ae83ca3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1690,6 +1690,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
+	reset_reclaim_mode(sc);
+
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)

