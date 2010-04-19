Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0DSK4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:56:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0DSK4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:56:19 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BCC34DF.6030702@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BCA026D.3070309@redhat.com>  <4BCA02D1.2020608@redhat.com>
	 <1271673836.1674.757.camel@laptop>  <4BCC34DF.6030702@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 12:56:15 +0200
Message-ID: <1271674575.1674.793.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 13:47 +0300, Avi Kivity wrote:
> On 04/19/2010 01:43 PM, Peter Zijlstra wrote:
> >
> >>>
> >>>> +
> >>>>    cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
> >>>>    {
> >>>>        struct pvclock_shadow_time shadow;
> >>>>        unsigned version;
> >>>>        cycle_t ret, offset;
> >>>> +    u64 last;
> >>>>
> >>>>
> >>>> +    do {
> >>>> +        last = last_value;
> >>>>          
> >>> Otherwise, this assignment can see a partial update.
> >>>        
> >> On a 32-bit guest, that is.
> >>      
> > Right, do bear in mind that the x86 implementation of atomic64_read() is
> > terrifyingly expensive, it is better to not do that read and simply use
> > the result of the cmpxchg.
> >
> >    
> 
> atomic64_read() _is_ cmpxchg64b.  Are you thinking of some clever 
> implementation for smp i386?


No, what I was suggesting was to rewrite that loop no to need the
initial read but use the cmpxchg result of the previous iteration.

Something like:

  u64 last = 0;

  /* more stuff */
 
  do {
    if (ret < last)
      return last;
    last = cmpxchg64(&last_value, last, ret);
  } while (last != ret);

That only has a single cmpxchg8 in there per loop instead of two
(avoiding the atomic64_read() one).

