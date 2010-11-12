Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab0KLQyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:54:37 -0500
Received: from stinky.trash.net ([213.144.137.162]:36471 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0KLQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:54:32 -0500
Message-ID: <4CDD7145.8070606@trash.net>
Date: Fri, 12 Nov 2010 17:54:29 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Lamparter <equinox@diac24.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Eric Paris <eparis@redhat.com>,
        Hua Zhong <hzhong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect failed
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <1289578108.3083.95.camel@localhost.localdomain> <1289578532.3185.265.camel@edumazet-laptop> <20101112163543.GB122902@jupiter.n2.diac24.net>
In-Reply-To: <20101112163543.GB122902@jupiter.n2.diac24.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.11.2010 17:35, schrieb David Lamparter:
> On Fri, Nov 12, 2010 at 05:15:32PM +0100, Eric Dumazet wrote:
>> Le vendredi 12 novembre 2010 à 11:08 -0500, Eric Paris a écrit :
>>
>>> 2) What should the generic TCP code (tcp_connect()) do if the skb failed
>>> to send.  Should it return error codes back up the stack somehow or
>>> should they continue to be ignored?  Obviously continuing to just ignore
>>> information we have doesn't make me happy (otherwise I wouldn't have
>>> started scratching this itch).  But the point about ENOBUFS is well
>>> taken.  Maybe I should make tcp_connect(), or the caller to
>>> tcp_connect() more intelligent about specific error codes?
>>>
>>> I'm looking for a path forward.  If SELinux is rejecting the SYN packets
>>> on connect() I want to pass that info to userspace rather than just
>>> hanging.  What's the best way to accomplish that?
>>>
>>
>> Eric, if you can differentiate a permanent reject, instead of a
>> temporary one (congestion, or rate limiting, or ENOBUF, or ...), then
>> yes, you could make tcp_connect() report to user the permanent error,
>> and ignore the temporary one.

Indeed. We could even make the NF_DROP return value configurable
by encoding it in the verdict.

> If the netfilter targets DROP/REJECT match the NF_DROP/NF_REJECT
> counterparts, which i guess they do but i didn't read the source ;),
> then SELinux should use NF_REJECT in my opinion.

There is no NF_REJECT.

> NF_DROP does exactly what the name says, it drops the packet aka
> basically puts it in /dev/null. As with writing to /dev/null, you don't
> get an error for that. Even more, if in the meantime the DROP rule does
> not match anymore, the 2nd or 3rd SYN from the connect() can come
> through and establish a connection (think of "-m statistic" & co.)
> 
> This is very different from REJECT.

Returning NF_DROP results in -EPERM getting reported back. As Eric
noticed, this is ignored for SYN packets.

> If REJECT doesn't immediately get reported to the application, that *is*
> a bug, but last time i checked i got EPERM immediately. I would fix
> SELinux to use the same mechanism.

NF_DROP returns -EPERM, the REJECT targets send packets to reject
a connection. Whether this is reported immediately depends on the
error and the protocol in question. Using a TCP reset immediately
resets the connection.
