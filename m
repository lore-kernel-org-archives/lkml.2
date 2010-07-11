Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0GKS34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 14:29:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44708 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0GKS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 14:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LaFfRMM8/FxMvttv7pk9bjBbd3+rbAQvVzx8B6mpVjCEGKP6H1j6f6bEiGsUCjXYpc
         VwV9nFLREGxUpucShVTZ/ESOkRsXPT6MsYAsz3RXmiGxkL+RmJQNA7gL+vsLjJPHrRSF
         OSx3vfGi14HLw92W2M/C25UGn/9rTr/+6vkCQ=
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
In-Reply-To: <1278870382.2538.180.camel@edumazet-laptop>
References: <4C358AAA.9080400@kernel.org>
	 <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
	 <1278867977.2538.167.camel@edumazet-laptop>
	 <1278870382.2538.180.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 20:29:50 +0200
Message-ID: <1278872990.2538.189.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 19:46 +0200, Eric Dumazet a écrit :
> Le dimanche 11 juillet 2010 à 19:06 +0200, Eric Dumazet a écrit :
> > Le dimanche 11 juillet 2010 à 19:09 +0300, Ilpo Järvinen a écrit :
> > > On Thu, 8 Jul 2010, Tejun Heo wrote:
> > > 
> > > > We've been seeing oops in tcp_xmit_retransmit_queue() w/ 2.6.32.15.
> > > > Please see the attached photoshoot.  This is happening on a HPC
> > > > cluster and very interestingly caused by one particular job.  How long
> > > > it takes isn't clear yet (at least more than a day) but when it
> > > > happens it happens on a lot of machines in relatively short time.
> > > > 
> > > > With a bit of disassemblying, I've found that the oops is happening
> > > > during tcp_for_write_queue_from() because the skb->next points to
> > > > NULL.
> > > > 
> > > >  void tcp_xmit_retransmit_queue(struct sock *sk)
> > > >  {
> > > >  ...
> > > > 	if (tp->retransmit_skb_hint) {
> > > > 		skb = tp->retransmit_skb_hint;
> > > > 		last_lost = TCP_SKB_CB(skb)->end_seq;
> > > > 		if (after(last_lost, tp->retransmit_high))
> > > > 			last_lost = tp->retransmit_high;
> > > > 	} else {
> > > > 		skb = tcp_write_queue_head(sk);
> > > > 		last_lost = tp->snd_una;
> > > > 	}
> > > > 
> > > >  =>	tcp_for_write_queue_from(skb, sk) {
> > > > 		 __u8 sacked = TCP_SKB_CB(skb)->sacked;
> > > > 
> > > > 		 if (skb == tcp_send_head(sk))
> > > > 			 break;
> > > > 		 /* we could do better than to assign each time */
> > > > 		 if (hole == NULL)
> > > > 
> > > > This can happen for one of the following reasons,
> > > > 
> > > > 1. tp->retransmit_skb_hint is NULL and tcp_write_queue_head() is NULL
> > > >    too.  ie. tcp_xmit_retransmit_queue() is called on an empty write
> > > >    queue for some reason.
> > > > 
> > > > 2. tp->retransmit_skb_hint is pointing to a skb which is not on the
> > > >    write_queue.  ie. somebody forgot to update hint while removing the
> > > >    skb from the write queue.
> > > 
> > > Once again I've read the unlinkers through, and only thing that could 
> > > cause this is tcp_send_synack (others do deal with the hints) but I think 
> > > Eric already proposed a patch to that but we never got anywhere due to 
> > > some counterargument why it wouldn't take place (too far away for me to 
> > > remember, see archives about the discussions). ...But if you want be dead 
> > > sure some WARN_ON there might not hurt. Also the purging of the whole 
> > > queue was a similar suspect I then came across (but that would only 
> > > materialize with sk reuse happening e.g., with nfs which the other guys 
> > > weren't using).
> > > 
> > 
> > Hmm.
> > 
> > This sounds familiar to me, but I cannot remember the discussion you
> > mention or the patch.
> > 
> > Or maybe it was the TCP transaction thing ? (including data in SYN or
> > SYN-ACK packet)
> 
> Hmm, I cannot find where we reset restransmit_skb_hint in
> tcp_mtu_probe(), if we call tcp_unlink_write_queue().
> 
> if (skb->len <= copy) {
> 	/* We've eaten all the data from this skb.
> 	 * Throw it away. */
> 	TCP_SKB_CB(nskb)->flags |= TCP_SKB_CB(skb)->flags;
> <<>>	tcp_unlink_write_queue(skb, sk);
> 	sk_wmem_free_skb(sk, skb);
> } else {
> 
> 
> Sorry if this was already discussed. We might add a comment here in anycase ;)
> 

Just in case, here is a patch for this issue, if Tejun wants to try it.

Thanks

[PATCH] tcp: tcp_mtu_probe() and retransmit hints

When removing an skb from tcp write queue, we must take care of various
hints that could be kept on this skb. tcp_mtu_probe() misses this
cleanup.

lkml reference : http://lkml.org/lkml/2010/7/8/63

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b4ed957..187453f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1666,6 +1666,9 @@ static int tcp_mtu_probe(struct sock *sk)
 			 * Throw it away. */
 			TCP_SKB_CB(nskb)->flags |= TCP_SKB_CB(skb)->flags;
 			tcp_unlink_write_queue(skb, sk);
+			tcp_clear_retrans_hints_partial(tp);
+			if (skb == tp->retransmit_skb_hint)
+				tp->retransmit_skb_hint = nskb;
 			sk_wmem_free_skb(sk, skb);
 		} else {
 			TCP_SKB_CB(nskb)->flags |= TCP_SKB_CB(skb)->flags &


