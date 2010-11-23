Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0KWSjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:39:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60953
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab0KWSjX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:39:23 -0500
Date: Tue, 23 Nov 2010 10:39:49 -0800 (PST)
Message-Id: <20101123.103949.39186245.davem@davemloft.net>
To: alban.crequy@collabora.co.uk
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, gorcunov@openvz.org,
        adobriyan@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        ian.molton@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] AF_UNIX: find the recipients for multicast messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101123174701.1b2f6f16@chocolatine.cbg.collabora.co.uk>
References: <20101123150315.4e67a139@chocolatine.cbg.collabora.co.uk>
	<1290528517.3046.91.camel@edumazet-laptop>
	<20101123174701.1b2f6f16@chocolatine.cbg.collabora.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>
Date: Tue, 23 Nov 2010 17:47:01 +0000

> Le Tue, 23 Nov 2010 17:08:37 +0100,
> Eric Dumazet <eric.dumazet@gmail.com> a écrit :
>> I am not sure if doing 90 clones of skb and filtering them one by one
>> is going to be fast :-(
> 
> Yes... I think it can be optimized. Run the socket filter first by
> calling sk_run_filter() directly and then call skb_clone() + pskb_trim()
> only on the few remaining sockets.

BTW, we have and have talked about the same exact problem with
AF_PACKET socket users such as DHCP.

We clone and push the packet down into the AF_PACKET protocol
code from the pt_type callback when %99 of the time the socket
filter doesn't match and thus the clone is completely wasted
work.

If we know the socket, or more specifically the filter, early enough,
we could have a special interface like:

	struct sk_buff *skb_filter_or_clone(struct sk_buff *skb, ...)

Which returns a non-NULL cloned SKB if the filter accepts the
packet.
