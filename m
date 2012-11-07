Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2KGBv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:51:56 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33913 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KGBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:51:54 -0500
Subject: Re: [PATCH] tcp: Replace infinite loop on recvmsg bug with proper
 crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Eric Dumazet <edumazet@chromium.org>
In-Reply-To: <20121107013907.GA31185@redhat.com>
References: <1352247335-10396-1-git-send-email-jwerner@chromium.org>
	 <20121107013907.GA31185@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Nov 2012 17:51:50 -0800
Message-ID: <1352253110.3140.2699.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-06 at 20:39 -0500, Dave Jones wrote:
> On Tue, Nov 06, 2012 at 04:15:35PM -0800, Julius Werner wrote:
>  > tcp_recvmsg contains a sanity check that WARNs when there is a gap
>  > between the socket's copied_seq and the first buffer in the
>  > sk_receive_queue. In theory, the TCP stack makes sure that This Should
>  > Never Happen (TM)... however, practice shows that there are still a few
>  > bug reports from it out there (and one in my inbox).
>  > 
>  > Unfortunately, when it does happen for whatever reason, the situation
>  > is not handled very well: the kernel logs a warning and breaks out of
>  > the loop that walks the receive queue. It proceeds to find nothing else
>  > to do on the socket and hits sk_wait_data, which cannot block because
>  > the receive queue is not empty. As no data was read, the outer while
>  > loop repeats (logging the same warning again) ad infinitum until the
>  > system's syslog exhausts all available hard drive capacity.
>  > 
>  > This patch improves that behavior by going straight to a proper kernel
>  > crash. The cause of the error can be identified right away and the
>  > system's hard drive is not unnecessarily strained.
>  > 
>  > Signed-off-by: Julius Werner <jwerner@chromium.org>
>  > ---
>  >  net/ipv4/tcp.c |    2 +-
>  >  1 files changed, 1 insertions(+), 1 deletions(-)
>  > 
>  > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>  > index 197c000..fcb0927 100644
>  > --- a/net/ipv4/tcp.c
>  > +++ b/net/ipv4/tcp.c
>  > @@ -1628,7 +1628,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>  >  				 "recvmsg bug: copied %X seq %X rcvnxt %X fl %X\n",
>  >  				 *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt,
>  >  				 flags))
>  > -				break;
>  > +				BUG();
>  >  
>  >  			offset = *seq - TCP_SKB_CB(skb)->seq;
>  >  			if (tcp_hdr(skb)->syn)
> 
> We've had reports of this WARN against the Fedora kernel for a while.
> Had this been immediately followed by a BUG(), we'd have never seen those traces at all,
> and just got "my machine just locked up" reports instead.
> 
> The proper fix here is to find out why we're getting into this state.

Yes, but there is no need to fill syslog over and over.

In fact, some drivers are buggy and can overwrite skbs.

Thats also a security issue, as payload can be changed without notice
(unless SSL or application checksums are done, see commit
abf02cfc179bb4bd for an example)

Quite frankly BUG_ON() here is the only way we can fix bugs instead of
being lazy.



