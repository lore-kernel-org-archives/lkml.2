Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2DWTIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:08:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33282 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2DWTIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:08:14 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 12:08:13 -0700
Message-ID: <CAMe9rOqy4g9QeOC7xWRmi3Wr=97qbUXm1G69pWgdcfykJQgMPQ@mail.gmail.com>
Subject: Incomplete cherry-pick on linux-3.3.y branch
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This cherry-pick commit:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=1cb41fe7e34a43a1d27dfdb6d65699786dd44c20

doesn't work on 3.3 branch since it misses other commits
required.  On 3.3 branch, there are

struct hist_entry *__hists__add_entry(struct hists *hists,
                                      struct addr_location *al,
                                      struct symbol *sym_parent, u64 period)
{
        struct rb_node **p;
        struct rb_node *parent = NULL;
        struct hist_entry *he;
        struct hist_entry entry = {
                .thread = al->thread,

It doesn't work with

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e11e482..a47a6f1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -230,6 +230,18 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
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

since entry isn't a pointer on 3.3 branch.


-- 
H.J.
