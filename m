Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2JGXbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:31:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38585 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063Ab2JGXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:05 -0400
Message-Id: <20121007225841.350586705@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        =?ISO-8859-15?q?Jakub=20Hus=C3=A1k?= <jakub@gooseman.cz>
Subject: [ 048/108] md/raid10: fix "enough" function for detecting if array is failed.
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 80b4812407c6b1f66a4f2430e69747a13f010839 upstream.

The 'enough' function is written to work with 'near' arrays only
in that is implicitly assumes that the offset from one 'group' of
devices to the next is the same as the number of copies.
In reality it is the number of 'near' copies.

So change it to make this number explicit.

This bug makes it possible to run arrays without enough drives
present, which is dangerous.
It is appropriate for an -stable kernel, but will almost certainly
need to be modified for some of them.

Reported-by: Jakub Husák <jakub@gooseman.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.2: s/geo->/conf->/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1226,14 +1226,16 @@ static int enough(struct r10conf *conf,
 	do {
 		int n = conf->copies;
 		int cnt = 0;
+		int this = first;
 		while (n--) {
-			if (conf->mirrors[first].rdev &&
-			    first != ignore)
+			if (conf->mirrors[this].rdev &&
+			    this != ignore)
 				cnt++;
-			first = (first+1) % conf->raid_disks;
+			this = (this+1) % conf->raid_disks;
 		}
 		if (cnt == 0)
 			return 0;
+		first = (first + conf->near_copies) % conf->raid_disks;
 	} while (first != 0);
 	return 1;
 }


