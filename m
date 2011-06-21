Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1FUBuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:50:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51562 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab1FUBuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:50:04 -0400
Date: Tue, 21 Jun 2011 11:49:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20110621114957.59fae11d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
net/bluetooth/l2cap_core.c between commit df3c3931ec58 ("Bluetooth: Fix
accepting connect requests for defer_setup") from the wireless-current
tree and commit ab07801d2898 ("Bluetooth: create channel timer to replace
sk_timer") from the wireless tree.

Jusr context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/l2cap_core.c
index 56fdd91,dff9d76..0000000
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@@ -4002,24 -4205,15 +4205,24 @@@ static int l2cap_security_cfm(struct hc
  			}
  		} else if (sk->sk_state == BT_CONNECT2) {
  			struct l2cap_conn_rsp rsp;
 -			__u16 result;
 +			__u16 res, stat;
  
  			if (!status) {
 -				sk->sk_state = BT_CONFIG;
 -				result = L2CAP_CR_SUCCESS;
 +				if (bt_sk(sk)->defer_setup) {
 +					struct sock *parent = bt_sk(sk)->parent;
 +					res = L2CAP_CR_PEND;
 +					stat = L2CAP_CS_AUTHOR_PEND;
 +					parent->sk_data_ready(parent, 0);
 +				} else {
 +					sk->sk_state = BT_CONFIG;
 +					res = L2CAP_CR_SUCCESS;
 +					stat = L2CAP_CS_NO_INFO;
 +				}
  			} else {
  				sk->sk_state = BT_DISCONN;
- 				l2cap_sock_set_timer(sk, HZ / 10);
+ 				l2cap_chan_set_timer(chan, HZ / 10);
 -				result = L2CAP_CR_SEC_BLOCK;
 +				res = L2CAP_CR_SEC_BLOCK;
 +				stat = L2CAP_CS_NO_INFO;
  			}
  
  			rsp.scid   = cpu_to_le16(chan->dcid);
