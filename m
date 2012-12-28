Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2L1TSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55321 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab2L1TSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:34 -0500
Message-Id: <20121228190351.205426503@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 100/173] Bluetooth: Add missing lock nesting notation
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit dc2a0e20fbc85a71c63aa4330b496fda33f6bf80 upstream.

This patch fixes the following report, it happens when accepting rfcomm
connections:

[  228.165378] =============================================
[  228.165378] [ INFO: possible recursive locking detected ]
[  228.165378] 3.7.0-rc1-00536-gc1d5dc4 #120 Tainted: G        W
[  228.165378] ---------------------------------------------
[  228.165378] bluetoothd/1341 is trying to acquire lock:
[  228.165378]  (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+...}, at:
[<ffffffffa0000aa0>] bt_accept_dequeue+0xa0/0x180 [bluetooth]
[  228.165378]
[  228.165378] but task is already holding lock:
[  228.165378]  (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+...}, at:
[<ffffffffa0205118>] rfcomm_sock_accept+0x58/0x2d0 [rfcomm]
[  228.165378]
[  228.165378] other info that might help us debug this:
[  228.165378]  Possible unsafe locking scenario:
[  228.165378]
[  228.165378]        CPU0
[  228.165378]        ----
[  228.165378]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
[  228.165378]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
[  228.165378]
[  228.165378]  *** DEADLOCK ***
[  228.165378]
[  228.165378]  May be due to missing lock nesting notation

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/rfcomm/sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4ddef57..ce3f665 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -467,7 +467,7 @@ static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int f
 	long timeo;
 	int err = 0;
 
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 
 	if (sk->sk_type != SOCK_STREAM) {
 		err = -EINVAL;
@@ -504,7 +504,7 @@ static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int f
 
 		release_sock(sk);
 		timeo = schedule_timeout(timeo);
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);


