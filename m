Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0GJAAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:00:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51440
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480Ab0GJAAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:00:05 -0400
Date: Fri, 09 Jul 2010 17:00:18 -0700 (PDT)
Message-Id: <20100709.170018.189701063.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, rpartearroyo@albentia.com,
       linux-kernel@vger.kernel.org, ipichel@albentia.com, nmoron@albentia.com,
       netdev@vger.kernel.org
Subject: Re: net/sched/act_nat.c BUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100709232359.GA2501@gondor.apana.org.au>
References: <201007091637.57660.rpartearroyo@albentia.com>
	<1278688420.2696.7.camel@edumazet-laptop>
	<20100709232359.GA2501@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 10 Jul 2010 07:23:59 +0800

> On Fri, Jul 09, 2010 at 05:13:40PM +0200, Eric Dumazet wrote:
>> Le vendredi 09 juillet 2010 à 16:37 +0200, Rodrigo Partearroyo González
>> a écrit :
>> > Hi all,
>> > 
>> > I have been testing Stateless NAT and found that ICMP packets with length less 
>> > than 20 bytes were not correctly NAT'ed. I have found a BUG that makes taking 
>> > into account IP header length twice, so ICMP packets smaller than 20 bytes 
>> > were being dropped.
>> > 
>> 
>> CC netdev
>> 
>> > The proposed fix is:
>> > 
>> > Index: net/sched/act_nat.c
>> > ===================================================================
>> > --- net/sched/act_nat.c
>> > +++ net/sched/act_nat.c
>> > @@ -202,7 +202,7 @@
>> >         {
>> >                 struct icmphdr *icmph;
>> >  
>> > -               if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
>> > +               if (!pskb_may_pull(skb, ihl + sizeof(*icmph)))
>> >                         goto drop;
>> >  
>> >                 icmph = (void *)(skb_network_header(skb) + ihl);
>> > 
>> > Please, consider applying it.
>> 
>> Nice catch, but take a look at next lines too,
>> when call to skb_clone_writable() is done, since same error is present.
>> 
>> 	skb_clone_writable(skb,
>> 			   ihl + sizeof(*icmph) + sizeof(*iph))
>> 
>> Please submit a formal patch, with your "Signed-off-by: ...", as
>> documented in Documentation/SubmittingPatches
> 
> No we do need the second IP header, think about it...
> 
> However, we should only drop it only if it's long enough and
> pskb_may_pull fails.

Ok, I've reverted until we come up with the proper fix, thanks.
