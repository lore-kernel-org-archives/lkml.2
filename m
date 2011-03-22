Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1CVCiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 22:38:16 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:36575 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1CVCiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 22:38:13 -0400
Date: Mon, 21 Mar 2011 21:38:10 -0500
From: David Fries <david@fries.net>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rfcomm/core.c avoid dangling pointer, check session
Message-ID: <20110322023810.GG22204@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfcomm_process_sessions is calling rfcomm_process_rx, but
in this case the session is closed and freed leaving a
dangling pointer that blows up when rfcomm_process_rx returns
and rfcomm_process_dlcs is called with the now dangling session
pointer.

I can reproduce using blueman-manager on desktop, and Motorola S305 bluetooth
headset.  Start out with the desktop as the last device the S305 paired
with.
desktop, connect to the S305,
S305, turn on
desktop (connection fails)
desktop (connection automatically comes up now that S305 is on)
desktop disconnect S305
desktop (kernel panic)

While rfcomm_process_sessions looks symmetrical,
rfcomm_session_hold(s);
rfcomm_process_rx
rfcomm_process_dlcs
rfcomm_session_put(s);

rfcomm_process_rx
if (sk->sk_state == BT_CLOSED) {
	if (!s->initiator)
		rfcomm_session_put(s);
	rfcomm_session_close(s, sk->sk_err);

Which isn't symmetrical.

Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
rfcomm_run:
rfcomm_l2sock_create:
rfcomm_session_add: session ddad6a40 sock dcf22200
rfcomm_dlc_clear_state: dd85d640
rfcomm_dlc_alloc: dd85d640
rfcomm_dlc_free: dd85d640
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
rfcomm_dlc_clear_state: dd85d4c0
rfcomm_dlc_alloc: dd85d4c0
rfcomm_dlc_clear_state: dd85d540
rfcomm_dlc_alloc: dd85d540
rfcomm_dlc_clear_state: dd85d440
rfcomm_dlc_alloc: dd85d440
rfcomm_dlc_clear_state: dd85d3c0
rfcomm_dlc_alloc: dd85d3c0
rfcomm_dlc_clear_state: dd85d140
rfcomm_dlc_alloc: dd85d140
rfcomm_dlc_clear_state: dd85d1c0
rfcomm_dlc_alloc: dd85d1c0
rfcomm_dlc_clear_state: de6fcf60
rfcomm_dlc_alloc: de6fcf60
rfcomm_dlc_free: de6fcf60
rfcomm_dlc_clear_state: c15187a0
rfcomm_dlc_alloc: c15187a0
rfcomm_dlc_free: c15187a0
rfcomm_security_cfm: conn df67fa00 status 0x00 encrypt 0x01
rfcomm_l2data_ready: c3c02000 bytes 0
rfcomm_run 2070
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_accept_connection: session ddad6a40
rfcomm_session_add: session ddad6920 sock df31a4e0
rfcomm_run 2072
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 2 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 2
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next ddad6960
s->dlcs.prev ddad6960
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 4
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 2 qlen 1
rfcomm_recv_sabm: session ddad6920 state 2 dlci 0
rfcomm_send_ua: ddad6920 dlci 0
rfcomm_send_frame: session ddad6920 len 4
rfcomm_process_connect: session ddad6920 state 1
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next ddad6960
s->dlcs.prev ddad6960
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 14
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_mcc: ddad6920 type 0x20 cr 2
rfcomm_recv_pn: session ddad6920 state 1 dlci 26
rfcomm_dlc_clear_state: c15187a0
rfcomm_dlc_alloc: c15187a0
rfcomm_dlc_link: dlc c15187a0 session ddad6920
rfcomm_session_clear_timer: session ddad6920 state 1
rfcomm_apply_pn: dlc c15187a0 state 2 dlci 26 mtu 126 fc 0xf0 credits 0
rfcomm_send_pn: ddad6920 cr 0 dlci 26 mtu 126
rfcomm_send_frame: session ddad6920 len 14
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 4
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_sabm: session ddad6920 state 1 dlci 26
rfcomm_dlc_set_timer: dlc c15187a0 state 2 timeout 25000
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 20
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_security_cfm: conn df67fa00 status 0x00 encrypt 0x01
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 40
rfcomm_dlc_clear_timer: dlc c15187a0 state 2
rfcomm_dlc_set_timer: dlc c15187a0 state 2 timeout 25000
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_accept: dlc c15187a0
rfcomm_send_ua: ddad6920 dlci 26
rfcomm_send_frame: session ddad6920 len 4
rfcomm_dlc_clear_timer: dlc c15187a0 state 6
rfcomm_send_msc: ddad6920 cr 1 v24 0x8c
rfcomm_send_frame: session ddad6920 len 8
rfcomm_l2data_ready: c1690c00 bytes 8
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_mcc: ddad6920 type 0x38 cr 0
rfcomm_recv_msc: dlci 26 cr 0 v24 0x8d
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 8
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_mcc: ddad6920 type 0x38 cr 2
rfcomm_recv_msc: dlci 26 cr 2 v24 0xd
rfcomm_send_msc: ddad6920 cr 0 v24 0xd
rfcomm_send_frame: session ddad6920 len 8
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 7 tx_credits 0
rfcomm_send_credits: ddad6920 addr 105 credits 33
rfcomm_send_frame: session ddad6920 len 5
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 5
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 40 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_security_cfm: conn df67fa00 status 0x00 encrypt 0x00
rfcomm_dlc_set_timer: dlc c15187a0 state 1 timeout 25000
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_security_cfm: conn df67fa00 status 0x00 encrypt 0x01
rfcomm_dlc_clear_timer: dlc c15187a0 state 1
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 40 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 15
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 39 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 14
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 39 tx_credits 15
rfcomm_send_frame: session ddad6920 len 18
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 39 tx_credits 14
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 15
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 38 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 126
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 38 tx_credits 15
rfcomm_send_frame: session ddad6920 len 130
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 38 tx_credits 14
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 38 tx_credits 13
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 14
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 37 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 24
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 37 tx_credits 15
rfcomm_send_frame: session ddad6920 len 28
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 37 tx_credits 14
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 24
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 36 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 36 tx_credits 15
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 15
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 35 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 35 tx_credits 15
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2data_ready: c1690c00 bytes 15
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_data: session ddad6920 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 34 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_send: dlc c15187a0 mtu 126 len 6
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 0
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next c15187a0
s->dlcs.prev c15187a0
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: in loop, p c15187a0 n ddad6960 &s->dlcs ddad6960
rfcomm_process_dlcs: rfcomm_dlc c15187a0 flags 0
rfcomm_process_tx: dlc c15187a0 state 1 cfc 40 rx_credits 34 tx_credits 15
rfcomm_send_frame: session ddad6920 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
input: 00:0D:FD:36:A5:FC as /devices/virtual/input/input5
rfcomm_l2data_ready: c1690c00 bytes 4
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_disc: session ddad6920 state 1 dlci 26
rfcomm_send_ua: ddad6920 dlci 26
rfcomm_send_frame: session ddad6920 len 4
__rfcomm_dlc_close: dlc c15187a0 state 9 dlci 26 err 104 session ddad6920
rfcomm_dlc_clear_timer: dlc c15187a0 state 9
rfcomm_dlc_unlink: dlc c15187a0 refcnt 2 session ddad6920
rfcomm_session_set_timer: session ddad6920 state 1 timeout 2000
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 1
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next ddad6960
s->dlcs.prev ddad6960
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_free: c15187a0
rfcomm_l2data_ready: c1690c00 bytes 4
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 1 qlen 1
rfcomm_recv_disc: session ddad6920 state 1 dlci 0
rfcomm_send_ua: ddad6920 dlci 0
rfcomm_send_frame: session ddad6920 len 4
rfcomm_session_close: session ddad6920 state 9 err 104
rfcomm_session_clear_timer: session ddad6920 state 9
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 9
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next ddad6960
s->dlcs.prev ddad6960
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_l2state_change: c1690c00 state 9
rfcomm_run 2070
rfcomm_process_sessions: ddad6920 sock df31a4e0 flags 0
rfcomm_process_rx: session ddad6920 state 9 qlen 0
rfcomm_session_close: session ddad6920 state 9 err 104
rfcomm_session_clear_timer: session ddad6920 state 9
rfcomm_process_sessions: line 1976
rfcomm_process_dlcs: session ddad6920 state 9
rfcomm_process_dlcs: pre loop, &p c2ba1fb0 &n c2ba1fac &s->dlcs ddad6960
s->dlcs.next ddad6960
s->dlcs.prev ddad6960
s->dlcs.next->next ddad6960
LIST_POISON1 00100100 LIST_POISON2 00200200
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1978
rfcomm_session_del: session ddad6920 state 9
rfcomm_session_clear_timer: session ddad6920 state 9
rfcomm_process_sessions: line 1981
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_dlc_clear_state: c15187a0
rfcomm_dlc_alloc: c15187a0
rfcomm_dlc_free: c15187a0
rfcomm_dlc_clear_state: c15187a0
rfcomm_dlc_alloc: c15187a0
rfcomm_dlc_free: c15187a0
rfcomm_dlc_free: dd85d4c0
rfcomm_dlc_free: dd85d540
rfcomm_dlc_free: dd85d3c0
rfcomm_dlc_free: dd85d440
rfcomm_dlc_free: dd85d140
rfcomm_dlc_free: dd85d1c0
rfcomm_run 2070
rfcomm_process_sessions: ddad6a40 sock dcf22200 flags 0
rfcomm_run 2072
rfcomm_kill_listener:
rfcomm_session_del: session ddad6a40 state 4
rfcomm_session_clear_timer: session ddad6a40 state 4
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
rfcomm_run:
rfcomm_l2sock_create:
rfcomm_session_add: session df7e9740 sock df31ad20
rfcomm_dlc_clear_state: dd85d4c0
rfcomm_dlc_alloc: dd85d4c0
rfcomm_dlc_free: dd85d4c0
rfcomm_dlc_clear_state: dd85d5c0
rfcomm_dlc_alloc: dd85d5c0
rfcomm_dlc_clear_state: dd85d6c0
rfcomm_dlc_alloc: dd85d6c0
rfcomm_dlc_clear_state: dd85d740
rfcomm_dlc_alloc: dd85d740
rfcomm_dlc_clear_state: dd85d640
rfcomm_dlc_alloc: dd85d640
rfcomm_dlc_clear_state: dd85d140
rfcomm_dlc_alloc: dd85d140
rfcomm_dlc_clear_state: c1623f40
rfcomm_dlc_alloc: c1623f40
rfcomm_dlc_clear_state: c1623ec0
rfcomm_dlc_alloc: c1623ec0
rfcomm_dlc_free: c1623ec0
rfcomm_dlc_clear_state: c1623ec0
rfcomm_dlc_alloc: c1623ec0
rfcomm_dlc_free: c1623ec0
rfcomm_dlc_clear_state: c1623ec0
rfcomm_dlc_alloc: c1623ec0
rfcomm_dlc_free: c1623ec0
rfcomm_dlc_clear_state: c1623ec0
rfcomm_dlc_alloc: c1623ec0
rfcomm_dlc_free: c1623ec0
rfcomm_dlc_clear_state: c1623ec0
rfcomm_dlc_alloc: c1623ec0
rfcomm_dlc_free: c1623ec0
rfcomm_security_cfm: conn df71b000 status 0x00 encrypt 0x01
rfcomm_l2data_ready: c3c02000 bytes 0
rfcomm_run 2078
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_accept_connection: session df7e9740
rfcomm_session_add: session c16918a0 sock dccab360
rfcomm_run 2080
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 2 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 2
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c16918e0
s->dlcs.prev c16918e0
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 4
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 2 qlen 1
rfcomm_recv_sabm: session c16918a0 state 2 dlci 0
rfcomm_send_ua: c16918a0 dlci 0
rfcomm_send_frame: session c16918a0 len 4
rfcomm_process_connect: session c16918a0 state 1
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c16918e0
s->dlcs.prev c16918e0
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 14
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_mcc: c16918a0 type 0x20 cr 2
rfcomm_recv_pn: session c16918a0 state 1 dlci 26
rfcomm_dlc_clear_state: c1623e40
rfcomm_dlc_alloc: c1623e40
rfcomm_dlc_link: dlc c1623e40 session c16918a0
rfcomm_session_clear_timer: session c16918a0 state 1
rfcomm_apply_pn: dlc c1623e40 state 2 dlci 26 mtu 126 fc 0xf0 credits 0
rfcomm_send_pn: c16918a0 cr 0 dlci 26 mtu 126
rfcomm_send_frame: session c16918a0 len 14
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 4
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_sabm: session c16918a0 state 1 dlci 26
rfcomm_dlc_set_timer: dlc c1623e40 state 2 timeout 25000
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 20
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_security_cfm: conn df71b000 status 0x00 encrypt 0x01
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 40
rfcomm_dlc_clear_timer: dlc c1623e40 state 2
rfcomm_dlc_set_timer: dlc c1623e40 state 2 timeout 25000
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_accept: dlc c1623e40
rfcomm_send_ua: c16918a0 dlci 26
rfcomm_send_frame: session c16918a0 len 4
rfcomm_dlc_clear_timer: dlc c1623e40 state 6
rfcomm_send_msc: c16918a0 cr 1 v24 0x8c
rfcomm_send_frame: session c16918a0 len 8
rfcomm_l2data_ready: c1622000 bytes 8
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_mcc: c16918a0 type 0x38 cr 0
rfcomm_recv_msc: dlci 26 cr 0 v24 0x8d
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 8
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_mcc: c16918a0 type 0x38 cr 2
rfcomm_recv_msc: dlci 26 cr 2 v24 0xd
rfcomm_send_msc: c16918a0 cr 0 v24 0xd
rfcomm_send_frame: session c16918a0 len 8
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 7 tx_credits 0
rfcomm_send_credits: c16918a0 addr 105 credits 33
rfcomm_send_frame: session c16918a0 len 5
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 5
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 40 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_security_cfm: conn df71b000 status 0x00 encrypt 0x00
rfcomm_dlc_set_timer: dlc c1623e40 state 1 timeout 25000
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_security_cfm: conn df71b000 status 0x00 encrypt 0x01
rfcomm_dlc_clear_timer: dlc c1623e40 state 1
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 40 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 15
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 39 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 14
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 39 tx_credits 15
rfcomm_send_frame: session c16918a0 len 18
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 39 tx_credits 14
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 15
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 38 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 126
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 38 tx_credits 15
rfcomm_send_frame: session c16918a0 len 130
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 38 tx_credits 14
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 38 tx_credits 13
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 14
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 37 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 24
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 37 tx_credits 15
rfcomm_send_frame: session c16918a0 len 28
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 37 tx_credits 14
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 24
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 36 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 36 tx_credits 15
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 15
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 35 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 35 tx_credits 15
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 15
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_data: session c16918a0 state 1 dlci 26 pf 16
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 34 tx_credits 15
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_dlc_send: dlc c1623e40 mtu 126 len 6
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 1
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c1623e40
s->dlcs.prev c1623e40
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: in loop, p c1623e40 n c16918e0 &s->dlcs c16918e0
rfcomm_process_dlcs: rfcomm_dlc c1623e40 flags 0
rfcomm_process_tx: dlc c1623e40 state 1 cfc 40 rx_credits 34 tx_credits 15
rfcomm_send_frame: session c16918a0 len 10
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
input: 00:0D:FD:36:A5:FC as /devices/virtual/input/input6
rfcomm_dlc_clear_state: c16230c0
rfcomm_dlc_alloc: c16230c0
rfcomm_dlc_free: c16230c0
rfcomm_dlc_clear_state: c16230c0
rfcomm_dlc_alloc: c16230c0
rfcomm_dlc_free: c16230c0
__rfcomm_dlc_close: dlc c1623e40 state 1 dlci 26 err 0 session c16918a0
rfcomm_send_disc: c16918a0 dlci 26
rfcomm_send_frame: session c16918a0 len 4
rfcomm_dlc_set_timer: dlc c1623e40 state 8 timeout 20000
rfcomm_l2data_ready: c1622000 bytes 4
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 1 qlen 1
rfcomm_recv_ua: session c16918a0 state 1 dlci 26
__rfcomm_dlc_close: dlc c1623e40 state 9 dlci 26 err 0 session c16918a0
rfcomm_dlc_clear_timer: dlc c1623e40 state 9
rfcomm_dlc_unlink: dlc c1623e40 refcnt 1 session c16918a0
rfcomm_dlc_free: c1623e40
rfcomm_dlc_unlink: list is empty &s->dlcs c16918e0 next c16918e0 prev c16918e0
rfcomm_session_set_timer: session c16918a0 state 1 timeout 2000
rfcomm_send_disc: c16918a0 dlci 0
rfcomm_send_frame: session c16918a0 len 4
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 8
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c16918e0
s->dlcs.prev c16918e0
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2data_ready: c1622000 bytes 4
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 8 qlen 1
rfcomm_recv_ua: session c16918a0 state 8 dlci 0
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 8
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next c16918e0
s->dlcs.prev c16918e0
s->dlcs.next->next c16918e0
rfcomm_process_dlcs: about to return
rfcomm_process_sessions: line 1986
rfcomm_process_sessions: line 1989
rfcomm_process_sessions: df7e9740 sock df31ad20 flags 0
rfcomm_run 2080
rfcomm_l2state_change: c1622000 state 9
rfcomm_run 2078
rfcomm_process_sessions: c16918a0 sock dccab360 flags 0
rfcomm_process_rx: session c16918a0 state 8 qlen 0
rfcomm_session_close: session c16918a0 state 8 err 103
rfcomm_session_clear_timer: session c16918a0 state 9
rfcomm_session_del: session c16918a0 state 9
rfcomm_session_clear_timer: session c16918a0 state 9
rfcomm_process_sessions: line 1984
rfcomm_process_dlcs: session c16918a0 state 758263603
rfcomm_process_dlcs: pre loop, &p c1405fb0 &n c1405fac &s->dlcs c16918e0
s->dlcs.next 6963682f
s->dlcs.prev 39333a30
BUG: unable to handle kernel paging request at 6963682f
IP: [<e085b325>] rfcomm_run+0x967/0xd17 [rfcomm]
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/input/input6/name
Modules linked in: rfcomm sco bnep nfsd exportfs xt_state ipt_REJECT iptable_filter ip_tables xt_tcpudp xt_multiport x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 it87 hwmon_vid hwmon tvaudio nfs lockd fscache auth_rpcgss sunrpc udf crc_itu_t isofs uinput hidp l2cap snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss btusb snd_mixer_oss bluetooth snd_pcm snd_seq_dummy snd_seq_oss usblp usbhid snd_seq_midi tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 snd_rawmidi msp3400 bttv snd_seq_midi_event snd_seq ohci_hcd snd_timer v4l2_common usbcore videodev snd_seq_device videobuf_dma_sg parport_pc snd videobuf_core ir_lirc_codec lirc_dev btcx_risc rc_core evdev floppy sis900 soundcore parport button tveeprom snd_page_alloc i2c_sis96x nls_base [last unloaded: rfcomm]

Pid: 3277, comm: krfcommd Not tainted 2.6.38+ #47 SYNTAX                           S635MP                          /S635MP
EIP: 0060:[<e085b325>] EFLAGS: 00010292 CPU: 0
EIP is at rfcomm_run+0x967/0xd17 [rfcomm]
EAX: 6963682f EBX: c16918a0 ECX: c1405f5c EDX: e085ec90
ESI: 00000000 EDI: c16918a0 EBP: c16918e0 ESP: c1405f58
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process krfcommd (pid: 3277, ti=c1404000 task=ddbf0f00 task.ti=c1404000)
Stack:
 e085ec90 39333a30 e085ec7d 6963682f 0000001a 00000063 c1623e00 c16918d0
 c16918e0 c1622000 df7e9740 ddbf0f00 c16918cc c162203c ddbf0f00 ff694233
 00222101 00000000 00000000 00000282 00000000 c16918e0 c16918e0 c1403f58
Call Trace:
 [<e085a9be>] ? rfcomm_run+0x0/0xd17 [rfcomm]
 [<c102b90c>] ? kthread+0x62/0x67
 [<c102b8aa>] ? kthread+0x0/0x67
 [<c1002bd6>] ? kernel_thread_helper+0x6/0x10
Code: e0 68 53 ec 85 e0 e8 e1 be 9d e0 83 c4 30 ff 73 40 68 7d ec 85 e0 e8 d1 be 9d e0 ff 73 44 68 90 ec 85 e0 e8 c4 be 9d e0 8b 43 40 <ff> 30 68 a3 ec 85 e0 e8 b5 be 9d e0 8b 43 40 89 44 24 60 8b 00
EIP: [<e085b325>] rfcomm_run+0x967/0xd17 [rfcomm] SS:ESP 0068:c1405f58
CR2: 000000006963682f
---[ end trace e78c5dd54fa11e2c ]---
rfcomm_dlc_clear_state: c1623e40
rfcomm_dlc_alloc: c1623e40
rfcomm_dlc_free: c1623e40
rfcomm_dlc_clear_state: c1623640
rfcomm_dlc_alloc: c1623640
rfcomm_dlc_free: c1623640
rfcomm_dlc_free: dd85d5c0
rfcomm_dlc_free: dd85d6c0
rfcomm_dlc_free: dd85d640
rfcomm_dlc_free: dd85d740
rfcomm_dlc_free: dd85d140
rfcomm_dlc_free: c1623f40

Signed-off-by: David Fries <David@Fries.net>
---
 net/bluetooth/rfcomm/core.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 6b83776..e48e150 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -124,10 +124,13 @@ static inline void rfcomm_schedule(void)
 	wake_up_process(rfcomm_thread);
 }
 
-static inline void rfcomm_session_put(struct rfcomm_session *s)
+static inline int rfcomm_session_put(struct rfcomm_session *s)
 {
-	if (atomic_dec_and_test(&s->refcnt))
+	if (atomic_dec_and_test(&s->refcnt)) {
 		rfcomm_session_del(s);
+		return 1;
+	}
+	return 0;
 }
 
 /* ---- RFCOMM FCS computation ---- */
@@ -661,7 +664,7 @@ static struct rfcomm_session *rfcomm_session_get(bdaddr_t *src, bdaddr_t *dst)
 	return NULL;
 }
 
-static void rfcomm_session_close(struct rfcomm_session *s, int err)
+static int rfcomm_session_close(struct rfcomm_session *s, int err)
 {
 	struct rfcomm_dlc *d;
 	struct list_head *p, *n;
@@ -680,7 +683,7 @@ static void rfcomm_session_close(struct rfcomm_session *s, int err)
 	}
 
 	rfcomm_session_clear_timer(s);
-	rfcomm_session_put(s);
+	return rfcomm_session_put(s);
 }
 
 static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src,
@@ -1842,7 +1845,7 @@ static inline void rfcomm_process_dlcs(struct rfcomm_session *s)
 	}
 }
 
-static inline void rfcomm_process_rx(struct rfcomm_session *s)
+static inline int rfcomm_process_rx(struct rfcomm_session *s)
 {
 	struct socket *sock = s->sock;
 	struct sock *sk = sock->sk;
@@ -1860,8 +1863,9 @@ static inline void rfcomm_process_rx(struct rfcomm_session *s)
 		if (!s->initiator)
 			rfcomm_session_put(s);
 
-		rfcomm_session_close(s, sk->sk_err);
+		return rfcomm_session_close(s, sk->sk_err);
 	}
+	return 0;
 }
 
 static inline void rfcomm_accept_connection(struct rfcomm_session *s)
@@ -1951,7 +1955,8 @@ static inline void rfcomm_process_sessions(void)
 			break;
 
 		default:
-			rfcomm_process_rx(s);
+			if (rfcomm_process_rx(s))
+				continue;
 			break;
 		}
 
-- 
1.7.2.3


On Fri, Mar 04, 2011 at 11:12:57PM -0300, Gustavo F. Padovan wrote:
> Hi David,
> 
> * David Fries <david@fries.net> [2011-03-02 00:19:10 -0600]:
> 
> > On Mon, Feb 28, 2011 at 02:30:22PM -0300, Gustavo F. Padovan wrote:
> > > Hi David,
> > > 
> > > * David Fries <david@fries.net> [2011-02-27 23:03:40 -0600]:
> > > 
> > > > On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
> > > > > I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
> > > > > by avoiding connections to be accepted before a L2CAP info response comes:
> > > > 
> > > > Is
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> > > > the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
> > > > As a side note, the inline patch in your e-mail has the tabs replaced by
> > > > spaces, once I changed them, it applied cleanly.
> > > > 
> > > > I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
> > > > changes or debugging), it crashed as expected.  I then applied your
> > > > patch 743400e0, and it still crashed.  I added back the
> > > > l2cap_conn_start parent check and some debugging in af_bluetooth.c
> > > > dmesg debug output and patches follow.
> > > 
> > > I want to see a test with this patch and a recent kernel. We added many fixes
> > > to stack in the last two years. Can you test this scenario?
> > 
> > I'm sorry, but apparently not, at least this post says 2.6.37 isn't
> > going to happen for the N900 and Maemo.
> > http://forums.internettablettalk.com/showthread.php?t=70082
> > 
> > I tried 2.6.37-n900 from
> > git://gitorious.org/nokia-n900-kernel/nokia-n900-kernel.git anyway,
> > but the display visibly degrades like it isn't being updated and
> > doesn't apparently get any further.  I don't have anyway to debug it
> > further.
> 
> I think you can test this in a desktop machine.
> 
> -- 
> Gustavo F. Padovan
> http://profusion.mobi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
