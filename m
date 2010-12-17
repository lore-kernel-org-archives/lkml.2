Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0LQF7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:59:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39160 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0LQF7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:59:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aMsOQjIhEvEQPiRr1h7A6KWSymWfp/Rbwl3JWSvyK30TrDJej109rA9LnWyTQNkchM
         YIl0xoCqS0x6tv91kAQ+hgHWkrLjp6ayByzNsjNpEv9xVJmSQkUjLXULzlqa6OYhvp4h
         1jMLmcp+iOw0DzztBPfFxqBP2jlHMRMzbzMwk=
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Minchan Kim <minchan.kim@gmail.com>, gerald.schaefer@de.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Ted Ts'o" <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20101217054722.GG2253@linux.vnet.ibm.com>
References: <20101121133024.GF23423@thunk.org>
	 <20101121153949.GD20947@barrios-desktop> <20101121173726.GG23423@thunk.org>
	 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
	 <rcu-radix-tree@mdm.bga.com> <20101122061619.GA2764@linux.vnet.ibm.com>
	 <1291748509.19276.62.camel@thinkpad>
	 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
	 <1292507421.4885.19.camel@thinkpad>
	 <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
	 <20101217054722.GG2253@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 06:59:01 +0100
Message-ID: <1292565541.2655.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 16 décembre 2010 à 21:47 -0800, Paul E. McKenney a écrit :
> On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> > How about this?
> > Maybe Paul have better idea.
> > (It's apparently be word-wrapped.)
> > 
> > diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> > index ab2baa5..135af1e 100644
> > --- a/include/linux/radix-tree.h
> > +++ b/include/linux/radix-tree.h
> > @@ -146,6 +146,20 @@ static inline void *radix_tree_deref_slot(void **pslot)
> >  }
> > 
> >  /**
> > + * radix_tree_deref_slot_nocheck       - dereference a slot without RCU check
> > + * @pslot:     pointer to slot, returned by radix_tree_lookup_slot
> > + * Returns:    item that was stored in that slot with any direct pointer flag
> > + *             removed.
> > + *
> > + * This functions works like radix_tree_deref_slot except it doesn't check
> > + * RCU rule. Normally this funcion is used with update-side lock.
> > + * You should use this function very carefully.
> > + */
> > +static inline void *radix_tree_deref_slot_nocheck(void **pslot)
> > +{
> > +       return rcu_dereference_protected(*pslot, 1);
> 
> I suggest replacing the "1" with lockdep expressions for the locks
> that you say might be held:
> 
> 	return rcu_dereference_check(*pslot,
> 				     lockdep_is_held(&mapping->tree_lock));
> 

Yes, but point was also to use rcu_dereference_protected() here, not
rcu_dereference_check().



> This assumes that when you said "and" you meant both lock_page() and
> mapping->tree_lock.  Also you need to pass in the mapping, which
> should not be a problem given likely inlining.
> 
> If you meant that either mapping->tree_lock or page_lock() might be
> held, I suppose that the page_lock() state could be passed in, but
> perhaps better to take a general lockdep expression.
> 
> So, either or both?  ;-)
> 

Thanks


