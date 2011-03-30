Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1C3PlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:41:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1C3PlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:41:24 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110330153228.GA1787@redhat.com>
References: <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com>
	 <20110330130951.GA2124@jolsa.brq.redhat.com>
	 <20110330153228.GA1787@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 17:40:52 +0200
Message-ID: <1301499652.4859.193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 17:32 +0200, Oleg Nesterov wrote:
> > +#ifdef HAVE_JUMP_LABEL
> > +static inline
> > +void perf_sched_events_inc(void)
> > +{
> > +     jump_label_inc(&perf_sched_events_out);
> > +     smp_mb__after_atomic_inc();
> > +     jump_label_inc(&perf_sched_events_in);
> > +}
> > +
> > +static inline
> > +void perf_sched_events_dec(void)
> > +{
> > +     if (atomic_dec_and_test(&perf_sched_events_in)) {
> > +             jump_label_disable(&perf_sched_events_in);
> > +             synchronize_sched();
> > +     }
> > +
> > +     jump_label_dec(&perf_sched_events_out);
> 
> probably smp_mb__after_atomic_inc() needs a comment...

You don't need it, jump_label_inc() uses atomic_add_return() which
implies a full mb.
