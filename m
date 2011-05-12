Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1ELOb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:31:59 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53913 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1ELOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G6W7TuMCq0b3X9q7lQNiz+FlXYJ1ZuiAGjAywD+sLLebqEJhh97oM5FkXVsMD3ZSmt
         yFcWVmwsOxGKlwrizzVCepH60ioKnfPt2ooepaCtY3ELfAU+lerAUW/4eIfpvMYaTcsb
         1ke6EgNVyG4BzEu5vU89PgHxd3i6/ZOb1TFb8=
Date: Thu, 12 May 2011 16:31:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110512143148.GB7410@nowhere>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
 <20110511143149.GA26548@aftab>
 <20110511152156.GA21707@elte.hu>
 <20110511170912.GA27362@aftab>
 <1305190277.2914.259.camel@laptop>
 <20110512101839.GA17731@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512101839.GA17731@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:18:39PM +0200, Borislav Petkov wrote:
> On Thu, May 12, 2011 at 04:51:17AM -0400, Peter Zijlstra wrote:
> > On Wed, 2011-05-11 at 19:09 +0200, Borislav Petkov wrote:
> > 
> > I can't really say I like this move stuff into perf_event.h and then
> > move it out again dance. Makes it exceedingly hard for me to tell wth
> > actually happened.
> > 
> > >  include/linux/perf_event.h |  132 --------------------------------------------
> > 
> > Compared with:
> > 
> >  include/linux/perf_event.h |  126 +++++++++++-
> >  include/linux/perf_event.h |    7 +-
> > 
> > Its very hard to tell if this undoes the exact damage you did earlier.
> 
> The right thing to do would be to redo the patches again with internal.h
> in mind.
> 
> > >  kernel/events/callchain.c  |    3 +
> > >  kernel/events/cgroup.c     |    2 +
> > >  kernel/events/core.c       |    2 +
> > >  kernel/events/internal.h   |  129 +++++++++++++++++++++++++++++++++++++++++++
> > >  5 files changed, 136 insertions(+), 132 deletions(-)
> > >  create mode 100644 kernel/events/internal.h
> > > 
> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > > index 7978850..6b25452 100644
> > > --- a/include/linux/perf_event.h
> > > +++ b/include/linux/perf_event.h
> > > @@ -963,7 +963,6 @@ enum event_type_t {
> > >  #ifdef CONFIG_PERF_EVENTS
> > >  extern struct list_head pmus;
> > >  extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
> > > -extern void perf_pmu_unregister(struct pmu *pmu);
> > 
> > That just doesn't make any sense. If we publish one side of the API we
> > should also publish the other side.
> 
> Fair enough. It was unused, therefore I removed it.
> 
> > >  extern int perf_num_counters(void);
> > >  extern const char *perf_pmu_name(void);
> > > @@ -985,8 +984,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
> > >                                 int cpu,
> > >                                 struct task_struct *task,
> > >                                 perf_overflow_handler_t callback);
> > > -extern u64 perf_event_read_value(struct perf_event *event,
> > > -                                u64 *enabled, u64 *running);
> > 
> > While not used, that is a valid part of the API.
> 
> Yep, ditto.
> 
> > >  
> > >  struct perf_sample_data {
> > >         u64                             type;
> > > @@ -1152,60 +1149,10 @@ extern int perf_output_begin(struct perf_output_handle *handle,
> > >                              struct perf_event *event, unsigned int size,
> > >                              int nmi, int sample);
> > >  extern void perf_output_end(struct perf_output_handle *handle);
> > > -extern void perf_output_copy(struct perf_output_handle *handle,
> > > -                            const void *buf, unsigned int len);
> > 
> > idem
> > 
> > >  extern int perf_swevent_get_recursion_context(void);
> > > -extern void perf_swevent_put_recursion_context(int rctx);
> > 
> > Again, creating asymmetry. 
> 
> Ok, I won't be able to redo the patches before Mo. due to travel. Also,
> I think that you should do the splitting, as I suggested so at the
> beginning!

I can take it if you want. I'm currently splitting the buffer
part so I can try to relay the rest as well :)
