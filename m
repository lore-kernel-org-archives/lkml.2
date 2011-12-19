Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1LSLmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:42:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1LSLme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:42:34 -0500
Date: Mon, 19 Dec 2011 12:40:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111219114023.GB29855@elte.hu>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF1C3B.3010307@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 12/19/2011 12:54 PM, Ingo Molnar wrote:
> > * Robert Richter <robert.richter@amd.com> wrote:
> >
> > > On 19.12.11 00:43:10, Ingo Molnar wrote:
> > >
> > > > So the question becomes, how well is it integrated: can perf 
> > > > 'record -a + perf report', or 'perf top' use LWP, to do 
> > > > system-wide precise [user-space] profiling and such?
> > > 
> > > There is only self-monitoring of a process possible, no 
> > > kernel and system-wide profiling. This is because we can 
> > > not allocate memory regions in the kernel for a thread 
> > > other than the current. This would require a complete 
> > > rework of mm code.
> >
> > Hm, i don't think a rework is needed: check the 
> > vmalloc_to_page() code in kernel/events/ring_buffer.c. Right 
> > now CONFIG_PERF_USE_VMALLOC is an ARM, MIPS, SH and Sparc 
> > specific feature, on x86 it turns on if 
> > CONFIG_DEBUG_PERF_USE_VMALLOC=y.
> >
> > That should be good enough for prototyping the kernel/user 
> > shared buffering approach.
> 
> LWP wants user memory, vmalloc is insufficient.  You need 
> do_mmap() with a different mm.

Take a look at PERF_USE_VMALLOC, it allows in-kernel allocated 
memory to be mmap()ed to user-space. It is basically a 
shared/dual user/kernel mode vmalloc implementation.

So all the conceptual pieces are there.

> You could let a workqueue call use_mm() and then do_mmap().  
> Even then it is subject to disruption by the monitored thread 
> (and may disrupt the monitored thread by playing with its 
> address space). [...]

Injecting this into another thread's context is indeed advanced 
stuff:

> [...] This is for thread monitoring only, I don't think 
> system-wide monitoring is possible with LWP.

That should be possible too, via two methods:

1) the easy hack: a (per cpu) vmalloc()ed buffer is made ring 3 
   accessible (by clearing the system bit in the ptes) - and 
   thus accessible to all user-space.

   This is obviously globally writable/readable memory so only a 
   debugging/prototyping hack - but would be a great first step 
   to prove the concept and see some nice perf top and perf 
   record results ...

2) the proper solution: creating a 'user-space vmalloc()' that 
   is per mm and that gets inherited transparently, across 
   fork() and exec(), and which lies outside the regular vma
   spaces. On 64-bit this should be straightforward.

   These vmas are not actually 'known' to user-space normally -
   the kernel PMU code knows about it and does what we do with
   PEBS: flushes it when necessary and puts it into the
   regular perf event channels.

   This solves the inherited perf record workflow immediately:
   the parent task just creates the buffer, which gets inherited 
   across exec() and fork(), into every portion of the workload.

   System-wide profiling is a small additional variant of this: 
   creating such a user-vmalloc() area for all tasks in the
   system so that the PMU code has them ready in the 
   context-switch code.

Solution #2 has the additional advantage that we could migrate 
PEBS to it and could allow interested user-space access to the 
'raw' PEBS buffer as well. (currently the PEBS buffer is only 
visible to kernel-space.)

I'd suggest the easy hack first, to get things going - we can 
then help out with the proper solution.

Thanks,

	Ingo

