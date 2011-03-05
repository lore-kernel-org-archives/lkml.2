Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1CEBGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:06:47 -0500
Received: from kroah.org ([198.145.64.141]:47728 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab1CEBFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:53 2011
Message-Id: <20110305010353.078132115@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [13/18] dccp: fix oops on Reset after close
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Gerrit Renker <gerrit@erg.abdn.ac.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/input.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -616,6 +616,9 @@ int dccp_rcv_state_process(struct sock *
 		/* Caller (dccp_v4_do_rcv) will send Reset */
 		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
 		return 1;
+	} else if (sk->sk_state == DCCP_CLOSED) {
+		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
+		return 1;
 	}
 
 	if (sk->sk_state != DCCP_REQUESTING && sk->sk_state != DCCP_RESPOND) {
@@ -678,10 +681,6 @@ int dccp_rcv_state_process(struct sock *
 	}
 
 	switch (sk->sk_state) {
-	case DCCP_CLOSED:
-		dcb->dccpd_reset_code = DCCP_RESET_CODE_NO_CONNECTION;
-		return 1;
-
 	case DCCP_REQUESTING:
 		queued = dccp_rcv_request_sent_state_process(sk, skb, dh, len);
 		if (queued >= 0)


