Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2CAQAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:00:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2CAQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:00:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.180.95.105 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330617640.2465.78.camel@edumazet-laptop>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        David Laight <David.Laight@ACULAB.COM>,
        David Miller <davem@davemloft.net>, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Mar 2012 08:00:40 -0800
In-Reply-To: <4F4F7FFB.6010608@collabora.co.uk>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com>
	  <1330606237.27405.5.camel@megeve>
	 <1330606775.2465.56.camel@edumazet-laptop>
	 <4F4F7FFB.6010608@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 mars 2012 à 14:56 +0100, Javier Martinez Canillas a écrit :

> We could use AF_INET multicast on a local machine but we need some
> ordering and control flow requirements that are not guaranteed on UDP
> multicast over IP. That's why we thought to add a new address family
> AF_MCAST.
> 

It seems application logic and complexity pushed into kernel, for a very
single user (even if used in a lot of products) : D-Bus

> To make it a general local multicast solution and not being too specific
> we added some flags to control its behavior like
> MCAST_MREQ_DROP_WHEN_FULL to decide to either block the sender or drop
> the packet when one receiver has its queue full.

I am only wondering how many lines this is going to add in kernel for a
complete implementation, given your performance expectations, flow
control, reliability, not counting all security issues (ancillary
messages and so on)

In case of IP_MULTICAST_LOOP, we could allow the sender to sleep if
receiver queue is full, with a bit of tweaking in stack (current
implementation uses loopback re-inject, so requires softirq handling).

In fact, we could use a new IP_MULTICAST_LOCAL option, so that sender
processing doesnt trigger a softirq handler at all and is allowed to
sleep if needed. For example skb allocations could use GFP_KERNEL
instead of current GFP_ATOMIC ones in udp mcast .

I dont know, maybe it would be a smaller patch.



