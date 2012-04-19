Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2DSVKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:10:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab2DSVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:56 -0400
Message-Id: <20120419210612.470820966@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 16/59] perf hists: Catch and handle out-of-date hist entry maps.
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

commit 63fa471dd49e9c9ce029d910d1024330d9b1b145 upstream.

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
Link: http://lkml.kernel.org/r/20120327.031418.1220315351537060808.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -158,6 +158,18 @@ struct hist_entry *__hists__add_entry(st
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
 


