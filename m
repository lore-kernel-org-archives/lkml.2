Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1FUCNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:13:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46653 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1FUCNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:13:15 -0400
Date: Tue, 21 Jun 2011 12:13:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: linux-next: manual merge of the bluetooth tree with the
 wireless-current tree
Message-Id: <20110621121310.bcdd3268.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/l2cap_core.c between commit df3c3931ec58 ("Bluetooth: Fix
accepting connect requests for defer_setup") from the wireless-current/
tree and various commits from the bluetooth tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/l2cap_core.c
index 8048337,700d01e..0000000
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@@ -4200,29 -4207,20 +4207,29 @@@ static int l2cap_security_cfm(struct hc
  				l2cap_send_cmd(conn, chan->ident,
  					L2CAP_CONN_REQ, sizeof(req), &req);
  			} else {
- 				l2cap_chan_clear_timer(chan);
- 				l2cap_chan_set_timer(chan, HZ / 10);
+ 				__clear_chan_timer(chan);
+ 				__set_chan_timer(chan, HZ / 10);
  			}
- 		} else if (sk->sk_state == BT_CONNECT2) {
+ 		} else if (chan->state == BT_CONNECT2) {
  			struct l2cap_conn_rsp rsp;
 -			__u16 result;
 +			__u16 res, stat;
  
  			if (!status) {
 -				l2cap_state_change(chan, BT_CONFIG);
 -				result = L2CAP_CR_SUCCESS;
 +				if (bt_sk(sk)->defer_setup) {
 +					struct sock *parent = bt_sk(sk)->parent;
 +					res = L2CAP_CR_PEND;
 +					stat = L2CAP_CS_AUTHOR_PEND;
 +					parent->sk_data_ready(parent, 0);
 +				} else {
- 					sk->sk_state = BT_CONFIG;
++					l2cap_state_change(chan, BT_CONFIG);
 +					res = L2CAP_CR_SUCCESS;
 +					stat = L2CAP_CS_NO_INFO;
 +				}
  			} else {
- 				sk->sk_state = BT_DISCONN;
- 				l2cap_chan_set_timer(chan, HZ / 10);
+ 				l2cap_state_change(chan, BT_DISCONN);
+ 				__set_chan_timer(chan, HZ / 10);
 -				result = L2CAP_CR_SEC_BLOCK;
 +				res = L2CAP_CR_SEC_BLOCK;
 +				stat = L2CAP_CS_NO_INFO;
  			}
  
  			rsp.scid   = cpu_to_le16(chan->dcid);
