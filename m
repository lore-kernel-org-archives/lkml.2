Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650Ab2ILOsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:48:31 -0400
Received: from [205.233.59.134] ([205.233.59.134]:33567 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab2ILOs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:48:28 -0400
Message-ID: <1347461232.15764.45.camel@twins>
Subject: Re: [BUG] perf: multiplexing and hotplug CPU problem
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 12 Sep 2012 16:47:12 +0200
In-Reply-To: <CABPqkBSemt4hsoFfGkm3pac+R+aUJ6Kd9LBTWM-JtKMOF4VM9Q@mail.gmail.com>
References: <CABPqkBSemt4hsoFfGkm3pac+R+aUJ6Kd9LBTWM-JtKMOF4VM9Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:40 +0200, Stephane Eranian wrote:
> Hi,
> 
> As I was debugging my hrtimer patch, I ran a few tests
> with hotplug CPU. In others words, I offline a CPU while
> there is an active monitoring session which causes multiplexing.
> 
> When the CPU goes down, all is well. But when it comes back,
> things go wrong. No kernel crashes but wrong results and multiplexing
> does not work anymore.
> 
> I investigated this some more and found out there is an issue
> on re-activation.
> 
> During shutdown, system-wide events are scheduled out AND removed
> from the event lists. Consequently, ctx->nr_events and ctx->nr_active
> go to zero.
> 
> When the CPU is brought back online and tools do start/stop on the events
> they can be scheduled back in, and therefore increment ctx->nr_active.
> Because list_add_event() is not called again, you may end up with
> ctx->nr_events < ctx->nr_active which is wrong. Events may not
> be a lists and therefore they cannot get multiplexed again.
> 
> It is not clear to me why we need to remove the events from any
> list (list_del_event) when the CPU goes down.
> 
> Why isn't calling event_sched_out() enough?
> If events are kept on lists, why not try to schedule them back in when
> the CPU is brought back online?

This might be never, I think we should put the events in error state
instead of disabling them, that should avoid the re-activation and
provide a stronger hint to userspace that something went funny.
