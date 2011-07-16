Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1GPTnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:43:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1GPTnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:43:14 -0400
Date: Sat, 16 Jul 2011 21:43:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ed Tomlinson <edt@aei.ca>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Ilia Kolomisnky <iliak@ti.com>, David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Bluetooth broken post rc7
In-Reply-To: <201107150728.04355.edt@aei.ca>
Message-ID: <alpine.LRH.2.00.1107162141340.7178@twin.jikos.cz>
References: <201107142318.33080.edt@aei.ca> <CABBYNZ+fxUWhi0uF0b_6Z8iqYd7Pp_4zPBRyM6Gyh3zJH1am5Q@mail.gmail.com> <201107150728.04355.edt@aei.ca>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Linus to CC ... would be good to have this fixed before 3.0-final 
  indeed ]

On Fri, 15 Jul 2011, Ed Tomlinson wrote:

> > > I booted to todays linux git and bluetooth is no longer working.  
> > > My magic mouse will not connect correctly.
> > >
> > > Reverting:
> > >
> > > commit 9fa7e4f76f3658ba1f44fbdb95c77e7df3f53f95
> > > Author: Gustavo F. Padovan <padovan@profusion.mobi>
> > > Date:   Thu Jun 30 16:11:30 2011 -0300
> > >
> > >    Bluetooth: Fix regression with incoming L2CAP connections
> > >
> > >    PTS test A2DP/SRC/SRC_SET/TC_SRC_SET_BV_02_I revealed that
> > >    ( probably after the df3c3931e commit ) the l2cap connection
> > >    could not be established in case when the "Auth Complete" HCI
> > >    event does not arive before the initiator send "Configuration
> > >    request", in which case l2cap replies with "Command rejected"
> > >    since the channel is still in BT_CONNECT2 state.
> > >
> > >    Based on patch from: Ilia Kolomisnky <iliak@ti.com>
> > >
> > >    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> > >
> > > Fixes the bug here (things work like rc7).
> > >
> > > Do we really need 9fa7e4f76f3658ba1f44fbdb95c77e7df3f53f95 in 3.0?
> > >
> > > Thanks,
> > >
> > > Ed Tomlinson
> > > --
> > 
> > I've changed the check to something like this:
> > 
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index ebff14c..f88b9c8 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -2323,8 +2323,7 @@ static inline int l2cap_config_req(struct
> > l2cap_conn *conn, struct l2cap_cmd_hdr
> > 
> >         sk = chan->sk;
> > 
> > -       if ((bt_sk(sk)->defer_setup && sk->sk_state != BT_CONNECT2) ||
> > -                (!bt_sk(sk)->defer_setup && sk->sk_state != BT_CONFIG)) {
> > +       if ((sk->sk_state != BT_CONNECT2) && (sk->sk_state != BT_CONFIG)) {
> >                 struct l2cap_cmd_rej rej;
> > 
> >                 rej.reason = cpu_to_le16(0x0002);
> > 
> > Seems to work fine.
> 
> And here too.  You can can my tested by
>  
> Tested By: Ed Tomlinson <edt@aei.ca>
> 
> IMHO this should be in 3.0.0
> 
> Thanks!
> Ed Tomlinson

Luiz,

could you please repost the patch with proper changelog and your 
Signed-off-by, so that it could (hopefully) be applied for 3.0 still?

Thanks,

-- 
Jiri Kosina
SUSE Labs

