Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1EQLam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:30:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1EQLak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:30:40 -0400
Date: Tue, 17 May 2011 13:30:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP
 support
Message-ID: <20110517113020.GA13475@elte.hu>
References: <4D91FA76.1010908@zytor.com>
 <1302018656-586370-1-git-send-email-hans.rosenfeld@amd.com>
 <20110407072305.GA20291@elte.hu>
 <20110516191012.GA575@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516191012.GA575@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> Hi,
> 
> On Thu, Apr 07, 2011 at 03:23:05AM -0400, Ingo Molnar wrote:
> > 
> > FYI, the bits in tip:x86/xsave crash on boot on an AMD X2 testbox:
> 
> > Full crashlog and kernel config attached. I've excluded x86/save from 
> > tip:master for now.
> 
> this issue has been fixed a few weeks ago.
> 
> Are there any plans to include x86/xsave into tip:master again?

Regarding the LWP bits, that branch was indeed excluded because of that crash, 
while re-checking the branch today i noticed at least one serious design error 
in it, which makes me reconsider the whole thing:

- Where is the hardware interrupt that signals the ring-buffer-full condition
  exposed to user-space and how can user-space wait for ring buffer events?
  AFAICS this needs to set the LWP_CFG MSR and needs an irq handler, which 
  needs kernel side support - but that is not included in these patches.

  The way we solved this with Intel's BTS (and PEBS) feature is that there's
  a per task hardware buffer that is coupled with the event ring buffer, so
  both setup and 'waiting' for the ring-buffer happens automatically and
  transparently because tools can already wait on the ring-buffer.

  Considerable effort went into that model on the Intel side before we merged
  it and i see no reason why an AMD hw-tracing feature should not have this 
  too...

  [ If that is implemented we can expose LWP to user-space as well (which can
    choose to utilize it directly and buffer into its own memory area without 
    irqs and using polling, but i'd generally discourage such crude event 
    collection methods). ]

- LWP is exposed indiscriminately, without giving user-space a chance to 
  disable it on a per task basis. Security-conscious apps would want to disable
  access to the LWP instructions - which are all ring 3 and unprivileged! We
  already allow this for the TSC for example. Right now sandboxed code like
  seccomp would get access to LWP as well - not good. Some intelligent
  (optional) control is needed, probably using cr0's lwp-enabled bit.

There are a couple of other items as well:

- The LWP_CFG has other features as well, such as the ability to aggregate 
  events amongst cores. This is not exposed either. This looks like a lower 
  prio, optional item which could be offered after the first patches went
  upstream.

- like we do it for PEBS with the perf_attr.precise attribute, it would be nice 
  to report not RIP+1 but the real RIP itself. On Intel we use LBR to discover 
  the previous instruction, this might not be possible on AMD CPUs.

  One solution would be to disassemble the sampled instruction and approximate 
  the previous one by assuming that it's the preceding instruction (for 
  branches and calls this might not be true). If we do this then the event::FUS 
  bit has to be taken into account - in case the CPU has fused the instruction
  and we have a two instructions delay in reporting.

  In any case, this is an optional item too and v1 support can be merged 
  without trying to implement precise RIP support.

- there are a few interesting looking event details that we'd want to expose
  in a generalized manner: branch taken/not taken bit, branch prediction 
  hit/miss bit, etc.

  This too is optional.

- The LWPVAL instruction allows the user-space generation of samples. There
  needs to be a matching generic event for it, which is then inserted into the 
  perf ring-buffer. Similarly, LWPINS needs to have a matching generic record 
  as well, so that user-space can decode it.

  This too looks optional to me.

- You'd eventually want to expose the randomization (bits 60-63 in the LWPCB)
  feature as well, via an attribute bit. Ditto for filtering such as cache
  latency filtering, which looks the most useful. The low/high IP filter could 
  be exposed as well. All optional. For remaining featurities if there's no sane
  way to expose them generally we can expose a raw event field as
  well and have a raw event configuration space to twiddle these details.

In general LWP is pretty neat and i agree that we want to offer it, it offers
access to five top categories of hw events (which we also have generalized):

 - instructions
 - branches
 - the most important types of cache misses
 - CPU cycles
 - constant (bus) cycles

 - user-space generated events/samples

So it will fit nicely into our existing scheme of how we handle PMU features
and generalizations.

Here are a couple of suggestions to LWP hardware designers:

 - the fact that LWP cannot count kernel events right now is unfortunate - 
   there's no reason not to allow privileged user-space to request ring 3
   events as well - hopefully this misfeature will be fixed in future 
   iterations of the hardware.

 - it would be nice to allow the per task masking/unmasking of LWP without
   having to modify the cr0 (which can be expensive). A third mode
   implemented in the LWP_CFG MSG would suffice: it would make the LWP
   instructions privileged, but would otherwise allow LWP event collection
   to occur even on sandboxed code.

 - it would be nice to also log the previous retired instruction in the
   trace entry, to ease decoding of the real instruction that generated
   an event. (Fused instructions can generate their RIP at the first
   instruction.)

Thanks,

	Ingo
