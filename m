Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2D3AOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:14:55 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41653 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2D3AOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:14:54 -0400
Date: Mon, 30 Apr 2012 01:14:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Bryan O'Donoghue" <bryan.odonoghue@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: APIC logic bug in kernel
In-Reply-To: <4F7B3D93.4030405@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1204300106540.19691@eddie.linux-mips.org>
References: <4F7B3D93.4030405@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

 Apologies for a late reply, I don't check mailing list traffic regularly.

On Tue, 3 Apr 2012, Bryan O'Donoghue wrote:

> I'm looking at the code in arch/x86/kernel/apic/apic.c specifically the code
> path that checks for x86_vendor == X86_VENDOR_INTEL with boot_cpu_data.x86 =
> 5.
> 
> As I understand the code, BIOS will have informed kernel that it has an APIC
> based on mps tables. If the CPU family == 5, the function apic_verify() will
> be called.
> 
> Problem is apic_verify() does an rdmsr for an MSR that was not included in IA
> until P6.
> 
> Specifically rdmsr/wrmsr instructions in apic.c are not P5 compatible - since
> the MSR IA32_APIC_BASE was not introduced until P6_01 - as listed in the
> system programming guide volume 3.
> 
> Are all of these rdmsr/wrmsr calls made with an awareness of P5 ?
> 
> Example:
> 
> We check in apic_verify() if cpuid(1).edx has bit 9 (local APIC) set.
> If so we set CPU capability FEATURE_APIC and rdmsr/wrmsr to 0x1B
> 
> arch/x86/include/asm/msr-index.h:#define MSR_IA32_APICBASE
> 0x0000001b
> 
> As I read this code it is perfectly valid for a P5, to have an APIC, report it
> has APIC capability via BIOS and CPUID and then subsequently to go ahead and
> touch the IA32_APIC_BASE MSR.
> 
> Basically this code doesn't seem to match the spec, am I missing a trick ?

 You mean this piece:

	if (!cpu_has_apic) {
[...]
	} else {
		if (apic_verify())
			return -1;
        }

in detect_init_APIC(), I presume?  Looks like a regression to me, and will 
trigger a #GP on RDMSR on Pentium-class processors.  Additionally the 
messages produced by apic_verify() look bogus to me in this context.

 Ingo, can you please look at it or find someone to?  Thanks.

  Maciej
