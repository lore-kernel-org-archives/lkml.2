Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0E3Nts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 09:49:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49169 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0E3Ntp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 09:49:45 -0400
Date: Sun, 30 May 2010 15:49:40 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/isdn/hardware/mISDN: Use GFP_ATOMIC when a lock
 is held
Message-ID: <Pine.LNX.4.64.1005301549230.15938@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function inittiger is only called from nj_init_card, where a lock is held.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@gfp exists@
identifier fn;
position p;
@@

fn(...) {
 ... when != spin_unlock_irqrestore
     when any
 GFP_KERNEL@p
 ... when any
}

@locked@
identifier gfp.fn;
@@

spin_lock_irqsave(...)
...  when != spin_unlock_irqrestore
fn(...)

@depends on locked@
position gfp.p;
@@

- GFP_KERNEL@p
+ GFP_ATOMIC
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hardware/mISDN/netjet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -320,12 +320,12 @@ inittiger(struct tiger_hw *card)
 		return -ENOMEM;
 	}
 	for (i = 0; i < 2; i++) {
-		card->bc[i].hsbuf = kmalloc(NJ_DMA_TXSIZE, GFP_KERNEL);
+		card->bc[i].hsbuf = kmalloc(NJ_DMA_TXSIZE, GFP_ATOMIC);
 		if (!card->bc[i].hsbuf) {
 			pr_info("%s: no B%d send buffer\n", card->name, i + 1);
 			return -ENOMEM;
 		}
-		card->bc[i].hrbuf = kmalloc(NJ_DMA_RXSIZE, GFP_KERNEL);
+		card->bc[i].hrbuf = kmalloc(NJ_DMA_RXSIZE, GFP_ATOMIC);
 		if (!card->bc[i].hrbuf) {
 			pr_info("%s: no B%d recv buffer\n", card->name, i + 1);
 			return -ENOMEM;
