Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab1B1FD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:03:56 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:52070 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1B1FDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:03:55 -0500
Date: Sun, 27 Feb 2011 23:03:40 -0600
From: David Fries <david@fries.net>
To: Liang Bao <tim.bao@gmail.com>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in
 l2cap_conn_start
Message-ID: <20110228050340.GC22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
 <20110221043601.GB22204@spacedout.fries.net>
 <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
 <20110227191545.GB2166@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110227191545.GB2166@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 27 Feb 2011 23:03:42 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
> I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
> by avoiding connections to be accepted before a L2CAP info response comes:

Is
git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
As a side note, the inline patch in your e-mail has the tabs replaced by
spaces, once I changed them, it applied cleanly.

I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
changes or debugging), it crashed as expected.  I then applied your
patch 743400e0, and it still crashed.  I added back the
l2cap_conn_start parent check and some debugging in af_bluetooth.c
dmesg debug output and patches follow.

I haven't at all looked into the bluetooth protocol, but what connect
sequence difference does it make if I power on the bluetooth headset
and press play on the headset before it automatically pairs with the
N900, vs power on bluetooth headset, wait for it to pair then press
play?  I ask this partly because I'm curiouse, but mostly how I
trigger the bug.  This is with pulse audio running, but no
applications playing audio or responding to a play event from the
headset.

[  443.424560] bt_accept_dequeue, parent cd54ba00 newsock c81f0180, defer_setup && BT_CONNECT2
[  443.427368] avoided crash in l2cap_conn_start sk c6d3f600 result 1 status 2
[  443.518463] bt_accept_dequeue, parent cdee9c00 newsock c81f0000, BT_CONNECTED
[  443.729736] bt_accept_dequeue, parent cd54be00 newsock c81f0000, BT_CONNECTED
[  443.813537] bt_accept_dequeue, parent cd54b600 newsock c81f0180, defer_setup && BT_CONNECT2

>From 5bc80fafac43b6698e271f1246cb24e596bf2ef1 Mon Sep 17 00:00:00 2001
From: David Fries <david@fries.net>
Date: Sun, 6 Feb 2011 14:34:49 -0600
Subject: [PATCH 1/2] work around for l2cap NULL dereference in l2cap_conn_start print sk

---
 net/bluetooth/l2cap.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index fda7741..ff05f51 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -400,7 +400,16 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 					struct sock *parent = bt_sk(sk)->parent;
 					rsp.result = cpu_to_le16(L2CAP_CR_PEND);
 					rsp.status = cpu_to_le16(L2CAP_CS_AUTHOR_PEND);
-					parent->sk_data_ready(parent, 0);
+					if(!parent) {
+						printk(KERN_DEBUG "avoided "
+							"crash in %s sk %p "
+							"result %d status %d\n",
+							__func__, sk,
+							rsp.result, rsp.status);
+					} else {
+						parent->sk_data_ready(parent,
+							0);
+					}
 
 				} else {
 					sk->sk_state = BT_CONFIG;
-- 
1.7.2.3


>From 42b9a6ef68a1cd0ef025b826afcfb0ef23342fe5 Mon Sep 17 00:00:00 2001
From: David Fries <david@fries.net>
Date: Sun, 27 Feb 2011 21:50:14 -0600
Subject: [PATCH 2/2] af_bluetooth.c debug

---
 net/bluetooth/af_bluetooth.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 8e910f1..57cd360 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -211,6 +211,18 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
 			continue;
 		}
 
+		if (bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
+			printk("%s, parent %p newsock %p, "
+				"defer_setup && BT_CONNECT2\n", __func__,
+				parent, newsock);
+		if (sk->sk_state == BT_CONNECTED)
+			printk("%s, parent %p newsock %p, "
+				"BT_CONNECTED\n", __func__,
+				parent, newsock);
+		if (!newsock)
+			printk("%s, parent %p newsock %p, "
+				"!newsock\n", __func__,
+				parent, newsock);
 		if ((bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
 				|| sk->sk_state == BT_CONNECTED || !newsock) {
 			bt_accept_unlink(sk);
-- 
1.7.2.3

 
> commit 743400e01a33779f93b79c84a1b0d1a2d27338c8
> Author: Gustavo F. Padovan <padovan@profusion.mobi>
> Date:   Sun Feb 27 16:05:07 2011 -0300
> 
>     Bluetooth: Don't accept l2cap connection before info_rsp
>     
>     When using defer_setup accepting a connection before receive the L2CAP
>     Info Response for the connection lead us to a crash in l2cap_conn_start(.
>     
>     Reported-by: David Fries <david@fries.net>
>     Reported-by: Liang Bao <tim.bao@gmail.com>
>     Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> 
> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
> index c4cf3f5..a8ca42b 100644
> --- a/net/bluetooth/af_bluetooth.c
> +++ b/net/bluetooth/af_bluetooth.c
> @@ -211,8 +211,8 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
>                         continue;
>                 }
>  
> -               if (sk->sk_state == BT_CONNECTED || !newsock ||
> -                                               bt_sk(parent)->defer_setup) {
> +               if ((bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
> +                               || sk->sk_state == BT_CONNECTED || !newsock) {
>                         bt_accept_unlink(sk);
>                         if (newsock)
>                                 sock_graft(sk, newsock);
> 
> 
> -- 
> Gustavo F. Padovan
> http://profusion.mobi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
