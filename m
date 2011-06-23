Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab1FWSDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:03:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:34836 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510Ab1FWRhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 144/247] dccp: fix oops on Reset after close
Date: Thu, 23 Jun 2011 13:33:32 -0400
Message-Id: <1308850515-15242-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerrit Renker <gerrit@erg.abdn.ac.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 720dc34bbbe9493c7bd48b2243058b4e447a929d upstream.

This fixes a bug in the order of dccp_rcv_state_process() that still permitted
reception even after closing the socket. A Reset after close thus causes a NULL
pointer dereference by not preventing operations on an already torn-down socket.

 dccp_v4_do_rcv()
	|
	| state other than OPEN
	v
 dccp_rcv_state_process()
	|
	| DCCP_PKT_RESET
	v
 dccp_rcv_reset()
	|
	v
 dccp_time_wait()

 WARNING: at net/ipv4/inet_timewait_sock.c:141 __inet_twsk_hashdance+0x48/0x128()
 Modules linked in: arc4 ecb carl9170 rt2870sta(C) mac80211 r8712u(C) crc_ccitt ah
 [<c0038850>] (unwind_backtrace+0x0/0xec) from [<c0055364>] (warn_slowpath_common)
 [<c0055364>] (warn_slowpath_common+0x4c/0x64) from [<c0055398>] (warn_slowpath_n)
 [<c0055398>] (warn_slowpath_null+0x1c/0x24) from [<c02b72d0>] (__inet_twsk_hashd)
 [<c02b72d0>] (__inet_twsk_hashdance+0x48/0x128) from [<c031caa0>] (dccp_time_wai)
 [<c031caa0>] (dccp_time_wait+0x40/0xc8) from [<c031c15c>] (dccp_rcv_state_proces)
 [<c031c15c>] (dccp_rcv_state_process+0x120/0x538) from [<c032609c>] (dccp_v4_do_)
 [<c032609c>] (dccp_v4_do_rcv+0x11c/0x14c) from [<c0286594>] (release_sock+0xac/0)
 [<c0286594>] (release_sock+0xac/0x110) from [<c031fd34>] (dccp_close+0x28c/0x380)
 [<c031fd34>] (dccp_close+0x28c/0x380) from [<c02d9a78>] (inet_release+0x64/0x70)

The fix is by testing the socket state first. Receiving a packet in Closed state
now also produces the required "No connection" Reset reply of RFC 4340, 8.3.1.

Reported-and-tested-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/dccp/input.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/dccp/input.c b/net/dccp/input.c
index def29ca..3caceee 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -617,6 +617,9 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Caller (dccp_v4_do_rcv) will send Reset */
 		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
 		return 1;
+	} else if (sk->sk_state == DCCP_CLOSED) {
+		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
+		return 1;
 	}
 
 	if (sk->sk_state != DCCP_REQUESTING && sk->sk_state != DCCP_RESPOND) {
@@ -679,10 +682,6 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	}
 
 	switch (sk->sk_state) {
-	case DCCP_CLOSED:
-		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
-		return 1;
-
 	case DCCP_REQUESTING:
 		queued = dccp_rcv_request_sent_state_process(sk, skb, dh, len);
 		if (queued >= 0)
-- 
1.7.4.4

