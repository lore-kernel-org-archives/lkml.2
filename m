Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1CJCoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:44:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36840 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1CJCoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:44:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bU1YCz49D4K79TFSDEkXy8rzsOF9WoJTKmNdCnZjFiIENEO342DyB2CUKnRnWLDPvt
         s6yZjqF+PPS6M+QtDZK9s+wrFoECDCQ49GQgJeesyXkz2oWzm/BfCT4bKD/NhpGJBp/z
         8MrqQmlzTLcNHIFOcFevLO3UKDmTfR24t/RtI=
Date: Thu, 10 Mar 2011 03:43:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110310024355.GG2533@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
 <20110307180619.GG1873@nowhere>
 <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 04:59:30PM +0800, Sam Liao wrote:
> On Tue, Mar 8, 2011 at 2:06 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > So, instead of having such temporary copy, could you rather feed the callchain
> > into the cursor in reverse from perf_session__resolve_callchain() ?
> >
> > You can keep the common part inside the loop into a seperate helper
> > but have two different kinds of loops.
> 
> In perf_session__resolve_callchain, only the callchain itself can be reversed,
> which means the root of report will still be the ip of the event with a reversed
> call chain sub tree. But what is more impressive to user is to make "main" like
> function to be the root of the report, and this means that both the ip
> and call chain is
> involved to the reversion process.
> 
> Since the ip of event is resolved in event__preprocess_sample, so it is kind
> hard to do such reversion in a better way.

You are making an interesting point.

My view of this feature was limited to the current per hist area: having
the callchains on top of hists that can be sorted per ip, dso, pid, etc...
like we have today basically. So my view was for this reverse callchain
to show us one callers profiling for each hist entry.

But your idea of turning the callee into the caller would show us a very global
profiling. With reverse callchains it can be a very nice overview of the big picture.

IMO both workflow can be interesting:

1) Have a big reversed callchain overview, with one root per entrypoint. This
what you wanted.
2) Have a per hist 1)  which means a per hist per entrypoint callchain

1) involves reverting both callchains and ip <->caller whereas 2) only involves
reverting the callchain.

In order to get both features with a maximum flexibility and keep that extendable, I
would suggest to decouple that in two independant parts:

	- an option to get reversed callchains. Using the -g option and caller/callee
	as a third argument.

	- a new "caller" sort entry. What defines a hist entry is a set of sort
	entries: dso, symbol, pid, comm, ... That we use with the -s option in perf report.
	If you want one hist per entrypoint, we could add a new "caller" sort entry.
	Then perf report -s caller will (roughly) produce one hist for main(), one hist
	for kernel_thread(), etc...

Hence, someone running "perf report -g fractal,0.5,reversed -s dso" is going to have a
per dso caller-callchain profiling.

Someone running "perf report -g fractal,0.5,reversed -s caller" is going to have that
global caller profiling you wanted. You'll have one hist per entrypoint.

The caller sorting mode may sound a bit limited currently, but think about what happens
when you push forward the entrypoint, if one day we bring a feature to filter the callchains
on some dso address space , we could do a caller callchain profile starting on a shared library
and pinpoint which functions are mostly called on it, so that can be coupled with dso sorting mode,
etc... So that looks like a right way to go.

Ah and that shouldn't require to overwrite the real ip of an event with the caller.
Better create a new "caller" field on struct hist_entry for that.

Hm?
