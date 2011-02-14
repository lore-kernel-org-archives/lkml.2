Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1BNPlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:41:07 -0500
Received: from stinky.trash.net ([213.144.137.162]:55345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab1BNPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:41:05 -0500
Message-ID: <4D594D0F.4090601@trash.net>
Date: Mon, 14 Feb 2011 16:41:03 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] core: dev: don't call BUG() on bad input
References: <1297694579-23611-1-git-send-email-segoon@openwall.com> <AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
In-Reply-To: <AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.02.2011 16:16, schrieb Alexey Dobriyan:
> On Mon, Feb 14, 2011 at 4:42 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
>> Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
>> even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
>> other errors.
> 
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -5761,7 +5761,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>>        size_t alloc_size;
>>        struct net_device *p;
>>
>> -       BUG_ON(strlen(name) >= sizeof(dev->name));
>> +       if (strnlen(name, sizeof(dev->name)) >= sizeof(dev->name)) {
>> +               pr_err("alloc_netdev: Too long device name\n");
>> +               return NULL;
>> +       }
> 
> Netdevice name isn't some random junk you get from userspace, so BUG is fine.

I agree, misuse of kernel APIs is not something we need to catch
verbosely.
