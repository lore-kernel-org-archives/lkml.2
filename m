Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0ECSWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:22:40 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44923 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0ECSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:22:38 -0400
Date: Mon, 3 May 2010 20:20:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Arnold, Frank" <Frank.Arnold@amd.com>
Subject: Re: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
Message-ID: <20100503182047.GI26107@aftab>
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
 <4BD0E869.10402@zytor.com>
 <20100423065016.GA11748@aftab>
 <20100423140927.GA13750@aftab>
 <4BD1E197.6000508@zytor.com>
 <20100424082105.GA22632@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100424082105.GA22632@aftab>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Sat, Apr 24, 2010 at 04:21:05AM -0400

Hi Peter,

any progress here, do you want me to send an updated series or can you
pick up the patchlet below?

Thanks.

> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Fri, Apr 23, 2010 at 11:06:15AM -0700
> 
> > On 04/23/2010 07:09 AM, Borislav Petkov wrote:
> > > 
> > > Ok, looking at the k8.o object it is 507 bytes so I don't think
> > > compiling it in would hurt embedded people too much:
> > > 
> > >    text    data     bss     dec     hex filename
> > >     379     104      24     507     1fb arch/x86/kernel/k8.o
> > > 
> > > So how about the following? It should apply cleanly on top and it
> > > survived a bunch of randconfigs here so far.
> > > 
> > 
> > I have to say I think that's pretty ridiculous for someone who cares so
> > much about size that they have disabled CONFIG_PCI that they can just
> > add another half-kilobyte of code that is going to do absolutely
> > nothing.  Think about the kind of x86 CPUs that could even consider
> > disabling CONFIG_PCI -- we're talking pretty deep embedded by now.
> 
> Yep, true story.
> 
> > So, no, I don't think this is an option.  Force-enabling CONFIG_PCI on
> > x86 would be a more realistic option, and I honestly don't know how many
> > people would object to that, but not right now.
> 
> Well, after looking at 1ac97018169c5a13feaa90d9671f2d6ba2d9e86e,
> grepping for '!PCI' in arch/x86/ returns nothing now.
> 
> From all the x86 flavors which didn't need PCI
> 
> 1) There used to be a X86_VOYAGER MCA-based 32-bit arch from NCR which
> seems to be gone now
> 
> 2) X86_VISWS "SGI 320/540 (Visual Workstation)" depended on !PCI but
> depends on PCI now, so which is it?
> 
> 3) X86_VSMP ("ScaleMP vSMP") used to depend on !PCI but depends on PCI
> now, [/me puzzled].
> 
> all seem fine with PCI currently (especially the Voyager :)). So it
> really looks like we could enable it by default on x86. Maybe for the
> .35 merge window and see how much fallout we generate. Or at least put
> it up for a flamewar on lkml since we like those so much :).
> 
> > The obvious answer instead is to augment the list of stubs in
> > <asm/k8.h>.  In particular, move num_k8_northbridges into the #ifdef and
> > just #define num_k8_northbridges 0 in the other clause.
> 
> Right, it couldn't be simpler, see below. With it, the only warning I
> get doing randconfig builds is
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c:498: warning: ‘cache_disable_0’ defined but not used
> arch/x86/kernel/cpu/intel_cacheinfo.c:500: warning: ‘cache_disable_1’ defined but not used
> 
> which is caused by !CONFIG_SYSFS but this is another senseless case.
> 
> ---
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Sat, 24 Apr 2010 09:56:53 +0200
> Subject: [PATCH] x86, k8-nb: Fix build error when K8_NB is disabled
> 
> K8_NB depends on PCI and when the last is disabled (allnoconfig) we fail
> at the final linking stage due to missing exported num_k8_northbridges.
> Add a header stub for that.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/include/asm/k8.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
 -- 
> 1.6.4.4
> 

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
