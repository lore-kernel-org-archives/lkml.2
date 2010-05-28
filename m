Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0E1SHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:07:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0E1SHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:07:19 -0400
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100528155719.GA10141@kryptos.osrc.amd.com>
References: <1274554806-28216-2-git-send-email-bp@alien8.de>
	 <1274638513.1674.1727.camel@laptop> <20100523183353.GB1408@liondog.tnic>
	 <1274640047.1674.1731.camel@laptop> <20100523185411.GA5608@liondog.tnic>
	 <1274642601.1674.1755.camel@laptop> <20100525073246.GA6085@liondog.tnic>
	 <1274799588.5882.1572.camel@twins> <20100528143311.GB9710@elte.hu>
	 <1275059860.27810.9635.camel@twins>
	 <20100528155719.GA10141@kryptos.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 20:07:10 +0200
Message-ID: <1275070030.1645.362.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 17:57 +0200, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, May 28, 2010 at 05:17:40PM +0200
> 
> > On Fri, 2010-05-28 at 16:33 +0200, Ingo Molnar wrote:
> > 
> > > >  2) get these things a buffer, perf_events as created don't actually
> > > >     have an output buffer, normally that is created at mmap() time, but
> > > >     since you cannot mmap() a kernel side event, it doesn't get to have
> > > >     a buffer. This could be done by extracting perf_mmap_data_alloc()
> > > >     into a sensible interface.
> > > 
> > > #2 could be a new syscall: sys_create_ring_buffer or so?
> > 
> > No, they need a buffer in-kernel, syscalls aren't the ideal tool for
> > that :-)
> 
> Yeah, I need a per-cpu buffer ready at event registration/enable time,
> maybe even have perf_event_create_kernel_counter() take care of that
> buffer allocation with a flag or similar prior to enabling the event...
> 
> > I've got patches refactoring the whole buffer stuff to make it more a
> > self-contained entity.
> 
> Can I see those when you're done so that I can base my stuff on top?


They can be found at:

http://programming.kicks-ass.net/sekrit/patches.tar.bz2

ignore the last 5 patches, those are random hackery.

In particular, look at:

patches/perf-fix-buffer-redirect.patch
patches/perf-buffer.patch
patches/perf-buffer-init.patch

(they won't apply separately in that order, simply push the full queue
until the last one or further)

After that you should be able to add:

  buffer = perf_buffer_alloc(nr_pages, watermark, cpu, flags);
  rcu_assign_pointer(event->buffer, buffer);

to allocate and attach a buffer to your event (do so for each cpu's MCE
event).

After that we still need a way to expose all that to userspace, but at
least the events will be complete and able to record bits ;-)



