Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1B0TPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 14:15:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48999 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1B0TPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 14:15:09 -0500
Date: Sun, 27 Feb 2011 16:15:45 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Liang Bao <tim.bao@gmail.com>
Cc: David Fries <david@fries.net>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] work around for l2cap NULL dereference in
 l2cap_conn_start
Message-ID: <20110227191545.GB2166@joana>
Mail-Followup-To: Liang Bao <tim.bao@gmail.com>,
	David Fries <david@fries.net>,
	Andrei Warkentin <andreiw@motorola.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110211035309.GA22204@spacedout.fries.net>
 <20110214145649.GE2597@joana>
 <AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
 <20110221043601.GB22204@spacedout.fries.net>
 <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Liang,

* Liang Bao <tim.bao@gmail.com> [2011-02-21 14:41:29 +0800]:

> Hi, David, Andrew et al.
> 
> 2011/2/21 David Fries <david@fries.net>:
> > bt_sk(sk)->parent can be NULL in l2cap_conn_start in state BT_CONNECT2
> > at least when a headset device pairs and the play button was pressed
> > right before pairing.
> >
> > Signed-off-by: David Fries <david@fries.net>
> > ---
> > I removed the printk, can this be merged to the bluetooth next tree?
> >
> > On Mon, Feb 14, 2011 at 03:40:46PM -0600, Andrei Warkentin wrote:
> >> FWIW still need it in 2.6.36.
> >
> > Andrei, I'm curious, what's your hardware hardware and bluetooth
> > device that's trigginer the crash?
> I  once submitted an issue observed with Android+Motorola S305 stereo
> headset. It's still open in launchpad:
> https://bugs.launchpad.net/ubuntu/+source/bluez/+bug/513642. Hope this
> helps. Thanks.
> >
> >> On Mon, Feb 14, 2011 at 8:56 AM, Gustavo F. Padovan
> >> <padovan@profusion.mobi> wrote:
> >> > Hi David,
> >> >
> >> > * David Fries <david@fries.net> [2011-02-10 21:53:09 -0600]:
> >> >
> >> >> Here's a patch to avoid a very repeatable crash in the N900.  If I
> >> >> take a Motorola S305 bluetooth headset that was previously paried with
> >> >> the N900, turn it on, and press the play button before the headphones
> >> >> automatically pair with the cell phone, the N900 will crash (and
> >> >> reboot) in pairing.  If I wait until after they have paired there
> >> >> isn't any problem.  The patch is against the kernel-power
> >> >> 2.6.28-maemo46 by Thomas Tanner, the stock Nokia PR1.2 oops looked
> >> >> the same, I just haven't gone back to that kernel.
> >> >
> >> > This is a very old kernel. You need to check this issue against
> >> > bluetooth-next-2.6.
> >
> >  net/bluetooth/l2cap.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
> > index ed83c1f..a7aa4d9 100644
> > --- a/net/bluetooth/l2cap.c
> > +++ b/net/bluetooth/l2cap.c
> > @@ -408,7 +408,8 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
> >                                        struct sock *parent = bt_sk(sk)->parent;
> >                                        rsp.result = cpu_to_le16(L2CAP_CR_PEND);
> >                                        rsp.status = cpu_to_le16(L2CAP_CS_AUTHOR_PEND);
> > -                                       parent->sk_data_ready(parent, 0);
> > +                                       if(parent)
> > +                                               parent->sk_data_ready(parent,0);
> >
> >                                } else {
> >                                        sk->sk_state = BT_CONFIG;

I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
by avoiding connections to be accepted before a L2CAP info response comes:

commit 743400e01a33779f93b79c84a1b0d1a2d27338c8
Author: Gustavo F. Padovan <padovan@profusion.mobi>
Date:   Sun Feb 27 16:05:07 2011 -0300

    Bluetooth: Don't accept l2cap connection before info_rsp
    
    When using defer_setup accepting a connection before receive the L2CAP
    Info Response for the connection lead us to a crash in l2cap_conn_start(.
    
    Reported-by: David Fries <david@fries.net>
    Reported-by: Liang Bao <tim.bao@gmail.com>
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index c4cf3f5..a8ca42b 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -211,8 +211,8 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
                        continue;
                }
 
-               if (sk->sk_state == BT_CONNECTED || !newsock ||
-                                               bt_sk(parent)->defer_setup) {
+               if ((bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
+                               || sk->sk_state == BT_CONNECTED || !newsock) {
                        bt_accept_unlink(sk);
                        if (newsock)
                                sock_graft(sk, newsock);


-- 
Gustavo F. Padovan
http://profusion.mobi
