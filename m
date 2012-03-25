Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2CYU2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51477 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab2CYU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:20 -0400
Date: Sun, 25 Mar 2012 16:28:18 -0400 (EDT)
Message-Id: <20120325.162818.1509258059090497224.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] perf: Catch and handle out-of-date hist entry maps.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a process exec()'s, all the maps are retired, but we keep the
hist entries around which hold references to those outdated maps.

If the same library gets mapped in for which we have hist entries, a
new map will be created.  But when we take a perf entry hit within
that map, we'll find the existing hist entry with the older map.

This causes symbol translations to be done incorrectly.  For example,
the perf entry processing will lookup the correct uptodate map entry
and use that to calculate the symbol and DSO relative address.  But
later when we update the histogram we'll translate the address using
the outdated map file instead leading to conditions such as
out-of-range offsets in symbol__inc_addr_samples() which now has an
assertion for this situation.

Therefore, update the map of the hist_entry dynamically at
lookup/creation time.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/hist.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3dc99a9..b7ab3b9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -253,6 +253,15 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		if (!cmp) {
 			he->period += period;
 			++he->nr_events;
+
+			/* If the map of an existing hist_entry has
+			 * become out-of-date due to an exec() or
+			 * similar, update it.  Otherwise we will
+			 * mis-adjust symbol addresses when computing
+			 * the history counter to increment.
+			 */
+			if (he->ms.map != entry->ms.map)
+				he->ms.map = entry->ms.map;
 			goto out;
 		}
 
-- 
1.7.9.1

