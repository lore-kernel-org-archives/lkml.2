Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1BUEoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:44:11 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:52092 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1BUEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:44:08 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Feb 2011 23:44:07 EST
Date: Sun, 20 Feb 2011 22:36:01 -0600
From: David Fries <david@fries.net>
To: Andrei Warkentin <andreiw@motorola.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] work around for l2cap NULL dereference in l2cap_conn_start
Message-ID: <20110221043601.GB22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 20 Feb 2011 22:36:03 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bt_sk(sk)->parent can be NULL in l2cap_conn_start in state BT_CONNECT2
at least when a headset device pairs and the play button was pressed
right before pairing.

Signed-off-by: David Fries <david@fries.net>
---
I removed the printk, can this be merged to the bluetooth next tree?

On Mon, Feb 14, 2011 at 03:40:46PM -0600, Andrei Warkentin wrote:
> FWIW still need it in 2.6.36.

Andrei, I'm curious, what's your hardware hardware and bluetooth
device that's trigginer the crash?

> On Mon, Feb 14, 2011 at 8:56 AM, Gustavo F. Padovan
> <padovan@profusion.mobi> wrote:
> > Hi David,
> >
> > * David Fries <david@fries.net> [2011-02-10 21:53:09 -0600]:
> >
> >> Here's a patch to avoid a very repeatable crash in the N900.  If I
> >> take a Motorola S305 bluetooth headset that was previously paried with
> >> the N900, turn it on, and press the play button before the headphones
> >> automatically pair with the cell phone, the N900 will crash (and
> >> reboot) in pairing.  If I wait until after they have paired there
> >> isn't any problem.  The patch is against the kernel-power
> >> 2.6.28-maemo46 by Thomas Tanner, the stock Nokia PR1.2 oops looked
> >> the same, I just haven't gone back to that kernel.
> >
> > This is a very old kernel. You need to check this issue against
> > bluetooth-next-2.6.

 net/bluetooth/l2cap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index ed83c1f..a7aa4d9 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -408,7 +408,8 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 					struct sock *parent = bt_sk(sk)->parent;
 					rsp.result = cpu_to_le16(L2CAP_CR_PEND);
 					rsp.status = cpu_to_le16(L2CAP_CS_AUTHOR_PEND);
-					parent->sk_data_ready(parent, 0);
+					if(parent)
+						parent->sk_data_ready(parent,0);
 
 				} else {
 					sk->sk_state = BT_CONFIG;
-- 
1.7.2.3

