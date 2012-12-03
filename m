Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab2LCOuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:50:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43744 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398Ab2LCOgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:18 -0500
Message-Id: <20121203143156.760367407@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 66/89] md: Avoid write invalid address if read_seqretry returned true.
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 35f9ac2dcec8f79d7059ce174fd7b7ee3290d620 upstream.

If read_seqretry returned true and bbp was changed, it will write
invalid address which can cause some serious problem.

This bug was introduced by commit v3.0-rc7-130-g2699b67.
So fix is suitable for 3.0.y thru 3.6.y.

Reported-by: zhuwenfeng@kedacom.com
Tested-by: zhuwenfeng@kedacom.com
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 14db6ab..4c7d880 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1817,10 +1817,10 @@ retry:
 			memset(bbp, 0xff, PAGE_SIZE);
 
 			for (i = 0 ; i < bb->count ; i++) {
-				u64 internal_bb = *p++;
+				u64 internal_bb = p[i];
 				u64 store_bb = ((BB_OFFSET(internal_bb) << 10)
 						| BB_LEN(internal_bb));
-				*bbp++ = cpu_to_le64(store_bb);
+				bbp[i] = cpu_to_le64(store_bb);
 			}
 			bb->changed = 0;
 			if (read_seqretry(&bb->lock, seq))


