Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2CEIim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 03:38:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2CEIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 03:38:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of luiz.dentz@gmail.com designates 10.101.152.1 as permitted sender) smtp.mail=luiz.dentz@gmail.com; dkim=pass header.i=luiz.dentz@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120302170823.7117821b@pyramind.ukuu.org.uk>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
	<20120301.170848.432407217191581288.davem@davemloft.net>
	<CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
	<20120302.035509.1994457175982020283.davem@davemloft.net>
	<4F509274.9060302@collabora.co.uk>
	<1330694031.2469.15.camel@edumazet-laptop>
	<4F50F6AA.9050909@collabora.co.uk>
	<20120302170823.7117821b@pyramind.ukuu.org.uk>
Date: Mon, 5 Mar 2012 10:38:39 +0200
Message-ID: <CABBYNZKhoT-POaaSvHoNLXU+hkPCiY_eqjEqDgzCqq4RvEvNXg@mail.gmail.com>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        ying.xue@windriver.com, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, Mar 2, 2012 at 7:08 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> 2- The transport layer used by D-bus is not performance sensitive
>> basically due:
>>
>> a) high number of context switches required to send messages between peer.
>
> This is a user space design issue. The fact dbus wakes up so much
> stuff wants fixing at the dbus level.

Can you be more specific, afaik centralizing the message subscription
on the daemon minimize the wakeups of the applications, in the other
hand BPF might be a better solution to filter the packets but is more
recent than D-Bus itself. If you have a suggestion of a better design
could you please let us know.

>> b) the D-bus daemon doing the routing and being a bottleneck of the whole.
>
> This is a userspace design issue.

But do you think letting the clients manage their connections to each
other client it talk would have been better? The number of fd per
client would sky rocketed.

>> c) amount of messages copied between kernel space and user space.
>
> This is mostly a userspace design issue and fixing a would fix much of c
> because you wouldn't keep sending people crap they didn't need.

Afaik this is not a problem in D-Bus, perhaps if you have eavesdrop
enabled but that is your configuration, the client only gets signals
they subscribe to and messages addressed to its connection (method
call). That doesn't mean that are bad implement client who subscribe
for everything and which translate in more data being copied and
wakeups, but that is not D-Bus fault and even with BPF the client can
do that too.

> You've already got multicast facilities in kernel (if dbus must work by
> shouting not state change subscription like saner setups), and you've got
> BPF filtering facilities to try and cure some of the wakeups even doing
> multicast.

Isn't that what is this all about? The problem seems to be that with
BPF alone it would not be possible to implement multicast without
sacrificing security, at least method call and reply messages should
be private to the peers involved without eavesdrop being enabled.

Btw this was posted in detail here:
http://blogs.gnome.org/rodrigo/2012/02/27/d-bus-optimizations/

> Beyond that I don't see what the kernel can do given its mostly an
> architectural problem.
>
> Your model appears to be "since its causing enormous amounts of work we
> should do the work faster". The right model would appear to me to be "We
> shouldn't cause enormous amounts of work"

Please check the link above and tell me if that different than the
model you suggested using BPF, apparently we are talking about the
very same solution but the implementation detail are getting in the
way because a lot of code was added.

-- 
Luiz Augusto von Dentz
