Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab2EDXSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:18:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1898 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2EDXSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:18:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 04 May 2012 16:18:08 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 4 May 2012 16:18:08 -0700
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Topic: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
Thread-Index: Ac0qRXXsAeHshWJMR9ac75EDvn/bBAABqzcg
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF103@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
	 <1336169422.16236.1.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
 <1336170586.16236.11.camel@twins>
In-Reply-To: <1336170586.16236.11.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for clarifying the Power7. I see the point - package vs cpu's within a package.

Yes, this is for Nvidia's ARM Quad-core Tegra CPU. It is a single package, organized flatly.
To save power, we want cores to be loaded up in order from cpu0, 1, etc.
The ASYM_PACKING flag seems to do exactly what we need if set in the domain flag.

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
Sent: Friday, May 04, 2012 3:30 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'Andrew Morton'; 'Christoph Lameter'; 'Michael Neuling'; 'Stephen Rothwell'; 'Benjamin Herrenschmidt'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in sched domain

On Fri, 2012-05-04 at 15:18 -0700, Diwakar Tundlam wrote:
> 
> arch_sd_sibling_asym_packing() is already present under ifdef CONFIG_SMT.
> I didn't touch that. I only added it to SD_CPU_INIT for all cpu's.
> I assumed Power7 shouldn't use SD_CPU_INIT.

All archs use SD_CPU_INIT, its the default topology level for a package/socket. So now you've made Power7 prefer lower numbered sockets over higher numbered sockets.. not fatal, but not really nice either.

[ power7 is the only one that implements arch_sd_sibling_asym_packing ]

> Maybe I should define a separate weak symbol, say arch_sd_bias_to_lower_num_cpu()?
> Then Power7 can define arch_sd_sibling_asym_packing() to be '1' and it 
> will not break all-cpu init.

A slightly saner name would be:

  arch_sd_package_asym_packing()

FWIW, I suspect you're wanting to use this for some ARM chip (nvidia doesn't do much else -- aside from this graphics stuff) so that if there's hardly anything it runs on cpu0. Now, last time I checked, these ARM things had only 1 package, so I still don't see the point :-)

I suspect you want to modify SD_MC_INIT() with something like:

  arch_sd_mc_asym_packing()

Or is this the big-little thing and you're representing them as separate packages?

See how a little extra information avoids me having to endlessly second guess wtf you're actually wanting to do?
