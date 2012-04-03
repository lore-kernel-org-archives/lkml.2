Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2DCSMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:12:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:3404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab2DCSMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:12:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84877525"
Message-ID: <4F7B3D93.4030405@linux.intel.com>
Date: Tue, 03 Apr 2012 19:12:35 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: APIC logic bug in kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings list.

I'm looking at the code in arch/x86/kernel/apic/apic.c specifically the 
code path that checks for x86_vendor == X86_VENDOR_INTEL with 
boot_cpu_data.x86 = 5.

As I understand the code, BIOS will have informed kernel that it has an 
APIC based on mps tables. If the CPU family == 5, the function 
apic_verify() will be called.

Problem is apic_verify() does an rdmsr for an MSR that was not included 
in IA until P6.

Specifically rdmsr/wrmsr instructions in apic.c are not P5 compatible - 
since the MSR IA32_APIC_BASE was not introduced until P6_01 - as listed 
in the system programming guide volume 3.

Are all of these rdmsr/wrmsr calls made with an awareness of P5 ?

Example:

We check in apic_verify() if cpuid(1).edx has bit 9 (local APIC) set.
If so we set CPU capability FEATURE_APIC and rdmsr/wrmsr to 0x1B

arch/x86/include/asm/msr-index.h:#define MSR_IA32_APICBASE		0x0000001b

As I read this code it is perfectly valid for a P5, to have an APIC, 
report it has APIC capability via BIOS and CPUID and then subsequently 
to go ahead and touch the IA32_APIC_BASE MSR.

Basically this code doesn't seem to match the spec, am I missing a trick ?


Bryan
