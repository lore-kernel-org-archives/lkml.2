Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2JNO75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:59:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46499 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182Ab2JNOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:24 -0400
Message-Id: <20121014143544.756915397@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 081/147] JFFS2: dont fail on bitflips in OOB
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 74d83beaa229aac7d126ac1ed9414658ff1a89d2 upstream.

JFFS2 was designed without thought for OOB bitflips, it seems, but they
can occur and will be reported to JFFS2 via mtd_read_oob()[1]. We don't
want to fail on these transactions, since the data was corrected.

[1] Few drivers report bitflips for OOB-only transactions. With such
    drivers, this patch should have no effect.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jffs2/wbuf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1032,11 +1032,11 @@ int jffs2_check_oob_empty(struct jffs2_s
 	ops.datbuf = NULL;
 
 	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
-	if (ret || ops.oobretlen != ops.ooblen) {
+	if ((ret && !mtd_is_bitflip(ret)) || ops.oobretlen != ops.ooblen) {
 		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
 				" bytes, read %zd bytes, error %d\n",
 				jeb->offset, ops.ooblen, ops.oobretlen, ret);
-		if (!ret)
+		if (!ret || mtd_is_bitflip(ret))
 			ret = -EIO;
 		return ret;
 	}
@@ -1075,11 +1075,11 @@ int jffs2_check_nand_cleanmarker(struct
 	ops.datbuf = NULL;
 
 	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
-	if (ret || ops.oobretlen != ops.ooblen) {
+	if ((ret && !mtd_is_bitflip(ret)) || ops.oobretlen != ops.ooblen) {
 		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
 				" bytes, read %zd bytes, error %d\n",
 				jeb->offset, ops.ooblen, ops.oobretlen, ret);
-		if (!ret)
+		if (!ret || mtd_is_bitflip(ret))
 			ret = -EIO;
 		return ret;
 	}


