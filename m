Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab2FHOgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:36:32 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:53275
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759909Ab2FHOgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:36:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z1823lz98dI936eI179dN1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5AZ8G-02-7UB-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 16:36:36 +0200
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
Message-ID: <20120608143636.GG31359@aftab.osrc.amd.com>
References: <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <1339163669.2507.16.camel@laptop>
 <20120608141543.GD31359@aftab.osrc.amd.com>
 <1339165250.2507.27.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339165250.2507.27.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:20:50PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-08 at 16:15 +0200, Borislav Petkov wrote:
> > have a variable which gets initialized to the number of all CPUs and
> > each time ->apply_microcode() finishes by returning 0, we decrement it
> > once.
> 
> > 
> > Hmm, I'm probably missing some obscure case. 
> 
> Since its all per-cpu sysfs muck, userspace could update a random
> subsets of cpus.. leaving us hanging.

I'm afraid I don't understand - when you modprobe microcode.ko,
it goes and loads /lib/firmware/amd-ucode/microcode_amd.bin (in
the AMD case) on each CPU when the driver gets regged through
subsys_interface_register().

It calls ->add_dev() on each CPU - this should be guaranteed because it
uses the cpu_subsys from drivers/base/cpu.c which onlines all CPUs, I'd
assume.

So, I'd say that once subsys_interface_register() returns, we have
updated ucode on all CPUs, if successful...

We probably could run the notifier at that moment, before we do
put_online_cpus().

> The 'bestestet' idea I came up with is doing the verify thing I have
> from a delayed work -- say 1 second into the future. That way, when
> there's lots of cpus they all try and enqueue the one work, which at
> the end executes only once, provided the entire update scan took less
> than the second.

You're saying, you want the last CPU that gets to update its microcode
gets to also run the delayed work...? Probably, I'd assume ucode update
on a single CPU takes less than a second IIUC.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

