Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3AIU6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:58:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:43617 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916Ab3AIUko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 72/80] Bluetooth: Add missing lock nesting notation
Date: Wed,  9 Jan 2013 12:36:04 -0800
Message-Id: <20130109201509.642066887@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/rfcomm/sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -485,7 +485,7 @@ static int rfcomm_sock_accept(struct soc
 	long timeo;
 	int err = 0;
 
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 
 	if (sk->sk_type != SOCK_STREAM) {
 		err = -EINVAL;
@@ -522,7 +522,7 @@ static int rfcomm_sock_accept(struct soc
 
 		release_sock(sk);
 		timeo = schedule_timeout(timeo);
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);


