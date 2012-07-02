Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2GBNzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:55:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61060 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GBNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:55:05 -0400
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1341234177.29646.69.camel@gurkel.linbit>
References: <1340981632.25226.2.camel@gurkel.linbit>
	 <1340982523.21162.1.camel@edumazet-glaptop>
	 <1341229532.29646.39.camel@gurkel.linbit>
	 <1341232568.22621.8.camel@edumazet-glaptop>
	 <1341234177.29646.69.camel@gurkel.linbit>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 15:54:59 +0200
Message-ID: <1341237299.22621.88.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 15:02 +0200, Andreas Gruenbacher wrote:

> bio_vec's have some alignment requirements that must be met, and
> anything that doesn't meet those requirements can't be passed to the
> block layer (without copying it first).  Additional layers between the
> network and block layers, like a pipe, won't make that problem go away.
> 

What are the "some alignment requirements" exactly, and how do you use
TCP exactly to meet them ? (MSS= multiple of 512 ?)

I believe you try to escape from the real problem.

If the NIC driver provides non aligned data, neither splice() or your
new stuff will magically align it. You _need_ a copy in either cases.

If NIC driver provides aligned data, splice(socket -> pipe) will keep
this alignment for you at 0 cost.

> It's not already there, it requires the alignment issue to be addresses
> first.


There is no guarantee TCP payload is aligned to a bio, ever, in linux
ethernet/ip/tcp stack.

Really, your patches work for you, by pure luck, because you use one
particular NIC driver that happens to prepare things for you (presumably
doing header split). Nothing guarantee this wont change even for the
same hardware in linux-3.8

So I will just say no to your patches, unless you demonstrate the
splice() problems, and how you can fix the alignment problem in a new
layer instead of in the existing zero copy standard one.



