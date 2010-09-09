Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0IIOoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:44:37 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:53186 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0IIOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:44:35 -0400
Date: Thu, 9 Sep 2010 16:44:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] trace: funcgraph tracer - adding funcgraph-irq option
Message-ID: <20100909144430.GG20955@cmpxchg.org>
References: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
 <1279828821.3319.23.camel@gandalf.stny.rr.com>
 <20100723131913.GB1829@jolsa.brq.redhat.com>
 <1283876920.5133.125.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283876920.5133.125.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

On Tue, Sep 07, 2010 at 12:28:40PM -0400, Steven Rostedt wrote:
> On Fri, 2010-07-23 at 15:19 +0200, Jiri Olsa wrote:
> > On Thu, Jul 22, 2010 at 04:00:21PM -0400, Steven Rostedt wrote:
> > > On Mon, 2010-07-12 at 18:21 +0200, Jiri Olsa wrote:
> > > 
> > SNIP
> > 
> > > 
> > > What happens if we lose the return event? That is, due to buffer
> > > overruns, the return of the trace is lost. Then we lose out on all
> > > events until another event of the same IRQ happens and its return is not
> > > lost.
> > > 
> > > You should save the depth instead of the function. When you are in a
> > > interrupt, record the depth. Then when the depth is less than or equal
> > > to the recorded depth you can restart printing. This may still suffer
> > > from missed returns, but it would not have as much of a consequence when
> > > it happens.
> > hi,
> > you're right, changed patch is attached
> > 
> > thanks,
> > jirka
> > 
> > ---
> > Adding funcgraph-irq option for function graph tracer.
> > 
> > It's handy to be able to disable the irq related output
> > and not to have to jump over each irq related code, when
> > you have no interrest in it.

Although greatly reduced, I still see the following noise in the trace
output with the IRQ filtering enabled:

 1)               |    wakeup_flusher_threads() {
 1)   0.205 us    |      __rcu_read_lock();
 1)   0.271 us    |      bdi_has_dirty_io();
 1)   0.287 us    |      bdi_has_dirty_io();
 1)   0.217 us    |      bdi_has_dirty_io();
 1)               |      bdi_has_dirty_io() {
 1)               |        smp_invalidate_interrupt() {
 1)   0.220 us    |          native_apic_mem_write();
 1)   0.794 us    |        } /* smp_invalidate_interrupt */
 1)   1.413 us    |      } /* bdi_has_dirty_io */
 1)   0.218 us    |      bdi_has_dirty_io();
 1)   0.213 us    |      bdi_has_dirty_io();
 1)   0.215 us    |      bdi_has_dirty_io();
 1)               |      smp_invalidate_interrupt() {
 1)   0.234 us    |        native_apic_mem_write();
 1)   0.819 us    |      } /* smp_invalidate_interrupt */
 1)   0.240 us    |      bdi_has_dirty_io();
 1)   0.259 us    |      bdi_has_dirty_io();

