Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab0FPRn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:43:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab0FPRn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:43:56 -0400
Subject: Re: [RFC] perf/perf_events: misleading number of samples due to 
 mmap()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTim1yFwS5g-s_2fMRHljjf5yMouoHb2Ulqj6V1AC@mail.gmail.com>
References: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
	 <1276699962.1745.599.camel@laptop>
	 <AANLkTim1yFwS5g-s_2fMRHljjf5yMouoHb2Ulqj6V1AC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 19:43:34 +0200
Message-ID: <1276710214.1745.604.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 18:41 +0200, stephane eranian wrote:
> On Wed, Jun 16, 2010 at 4:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-06-16 at 16:40 +0200, Stephane Eranian wrote:
> >> This leads me to another point. For per-thread sampling, why
> >> do we need to record mmap() events happening *outside* of
> >> the process? I can understand the exception of kernel modules.
> >
> > How does that happen? The per-thread events should be on the per-task
> > context, so another task's mmap() events should never end up there.
> >
> 
> I don't see the test that says the vma does not belong to the current task.
> I also don't see anything in perf_event_mmap_match().
> 
> It does seem to work as you said in recent kernels, though. So I am certainly
> missing something here.

vma's are always part of the current task, its impossible to call mmap()
on another process's address space.

Look at the tail of perf_event_mmap_event(), it does:

        rcu_read_lock();
        cpuctx = &get_cpu_var(perf_cpu_context);
        perf_event_mmap_ctx(&cpuctx->ctx, mmap_event, vma->vm_flags & VM_EXEC);
        ctx = rcu_dereference(current->perf_event_ctxp);
        if (ctx)
                perf_event_mmap_ctx(ctx, mmap_event, vma->vm_flags & VM_EXEC);
        put_cpu_var(perf_cpu_context);
        rcu_read_unlock();

There it traverses the per-cpu context and the per-task context.


