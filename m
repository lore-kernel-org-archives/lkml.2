Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2E3HCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:02:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2E3HCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:02:12 -0400
Date: Wed, 30 May 2012 03:02:05 -0400 (EDT)
Message-Id: <20120530.030205.1337682162603770949.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] net: sock: validate data_len before allocating skb in
 sock_alloc_send_pskb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338360383.2760.84.camel@edumazet-glaptop>
References: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<1338360383.2760.84.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 May 2012 00:02:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 May 2012 08:46:23 +0200

> Why doing this test in the while (1) block, it should be done before the
> loop...
> 
> Or even in the caller, note net/unix/af_unix.c does this right.
> 
>         if (len > SKB_MAX_ALLOC)
>                 data_len = min_t(size_t,
>                                  len - SKB_MAX_ALLOC,
>                                  MAX_SKB_FRAGS * PAGE_SIZE);
> 
>         skb = sock_alloc_send_pskb(sk, len - data_len, data_len,
>                                    msg->msg_flags & MSG_DONTWAIT, &err);

My impression is that the callers should be fixed to.  It makes no sense
to penalize the call sites that get this right.

And yes, if we do check it in sock_alloc_send_pskb() it should be done
at function entry, not inside the loop.
