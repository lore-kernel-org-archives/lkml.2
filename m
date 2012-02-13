Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2BMKqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:46:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63235 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2BMKqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:46:05 -0500
Message-ID: <1329129960.2494.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: ixgbe truesize underestimation fix missing?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christian Brunner <christian@brunner-muc.de>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 11:46:00 +0100
In-Reply-To: <CAJafhzS3TMNPsyc_wwjZOf4zNmGD-XdP59qgYgGMx0-SMAnc-w@mail.gmail.com>
References: <CAJafhzQV821ij62y_TQr9M3jHyyDdovi0P30kidv7H8fsoqKPw@mail.gmail.com>
	 <1329123803.2336.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAJafhzS3TMNPsyc_wwjZOf4zNmGD-XdP59qgYgGMx0-SMAnc-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 13 février 2012 à 10:57 +0100, Christian Brunner a écrit :
> 2012/2/13 Eric Dumazet <eric.dumazet@gmail.com>:
> > Le lundi 13 février 2012 à 09:45 +0100, Christian Brunner a écrit :
> >> Back in Oktober, there was a patch by Eric Dumazet for the ixgbe
> >> driver to fix the skb truesize underestimation (commit
> >> 98130646770db42cd14c44ba0d7f2d0eb8078820). It changed only one line in
> >> ixgbe_main.c:
> >>
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> >> @@ -1326,7 +1326,7 @@ static bool ixgbe_clean_rx_irq(struct
> >> ixgbe_q_vector *q_vector,
> >>                         skb->len += upper_len;
> >>                         skb->data_len += upper_len;
> >> -                       skb->truesize += upper_len;
> >> +                       skb->truesize += PAGE_SIZE / 2;
> >>                 }                 i++;
> >>
> >>
> >> But when I look at the current code (3.2.5 or 3.3rc), skb->truesize is
> >> still increased by the same value as skb->data_len.
> >>
> >> 1228         skb->data_len += frag_list_size;
> >> 1229         skb->truesize += frag_list_size;
> >>
> >> Is it posible that there was a merge conflict, or am I missing something here?
> >
> > Maybe a problem in your local tree ?
> >
> > I can see proper fix in current tree.
> 
> Ahh... Sorry. I Was looking at the wrong place -
> ixgbe_transform_rsc_queue() has code that is quite similar.
> 
> This however makes me wonder, why we are using "skb->len" for
> increasing the frag_list_size, as skb->len might be smaller than
> skb->truesize.
> 
> Shouldn't we add a frag_list_truesize counter in ixgbe_transform_rsc_queue() ?

Probably, but you should raise this discussion on netdev, not lkml, and
based on net-next tree, as ixgbe_transform_rsc_queue() doesnt exist
anymore ;)

Note that in this case (RSC) truesize underestimation is small since
typical segment size is very close to PAGE_SIZE/2



