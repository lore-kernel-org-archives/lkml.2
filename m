Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GBMgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:36:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49456 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2GBMgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:36:14 -0400
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1341229532.29646.39.camel@gurkel.linbit>
References: <1340981632.25226.2.camel@gurkel.linbit>
	 <1340982523.21162.1.camel@edumazet-glaptop>
	 <1341229532.29646.39.camel@gurkel.linbit>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 14:36:08 +0200
Message-ID: <1341232568.22621.8.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 13:45 +0200, Andreas Gruenbacher wrote:
> On Fri, 2012-06-29 at 17:08 +0200, Eric Dumazet wrote:
> > This looks like yet another zero copy, needing another couple of hundred
> > of lines.
> 
> Kind of, yes.  We really want to make no copies at all though; the cpu
> just passes buffers from one device to the other.
> 
> > Why splice infrastructure doesnt fit your needs ?
> 
> The pipe api that splice is based on saves a copy between the kernel and
> user space, but it currently writes to files, going through the page
> cache.  For that, the alignment of data in the network receive buffers
> doesn't matter.
> 

No files or page cache are needed for splice() usage, for example from
socket to another socket.

It just works (check haproxy for an example), with 10Gb performance out
of the box.

The pipe is only a container for buffers, in case the data fetched from
producer cannot be fully sent to consumer. You don't want to lose this
data.


> We want to go directly to the block layer instead.  This requires that
> the network hardware receives the data into sector aligned buffers.
> Hence the proposed MSG_NEW_PACKET flag.
> 

This only is a hint something is wrong with the approach.

> With that, it might be possible to implement a pipe "sink" that goes to
> a bio instead of writing to a file.  Going through the pipe
> infrastructure doesn't actually help in this case though, it's just
> overhead.

There is no expensive overhead in splice() infrastructure, only some
small details that should be eventually solved instead of designing a
new zero copy mode.

You didnt actually tried splice() if you believe a regular file is
needed.

You only need proper splice() support (from pipe to bio), if not already
there.



