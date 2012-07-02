Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2GBVhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:37:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48327 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2GBVhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:37:10 -0400
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Eric Dumazet <eric.dumazet@gmail.com>
To: chetan loke <loke.chetan@gmail.com>
Cc: Andreas Gruenbacher <agruen@linbit.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
In-Reply-To: <CAAsGZS6ahzUo+QRcLOyPcj5=mp53O+M9kqByOwPb0zZcr-cgwQ@mail.gmail.com>
References: <1341237299.22621.88.camel@edumazet-glaptop>
	 <1341245191.2177.40.camel@schurl.lan>
	 <CAAsGZS6ahzUo+QRcLOyPcj5=mp53O+M9kqByOwPb0zZcr-cgwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 23:37:04 +0200
Message-ID: <1341265024.22621.464.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 15:41 -0400, chetan loke wrote:
> On Mon, Jul 2, 2012 at 12:06 PM, Andreas Gruenbacher <agruen@linbit.com> wrote:
> > On Mon, 2012-07-02 at 15:54 +0200, Eric Dumazet wrote:
> >> So I will just say no to your patches, unless you demonstrate the
> >> splice() problems, and how you can fix the alignment problem in a new
> >> layer instead of in the existing zero copy standard one.
> >
> > Again, splice or not is not the issue here. It does not, by itself, allow zero
> > copy from the network directly to disk but it could likely be made to support
> > that if we can get the alignment right first.  The proposed MSG_NEW_PACKET flag
> > helps with that, but maybe someone has a better idea.
> >
> 
> Eric - by using splice do you mean something like:
> 
> int filedes[2];
> PIPE_SIZE (64*1024)
> pipe(filedes);
> ret = splice (sock_fd_from, &from_offset, filedes [1], NULL, PIPE_SIZE,
>                      SPLICE_F_MORE | SPLICE_F_MOVE);
> 
> 
> ret = splice (filedes [0], NULL, file_fd_to,
>                          &to_offset, ret,
>                          SPLICE_F_MORE | SPLICE_F_MOVE);
> 

Yes, thats more or less the plan. You also can play with bigger
PIPE_SIZE if needed.

> 
> i.e. splice-in from socket to pipe, and splice-out from pipe to destination?
> 
> Andreas - if the above assumption is true then can you apply the
> 'MSG_NEW_PACKET' on the sender and see if the above pseudo-splice code
> achieves something similar to what you expect on the receive side(you
> can also play w/ F_SETPIPE_SZ -  although I found very little
> reduction in CPU usage)? Note: My personal experience - using splice
> from an input-file-A to output-file-B bought very minimal cpu
> reduction(yes, both the files used O_DIRECT). Instead, a simple
> read/write w/ O_DIRECT from file-A to file-B was much much faster.

splice() performance from socket to pipe have improved a lot in
linux-3.5

It was not true zero copy, until very recent patches.
(It was zero copy only on certain class of NIC, not on the ones found
on appliances or cheap platforms)

Willy Tarreau mentioned a nice boost of performance with haproxy.

Willy wanted to work on a direct splice from socket to socket, but
I am not sure it'll bring major speed improvement.



