Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2EXMR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab2EXMRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:17:24 -0400
Date: Thu, 24 May 2012 14:16:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 04/16] perf: Add ability to attach user stack dump to
 sample
Message-ID: <20120524121657.GC1775@m.brq.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
 <1337801535-12865-5-git-send-email-jolsa@redhat.com>
 <1337856680.9783.111.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337856680.9783.111.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:51:20PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> > +static void

SNIP

> > +               /* What couldn't be dumped is zero padded */
> > +               while (rem--) {
> > +                       char zero = 0;
> > +                       perf_output_put(handle, zero);
> > +               }
> 
> Does this matter? If we don't write it the worst that can happen is that
> we leave previous ring-bugger content around, but since we already are
> privileged to read that (and very likely already have) there's no
> problem with that..
> 
> I know not zero-ing is ugly, but its also faster.. and do we care about
> them silly zeros?
hm, I dont think we care.. seems like this can go out


> > +       if (sample_type & PERF_SAMPLE_STACK) {
> > +               u64 mode = event->attr.sample_stack;
> > +
> > +               if (mode & PERF_SAMPLE_STACK_USER) {
> > +                       u64 dump_size = event->attr.sample_stack_user;
> > +
> > +                       perf_output_sample_ustack(handle, dump_size,
> > +                                                 data->regs_user);
> 
> OK, so that function is called _ustack() I read that as userstack, so
> why this strange split up?
ook


> 
> > +               }
> > +       }
> >  }
> >  
> >  void perf_prepare_sample(struct perf_event_header *header,
> > @@ -4135,6 +4185,39 @@ void perf_prepare_sample(struct perf_event_header *header,
> >  
> >                 header->size += size;
> >         }
> > +
> > +       if (sample_type & PERF_SAMPLE_STACK) {
> > +               u64 mode = event->attr.sample_stack;
> > +               int size = 0;
> > +
> > +               if (mode & PERF_SAMPLE_STACK_USER) {
> 
> This is very much similar to ->sample_stack_user, since a non-zero size
> usually means you want something.

ok, same case as for the regs bitmask stuf then..
we can use the size to check the presence in sample

> 
> > +                       if (!data->regs_user)
> > +                               data->regs_user = perf_sample_regs_user(regs);
> > +
> > +                       /*
> > +                        * A first field that tells the _static_ size of the
> > +                        * dump. 0 if there is nothing to dump (ie: we are in
> > +                        * a kernel thread) otherwise the requested size.
> > +                        */
> > +                       size += sizeof(u64);
> > +
> > +                       /*
> > +                        * If there is something to dump, add space for the
> > +                        * dump itself and for the field that tells the
> > +                        * dynamic size, which is how many have been actually
> > +                        * dumped. What couldn't be dumped will be zero-padded.
> > +                        */
> > +                       if (data->regs_user) {
> > +                               u64 user_size = event->attr.sample_stack_user;
> > +
> > +                               user_size = round_up(user_size, sizeof(u64));
> 
> Right, and here we go again.. so how about you either reject sizes that
> aren't properly aligned in perf_copy_attr() or just fix it up there.

right, we can do that in the attr check
