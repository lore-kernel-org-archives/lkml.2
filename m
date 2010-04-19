Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0DSOc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0DSOcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:32:25 -0400
Date: Mon, 19 Apr 2010 11:32:19 -0300
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100419143219.GF14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <4BCA026D.3070309@redhat.com>
 <4BCA02D1.2020608@redhat.com>
 <1271673836.1674.757.camel@laptop>
 <4BCC34DF.6030702@redhat.com>
 <1271674575.1674.793.camel@laptop>
 <4BCC3AC2.8050601@redhat.com>
 <1271675983.1674.853.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271675983.1674.853.camel@laptop>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 01:19:43PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-19 at 14:13 +0300, Avi Kivity wrote:
> > On 04/19/2010 01:56 PM, Peter Zijlstra wrote:
> > >
> > >    
> > >>> Right, do bear in mind that the x86 implementation of atomic64_read() is
> > >>> terrifyingly expensive, it is better to not do that read and simply use
> > >>> the result of the cmpxchg.
> > >>>
> > >>>
> > >>>        
> > >> atomic64_read() _is_ cmpxchg64b.  Are you thinking of some clever
> > >> implementation for smp i386?
> > >>      
> > >
> > > No, what I was suggesting was to rewrite that loop no to need the
> > > initial read but use the cmpxchg result of the previous iteration.
> > >
> > > Something like:
> > >
> > >    u64 last = 0;
> > >
> > >    /* more stuff */
> > >
> > >    do {
> > >      if (ret<  last)
> > >        return last;
> > >      last = cmpxchg64(&last_value, last, ret);
> > >    } while (last != ret);
> > >
> > > That only has a single cmpxchg8 in there per loop instead of two
> > > (avoiding the atomic64_read() one).
> > >    
> > 
> > Still have two cmpxchgs in the common case.  The first iteration will 
> > fail, fetching last_value, the second will work.
> > 
> > It will be better when we have contention, though, so it's worthwhile.
> 
> Right, another option is to put the initial read outside of the loop,
> that way you'll have the best of all cases, a single LOCK'ed op in the
> loop, and only a single LOCK'ed op for the fast path on sensible
> architectures ;-)
> 
>     last = atomic64_read(&last_value);
isn't a barrier enough here?


