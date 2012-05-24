Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab2EXQT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:19:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab2EXQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:19:54 -0400
Message-ID: <4FBE5FA6.5050802@gmail.com>
Date: Thu, 24 May 2012 10:19:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: perf, x86: only do lbr init if bts is available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM recently added support for a version 2 PMU. When passing -cpu host 
as the CPU model for the guest we get an abnormal configuration from 
perf's perspective in that the guest identifies the processor as a 
Westmere or Nehalem (etc):

[    0.013998] Performance Events: Westmere events, Intel PMU driver.


but yet the processor does not have the debug store mechanisms 
(X86_FEATURE_DTES64 is not set) meaning there is no PEBS or BTS.

Right now the LBR init functions are run based on processor model which 
leads to attempts to write to LBR MSRs generating messages like:

[ 1170.125605] kvm: 6873: cpu0 unhandled rdmsr: 0x345
[ 1170.135354] kvm_set_msr_common: 54 callbacks suppressed
[ 1170.135612] kvm: 6873: cpu0 unhandled wrmsr: 0x680 data 0
[ 1170.135900] kvm: 6873: cpu0 unhandled wrmsr: 0x6c0 data 0
[ 1170.136163] kvm: 6873: cpu0 unhandled wrmsr: 0x681 data 0
[ 1170.136437] kvm: 6873: cpu0 unhandled wrmsr: 0x6c1 data 0
[ 1170.136703] kvm: 6873: cpu0 unhandled wrmsr: 0x682 data 0
[ 1170.136968] kvm: 6873: cpu0 unhandled wrmsr: 0x6c2 data 0
[ 1170.137227] kvm: 6873: cpu0 unhandled wrmsr: 0x683 data 0
[ 1170.137502] kvm: 6873: cpu0 unhandled wrmsr: 0x6c3 data 0
[ 1170.137797] kvm: 6873: cpu0 unhandled wrmsr: 0x684 data 0
[ 1170.138061] kvm: 6873: cpu0 unhandled wrmsr: 0x6c4 data 0


MSR 0x345 is MSR_IA32_PERF_CAPABILITIES; the 0x6XX MSRs are LBR from/to.

Question: is something like this acceptable/make sense -- to only setup 
lbr values if the BTS is detected?

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c 
b/arch/x86/kernel/cpu/perf_event_intel.c
index 166546e..7ba4afa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1783,7 +1784,8 @@ __init int intel_pmu_init(void)
         memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
                sizeof(hw_cache_extra_regs));

-       intel_pmu_lbr_init_nhm();
+       if (x86_pmu.bts)
+           intel_pmu_lbr_init_nhm();

         x86_pmu.event_constraints = intel_nehalem_event_constraints;
         x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;

David
