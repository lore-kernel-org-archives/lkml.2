Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1FINRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:17:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab1FINRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:17:38 -0400
Date: Thu, 9 Jun 2011 15:17:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf update
Message-ID: <20110609131732.GA21100@elte.hu>
References: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
 <1307610813.3941.23.camel@twins>
 <20110609091924.GA8188@elte.hu>
 <20110609114313.GA15332@elte.hu>
 <20110609123519.GF25771@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609123519.GF25771@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jun 09, 2011 at 01:43:13PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > On Tue, 2011-06-07 at 16:56 +0200, Frederic Weisbecker wrote:
> > > > 
> > > > > Frederic Weisbecker (1):
> > > > >       perf: Split up buffer handling from core code
> > > > > 
> > > > > 
> > > > >  kernel/events/Makefile   |    2 +-
> > > > >  kernel/events/buffer.c   |  400 ++++++++++++++++++++++++++++++++++++++++
> > > > >  kernel/events/core.c     |  458 ++--------------------------------------------
> > > > >  kernel/events/internal.h |   70 +++++++
> > > > >  4 files changed, 487 insertions(+), 443 deletions(-)
> > > > 
> > > > Looks about right.
> > > > 
> > > > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 
> > > thanks, i'll pull it it and test it.
> > 
> > Note, i ended up applying it by hand:
> > 
> >  - fixed a build error,
> > 
> >  - streamlined the renaming: we really want this to be ring_buffer.c 
> >    (most of the complexity comes from this not being a simple buffer 
> >    but a ring-buffer)
> > 
> >  - i streamlined the naming around it: struct ring_buffer 
> >    internalized via internal.h (it does not clash with ftrace's 
> >    ring-buffer)
> > 
> > It all looks and reads much nicer now, but please double check the 
> > commit as well :-)
> > 
> > One other rename i'd like to do is:
> > 
> >    struct perf_output_handle		=> struct rb_handle
> > 
> >    perf_output_begin()			=> rb_open()
> >    perf_output_copy()			=> rb_write()
> >    perf_output_sample()			=> rb_write_sample()
> >    perf_output_end()			=> rb_close()
> > 
> > Which really makes it a lot more apparent that it's a regular 
> > input/output flow defined over the ring-buffer!
> > 
> > I can do this if this is fine with everyone. There will be no change 
> > in functionality.
> 
> I feel more comfortable if we keep the perf_outpout_*() naming, having some
> global rb_* would pollute the global namespace.

Hm, using the rb_ prefix is not good due to the (conceptual) clash 
with rbtree.h primitives.

> perf_rb_* namespace would be fine as well.

How about:

    struct perf_output_handle		=> struct ring_buffer_handle
 
    perf_output_begin()			=> ring_buffer_open()
    perf_output_copy()			=> ring_buffer_write()
    perf_output_sample()		=> ring_buffer_write_sample()
    perf_output_end()			=> ring_buffer_close()

?

It doesn't clash with existing names.

Thanks,

	Ingo
