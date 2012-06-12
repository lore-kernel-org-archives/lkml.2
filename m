Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2FLRXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:23:46 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:10864
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab2FLRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:23:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z1823lz98dI936eI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5ILNB-02-GKU-02
X-M-MSG: 
Date: Tue, 12 Jun 2012 19:23:34 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612172334.GQ1478@erda.amd.com>
References: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120612170725.GE5046@erda.amd.com>
 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
 <1339521203.31548.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339521203.31548.92.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.12 19:13:23, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 19:09 +0200, Stephane Eranian wrote:
> > > Instead of registering a microcode notifier, why not checking the
> > > availability of pebs dynamically with each syscall in
> > > intel_pmu_hw_config()? It looks like intel_snb_verify_ucode() is not
> > > that much expensive. We can perform the check only if the event
> > could
> > > be for pebs and if pebs is broken. The check could be repeated when
> > > setting up a new event after ucode could potentially has been
> > updated
> > > (e.g. after bringing a cpu online or so).
> 
> Because you then end up with a for_each_online_cpu() loop in there,
> that's not pretty and quite horrible on large systems when you need to
> create nr_cpus events.

But usually the check fails on the current cpu, no need to touch other
cpus in this case. for_each_online_cpu() would run only for the case
that there just was a ucode update and pebs is going to be enabled.
And for this rare case we could use locking.

> Furthermore, ucode update is the rare thing, creating events happens
> much more frequently.
> 
> > That's what I had in my original version. 
> 
> Right, but you really need to check all cpus, not just the one you
> happen to run on or the boot cpu.

Once pebs is enabled no further checks are needed anymore, I think.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

