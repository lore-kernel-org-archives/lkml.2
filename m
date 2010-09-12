Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab0ILGzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 02:55:25 -0400
Received: from [83.228.35.12] ([83.228.35.12]:35167 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0ILGzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 02:55:23 -0400
Message-ID: <4C8C7957.7080207@fs.uni-ruse.bg>
Date: Sun, 12 Sep 2010 09:55:19 +0300
From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; bg; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
        eric.dumazet@gmail.com, herbert@gondor.hengli.com.au,
        kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
References: <1283672983.3402.38.camel@edumazet-laptop> <20100908062004.GA6280@ff.dom.local> <20100908.103256.112592448.davem@davemloft.net> <201009082221.16356.rjw@sisk.pl>
In-Reply-To: <201009082221.16356.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

На 08.9.2010 г. 23:21, Rafael J. Wysocki написа:
> On Wednesday, September 08, 2010, David Miller wrote:
>> From: Jarek Poplawski<jarkao2@gmail.com>
>> Date: Wed, 8 Sep 2010 06:20:04 +0000
>>
>>> We need both of them. I hope David could add this too:
>>>
>>> Tested-by: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
>>
>> Done, and applied, thanks :-)
>
> Please kindly let me know when Linus gets them, so that I can close the bug.
>
> Rafael

Now that both commits that fix my problems are in Linus' tree, the
bug can be closed, but these fixes should go in 2.6.35.y, too.
So, CCing -stable.

Fix 1:
> commit	3d3be4333fdf6faa080947b331a6a19bce1a4f57
>
> gro: fix different skb headrooms
>
> Packets entering GRO might have different headrooms, even for a given
> flow (because of implementation details in drivers, like copybreak).
> We cant force drivers to deliver packets with a fixed headroom.
>
> 1) fix skb_segment()
>
> skb_segment() makes the false assumption headrooms of fragments are same
> than the head. When CHECKSUM_PARTIAL is used, this can give csum_start
> errors, and crash later in skb_copy_and_csum_dev()
>
> 2) allocate a minimal skb for head of frag_list
>
> skb_gro_receive() uses netdev_alloc_skb(headroom + skb_gro_offset(p)) to
> allocate a fresh skb. This adds NET_SKB_PAD to a padding already
> provided by netdevice, depending on various things, like copybreak.
>
> Use alloc_skb() to allocate an exact padding, to reduce cache line
> needs:
> NET_SKB_PAD + NET_IP_ALIGN
>
> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
>
> Many thanks to Plamen Petrov, testing many debugging patches !
> With help of Jarek Poplawski.
>
> Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Jarek Poplawski <jarkao2@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Fix 2:
> commit	64289c8e6851bca0e589e064c9a5c9fbd6ae5dd4
>
> gro: Re-fix different skb headrooms
>
> The patch: "gro: fix different skb headrooms" in its part:
> "2) allocate a minimal skb for head of frag_list" is buggy. The copied
> skb has p->data set at the ip header at the moment, and skb_gro_offset
> is the length of ip + tcp headers. So, after the change the length of
> mac header is skipped. Later skb_set_mac_header() sets it into the
> NET_SKB_PAD area (if it's long enough) and ip header is misaligned at
> NET_SKB_PAD + NET_IP_ALIGN offset. There is no reason to assume the
> original skb was wrongly allocated, so let's copy it as it was.
>
> bugzilla : https://bugzilla.kernel.org/show_bug.cgi?id=16626
> fixes commit: 3d3be4333fdf6faa080947b331a6a19bce1a4f57
>
> Reported-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Plamen
