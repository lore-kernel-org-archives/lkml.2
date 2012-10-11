Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab2JKBQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:16:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35604 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933564Ab2JKBO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:14:59 -0400
X-Sasl-enc: WuiuRSG9Yo8vwfhe5MqDofkq7lUomdJSnSOWNw9983Ts 1349918098
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 116/120] JFFS2: dont fail on bitflips in OOB
Date: Thu, 11 Oct 2012 10:01:08 +0900
Message-Id: <20121011005848.869628669@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/wbuf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1043,10 +1043,10 @@ int jffs2_check_oob_empty(struct jffs2_s
 	ops.datbuf = NULL;
 
 	ret = mtd_read_oob(c->mtd, jeb->offset, &ops);
-	if (ret || ops.oobretlen != ops.ooblen) {
+	if ((ret && !mtd_is_bitflip(ret)) || ops.oobretlen != ops.ooblen) {
 		pr_err("cannot read OOB for EB at %08x, requested %zd bytes, read %zd bytes, error %d\n",
 		       jeb->offset, ops.ooblen, ops.oobretlen, ret);
-		if (!ret)
+		if (!ret || mtd_is_bitflip(ret))
 			ret = -EIO;
 		return ret;
 	}
@@ -1085,10 +1085,10 @@ int jffs2_check_nand_cleanmarker(struct
 	ops.datbuf = NULL;
 
 	ret = mtd_read_oob(c->mtd, jeb->offset, &ops);
-	if (ret || ops.oobretlen != ops.ooblen) {
+	if ((ret && !mtd_is_bitflip(ret)) || ops.oobretlen != ops.ooblen) {
 		pr_err("cannot read OOB for EB at %08x, requested %zd bytes, read %zd bytes, error %d\n",
 		       jeb->offset, ops.ooblen, ops.oobretlen, ret);
-		if (!ret)
+		if (!ret || mtd_is_bitflip(ret))
 			ret = -EIO;
 		return ret;
 	}


