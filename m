Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2DEX3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2DEX3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        stable@kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf hists: Catch and handle out-of-date hist entry maps.
Date: Thu,  5 Apr 2012 20:28:50 -0300
Message-Id: <1333668532-3624-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333668532-3624-1-git-send-email-acme@infradead.org>
References: <1333668532-3624-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

When a process exec()'s, all the maps are retired, but we keep the hist
entries around which hold references to those outdated maps.

If the same library gets mapped in for which we have hist entries, a new
map will be created.  But when we take a perf entry hit within that map,
we'll find the existing hist entry with the older map.

This causes symbol translations to be done incorrectly.  For example,
the perf entry processing will lookup the correct uptodate map entry and
use that to calculate the symbol and DSO relative address.  But later
when we update the histogram we'll translate the address using the
outdated map file instead leading to conditions such as out-of-range
offsets in symbol__inc_addr_samples().

Therefore, update the map of the hist_entry dynamically at lookup/
creation time.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20120327.031418.1220315351537060808.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2ec4b60..9f6d630 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -256,6 +256,18 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
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
+			if (he->ms.map != entry->ms.map) {
+				he->ms.map = entry->ms.map;
+				if (he->ms.map)
+					he->ms.map->referenced = true;
+			}
 			goto out;
 		}
 
-- 
1.7.9.2.358.g22243

