Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab2GBLpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:45:36 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:57531 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2GBLpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:45:35 -0400
Message-ID: <1341229532.29646.39.camel@gurkel.linbit>
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Andreas Gruenbacher <agruen@linbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 02 Jul 2012 13:45:32 +0200
In-Reply-To: <1340982523.21162.1.camel@edumazet-glaptop>
References: <1340981632.25226.2.camel@gurkel.linbit>
	 <1340982523.21162.1.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:08 +0200, Eric Dumazet wrote:
> This looks like yet another zero copy, needing another couple of hundred
> of lines.

Kind of, yes.  We really want to make no copies at all though; the cpu
just passes buffers from one device to the other.

> Why splice infrastructure doesnt fit your needs ?

The pipe api that splice is based on saves a copy between the kernel and
user space, but it currently writes to files, going through the page
cache.  For that, the alignment of data in the network receive buffers
doesn't matter.

We want to go directly to the block layer instead.  This requires that
the network hardware receives the data into sector aligned buffers.
Hence the proposed MSG_NEW_PACKET flag.

With that, it might be possible to implement a pipe "sink" that goes to
a bio instead of writing to a file.  Going through the pipe
infrastructure doesn't actually help in this case though, it's just
overhead.

Thanks,
Andreas

