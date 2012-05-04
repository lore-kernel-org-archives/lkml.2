Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab2EDWaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:30:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2EDWaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:30:08 -0400
Message-ID: <1336170586.16236.11.camel@twins>
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Sat, 05 May 2012 00:29:46 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
	 <1336169422.16236.1.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 15:18 -0700, Diwakar Tundlam wrote:
> 
> arch_sd_sibling_asym_packing() is already present under ifdef CONFIG_SMT.
> I didn't touch that. I only added it to SD_CPU_INIT for all cpu's.
> I assumed Power7 shouldn't use SD_CPU_INIT.

All archs use SD_CPU_INIT, its the default topology level for a
package/socket. So now you've made Power7 prefer lower numbered sockets
over higher numbered sockets.. not fatal, but not really nice either.

[ power7 is the only one that implements arch_sd_sibling_asym_packing ]

> Maybe I should define a separate weak symbol, say arch_sd_bias_to_lower_num_cpu()?
> Then Power7 can define arch_sd_sibling_asym_packing() to be '1' and it will not
> break all-cpu init.

A slightly saner name would be:

  arch_sd_package_asym_packing()

FWIW, I suspect you're wanting to use this for some ARM chip (nvidia
doesn't do much else -- aside from this graphics stuff) so that if
there's hardly anything it runs on cpu0. Now, last time I checked, these
ARM things had only 1 package, so I still don't see the point :-)

I suspect you want to modify SD_MC_INIT() with something like:

  arch_sd_mc_asym_packing()

Or is this the big-little thing and you're representing them as separate
packages?

See how a little extra information avoids me having to endlessly second
guess wtf you're actually wanting to do?
