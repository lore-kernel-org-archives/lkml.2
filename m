Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1CXPhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:37:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1CXPhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e8yce9fROt1/MWnfs3Ri+bxwbCKxTLH0Atvbi6Ap23kkJ7L5KzJUaEzTufdmvM/tvO
         KgsNzlYAUBs/p3lByu8x2Ew9DnZhHSmcHIm15R1EIWusT/XB/cUM8sQw5B1Jtd/9ciMx
         pE8ZxFNKqHBV3ny4O7uK81/sYI7WrwO27UxmQ=
MIME-Version: 1.0
In-Reply-To: <20110228050340.GC22204@spacedout.fries.net>
References: <20110211035309.GA22204@spacedout.fries.net>
	<20110214145649.GE2597@joana>
	<AANLkTi==Sh2yc2JjjY5t-NKxQexKPgPwNyWo4SMju92k@mail.gmail.com>
	<20110221043601.GB22204@spacedout.fries.net>
	<AANLkTi=b5UCdyc3ZtUFCx23uYygM7eRyGu-y_wdJ5JXi@mail.gmail.com>
	<20110227191545.GB2166@joana>
	<20110228050340.GC22204@spacedout.fries.net>
Date: Thu, 24 Mar 2011 17:37:29 +0200
Message-ID: <AANLkTinKgdKpNgLm3=9UkwGMQOcT1jwHBGtVsfP-s7qe@mail.gmail.com>
Subject: Re: [PATCH] work around for l2cap NULL dereference in l2cap_conn_start
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: David Fries <david@fries.net>
Cc: Liang Bao <tim.bao@gmail.com>, Andrei Warkentin <andreiw@motorola.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

On Mon, Feb 28, 2011 at 7:03 AM, David Fries <david@fries.net> wrote:
> On Sun, Feb 27, 2011 at 04:15:45PM -0300, Gustavo F. Padovan wrote:
>> I pushed the following patch to bluetooth-2.6 tree. It should fix the problem
>> by avoiding connections to be accepted before a L2CAP info response comes:
>
> Is
> git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> the bluetooth-2.6 tree you mentioned?  I don't see your patch there.
> As a side note, the inline patch in your e-mail has the tabs replaced by
> spaces, once I changed them, it applied cleanly.
>
> I first reverted to the base N900 kernel-power-2.6.28 46 (none of my
> changes or debugging), it crashed as expected.  I then applied your
> patch 743400e0, and it still crashed.

the same for me. Your patch with adding BT_CONNECT2 check seems
have no effect since sk_state == BT_CONNECT2 for my case.

I've posted series of patches which fixes the issue but I believe it is better
to keep check for parent.

Search my patches by "[RFCv1 0/3] Set of patches fixing kernel crash"

Regards,
Andrei

> I added back the
> l2cap_conn_start parent check and some debugging in af_bluetooth.c
> dmesg debug output and patches follow.
>
> I haven't at all looked into the bluetooth protocol, but what connect
> sequence difference does it make if I power on the bluetooth headset
> and press play on the headset before it automatically pairs with the
> N900, vs power on bluetooth headset, wait for it to pair then press
> play?  I ask this partly because I'm curiouse, but mostly how I
> trigger the bug.  This is with pulse audio running, but no
> applications playing audio or responding to a play event from the
> headset.
>
> [  443.424560] bt_accept_dequeue, parent cd54ba00 newsock c81f0180, defer_setup && BT_CONNECT2
> [  443.427368] avoided crash in l2cap_conn_start sk c6d3f600 result 1 status 2
> [  443.518463] bt_accept_dequeue, parent cdee9c00 newsock c81f0000, BT_CONNECTED
> [  443.729736] bt_accept_dequeue, parent cd54be00 newsock c81f0000, BT_CONNECTED
> [  443.813537] bt_accept_dequeue, parent cd54b600 newsock c81f0180, defer_setup && BT_CONNECT2
>
> From 5bc80fafac43b6698e271f1246cb24e596bf2ef1 Mon Sep 17 00:00:00 2001
> From: David Fries <david@fries.net>
> Date: Sun, 6 Feb 2011 14:34:49 -0600
> Subject: [PATCH 1/2] work around for l2cap NULL dereference in l2cap_conn_start print sk
>
> ---
>  net/bluetooth/l2cap.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
> index fda7741..ff05f51 100644
> --- a/net/bluetooth/l2cap.c
> +++ b/net/bluetooth/l2cap.c
> @@ -400,7 +400,16 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
>                                        struct sock *parent = bt_sk(sk)->parent;
>                                        rsp.result = cpu_to_le16(L2CAP_CR_PEND);
>                                        rsp.status = cpu_to_le16(L2CAP_CS_AUTHOR_PEND);
> -                                       parent->sk_data_ready(parent, 0);
> +                                       if(!parent) {
> +                                               printk(KERN_DEBUG "avoided "
> +                                                       "crash in %s sk %p "
> +                                                       "result %d status %d\n",
> +                                                       __func__, sk,
> +                                                       rsp.result, rsp.status);
> +                                       } else {
> +                                               parent->sk_data_ready(parent,
> +                                                       0);
> +                                       }
>
>                                } else {
>                                        sk->sk_state = BT_CONFIG;
> --
> 1.7.2.3
>
>
> From 42b9a6ef68a1cd0ef025b826afcfb0ef23342fe5 Mon Sep 17 00:00:00 2001
> From: David Fries <david@fries.net>
> Date: Sun, 27 Feb 2011 21:50:14 -0600
> Subject: [PATCH 2/2] af_bluetooth.c debug
>
> ---
>  net/bluetooth/af_bluetooth.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
> index 8e910f1..57cd360 100644
> --- a/net/bluetooth/af_bluetooth.c
> +++ b/net/bluetooth/af_bluetooth.c
> @@ -211,6 +211,18 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
>                        continue;
>                }
>
> +               if (bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
> +                       printk("%s, parent %p newsock %p, "
> +                               "defer_setup && BT_CONNECT2\n", __func__,
> +                               parent, newsock);
> +               if (sk->sk_state == BT_CONNECTED)
> +                       printk("%s, parent %p newsock %p, "
> +                               "BT_CONNECTED\n", __func__,
> +                               parent, newsock);
> +               if (!newsock)
> +                       printk("%s, parent %p newsock %p, "
> +                               "!newsock\n", __func__,
> +                               parent, newsock);
>                if ((bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
>                                || sk->sk_state == BT_CONNECTED || !newsock) {
>                        bt_accept_unlink(sk);
> --
> 1.7.2.3
>
>
>> commit 743400e01a33779f93b79c84a1b0d1a2d27338c8
>> Author: Gustavo F. Padovan <padovan@profusion.mobi>
>> Date:   Sun Feb 27 16:05:07 2011 -0300
>>
>>     Bluetooth: Don't accept l2cap connection before info_rsp
>>
>>     When using defer_setup accepting a connection before receive the L2CAP
>>     Info Response for the connection lead us to a crash in l2cap_conn_start(.
>>
>>     Reported-by: David Fries <david@fries.net>
>>     Reported-by: Liang Bao <tim.bao@gmail.com>
>>     Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
>>
>> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
>> index c4cf3f5..a8ca42b 100644
>> --- a/net/bluetooth/af_bluetooth.c
>> +++ b/net/bluetooth/af_bluetooth.c
>> @@ -211,8 +211,8 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
>>                         continue;
>>                 }
>>
>> -               if (sk->sk_state == BT_CONNECTED || !newsock ||
>> -                                               bt_sk(parent)->defer_setup) {
>> +               if ((bt_sk(parent)->defer_setup && sk->sk_state == BT_CONNECT2)
>> +                               || sk->sk_state == BT_CONNECTED || !newsock) {
>>                         bt_accept_unlink(sk);
>>                         if (newsock)
>>                                 sock_graft(sk, newsock);
>>
>>
>> --
>> Gustavo F. Padovan
>> http://profusion.mobi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> David Fries <david@fries.net>
> http://fries.net/~david/ (PGP encryption key available)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
