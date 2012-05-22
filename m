Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2EVMXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:23:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50592 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2EVMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:23:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee61a-b7fe76d0000023f5-66-4fbb85440c41
Message-id: <4FBB8544.3040408@samsung.com>
Date: Tue, 22 May 2012 21:23:32 +0900
From: Chanyeol Park <chanyeol.park@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
To: Minho Ban <mhban@samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Bluetooth: prevent double l2cap_chan_destroy
References: <4FB992C8.8090105@samsung.com> <20120521162137.GE16942@joana>
 <4FBAFEF5.2000207@samsung.com>
In-reply-to: <4FBAFEF5.2000207@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAV2X1t3+Boum6lrMudbHbHF51xw2
	i2MLxByYPT5vkgtgjOKySUnNySxLLdK3S+DKOHnkE3vBPa6Kxr3f2RsYH7N3MXJySAiYSNz+
	/JQFwhaTuHBvPVsXIxeHkMAiRolFzUsZQRK8AoISPybfAyri4GAWkJc4cikbJMwsYCbxqGUd
	M0T9K0aJxk+L2SHqtSR6l3wEs1kEVCV+r9vFDGKzCehLHNp1HGymqECYxOsph8AWiwgoSqw8
	9Y8NYmgjk8Tbx8ogtrCAq0Tj5i1gNUICWRK/7zaygdzAKaAtcea12wRGgVlIrpuFcN0sJNct
	YGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcjs+kdjCubLA4xCjAwajEwytQvdtfiDWx
	rLgy9xCjBAezkgjvprZd/kK8KYmVValF+fFFpTmpxYcYpTlYlMR57Rbv8BcSSE8sSc1OTS1I
	LYLJMnFwSjUwsv54qVj7KdbmS+Esj9wFj4t+PF2U/uX1qes50z8fWxQs/e4vzxNvz4tHlrfc
	WvzOUjhhR/jfu6/57lz98try+pGHcZsttfOnB0up9Z35c67jvLphR2/xIa89GwUvfVzF5dOs
	voTF7ZZJ7ga/xalq7evfOPN8bTy08Oa2jFkX71bcK33kJl56foESS3FGoqEWc1FxIgAe0SH3
	QwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 2012년 05월 22일 11:50, Minho Ban wrote:
> @@ -1343,10 +1343,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
>                  l2cap_chan_lock(chan);
>
>                  l2cap_chan_del(chan, err);
> +               chan->ops->close(chan->data);
>
>                  l2cap_chan_unlock(chan);
>
> -               chan->ops->close(chan->data);
>                  l2cap_chan_put(chan);
>          }
I think this patch does not make sense Because inside chan->ops->close() 
"chan" could be freed in the l2cap_chan_destroy().

> close callback must locate within chan_lock unless it can be scheduled to other thread
> which may wait for chan_lock in l2cap_sock_shutdown and this lead to duplicate sock_kill.
>
>   static void l2cap_sock_kill(struct sock *sk)
>   {
> -       if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> +       if (!sock_flag(sk, SOCK_ZAPPED) || sock_flag(sk, SOCK_DEAD) ||
> +                       sk->sk_socket)
>                  return;
>
>          BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
>
> Duplicate sock_kill may happen anyway, need test SOCK_DEAD if chan_destroy is already called.
Even l2cap_sock_kill() is called twice, " if (!sock_flag(sk, 
SOCK_ZAPPED) || sk->sk_socket)" can't filter it.
I tested Mr.ban case. it works fine with me.

BR
Chanyeol Park.

