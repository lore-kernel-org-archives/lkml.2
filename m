Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0GIXYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:24:08 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:37399 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0GIXYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:24:06 -0400
Date: Sat, 10 Jul 2010 07:23:59 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rodrigo Partearroyo =?iso-8859-1?Q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Iratxo Pichel Ortiz <ipichel@albentia.com>,
       Noelia =?iso-8859-1?Q?Mor=F3n?= <nmoron@albentia.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: net/sched/act_nat.c BUG
Message-ID: <20100709232359.GA2501@gondor.apana.org.au>
References: <201007091637.57660.rpartearroyo@albentia.com> <1278688420.2696.7.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1278688420.2696.7.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 05:13:40PM +0200, Eric Dumazet wrote:
> Le vendredi 09 juillet 2010 à 16:37 +0200, Rodrigo Partearroyo González
> a écrit :
> > Hi all,
> > 
> > I have been testing Stateless NAT and found that ICMP packets with length less 
> > than 20 bytes were not correctly NAT'ed. I have found a BUG that makes taking 
> > into account IP header length twice, so ICMP packets smaller than 20 bytes 
> > were being dropped.
> > 
> 
> CC netdev
> 
> > The proposed fix is:
> > 
> > Index: net/sched/act_nat.c
> > ===================================================================
> > --- net/sched/act_nat.c
> > +++ net/sched/act_nat.c
> > @@ -202,7 +202,7 @@
> >         {
> >                 struct icmphdr *icmph;
> >  
> > -               if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
> > +               if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
> >                         goto drop;
> >  
> >                 icmph = (void *)(skb_network_header(skb) + ihl);
> > 
> > Please, consider applying it.
> 
> Nice catch, but take a look at next lines too,
> when call to skb_clone_writable() is done, since same error is present.
> 
> 	skb_clone_writable(skb,
> 			   ihl + sizeof(*icmph) + sizeof(*iph))
> 
> Please submit a formal patch, with your "Signed-off-by: ...", as
> documented in Documentation/SubmittingPatches

No we do need the second IP header, think about it...

However, we should only drop it only if it's long enough and
pskb_may_pull fails.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
