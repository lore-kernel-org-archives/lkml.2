Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2AYUBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:01:48 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41436 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2AYUBr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <1327517706.2605.7.camel@edumazet-laptop>
References: <1327517188-14088-1-git-send-email-netdev@pradeepdalvi.com>
	<1327517706.2605.7.camel@edumazet-laptop>
Date: Thu, 26 Jan 2012 01:31:45 +0530
Message-ID: <CA+Dx6Ha4dnqnkR_Pc+dFZ+Ef_mxRNN_Jk44vJ_R0viuHd0JGHw@mail.gmail.com>
Subject: Re: [PATCH net] amd/lance.c: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 26 janvier 2012 à 00:16 +0530, Pradeep A. Dalvi a écrit :
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb for amd/lance.c
>>   - Removed extra skb->dev = dev
>>
>> Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
>> ---
>>  drivers/net/ethernet/amd/lance.c |    9 ++++-----
>>  1 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
>> index a6e2e84..a8a6b45 100644
>> --- a/drivers/net/ethernet/amd/lance.c
>> +++ b/drivers/net/ethernet/amd/lance.c
>> @@ -871,12 +871,11 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
>>               struct sk_buff *skb;
>>               void *rx_buff;
>>
>> -             skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
>> +             skb = __netdev_alloc_skb(dev, PKT_BUF_SZ, GFP_DMA | gfp);
>
> Nack
>
> As I already explained, alloc_skb() and netdev_alloc_skb() are
> different.
>
> Why do you repost this ?
>
> nedev_alloc_skb() adds NET_SKB_PAD bytes.
>
> This driver doesnt need this extra space.
>
> (In fact it could use kmalloc(), since the skb themselves are not used
> at all : At RX time, we perform a copybreak)

Thanks Eric! Even if we try to skip NET_SKB_PAD i.e. max of 32 or
L1_CACHE_BYTES, SKB_DATA_ALIGN is anyway going to add some additional
bytes for the same reason.

And towards the end, as from my current understanding regarding skb
allocations, for MTU including alignments < 2048, there is not much to
worry about. As long as, it doesn't cross the boundary.

(And in fact, this driver doesn't even get compiled with current
configs, even after forcefully adding CONFIG_ISA & CONFIG_LANCE, of
course along with CONFIG_ISA_DMA_API. Had to change the Makefile)
