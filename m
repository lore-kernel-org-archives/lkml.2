Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1BQPVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:21:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab1BQPVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:21:34 -0500
Date: Thu, 17 Feb 2011 16:20:58 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, ananth@in.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
Message-ID: <20110217152058.GB1952@jolsa.brq.redhat.com>
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
 <4D5A4A66.4010503@hitachi.com>
 <20110215123058.GB3135@jolsa.brq.redhat.com>
 <4D5AA209.7070309@hitachi.com>
 <20110215170507.GD3135@jolsa.brq.redhat.com>
 <4D5B4654.30407@hitachi.com>
 <20110217151103.GA11156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217151103.GA11156@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:11:03PM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > (2011/02/16 2:05), Jiri Olsa wrote:
> > > You can crash the kernel using kprobe tracer by running:
> > > 
> > > echo "p system_call_after_swapgs" > ./kprobe_events
> > > echo 1 > ./events/kprobes/enable
> > > 
> > > The reason is that at the system_call_after_swapgs label, the kernel
> > > stack is not set up. If optimized kprobes are enabled, the user space
> > > stack is being used in this case (see optimized kprobe template) and
> > > this might result in a crash.
> > > 
> > > There are several places like this over the entry code (entry_$BIT).
> > > As it seems there's no any reasonable/maintainable way to disable only
> > > those places where the stack is not ready, I switched off the whole
> > > entry code from kprobe optimizing.
> > 
> > Agreed, and this could be the best way, because kprobes can not
> > know where the kernel stack is ready without this text section.
> 
> The only worry would be that if we move the syscall entry code out of the regular 
> text section fragments the icache layout a tiny bit, possibly hurting performance.
> 
> It's probably not measurable, but we need to measure it:
> 
> Testing could be done of some syscall but also cache-intense workload, like 
> 'hackbench 10', via perf 'stat --repeat 30' and have a very close look at 
> instruction cache eviction differences.
> 
> Perhaps also explicitly enable measure one of these:
> 
>   L1-icache-loads                            [Hardware cache event]
>   L1-icache-load-misses                      [Hardware cache event]
>   L1-icache-prefetches                       [Hardware cache event]
>   L1-icache-prefetch-misses                  [Hardware cache event]
> 
>   iTLB-loads                                 [Hardware cache event]
>   iTLB-load-misses                           [Hardware cache event]
> 
> to see whether there's any statistically significant difference in icache/iTLB 
> evictions, with and without the patch.
> 
> If such stats are included in the changelog - even if just to show that any change 
> is within measurement accuracy, it would make it easier to apply this change.

ok, I'll run it 

thanks,
jirka
