Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2GWB4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:56:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54247 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab2GWBnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:01 -0400
Message-Id: <20120723010701.901167648@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        Benny Halevy <bhalevy@tonian.com>
Subject: [ 069/108] ore: Remove support of partial IO request (NFS crash)
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 62b62ad873f2accad9222a4d7ffbe1e93f6714c1 upstream.

Do to OOM situations the ore might fail to allocate all resources
needed for IO of the full request. If some progress was possible
it would proceed with a partial/short request, for the sake of
forward progress.

Since this crashes NFS-core and exofs is just fine without it just
remove this contraption, and fail.

TODO:
	Support real forward progress with some reserved allocations
	of resources, such as mem pools and/or bio_sets

[Bug since 3.2 Kernel]
CC: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exofs/ore.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 49cf230..24a49d4 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -735,13 +735,7 @@ static int _prepare_for_striping(struct ore_io_state *ios)
 out:
 	ios->numdevs = devs_in_group;
 	ios->pages_consumed = cur_pg;
-	if (unlikely(ret)) {
-		if (length == ios->length)
-			return ret;
-		else
-			ios->length -= length;
-	}
-	return 0;
+	return ret;
 }
 
 int ore_create(struct ore_io_state *ios)


