Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1BAPPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:15:11 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46642
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751618Ab1BAPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:15:06 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz1418M1432N98dN1fa4Lzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFY2CX-01-99D-02
X-M-MSG: 
Date: Tue, 1 Feb 2011 16:14:55 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110201151455.GA9507@escobedo.osrc.amd.com>
References: <20110126105637.GA27809@elte.hu>
 <1296061716-185599-1-git-send-email-hans.rosenfeld@amd.com>
 <20110126205608.GA14361@elte.hu>
 <20110127115017.GH877@escobedo.osrc.amd.com>
 <20110127124756.GA16094@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110127124756.GA16094@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 07:47:56AM -0500, Ingo Molnar wrote:
> > The problem is that cpuinfo_x86.compute_unit_id etc. don't exist unless
> > CONFIG_SMP is enabled. I don't think there is any reason why this should
> > be that way, but changing this just for this particular L3 feature seems
> > too intrusive. Do you really want me to do that?
> 
> All the CONFIG_X86_HT #ifdefs in arch/x86/kernel/cpu/amd.c look pretty ugly too - 
> and it's not really a properly modularized solution.
> 
> We generally want to unify the SMP and UP kernels as much as possible. 'CONFIG_SMP' 
> is not really a property of the hardware, it's a property of the software.
> 
> If some topology information should be excluded then it can already be done by 
> turning off CONFIG_CPU_SUP_AMD under CONFIG_EXPERT.

I see several solutions to resolve this issue:

1. Remove #ifdef CONFIG_SMP around compute_unit_id in struct cpuinfo_x86
   and then use my original patch. This would work without introducing
   new #ifdef ugliness with the L3 cache partitioning, but it would
   increase #ifdef ugliness in struct cpuinfo_x86. Also, compute_unit_id
   would just so happen to be initialized to 0, there would be no other
   code using it for CONFIG_SMP. L3 cache partitioning would be the
   first SMP-specific feature to be available in non-SMP kernels.

2. Same as #1, but remove CONFIG_SMP completely from struct cpuinfo_x86.
   This would mean less #ifdef ugliness there, but then we would have a
   bunch of unused fields in there in non-SMP kernels, which would also
   just be initialized to 0. I don't think that would be correct for
   booted_cores, but as it is unused I don't see an immediate problem
   with that. Of course, this is also neither correct nor less ugly.

3. Same as #2, but also rework all code using those fields to be usable
   on non-SMP kernels. This would be essentially a rework of all that
   CONFIG_SMP stuff, and I think thats too much to ask for just for a
   little extra L3 feature.

Maybe I'm missing something here, but I don't see how this could be
done cleanly in any other way at this time.

Of course, you could just take the modified patch I sent you. That would
be ugly, but not more so than the existing code. If this is not
acceptable, please tell me which of the other two ugly solutions you
would prefer.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

