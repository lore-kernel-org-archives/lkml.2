Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1ERIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:16:57 -0400
Received: from 8bytes.org ([88.198.83.132]:55513 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1ERIQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:16:55 -0400
Date: Wed, 18 May 2011 10:16:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling,
	LWP support
Message-ID: <20110518081653.GA23407@8bytes.org>
References: <4D91FA76.1010908@zytor.com> <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com> <20110407072305.GA20291@elte.hu> <20110516191012.GA575@escobedo.osrc.amd.com> <20110517113020.GA13475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517113020.GA13475@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

thanks for your thoughts on this. I have some comments below.

On Tue, May 17, 2011 at 01:30:20PM +0200, Ingo Molnar wrote:

> - Where is the hardware interrupt that signals the ring-buffer-full condition
>   exposed to user-space and how can user-space wait for ring buffer events?
>   AFAICS this needs to set the LWP_CFG MSR and needs an irq handler, which 
>   needs kernel side support - but that is not included in these patches.
> 
>   The way we solved this with Intel's BTS (and PEBS) feature is that there's
>   a per task hardware buffer that is coupled with the event ring buffer, so
>   both setup and 'waiting' for the ring-buffer happens automatically and
>   transparently because tools can already wait on the ring-buffer.
> 
>   Considerable effort went into that model on the Intel side before we merged
>   it and i see no reason why an AMD hw-tracing feature should not have this 
>   too...
> 
>   [ If that is implemented we can expose LWP to user-space as well (which can
>     choose to utilize it directly and buffer into its own memory area without 
>     irqs and using polling, but i'd generally discourage such crude event 
>     collection methods). ]

If I understand this correctly you suggest to propagate the lwp-events
through perf into user-space. This is certainly good because it provides
a unified interface, but it somewhat elimitates the 'lightweight' part
of LWP because the samples need to be read by the kernel from user-space
memory (the lwp-ring-buffer needs to be in user-space memory), convert
it to perf-samples, and copy it back to user-space. The benefit is the
unified interface but the 'lightweight' and low-impact part vanishes to
some degree.

Also, LWP is somewhat different from the old-style PMU. LWP is designed
for self-monitoring of applications that want to optimize themself at
runtime, like JIT compilers (Java, LVMM, ...) or databases. For those
applications it would be good to keep LWP as lightweight as possible.

The missing support for interupts is certainly a problem here which
significantly limits the usefulness of the feature for now. My idea was
to expose the interupt-event through perf to user-space so that the
application can wait on that event to read out the LWP ring-buffer.

But to come back to your idea, it probably could be done in a way to
enable profiling of other applications using LWP. The kernel needs to
allocate the lwp ring-buffer and setup lwp itself. The problem is that
the buffer needs to be user-accessible and where to map this buffer:

	a) On the kernel-part of the address space. Problematic because
	   every process can read the buffer of other tasks. So this is
	   a no-go from a security point-of-view.

	b) Change the address space layout in a comatible way to allow
	   the kernel to map it (e.g. make a small part of the
	   kernel-address space per-process). Somewhat intrusive to
	   current x86 code, also not sure this feature is worth it.

	c) Some way to let userspace setup such a buffer and give the
	   address to the kernel, or we mmap it directly into user
	   address space. But that may cause other problems with
	   applications that have strict requirements for their
	   address-space layout.

Bottom-line is, we need a good and secure way to setup a user-accessible
buffer per-process in the kernel. If we have that we can use LWP to
monitor other applications (unless the application decides to use LWP of
its own).

I like the idea, but we should also make sure that we don't prevent the
low-impact self-monitoring use-case for applications that want it.

> - LWP is exposed indiscriminately, without giving user-space a chance to 
>   disable it on a per task basis. Security-conscious apps would want to disable
>   access to the LWP instructions - which are all ring 3 and unprivileged! We
>   already allow this for the TSC for example. Right now sandboxed code like
>   seccomp would get access to LWP as well - not good. Some intelligent
>   (optional) control is needed, probably using cr0's lwp-enabled bit.

That could certainly be done, but requires an xcr0 write at
context-switch. JFI, how can the tsc be disabled for a task from
userspace?

Regards,

	Joerg

