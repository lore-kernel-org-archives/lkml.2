Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0C3XTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:53 -0400
Received: from kroah.org ([198.145.64.141]:45552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab0C3XTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:05 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:12 2010
Message-Id: <20100330225711.731917290@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [109/116] Bluetooth: Fix potential bad memory access with sysfs files
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 101545f6fef4a0a3ea8daf0b5b880df2c6a92a69 upstream.

When creating a high number of Bluetooth sockets (L2CAP, SCO
and RFCOMM) it is possible to scribble repeatedly on arbitrary
pages of memory. Ensure that the content of these sysfs files is
always less than one page. Even if this means truncating. The
files in question are scheduled to be moved over to debugfs in
the future anyway.

Based on initial patches from Neil Brown and Linus Torvalds

Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/l2cap.c       |   10 +++++++++-
 net/bluetooth/rfcomm/core.c |   13 ++++++++++++-
 net/bluetooth/rfcomm/sock.c |   11 ++++++++++-
 net/bluetooth/sco.c         |   11 ++++++++++-
 4 files changed, 41 insertions(+), 4 deletions(-)

--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -3885,16 +3885,24 @@ static ssize_t l2cap_sysfs_show(struct c
 	struct sock *sk;
 	struct hlist_node *node;
 	char *str = buf;
+	int size = PAGE_SIZE;
 
 	read_lock_bh(&l2cap_sk_list.lock);
 
 	sk_for_each(sk, node, &l2cap_sk_list.head) {
 		struct l2cap_pinfo *pi = l2cap_pi(sk);
+		int len;
 
-		str += sprintf(str, "%s %s %d %d 0x%4.4x 0x%4.4x %d %d %d\n",
+		len = snprintf(str, size, "%s %s %d %d 0x%4.4x 0x%4.4x %d %d %d\n",
 				batostr(&bt_sk(sk)->src), batostr(&bt_sk(sk)->dst),
 				sk->sk_state, __le16_to_cpu(pi->psm), pi->scid,
 				pi->dcid, pi->imtu, pi->omtu, pi->sec_level);
+
+		size -= len;
+		if (size <= 0)
+			break;
+
+		str += len;
 	}
 
 	read_unlock_bh(&l2cap_sk_list.lock);
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2096,6 +2096,7 @@ static ssize_t rfcomm_dlc_sysfs_show(str
 	struct rfcomm_session *s;
 	struct list_head *pp, *p;
 	char *str = buf;
+	int size = PAGE_SIZE;
 
 	rfcomm_lock();
 
@@ -2104,11 +2105,21 @@ static ssize_t rfcomm_dlc_sysfs_show(str
 		list_for_each(pp, &s->dlcs) {
 			struct sock *sk = s->sock->sk;
 			struct rfcomm_dlc *d = list_entry(pp, struct rfcomm_dlc, list);
+			int len;
 
-			str += sprintf(str, "%s %s %ld %d %d %d %d\n",
+			len = snprintf(str, size, "%s %s %ld %d %d %d %d\n",
 					batostr(&bt_sk(sk)->src), batostr(&bt_sk(sk)->dst),
 					d->state, d->dlci, d->mtu, d->rx_credits, d->tx_credits);
+
+			size -= len;
+			if (size <= 0)
+				break;
+
+			str += len;
 		}
+
+		if (size <= 0)
+			break;
 	}
 
 	rfcomm_unlock();
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -1065,13 +1065,22 @@ static ssize_t rfcomm_sock_sysfs_show(st
 	struct sock *sk;
 	struct hlist_node *node;
 	char *str = buf;
+	int size = PAGE_SIZE;
 
 	read_lock_bh(&rfcomm_sk_list.lock);
 
 	sk_for_each(sk, node, &rfcomm_sk_list.head) {
-		str += sprintf(str, "%s %s %d %d\n",
+		int len;
+
+		len = snprintf(str, size, "%s %s %d %d\n",
 				batostr(&bt_sk(sk)->src), batostr(&bt_sk(sk)->dst),
 				sk->sk_state, rfcomm_pi(sk)->channel);
+
+		size -= len;
+		if (size <= 0)
+			break;
+
+		str += len;
 	}
 
 	read_unlock_bh(&rfcomm_sk_list.lock);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -957,13 +957,22 @@ static ssize_t sco_sysfs_show(struct cla
 	struct sock *sk;
 	struct hlist_node *node;
 	char *str = buf;
+	int size = PAGE_SIZE;
 
 	read_lock_bh(&sco_sk_list.lock);
 
 	sk_for_each(sk, node, &sco_sk_list.head) {
-		str += sprintf(str, "%s %s %d\n",
+		int len;
+
+		len = snprintf(str, size, "%s %s %d\n",
 				batostr(&bt_sk(sk)->src), batostr(&bt_sk(sk)->dst),
 				sk->sk_state);
+
+		size -= len;
+		if (size <= 0)
+			break;
+
+		str += len;
 	}
 
 	read_unlock_bh(&sco_sk_list.lock);


