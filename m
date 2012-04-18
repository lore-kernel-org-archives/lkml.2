Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2DRHyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:54:18 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41105 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2DRHyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <1334734196.2472.91.camel@edumazet-glaptop>
References: <CAA1sL1QTRKnfvCnHWjbSJ-hq6dgZK+KGDPVTrOhsfZcFTs01Mw@mail.gmail.com>
	<1334502964.28012.1.camel@edumazet-glaptop>
	<CAA1sL1SJyY7fYJn7OKqo5Pa=b4-r9DW90-5WVGBf==tFjVEBpg@mail.gmail.com>
	<1334695506.2472.46.camel@edumazet-glaptop>
	<CAA1sL1TN+acPd4NAnFC0soeHzzcJe0ja3_zS5ZkFog11HSDAyA@mail.gmail.com>
	<1334734196.2472.91.camel@edumazet-glaptop>
Date: Wed, 18 Apr 2012 11:54:15 +0400
Message-ID: <CAA1sL1SE1kDPsuMLHUV=MNYvyte1G1J-tQnJDj83Xc1qa6sADg@mail.gmail.com>
Subject: Re: 3.4.0-rc2: skb_put() -> skb_over_panic
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Thanks a lot, I belive I know where the problem is.
>> >
>> > Could you check if commit a21d45726acacc963d8baddf74607d9b74e2b723
>> > (tcp: avoid order-1 allocations on wifi and tx path)
>> > was in your tree ?
>> >
>>
>> It was,
>> git show a21d4572 v3.4-rc2..668ce0a
>> shows it
>
> Thansk for the confirmation.
>
> Had you see the patch I sent some hours ago, and can you test it ?
>
> If not, I probably can reproduce the problem in my lab.
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 376b2cf..7ac6423 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1096,6 +1096,7 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
>        eat = min_t(int, len, skb_headlen(skb));
>        if (eat) {
>                __skb_pull(skb, eat);
> +               skb->avail_size -= eat;
>                len -= eat;
>                if (!len)
>                        return;
>
>

Yes, I am testing it.
