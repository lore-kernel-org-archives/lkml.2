Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1F0Nxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:53:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14097
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab1F0Nx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:53:29 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 09:53:29 EDT
X-SpamScore: -18
X-BigFish: VPS-18(zz936eK4015L10e3K1432N98dKzz1202hzzz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNGB7N-01-J8T-02
X-M-MSG: 
Date: Mon, 27 Jun 2011 15:38:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vince Weaver <vweaver1@eecs.utk.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch] perf_events: more wrong events for AMD fam10h
Message-ID: <20110627133809.GC4590@erda.amd.com>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
 <1309173740.6701.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309173740.6701.103.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.11 07:22:20, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 15:39 -0400, Vince Weaver wrote:
> > Hello
> > 
> > I'm in the process of auditing perf_event's awesome "generalized events".
> > 
> > On AMD fam10h for some we have the following definitions:
> >   cache-references = INSTRUCTION_CACHE_FETCHES	0x530080
> >   cache-misses 	   = INSTRUCTION_CACHE_MISSES	0x530081
> > 
> > on Intel at least I'm pretty sure these events match to Last Level Cache 
> > accesses/misses, not icache.  Is there a reason for this?
> > 
> > Attached is a patch that removes these until better events can be found.
> > (LLC is tricky on AMD as it's a shared resource).
> > 
> > Note, l1-dcache-stores is broken too, I'm looking into it.
> > 
> > Thanks,
> > 
> > Vince
> > vweaver1@eecs.utk.edu
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > index fe29c1d..a46b987 100644
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -98,8 +98,6 @@ static const u64 amd_perfmon_event_map[] =
> >  {
> >    [PERF_COUNT_HW_CPU_CYCLES]			= 0x0076,
> >    [PERF_COUNT_HW_INSTRUCTIONS]			= 0x00c0,

I am not sure if Intel's LLC definition includes uncore events which
are equivalent to AMD's northbridge counter (L3) events (it could be
meant the LLC of the core only?).

Following definition taken form the Intel spec (SDM 3B, 30.2.3 and
Appendix A):

> > -  [PERF_COUNT_HW_CACHE_REFERENCES]		= 0x0080,

"This event counts requests originating from the core that reference a
cache line in the last level cache." (Intel event 2EH/4FH)

> > -  [PERF_COUNT_HW_CACHE_MISSES]			= 0x0081,

"This event counts each cache miss condition for references to the
last level cache." (Intel event 2EH/41H)

> 
> Would 0x40000F7E0 and 0x40000F7E1 be better?

Taking this is a bit tricky, we would measure all misses of the node
then. We actually would have to select the current core. But for this
we need to schedule one northbridge counter for each core. On a six
core (family 10h ref D) we don't have enough counters then. There is
also an erratum, we can not do per-core L3 measurements.

On family 15h northbridge counters are not yet implemented.

On k7/k8 we must select L2 events (0x0080/0x0081).

So even if LLC includes per-definition the L3, it is not easy to
implement. But using 0x0080/0x0081 on all models would give similar
results for every cpu family.

-Robert

> 
> >    [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]		= 0x00c2,
> >    [PERF_COUNT_HW_BRANCH_MISSES]			= 0x00c3,
> >    [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00d0, /* "Decoder empty" event */
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

