Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2JDKjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab2JDKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:39:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATH 0/2] perf: x86_64 rsp related changes
Date: Thu,  4 Oct 2012 12:38:43 +0200
Message-Id: <1349347125-5770-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20121003133007.GD945@krava.brq.redhat.com>
References: <20121003133007.GD945@krava.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 03:30:07PM +0200, Jiri Olsa wrote:
> On Wed, Oct 03, 2012 at 03:22:17PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-10-03 at 15:13 +0200, Jiri Olsa wrote:
> > > @@ -1190,8 +1191,8 @@ static inline void perf_sample_data_init(struct
> > > perf_sample_data *data,
> > >         data->raw  = NULL;
> > >         data->br_stack = NULL;
> > >         data->period = period;
> > > -       data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
> > > -       data->regs_user.regs = NULL;
> > > +       /* Sets abi to PERF_SAMPLE_REGS_ABI_NONE. */
> > > +       memset(&data->regs_user, 0, sizeof(data->regs_user));
> > >         data->stack_user_size = 0;
> > >  } 
> > 
> > Hmm, this will slow down all events, regardless of whether they use any
> > of that stuff or not. Since the one user actually does something like:
> > 
> >   data->regs_user = *pt_regs;
> > 
> > except it does a memcpy() for some obscure reason, it really doesn't
> > matter what is in there when uninitialized, right?
> 
> right, the init can stay as it was
> 
> jirka

I made the change and I split it into 2 patches,
should be more readable

  1/2 perf x86_64: Fix rsp register for system call fast path
  2/2 perf: Simplify the sample's user regs/stack retrieval

thanks,
jirka

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   37 +++++++++++++++++++
 include/linux/perf_event.h       |    1 +
 kernel/events/core.c             |   74 ++++++++++++++++++++------------------
 3 files changed, 77 insertions(+), 35 deletions(-)
