Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0IHE5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 00:57:37 -0400
Received: from [83.228.35.12] ([83.228.35.12]:53223 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0IHE5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 00:57:34 -0400
Message-ID: <4C8717BB.2050504@fs.uni-ruse.bg>
Date: Wed, 08 Sep 2010 07:57:31 +0300
From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; bg; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
References: <20100904203429.GA4891@del.dom.local> <1283672983.3402.38.camel@edumazet-laptop>
In-Reply-To: <1283672983.3402.38.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

На 05.9.2010 г. 10:49, Eric Dumazet написа:
> Le samedi 04 septembre 2010 à 22:34 +0200, Jarek Poplawski a écrit :
>
>> Hi again,
>>
>> Just had a second look, and unless I miss something...
>>
>> Plamen, could you test this patch, too? (Without removing the previous
>> one.)
>>
>> Thanks,
>> Jarek P.
>>
>> ------------------->
>>
>> [PATCH] gro: Re-fix different skb headrooms
>>
>> The patch: "gro: fix different skb headrooms" in its part:
>> "2) allocate a minimal skb for head of frag_list" is buggy. The copied
>> skb has p->data set at the ip header at the moment, and skb_gro_offset
>> is the length of ip + tcp headers. So, after the change the length of
>> mac header is skipped. Later skb_set_mac_header() sets it into the
>> NET_SKB_PAD area (if it's long enough) and ip header is misaligned at
>> NET_SKB_PAD + NET_IP_ALIGN offset. There is no reason to assume the
>> original skb was wrongly allocated, so let's copy it as it was.
>>
>> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
>> fixes commit: 3d3be4333fdf6faa080947b331a6a19bce1a4f57
>>
>> Reported-by: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
>> Signed-off-by: Jarek Poplawski<jarkao2@gmail.com>
>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>> ---
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 26396ff..c83b421 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -2706,7 +2706,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
>>   	} else if (skb_gro_len(p) != pinfo->gso_size)
>>   		return -E2BIG;
>>
>> -	headroom = NET_SKB_PAD + NET_IP_ALIGN;
>> +	headroom = skb_headroom(p);
>>   	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
>>   	if (unlikely(!nskb))
>>   		return -ENOMEM;
>
> You are right, thanks for reviewing this patch again :)
>
> By the way, NET_IP_ALIGN is now 0 on x86, so technically speaking, your
> patch un-aligns IP header on x86, but thats OK, since other arches might
> want it being aligned, while x86 doesnt care.
>
> Acked-by: Eric Dumazet<eric.dumazet@gmail.com>
>
>
>

Well, now that I'm back at work, I'm glad to report
that I tested both variants of the patch, and as Eric
points out - it works both ways.

So, which ever fits you guys better.

Thanks a lot!
