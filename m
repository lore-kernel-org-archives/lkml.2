Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0IISLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0IISK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:10:56 -0400
Date: Thu, 9 Sep 2010 20:10:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] trace: funcgraph tracer - adding funcgraph-irq option
Message-ID: <20100909181046.GB1963@jolsa.brq.redhat.com>
References: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
 <1279828821.3319.23.camel@gandalf.stny.rr.com>
 <20100723131913.GB1829@jolsa.brq.redhat.com>
 <1283876920.5133.125.camel@gandalf.stny.rr.com>
 <20100909144430.GG20955@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909144430.GG20955@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 04:44:30PM +0200, Johannes Weiner wrote:
> Hi Guys,
> 
> On Tue, Sep 07, 2010 at 12:28:40PM -0400, Steven Rostedt wrote:
> > On Fri, 2010-07-23 at 15:19 +0200, Jiri Olsa wrote:
> > > On Thu, Jul 22, 2010 at 04:00:21PM -0400, Steven Rostedt wrote:
> > > > On Mon, 2010-07-12 at 18:21 +0200, Jiri Olsa wrote:
> > > > 
> > > SNIP
> > > 
> > > > 
> > > > What happens if we lose the return event? That is, due to buffer
> > > > overruns, the return of the trace is lost. Then we lose out on all
> > > > events until another event of the same IRQ happens and its return is not
> > > > lost.
> > > > 
> > > > You should save the depth instead of the function. When you are in a
> > > > interrupt, record the depth. Then when the depth is less than or equal
> > > > to the recorded depth you can restart printing. This may still suffer
> > > > from missed returns, but it would not have as much of a consequence when
> > > > it happens.
> > > hi,
> > > you're right, changed patch is attached
> > > 
> > > thanks,
> > > jirka
> > > 
> > > ---
> > > Adding funcgraph-irq option for function graph tracer.
> > > 
> > > It's handy to be able to disable the irq related output
> > > and not to have to jump over each irq related code, when
> > > you have no interrest in it.
> 
> Although greatly reduced, I still see the following noise in the trace
> output with the IRQ filtering enabled:
> 
>  1)               |    wakeup_flusher_threads() {
>  1)   0.205 us    |      __rcu_read_lock();
>  1)   0.271 us    |      bdi_has_dirty_io();
>  1)   0.287 us    |      bdi_has_dirty_io();
>  1)   0.217 us    |      bdi_has_dirty_io();
>  1)               |      bdi_has_dirty_io() {
>  1)               |        smp_invalidate_interrupt() {
>  1)   0.220 us    |          native_apic_mem_write();
>  1)   0.794 us    |        } /* smp_invalidate_interrupt */
>  1)   1.413 us    |      } /* bdi_has_dirty_io */
>  1)   0.218 us    |      bdi_has_dirty_io();
>  1)   0.213 us    |      bdi_has_dirty_io();
>  1)   0.215 us    |      bdi_has_dirty_io();
>  1)               |      smp_invalidate_interrupt() {
>  1)   0.234 us    |        native_apic_mem_write();
>  1)   0.819 us    |      } /* smp_invalidate_interrupt */
>  1)   0.240 us    |      bdi_has_dirty_io();
>  1)   0.259 us    |      bdi_has_dirty_io();
>
hi,

both smp_invalidate_interrupt and native_apic_mem_write are not put
into __irqentry_text code location, so the logic misses them.

I'm not sure how such functions could be caught besides function
pointer check..

It looks like smp_invalidate_interrupt is used for TLB mainating,
which I know nothing about.. :) anyone knows wether it would make
sense to put those function to __irqentry_text area?

thanks,
jirka
