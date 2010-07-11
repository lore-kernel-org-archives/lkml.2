Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0GKRGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 13:06:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0GKRGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 13:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lwlfHJP/MNRbvrT7lqYd8eY2ofDJSMSTFRckqnV+IGMsdaE0bGJT6NkBaHucelyMAK
         t1e/Lx1lvN/M7RyvX5wGLUn6xpxPX5oG0vagHEiRW9whCfkyY4d5p04kWVjBx1bvygqr
         wUWSfUxqPEifV42ePEE1URAitvZhWfJYzhiPY=
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
In-Reply-To: <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
References: <4C358AAA.9080400@kernel.org>
	 <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 19:06:17 +0200
Message-ID: <1278867977.2538.167.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 19:09 +0300, Ilpo Järvinen a écrit :
> On Thu, 8 Jul 2010, Tejun Heo wrote:
> 
> > We've been seeing oops in tcp_xmit_retransmit_queue() w/ 2.6.32.15.
> > Please see the attached photoshoot.  This is happening on a HPC
> > cluster and very interestingly caused by one particular job.  How long
> > it takes isn't clear yet (at least more than a day) but when it
> > happens it happens on a lot of machines in relatively short time.
> > 
> > With a bit of disassemblying, I've found that the oops is happening
> > during tcp_for_write_queue_from() because the skb->next points to
> > NULL.
> > 
> >  void tcp_xmit_retransmit_queue(struct sock *sk)
> >  {
> >  ...
> > 	if (tp->retransmit_skb_hint) {
> > 		skb = tp->retransmit_skb_hint;
> > 		last_lost = TCP_SKB_CB(skb)->end_seq;
> > 		if (after(last_lost, tp->retransmit_high))
> > 			last_lost = tp->retransmit_high;
> > 	} else {
> > 		skb = tcp_write_queue_head(sk);
> > 		last_lost = tp->snd_una;
> > 	}
> > 
> >  =>	tcp_for_write_queue_from(skb, sk) {
> > 		 __u8 sacked = TCP_SKB_CB(skb)->sacked;
> > 
> > 		 if (skb == tcp_send_head(sk))
> > 			 break;
> > 		 /* we could do better than to assign each time */
> > 		 if (hole == NULL)
> > 
> > This can happen for one of the following reasons,
> > 
> > 1. tp->retransmit_skb_hint is NULL and tcp_write_queue_head() is NULL
> >    too.  ie. tcp_xmit_retransmit_queue() is called on an empty write
> >    queue for some reason.
> > 
> > 2. tp->retransmit_skb_hint is pointing to a skb which is not on the
> >    write_queue.  ie. somebody forgot to update hint while removing the
> >    skb from the write queue.
> 
> Once again I've read the unlinkers through, and only thing that could 
> cause this is tcp_send_synack (others do deal with the hints) but I think 
> Eric already proposed a patch to that but we never got anywhere due to 
> some counterargument why it wouldn't take place (too far away for me to 
> remember, see archives about the discussions). ...But if you want be dead 
> sure some WARN_ON there might not hurt. Also the purging of the whole 
> queue was a similar suspect I then came across (but that would only 
> materialize with sk reuse happening e.g., with nfs which the other guys 
> weren't using).
> 

Hmm.

This sounds familiar to me, but I cannot remember the discussion you
mention or the patch.

Or maybe it was the TCP transaction thing ? (including data in SYN or
SYN-ACK packet)

> > 3. The hint is pointing to a skb on the list but the list itself is
> >    corrupt.
> > 
> > I added some debug code and the crash is happening when
> > tp->retransmit_skb_hint is not NULL but tp->retransmit_skb_hint->next
> > is NULL.  So, #1 is out; unfortunately, I didn't have debug code in
> > place to discern between #2 and #3.
> > 
> > Does anything ring a bell?  This is a production system and debugging
> > affects quite a number of people.  I can put debug code in to discern
> > between #2 and #3 but I'm basically shooting in the dark and it would
> > be great if someone has a better idea.
> 
> Thanks for taking this up. I've been kind of waiting somebody to show up 
> who actually has some way of reproducing it. Once I had one guy in the 
> hook but his ability to reproduce was for some reason lost when he tried 
> with a debug patch [1]. 
> 
> I now realize that the debug patch should probably also print the write 
> queue too when the problem is caught in order to discern the cases you 
> mention.
> 
> Something along these lines:
> 
> tcp_for_write_queue(skb, sk) {
> 	printk("skb %p (%u-%u) next %p prev %p sacked %u\n", ...);
> }
> 
> Anyway, my debugging patch should be such that in a lucky case it avoids 
> crashing the system too, though price to pay might then be a stuck 
> connection. In case #3 I'd expect the box to die elsewhere in TCP code 
> pretty soon anyway so it depends whether avoiding oops is really so 
> useful, but if you're lucky other mechanism in TCP will recover 
> the lost one for you (basically RTO driven retransmission).
> 


