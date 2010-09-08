Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0IHGUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:20:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42999 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0IHGUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=abS/CD0m0xbgL8doGX7j1BS59fLZinc94qr8/KQVJ5nO6SELZrD68p92asG3itbNrq
         T0zBxlYeQv488hs/rncwSEIMD88g/oz4EHX9pq0yAUmO43+xJcTv+MC24BMsLrYJnjGd
         99sSIGn3KeMV/O/tfmEWa1u1XRf1DHq14LDsk=
Date: Wed, 8 Sep 2010 06:20:04 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Message-ID: <20100908062004.GA6280@ff.dom.local>
References: <20100904203429.GA4891@del.dom.local> <1283672983.3402.38.camel@edumazet-laptop> <4C8717BB.2050504@fs.uni-ruse.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8717BB.2050504@fs.uni-ruse.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 07:57:31AM +0300, Plamen Petrov wrote:
> ???? 05.9.2010 ??. 10:49, Eric Dumazet ????????????:
>> Le samedi 04 septembre 2010 ?? 22:34 +0200, Jarek Poplawski a écrit :
>>
>>> Hi again,
>>>
>>> Just had a second look, and unless I miss something...
>>>
>>> Plamen, could you test this patch, too? (Without removing the previous
>>> one.)
>>>
>>> Thanks,
>>> Jarek P.
>>>
>>> ------------------->
>>>
>>> [PATCH] gro: Re-fix different skb headrooms
>>>
>>> The patch: "gro: fix different skb headrooms" in its part:
>>> "2) allocate a minimal skb for head of frag_list" is buggy. The copied
>>> skb has p->data set at the ip header at the moment, and skb_gro_offset
>>> is the length of ip + tcp headers. So, after the change the length of
>>> mac header is skipped. Later skb_set_mac_header() sets it into the
>>> NET_SKB_PAD area (if it's long enough) and ip header is misaligned at
>>> NET_SKB_PAD + NET_IP_ALIGN offset. There is no reason to assume the
>>> original skb was wrongly allocated, so let's copy it as it was.
>>>
>>> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
>>> fixes commit: 3d3be4333fdf6faa080947b331a6a19bce1a4f57
>>>
>>> Reported-by: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
>>> Signed-off-by: Jarek Poplawski<jarkao2@gmail.com>
>>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>>> ---
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index 26396ff..c83b421 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -2706,7 +2706,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
>>>   	} else if (skb_gro_len(p) != pinfo->gso_size)
>>>   		return -E2BIG;
>>>
>>> -	headroom = NET_SKB_PAD + NET_IP_ALIGN;
>>> +	headroom = skb_headroom(p);
>>>   	nskb = alloc_skb(headroom + skb_gro_offset(p), GFP_ATOMIC);
>>>   	if (unlikely(!nskb))
>>>   		return -ENOMEM;
>>
>> You are right, thanks for reviewing this patch again :)
>>
>> By the way, NET_IP_ALIGN is now 0 on x86, so technically speaking, your
>> patch un-aligns IP header on x86, but thats OK, since other arches might
>> want it being aligned, while x86 doesnt care.
>>
>> Acked-by: Eric Dumazet<eric.dumazet@gmail.com>
>>
>>
>>
>
> Well, now that I'm back at work, I'm glad to report
> that I tested both variants of the patch, and as Eric
> points out - it works both ways.
>
> So, which ever fits you guys better.

We need both of them. I hope David could add this too:

Tested-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>

Thanks a lot everybody!
Jarek P.
