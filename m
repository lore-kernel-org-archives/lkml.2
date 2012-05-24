Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2EXGcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:32:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25849 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2EXGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:32:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-5c-4fbdd6099874
Message-id: <4FBDD609.8060702@samsung.com>
Date: Thu, 24 May 2012 15:32:41 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
To: Chanyeol Park <chanyeol.park@samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix null pointer dereference in l2cap_chan_send
References: <4FB9932B.9070101@samsung.com> <4FBB8828.303@samsung.com>
In-reply-to: <4FBB8828.303@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQV3Oa3v9DXY/07CYc62P2eLyrjls
	FscWiDkwe3zeJBfAGMVlk5Kak1mWWqRvl8CV8XbpDOaCfs6Kbev3sDQwzmXvYuTkkBAwkXj8
	5yoThC0mceHeerYuRi4OIYHpjBJty44wgyR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8
	RcwQ9W8ZJeY+/sYIUa8lcejAKjYQm0VAVaL56Fswm01AWeLus1usILaoQJjE6ymHwGaKCOhK
	/O2ogpjZyCTx9rEyiC0s4C/xZ/FCsHIhAVeJtm3/wMZzAu39PeM34wRGgVlIrpuFcN0sJNct
	YGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcjs+kdzCuarA4xCjAwajEw2uxeq+/EGti
	WXFl7iFGCQ5mJRFer2KgEG9KYmVValF+fFFpTmrxIUZpDhYlcd4nS3b4CwmkJ5akZqemFqQW
	wWSZODilGhijpEUVFk9ensJ+cP4kVuk6i3/rn9zbc4nh1J2V1+VO/lJyyppYb8GqEigX9HyC
	UemOGQwevLM3XQp+9ir0QlFLmU7RpXzG6LigVJ8fl5o1tU6svOkYa7Rk97ozz59rLJy6x+mI
	YFiMpaSs0oITKR+3rn3822xRmTLLvHrLVzp/S4Ty4lLSOd2VWIozEg21mIuKEwG5L+fcQwIA	AA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 09:35 PM, Chanyeol Park wrote:
> Hi
> On 2012년 05월 21일 09:58, Minho Ban wrote:
>> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
>> index 3bb1611..98d4541 100644
>> --- a/net/bluetooth/l2cap_sock.c
>> +++ b/net/bluetooth/l2cap_sock.c
>> @@ -727,10 +727,12 @@ static int l2cap_sock_sendmsg(struct kiocb *iocb, struct socket *sock, struct ms
>>       if (msg->msg_flags&  MSG_OOB)
>>           return -EOPNOTSUPP;
>>
>> -    if (sk->sk_state != BT_CONNECTED)
>> +    l2cap_chan_lock(chan);
>> +    if (sk->sk_state != BT_CONNECTED || !chan->conn) {
>> +        l2cap_chan_unlock(chan);
>>           return -ENOTCONN;
>> +    }
>>
>> -    l2cap_chan_lock(chan);
>>       err = l2cap_chan_send(chan, msg, len, sk->sk_priority);
>>       l2cap_chan_unlock(chan);
>>   
> Beside !chan->conn condition,I think it makes sense that sk_state check should be moved after l2cap_chan_lock()
> because sk_state could be changed due to l2cap_conn_del().
> 

Thanks, chan->conn condition is not necessary, move sk->sk_state != BT_CONNECTED behind chan_lock is enough.
I'll amend this patch.

Regards
Minho Ban
