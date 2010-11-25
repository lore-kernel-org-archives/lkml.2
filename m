Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0KYOxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:53:07 -0500
Received: from smtp-out.google.com ([74.125.121.35]:6296 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0KYOxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xxpa3A+OyuAiu27uSTM4GlzgFVnwQeV/RENjmQixoEm50IylC3nJvkaJFvMuoZsy3X
         U6Yp72MSIpGs2pFJZpEQ==
MIME-Version: 1.0
In-Reply-To: <1290684033.2145.25.camel@laptop>
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
	<1290684033.2145.25.camel@laptop>
Date: Thu, 25 Nov 2010 15:53:00 +0100
Message-ID: <AANLkTim23nB7gL_wfanxGjJBHvE-7VpSjQ4wU4cQ_fG3@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, 2010-11-18 at 12:40 +0200, Stephane Eranian wrote:
> > @@ -919,6 +945,10 @@ static inline void perf_event_task_sched_in(struct task_struct *task)
> >  static inline
> >  void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
> >  {
> > +#ifdef CONFIG_CGROUPS
> > +       atomic_t *cgroup_events = &__get_cpu_var(perf_cgroup_events);
> > +       COND_STMT(cgroup_events, perf_cgroup_switch(task, next));
> > +#endif
> >         COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
> >  }
>
> I don't think that'll actually work, the jump label stuff needs a static
> address.
>

I did not know that.

> Why not simply: s/perf_task_events/perf_sched_events/ and increment it
> for cgroup events as well?
>

But you would need to demultiplex. that's not because perf_sched_events is
set that you want BOTH perf_cgroup_switch() AND perf_event_task_sched_out().
Cgroup mode is per-cpu only.
