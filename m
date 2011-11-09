Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823Ab1KJD1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934796Ab1KJD1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.196994591@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [135/262] bonding: use local function pointer of bond->recv_probe in bond_handle_frame
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

[ Upstream commit 4d97480b1806e883eb1c7889d4e7a87e936e06d9 ]

The bond->recv_probe is called in bond_handle_frame() when
a packet is received, but bond_close() sets it to NULL. So,
a panic occurs when both functions work in parallel.

Why this happen:
After null pointer check of bond->recv_probe, an sk_buff is
duplicated and bond->recv_probe is called in bond_handle_frame.
So, a panic occurs when bond_close() is called between the
check and call of bond->recv_probe.

Patch:
This patch uses a local function pointer of bond->recv_probe
in bond_handle_frame(). So, it can avoid the null pointer
dereference.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1500,6 +1500,8 @@ static rx_handler_result_t bond_handle_f
 	struct sk_buff *skb = *pskb;
 	struct slave *slave;
 	struct bonding *bond;
+	void (*recv_probe)(struct sk_buff *, struct bonding *,
+				struct slave *);
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
@@ -1513,11 +1515,12 @@ static rx_handler_result_t bond_handle_f
 	if (bond->params.arp_interval)
 		slave->dev->last_rx = jiffies;
 
-	if (bond->recv_probe) {
+	recv_probe = ACCESS_ONCE(bond->recv_probe);
+	if (recv_probe) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
 		if (likely(nskb)) {
-			bond->recv_probe(nskb, bond, slave);
+			recv_probe(nskb, bond, slave);
 			dev_kfree_skb(nskb);
 		}
 	}


