Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab0IUJjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:39:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab0IUJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dIzeziVmETQmRnixYtCf4NFGe+3euv0Tq4LIQSJ5SJLUg5A2U7TDgFwXvw4nQLGRxA
         j61oIMx4VHOpXCfbr8vqerw5XaiNgM5oQgD3Xcj4coxQd7HRlLsdzsCgL6rjwmmirWG2
         O5f81+CZhktYJBD3VaLI1i0N7/BCWrevcde+o=
Date: Tue, 21 Sep 2010 09:38:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
Message-ID: <20100921093853.GA8664@ff.dom.local>
References: <20100921091248.GA8424@ff.dom.local> <1285060860.2617.158.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285060860.2617.158.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 11:21:00AM +0200, Eric Dumazet wrote:
> Le mardi 21 septembre 2010 ?? 09:12 +0000, Jarek Poplawski a écrit :
> > On 2010-09-20 23:31, Eric Dumazet wrote:
> > ...
> > > @@ -510,11 +509,13 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> > >  				goto slow_path;
> > >  
> > >  			BUG_ON(frag->sk);
> > > -			if (skb->sk) {
> > > +		}
> > > +		if (skb->sk) {
> > > +			skb_walk_frags(skb, frag) {
> > >  				frag->sk = skb->sk;
> > >  				frag->destructor = sock_wfree;
> > 
> > Nice catch, but it seems doing it in the first loop as now, and
> > reverting changes before goto slow_path might be more optimal here.
> > 
> 
> I thought of this, but found this function already very complex.
> 
> Once everything is in cpu caches, the added loop is very cheap.

I hope you're right with this.

> 
> I liked the :
> 
> <check everything without changing state>
> if something wrong
> 	goto slow_path
> else
> 	<OK, lets do destructive things>
> 

But it's an optimization of the "unlikely" case btw. ;-)

Jarek P.
