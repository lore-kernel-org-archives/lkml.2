Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab1GOL2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:28:14 -0400
Received: from mail001.aei.ca ([206.123.6.130]:56032 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GOL2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:28:12 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: Re: [BUG] Bluetooth broken post rc7
Date: Fri, 15 Jul 2011 07:28:03 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-crc+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Ilia Kolomisnky <iliak@ti.com>, David Miller <davem@davemloft.net>
References: <201107142318.33080.edt@aei.ca> <CABBYNZ+fxUWhi0uF0b_6Z8iqYd7Pp_4zPBRyM6Gyh3zJH1am5Q@mail.gmail.com>
In-Reply-To: <CABBYNZ+fxUWhi0uF0b_6Z8iqYd7Pp_4zPBRyM6Gyh3zJH1am5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107150728.04355.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 July 2011 06:11:04 Luiz Augusto von Dentz wrote:
> Hi,
> 
> On Fri, Jul 15, 2011 at 6:18 AM, Ed Tomlinson <edt@aei.ca> wrote:
> > Hi,
> >
> > I booted to todays linux git and bluetooth is no longer working.  My magic mouse will not connect correctly.
> >
> > Reverting:
> >
> > commit 9fa7e4f76f3658ba1f44fbdb95c77e7df3f53f95
> > Author: Gustavo F. Padovan <padovan@profusion.mobi>
> > Date:   Thu Jun 30 16:11:30 2011 -0300
> >
> >    Bluetooth: Fix regression with incoming L2CAP connections
> >
> >    PTS test A2DP/SRC/SRC_SET/TC_SRC_SET_BV_02_I revealed that
> >    ( probably after the df3c3931e commit ) the l2cap connection
> >    could not be established in case when the "Auth Complete" HCI
> >    event does not arive before the initiator send "Configuration
> >    request", in which case l2cap replies with "Command rejected"
> >    since the channel is still in BT_CONNECT2 state.
> >
> >    Based on patch from: Ilia Kolomisnky <iliak@ti.com>
> >
> >    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> >
> > Fixes the bug here (things work like rc7).
> >
> > Do we really need 9fa7e4f76f3658ba1f44fbdb95c77e7df3f53f95 in 3.0?
> >
> > Thanks,
> >
> > Ed Tomlinson
> > --
> 
> I've changed the check to something like this:
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index ebff14c..f88b9c8 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -2323,8 +2323,7 @@ static inline int l2cap_config_req(struct
> l2cap_conn *conn, struct l2cap_cmd_hdr
> 
>         sk = chan->sk;
> 
> -       if ((bt_sk(sk)->defer_setup && sk->sk_state != BT_CONNECT2) ||
> -                (!bt_sk(sk)->defer_setup && sk->sk_state != BT_CONFIG)) {
> +       if ((sk->sk_state != BT_CONNECT2) && (sk->sk_state != BT_CONFIG)) {
>                 struct l2cap_cmd_rej rej;
> 
>                 rej.reason = cpu_to_le16(0x0002);
> 
> Seems to work fine.

And here too.  You can can my tested by
 
Tested By: Ed Tomlinson <edt@aei.ca>

IMHO this should be in 3.0.0

Thanks!
Ed Tomlinson

