Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1HNQKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab1HNQKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.676106328@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>
Subject: [86/90] dp83640: increase receive time stamp buffer size
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 8028837d71ba9904b17281b40f94b93e947fbe38 upstream.

The dp83640 buffers receive time stamps from special PHY status frames,
matching them to received PTP packets in a work queue. Because the timeout
for orphaned time stamps is so long and the buffer is so small, the driver
can drop time stamps under moderate PTP traffic.

This commit fixes the issue by decreasing the timeout to (at least) one
timer tick and increasing the buffer size.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/phy/dp83640.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -34,8 +34,7 @@
 #define PAGESEL		0x13
 #define LAYER4		0x02
 #define LAYER2		0x01
-#define MAX_RXTS	4
-#define MAX_TXTS	4
+#define MAX_RXTS	64
 #define N_EXT_TS	1
 #define PSF_PTPVER	2
 #define PSF_EVNT	0x4000
@@ -218,7 +217,7 @@ static void phy2rxts(struct phy_rxts *p,
 	rxts->seqid = p->seqid;
 	rxts->msgtype = (p->msgtype >> 12) & 0xf;
 	rxts->hash = p->msgtype & 0x0fff;
-	rxts->tmo = jiffies + HZ;
+	rxts->tmo = jiffies + 2;
 }
 
 static u64 phy2txts(struct phy_txts *p)


