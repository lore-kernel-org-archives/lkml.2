Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DMSDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:03:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2DMSDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:03:40 -0400
Date: Fri, 13 Apr 2012 11:03:29 -0700
From: tip-bot for David Miller <davem@davemloft.net>
Message-ID: <tip-63fa471dd49e9c9ce029d910d1024330d9b1b145@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120327.031418.1220315351537060808.davem@davemloft.net>
References: <20120327.031418.1220315351537060808.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Catch and handle out-of-date hist entry maps.
Git-Commit-ID: 63fa471dd49e9c9ce029d910d1024330d9b1b145
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:03:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63fa471dd49e9c9ce029d910d1024330d9b1b145
Gitweb:     http://git.kernel.org/tip/63fa471dd49e9c9ce029d910d1024330d9b1b145
Author:     David Miller <davem@davemloft.net>
AuthorDate: Tue, 27 Mar 2012 03:14:18 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Apr 2012 18:53:47 -0300

perf hists: Catch and handle out-of-date hist entry maps.

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
 1 files changed, 12 insertions(+), 0 deletions(-)

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
 
