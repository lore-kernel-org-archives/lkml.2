Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab0JZMVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:21:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36608 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0JZMU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:20:59 -0400
Date: Tue, 26 Oct 2010 14:20:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Karsten Keil <isdn@linux-pingi.de>, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] drivers/isdn: delete double assignment
In-Reply-To: <4CC6C1C0.8020005@bfs.de>
Message-ID: <Pine.LNX.4.64.1010261419510.25281@ask.diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-11-git-send-email-julia@diku.dk> <4CC6C1C0.8020005@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  In the first case, the
hscx array has two elements, so change the assignment to initialize the
second one.  In the second case, the two assignments are simply identical.
Furthermore, neither is necessary, because the effect of the assignment is
only visible in the next line, in the assignment in the if test.  The patch
inlines the right hand side value in the latter assignment and pulls that
assignment out of the if test.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
In the first case, the patch changes the semantics and has not been tested.

 drivers/isdn/hardware/mISDN/mISDNinfineon.c |    2 +-
 drivers/isdn/hisax/l3_1tr6.c                |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index af25e1f..e90db88 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -563,7 +563,7 @@ reset_inf(struct inf_hw *hw)
 		mdelay(10);
 		hw->ipac.isac.adf2 = 0x87;
 		hw->ipac.hscx[0].slot = 0x1f;
-		hw->ipac.hscx[0].slot = 0x23;
+		hw->ipac.hscx[1].slot = 0x23;
 		break;
 	case INF_GAZEL_R753:
 		val = inl((u32)hw->cfg.start + GAZEL_CNTRL);
diff --git a/drivers/isdn/hisax/l3_1tr6.c b/drivers/isdn/hisax/l3_1tr6.c
index b0554f8..ee4dae1 100644
--- a/drivers/isdn/hisax/l3_1tr6.c
+++ b/drivers/isdn/hisax/l3_1tr6.c
@@ -164,11 +164,9 @@ l3_1tr6_setup(struct l3_process *pc, u_char pr, void *arg)
 	char tmp[80];
 	struct sk_buff *skb = arg;
 
-	p = skb->data;
-
 	/* Channel Identification */
-	p = skb->data;
-	if ((p = findie(p, skb->len, WE0_chanID, 0))) {
+	p = findie(skb->data, skb->len, WE0_chanID, 0);
+	if (p) {
 		if (p[1] != 1) {
 			l3_1tr6_error(pc, "setup wrong chanID len", skb);
 			return;
