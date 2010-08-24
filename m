Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab0HXXLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:11:36 -0400
Received: from kroah.org ([198.145.64.141]:41307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200Ab0HXXDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:12 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:08 2010
Message-Id: <20100824224508.354686241@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [082/114] can-raw: Fix skb_orphan_try handling
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit cff0d6e6edac7672b3f915bb4fb59f279243b7f9 upstream.

Commit fc6055a5ba31e2c14e36e8939f9bf2b6d586a7f5 (net: Introduce
skb_orphan_try()) allows an early orphan of the skb and takes care on
tx timestamping, which needs the sk-reference in the skb on driver level.
So does the can-raw socket, which has not been taken into account here.

The patch below adds a 'prevent_sk_orphan' bit in the skb tx shared info,
which fixes the problem discovered by Matthias Fuchs here:

      http://marc.info/?t=128030411900003&r=1&w=2

Even if it's not a primary tx timestamp topic it fits well into some skb
shared tx context. Or should be find a different place for the information to
protect the sk reference until it reaches the driver level?

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/skbuff.h |    4 +++-
 net/can/raw.c          |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -169,6 +169,7 @@ struct skb_shared_hwtstamps {
  * @software:		generate software time stamp
  * @in_progress:	device driver is going to provide
  *			hardware time stamp
+ * @prevent_sk_orphan:	make sk reference available on driver level
  * @flags:		all shared_tx flags
  *
  * These flags are attached to packets as part of the
@@ -178,7 +179,8 @@ union skb_shared_tx {
 	struct {
 		__u8	hardware:1,
 			software:1,
-			in_progress:1;
+			in_progress:1,
+			prevent_sk_orphan:1;
 	};
 	__u8 flags;
 };
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -655,6 +655,10 @@ static int raw_sendmsg(struct kiocb *ioc
 	err = sock_tx_timestamp(msg, sk, skb_tx(skb));
 	if (err < 0)
 		goto free_skb;
+
+	/* to be able to check the received tx sock reference in raw_rcv() */
+	skb_tx(skb)->prevent_sk_orphan = 1;
+
 	skb->dev = dev;
 	skb->sk  = sk;
 


