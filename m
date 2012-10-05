Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2JEVdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:33:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51449 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2JEVd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:33:29 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: samuel@sortiz.org
Cc: irda-users@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 6/20 V2] drivers/net/irda/irtty-sir.c: fix error return code
Date: Fri,  5 Oct 2012 23:33:03 +0200
Message-Id: <1349472786-10921-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349472786-10921-1-git-send-email-peter.senna@gmail.com>
References: <1349472786-10921-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

The function irtty_open() return 0 for success and negative value
for most of its internal tests failures. There is one exception
that is error case going to out_put:. For this error case, the
function abort its success execution path, but returns non negative
value, making it difficult for a caller function to notice the error.

This patch fixes the error case that do not return negative value.

This was found by Coccinelle, but the code change was made by hand.
This patch is not robot generated.

A simplified version of the semantic match that finds this problem is
as follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Change from V1:
        Updated commit message. See:
        http://www.kernelhub.org/?p=2&msg=139319

 drivers/net/irda/irtty-sir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 30087ca..6e4d4b6 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -459,8 +459,10 @@ static int irtty_open(struct tty_struct *tty)
 
 	/* allocate private device info block */
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
+	if (!priv) {
+		ret = -ENOMEM;
 		goto out_put;
+	}
 
 	priv->magic = IRTTY_MAGIC;
 	priv->tty = tty;

