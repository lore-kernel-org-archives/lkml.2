Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab1FWOqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:46:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:35857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1FWOq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:46:29 -0400
Subject: Re: [PATCH] events: Ensure that timers are updated without
 requiring read() call
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110623143853.GA5033@mgebm.net>
References: <1308838537-6682-1-git-send-email-emunson@mgebm.net>
	 <1308839150.1022.130.camel@twins>  <20110623143853.GA5033@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 16:45:37 +0200
Message-ID: <1308840337.1022.132.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 10:38 -0400, Eric B Munson wrote:
> On Thu, 23 Jun 2011, Peter Zijlstra wrote:
> 
> > On Thu, 2011-06-23 at 10:15 -0400, Eric B Munson wrote:
> > > The event tracing infrastructure exposes two timers which should be updated
> > > each time the value of the counter is updated.  Currently, these counters are
> > > only updated when userspace calls read() on the fd associated with an event.
> > > This means that counters which are read via the mmap'd page exclusively never
> > > have their timers updated.  This patch adds ensures that the timers are updated
> > > each time the values in the mmap'd page are updated.
> > > 
> > > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > > ---
> > >  kernel/events/core.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index 9efe710..3dd4ebe 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -3369,6 +3369,7 @@ void perf_event_update_userpage(struct perf_event *event)
> > >  	struct perf_buffer *buffer;
> > >  
> > >  	rcu_read_lock();
> > > +	update_event_times(event);
> > >  	buffer = rcu_dereference(event->buffer);
> > >  	if (!buffer)
> > >  		goto unlock;
> > 
> > Not that easy, perf_event_update_userpage() can happen from NMI context,
> > and update_event_times() needs to be done under ctx->lock.
> > 
> 
> I was afraid that might be the case, is there an easy-ish way to accomplish
> the timer update?

IIRC Stephane did something along these lines, he kept a stamp and then
computed a delta in NMI context using perf_clock(). Let me try and find
where that lives.

See perf_output_read().
