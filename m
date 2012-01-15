Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2AOKIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:08:13 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:50749 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2AOKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:08:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] blutetooth: Remove bogus inline for l2cap_chan_connect()
Date: Sun, 15 Jan 2012 11:07:56 +0100
Message-Id: <1326622076-957-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 03a001948166d966d0d580cddb8ae3a23f8b795b ("Bluetooth: invert locking
order in connect path") marked l2cap_chan_connect() inline for both the
prototype in include/net/bluetooth/l2cap.h and the implementation in
net/bluetooth/l2cap_core.c.

As the former doesn't contain an implementation, net/bluetooth/l2cap_sock.c
now fails to build, e.g. for m68k allmodconfig:

    net/bluetooth/l2cap_sock.c: In function ‘l2cap_sock_connect’:
    include/net/bluetooth/l2cap.h:838: sorry, unimplemented: inlining failed in call to ‘l2cap_chan_connect’: function body not available
    net/bluetooth/l2cap_sock.c:126: sorry, unimplemented: called from here
    make[1]: *** [net/bluetooth/l2cap_sock.o] Error 1

As l2cap_chan_connect() is not that small and also called from
net/bluetooth/l2cap_sock.c, I removed both inline keywords.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
As I can't seem to find anyone else getting this, I guess it's only
triggered by some versions of gcc. Mine is

gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)
---
 include/net/bluetooth/l2cap.h |    2 +-
 net/bluetooth/l2cap_core.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 68f5891..124f7cf 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -834,7 +834,7 @@ int l2cap_add_scid(struct l2cap_chan *chan,  __u16 scid);
 struct l2cap_chan *l2cap_chan_create(struct sock *sk);
 void l2cap_chan_close(struct l2cap_chan *chan, int reason);
 void l2cap_chan_destroy(struct l2cap_chan *chan);
-inline int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
+int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 								bdaddr_t *dst);
 int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len,
 								u32 priority);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index faf0b11..980abdb 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1120,7 +1120,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm, bdaddr
 	return c1;
 }
 
-inline int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid, bdaddr_t *dst)
+int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid, bdaddr_t *dst)
 {
 	struct sock *sk = chan->sk;
 	bdaddr_t *src = &bt_sk(sk)->src;
-- 
1.7.0.4

