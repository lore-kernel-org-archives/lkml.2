Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab2J3Sjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2J3Sjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:39:33 -0400
Date: Tue, 30 Oct 2012 14:42:04 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, klamm@yandex-team.ru,
        akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org
Subject: [PATCH RFC] mm,vmscan: only evict file pages when we have plenty
Message-ID: <20121030144204.0aa14d92@dull>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have more inactive file pages than active file pages, we
skip scanning the active file pages alltogether, with the idea
that we do not want to evict the working set when there is
plenty of streaming IO in the cache.

However, the code forgot to also skip scanning anonymous pages
in that situation.  That lead to the curious situation of keeping
the active file pages protected from being paged out when there
are lots of inactive file pages, while still scanning and evicting
anonymous pages.

This patch fixes that situation, by only evicting file pages
when we have plenty of them and most are inactive.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2624edc..1a53fbb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1686,6 +1686,15 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			fraction[1] = 0;
 			denominator = 1;
 			goto out;
+		} else if (!inactive_file_is_low_global(zone)) {
+			/*
+			 * There is enough inactive page cache, do not
+			 * reclaim anything from the working set right now.
+			 */
+			fraction[0] = 0;
+			fraction[1] = 1;
+			denominator = 1;
+			goto out;
 		}
 	}
 
