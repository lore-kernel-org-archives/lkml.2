Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0HPQYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:24:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34655 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0HPQYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:24:44 -0400
Date: Mon, 16 Aug 2010 18:24:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/16] drivers/firewire: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161824210.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in retval, but the return value is always 0.  Return
retval in the error case instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics of the code and has not been tested.
Furthermore, there is another call, to fwnet_pd_update, where there is a
goto to bad_proto (the label associated with the second block of code), and
that does not set retval.  Perhaps a value should be chosen in that case.
Or perhaps retval should just be dropped, if it is not going to be used.

 drivers/firewire/net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index da17d40..8d91484 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -681,7 +681,7 @@ static int fwnet_incoming_packet(struct fwnet_device *dev, __be32 *buf, int len,
 	int fg_off;
 	int dg_size;
 	u16 datagram_label;
-	int retval;
+	int retval = 0;
 	u16 ether_type;
 
 	hdr.w0 = be32_to_cpu(buf[0]);
@@ -801,7 +801,7 @@ static int fwnet_incoming_packet(struct fwnet_device *dev, __be32 *buf, int len,
 	if (netif_queue_stopped(net))
 		netif_wake_queue(net);
 
-	return 0;
+	return retval;
 }
 
 static void fwnet_receive_packet(struct fw_card *card, struct fw_request *r,
