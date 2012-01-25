Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2AYGXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:23:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34782 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2AYGXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:23:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120124.230354.1696063062900108959.davem@davemloft.net>
References: <12446987.2261327416407141.JavaMail.root@5-MeO-DMT.ynet.sk>
 <25119746.2341327416953583.JavaMail.root@5-MeO-DMT.ynet.sk> <20120124.230354.1696063062900108959.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Wed, 25 Jan 2012 07:22:43 +0100
X-Google-Sender-Auth: 5fDb_T7ta7NSDPGLemjfrg7M6Iw
Message-ID: <CAGsizzLHT6jK8zJn+5eJkTUt5NBdpK9uNHJTzDCPrbCcPBvBNA@mail.gmail.com>
Subject: Re: [patch v3, kernel version 3.2.1] Source mode for macvlan interface
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/25 David Miller <davem@davemloft.net>:
> From: Stefan Gula <steweg@ynet.sk>
> Date: Tue, 24 Jan 2012 15:55:53 +0100 (CET)
>
>> diff -uprN -X linux/Documentation/dontdiff linux-3.2.1-orig/net/core/rtnetlink.c linux/net/core/rtnetlink.c
>> --- linux-3.2.1-orig/net/core/rtnetlink.c     2012-01-12 20:42:45.000000000 +0100
>> +++ linux/net/core/rtnetlink.c        2012-01-24 14:26:58.083219352 +0100
>> @@ -1506,6 +1506,9 @@ errout:
>>
>>       if (send_addr_notify)
>>               call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
>> +     min_ifinfo_dump_size = max_t(u16, if_nlmsg_size(dev),
>> +                                     min_ifinfo_dump_size);
>> +
>
> What is this?  And whatever it is why isn't it 1) described in the
> commit message and why isn't it 2) in a seperate patch if it's
> unrelated to this macvlan change?
>
> I'm not apply this patch as it is right now, it needs some sort of
> change.
>
It's a result of need to have enough space allocated for sk_buff
struct before called macvlan_fill_info. I know that it looks somehow
messy. BUt before the macvlan_fill_info is called there is only one
procedure calcit. The problem of calcit is that it doesn't have access
to struct net_device *dev int it. It has only access to struct sk_buff
*skb, so from that point it cannot be called directly (whole parsing
code had to be copied there to get the *dev a calling
if_nlmsg_size(dev) from it. On the other hand calcit returns global
static value of min_ifinfo_dump_size and that is shared among all
interfaces and modifying like this do the job properly. There was
another different way and that was creating and registering a whole
new PF_MACLVAN netlink group resulting in copying almost 95% percent
of given code and modified it somehow to do the same.

If it should be result of separate commitment than ok, but it was
result apparently of need only for use of macvlan that's why it was
included in my patch.

So how should I proceed with it?
