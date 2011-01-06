Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1AFUuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:50:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16763 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AFUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:50:30 -0500
Date: Thu, 6 Jan 2011 21:50:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Jean-Paul Roubelat <jpr@f6fbb.org>, Frederic Rible <frible@teaser.fr>,
        Thomas Sailer <sailer@ife.ee.ethz.ch>
Subject: [PATCH] hamradio: Resolve memory leak due to missing firmware release
 in add_mcs()
Message-ID: <alpine.LNX.2.00.1101062146430.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Failure to release_firmware() in drivers/net/hamradio/yam.c::add_mcs() 
causes memory leak.
This patch should fix it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 yam.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

  compile tested only

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 4e7d1d0..7d9ced0 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -396,7 +396,7 @@ static unsigned char *add_mcs(unsigned char *bits, int bitrate,
 	while (p) {
 		if (p->bitrate == bitrate) {
 			memcpy(p->bits, bits, YAM_FPGA_SIZE);
-			return p->bits;
+			goto out;
 		}
 		p = p->next;
 	}
@@ -411,7 +411,7 @@ static unsigned char *add_mcs(unsigned char *bits, int bitrate,
 	p->bitrate = bitrate;
 	p->next = yam_data;
 	yam_data = p;
-
+ out:
 	release_firmware(fw);
 	return p->bits;
 }


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

