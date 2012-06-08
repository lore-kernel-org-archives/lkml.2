Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab2FHUm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:42:58 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:32097
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759538Ab2FHUm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:42:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z1823lz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5BG7B-02-9F7-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 22:38:28 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608203828.GA5220@aftab.osrc.amd.com>
References: <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608180505.GA4171@aftab.osrc.amd.com>
 <1339181537.30462.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339181537.30462.7.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 08:52:17PM +0200, Peter Zijlstra wrote:
> Checking a bitmap of n bits for being all zero is O(n), so the total is
> still O(n^2). Still, probably faster than the for_each_online_cpu() scan
> I do now.

Ok, here's what I mean:

On init you do:

	cpumask_copy(ucode_mask, cpu_online_mask);

In the notifier:

	cpumask_clear_cpu(this_cpu, ucode_mask);

	if (cpumask_empty(ucode_mask))
		verify_pebs();

So, on each cpu you do cpumask_clear_cpu() which should be O(k) for some
constant k.

And ok, cpumask_empty() aka __bitmap_empty() iterates over
nbits/BITS_PER_LONG, so here's the O(n), I see what you mean.

Well, you could probably replace cpumask_empty() with cpumask_weight()
which should use POPCNT in newer hardware and should be almost for free.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

