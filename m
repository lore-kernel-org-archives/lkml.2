Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0CVK7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:59:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab0CVK7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:59:37 -0400
Date: Mon, 22 Mar 2010 11:59:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: oerg Roedel <joro@8bytes.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100322105927.GB3483@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <1268969929.2813.184.camel@localhost>
 <20100319082122.GE12576@elte.hu>
 <20100319172903.GI13108@8bytes.org>
 <20100321184300.GB25922@elte.hu>
 <20100322101451.GK13108@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322101451.GK13108@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* oerg Roedel <joro@8bytes.org> wrote:

> On Sun, Mar 21, 2010 at 07:43:00PM +0100, Ingo Molnar wrote:
> > Having access to the actual executable files that include the symbols achieves 
> > precisely that - with the additional robustness that all this functionality is 
> > concentrated into the host, while the guest side is kept minimal (and 
> > transparent).
> 
> If you want to access the guests file-system you need a piece of software 
> running in the guest which gives you this access. But when you get an event 
> this piece of software may not be runnable (if the guest is in an interrupt 
> handler or any other non-preemptible code path). When the host finally gets 
> access to the guests filesystem again the source of that event may already 
> be gone (process has exited, module unloaded...). The only way to solve that 
> is to pass the event information to the guest immediatly and let it collect 
> the information we want.

The very same is true of profiling in the host space as well (KVM is nothing 
special here, other than its unreasonable insistence on not enumerating 
readily available information in a more usable way).

So are you suggesting a solution to a perf problem we already solved 
differently? (and which i argue we solved in a better way)

We have solved that in the host space already (and quite elaborately so), and 
not via your suggestion of moving symbol resolution to a different stage, but 
by properly generating the right events to allow the post-processing stage to 
see processes that have already exited, to robustly handle files that have 
been rebuilt, etc.

>From an instrumentation POV it is fundamentally better to acquire the right 
data and delay any complexities to the analysis stage (the perf model) than to 
complicate sampling (the oprofile dcookies model).

Your proposal of 'doing the symbol resolution in the guest context' is in 
essence re-arguing that very similar point that oprofile lost. Did you really 
intend to re-argue that point as well? If yes then please propose an 
alternative implementation for everything that perf does wrt. symbol lookups.

What we propose for 'perf kvm' right now is simply a straight-forward 
extension of the existing (and well working) symbol handling code to 
virtualization.

> > You need to be aware of the fact that symbol resolution is a separate step 
> > from call chain generation.
> 
> Same concern as above applies to call-chain generation too.

Best would be if you demonstrated any problems of the perf symbol lookup code 
you are aware of on the host side, as it has that exact design you are 
criticising here. We are eager to fix any bugs in it.

If you claim that it's buggy then that should very much be demonstratable - no 
need to go into theoretical arguments about it.

( You should be aware of the fact that perf currently works with 'processes
  exiting prematurely' and similar scenarios just fine, so if you want to
  demonstrate that it's broken you will probably need a different example. )

> > > How we speak to the guest was already discussed in this thread. My 
> > > personal opinion is that going through qemu is an unnecessary step and 
> > > we can solve that more clever and transparent for perf.
> > 
> > Meaning exactly what?
> 
> Avi was against that but I think it would make sense to give names to 
> virtual machines (with a default, similar to network interface names). Then 
> we can create a directory in /dev/ with that name (e.g. /dev/vm/fedora/). 
> Inside the guest a (priviledged) process can create some kind of named 
> virt-pipe which results in a device file created in the guests directory 
> (perf could create /dev/vm/fedora/perf for example). This file is used for 
> guest-host communication.

That is kind of half of my suggestion - the built-in enumeration guests and a 
guaranteed channel to them accessible to tools. (KVM already has its own 
special channel so it's not like channels of communication are useless.)

The other half of my suggestion is that if we bring this thought to its 
logical conclusion then we might as well walk the whole mile and not use 
quirky, binary API single-channel pipes. I.e. we could use this convenient, 
human-readable, structured, hierarchical abstraction to expose information in 
a finegrained, scalable way, which has a world-class implementation in Linux: 
the 'VFS namespace'.

Thanks,

	Ingo
