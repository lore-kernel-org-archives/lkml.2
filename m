Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab2FHOPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:15:34 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:57838
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2FHOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:15:32 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z1823lz98dI936eI179dN1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5AY9M-01-24D-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 16:15:43 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <andi@firstfloor.org>, <mingo@elte.hu>, <ming.m.lin@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608141543.GD31359@aftab.osrc.amd.com>
References: <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <1339163669.2507.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339163669.2507.16.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:54:29PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-08 at 15:51 +0200, Borislav Petkov wrote:
> > Reportedly, there are some obscure systems which need different
> > microcode versions per CPU:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/01010.html
> 
> *groan*,.. ok.

Tell me about it - if we didn't have to support this, we could've killed
a lot of code from the thing.

> > > The biggest problem is finding when the minimum revision changes, at
> > > best this is a n log n sorting problem due to the per-cpu setup, but I
> > > couldn't be arsed to implement a tree or anything fancy since it all
> > > stinks anyway.
> > 
> > I know. Can't you just iterate over all CPUs and collect the lowest
> > ucode version? Provided, of course, newer microcode versions means a
> > higher version number. 
> 
> That's what I do.. but that's O(n) per cpu, so if you update all cpus,
> that's O(n^2).
> 
> You don't know when userspace is done updating the 'last' cpu, so you
> have to scan all cpus for every cpu.
> 
> I'm sure the SGI people with their silly CPU counts aren't too thrilled
> to have this.

Ok, hmm, I don't have a bright idea right now except maybe a stupid one:

have a variable which gets initialized to the number of all CPUs and
each time ->apply_microcode() finishes by returning 0, we decrement it
once.

"Finishes by returning 0" means ucode successfully updated.

When it has reached 0, microcode_notifier_done() says
MICROCODE_SUCCESSFULLY_UPDATED_ON_ALL_CPUS and only then you run
intel_snb_verify_ucode().

However(!),

* what do you do when you boot the box with less CPUs than present? All
the offline CPUs cannot get to userspace to get the chance to update
ucode. In that case, counter stays !0 and bo PEBS, tough luck.

* hotplug: we don't care about it because once we ONLINE a CPU again, it
automatically gets the ucode applied.

Hmm, I'm probably missing some obscure case.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

