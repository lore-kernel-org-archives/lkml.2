Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2EVCup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:50:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48625 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2EVCuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:50:32 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-9f-4fbafef61c31
Message-id: <4FBAFEF5.2000207@samsung.com>
Date: Tue, 22 May 2012 11:50:29 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Bluetooth: prevent double l2cap_chan_destroy
References: <4FB992C8.8090105@samsung.com> <20120521162137.GE16942@joana>
In-reply-to: <20120521162137.GE16942@joana>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd1v/3b5G9zYKGox51ofs8XlXXPY
	LI4tEHNg9vi8SS6AMYrLJiU1J7MstUjfLoEro/nhGtaCY/wV92+/ZWpgvMvdxcjJISFgIrHq
	4WY2CFtM4sK99UA2F4eQwHRGibcH7zCDJIQE3jJKXJ1Y0cXIwcEroCXReLsYJMwioCoxc9MS
	sBI2AWWJu89usYLYogJhEq+nHGIBsXkFBCV+TL7HAjJTRKCRSaL5Uz8jSEJYwFWicfMWFoj5
	nhLbbj8Gi3MKaEvs2HIebBCzgI7E/tZpbBC2vMTmNW+ZJzDyz0IydxaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA69Z1I7GFc2WBxiFOBgVOLhvfB9l78Qa2JZcWXuIUYJ
	DmYlEd5NbUAh3pTEyqrUovz4otKc1OJDjNIcLErivHaLd/gLCaQnlqRmp6YWpBbBZJk4OKUa
	GKP2+L9sTXvLt97xYVVg+KmTj0Tf82+9ueXW8fnh73fFSQeXBwrJX93W6V33UlHoupXf059z
	I+NKnwf8m3Fp/s5Lf156xC0O6J5Qde2nVKzFB0ODHTs/dK/tOSYjnCXzxn56oLeeUKrHMZVj
	dhUPOleoVbf8U9JVbTj8SfmT346NBnF/Jl5e9FaJpTgj0VCLuag4EQCvGuo/OQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:21 AM, Gustavo Padovan wrote:
> Hi Minho,
> 
> * Minho Ban <mhban@samsung.com> [2012-05-21 09:56:40 +0900]:
> 
>> l2cap_sock_kill can be called in l2cap_sock_release and l2cap_sock_close_cb
>> either. This lead l2cap_chan_destroy to be called twice for same channel.
>> To prevent double list_del and double chan_put, chan_destroy should be protected
>> with chan->refcnt and chan_list_lock so that reentrance could be forbidden.
> 
> Even if l2cap_sock_kill() is called twice it will call l2cap_chan_destroy()
> only once. If this is not happening we just have a broken piece of code
> somewhere else and not here.
> 
> 	Gustavo
> 

Thanks for comment but I could not found any suitable code in l2cap_sock_kill that 
can make l2cap_chan_destroy to be called just once. sock flag test is not enough to 
do it.

I agree this path should not be the fix. Testing chan->refcnt is nonsense because 
chan might have been freed already. So I looked for another point,

@@ -1343,10 +1343,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
                l2cap_chan_lock(chan);
 
                l2cap_chan_del(chan, err);
+               chan->ops->close(chan->data);
 
                l2cap_chan_unlock(chan);
 
-               chan->ops->close(chan->data);
                l2cap_chan_put(chan);
        }

close callback must locate within chan_lock unless it can be scheduled to other thread 
which may wait for chan_lock in l2cap_sock_shutdown and this lead to duplicate sock_kill.

 static void l2cap_sock_kill(struct sock *sk)
 {
-       if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
+       if (!sock_flag(sk, SOCK_ZAPPED) || sock_flag(sk, SOCK_DEAD) ||
+                       sk->sk_socket)
                return;
 
        BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));

Duplicate sock_kill may happen anyway, need test SOCK_DEAD if chan_destroy is already called.

Regards,
Minho Ban
