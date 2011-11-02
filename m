Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab1KCCHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:07:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654Ab1KCBhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.558850466@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
        Philipp Hahn <hahn@univention.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [092/107] KVM: x86: Reset tsc_timestamp on TSC writes
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Philipp Hahn <hahn@univention.de>

There is no upstream commit ID for this patch since it is not a straight
backport from upstream. It is a fix only relevant to 2.6.32.y.

Since 1d5f066e0b63271b67eac6d3752f8aa96adcbddb from 2.6.37 was
back-ported to 2.6.32.40 as ad2088cabe0fd7f633f38ba106025d33ed9a2105,
the following patch is needed to add the needed reset logic to 2.6.32 as
well.


Bug #23257: Reset tsc_timestamp on TSC writes

vcpu->last_guest_tsc is updated in vcpu_enter_guest() and kvm_arch_vcpu_put()
by getting the last value of the TSC from the guest.
On reset, the SeaBIOS resets the TSC to 0, which triggers a bug on the next
call to kvm_write_guest_time(): Since vcpu->hw_clock.tsc_timestamp still
contains the old value before the reset, "max_kernel_ns = vcpu->last_guest_tsc
- vcpu->hw_clock.tsc_timestamp" gets negative. Since the variable is u64, it
 gets translated to a large positive value.

[9333.197080]
vcpu->last_guest_tsc        =209_328_760_015           ←
vcpu->hv_clock.tsc_timestamp=209_328_708_109
vcpu->last_kernel_ns        =9_333_179_830_643
kernel_ns                   =9_333_197_073_429
max_kernel_ns               =9_333_179_847_943         ←

[9336.910995]
vcpu->last_guest_tsc        =9_438_510_584             ←
vcpu->hv_clock.tsc_timestamp=211_080_593_143
vcpu->last_kernel_ns        =9_333_763_732_907
kernel_ns                   =9_336_910_990_771
max_kernel_ns               =6_148_296_831_006_663_830 ←

For completeness, here are the values for my 3 GHz CPU:
vcpu->hv_clock.tsc_shift         =-1
vcpu->hv_clock.tsc_to_system_mul =2_863_019_502

This makes the guest kernel crawl very slowly when clocksource=kvmclock is
used: sleeps take way longer than expected and don't match wall clock any more.
The times printed with printk() don't match real time and the reboot often
stalls for long times.

In linux-git this isn't a problem, since on every MSR_IA32_TSC write
vcpu->arch.hv_clock.tsc_timestamp is reset to 0, which disables above logic.
The code there is only in arch/x86/kvm/x86.c, since much of the kvm-clock
related code has been refactured for 2.6.37:
	99e3e30a arch/x86/kvm/x86.c 
        (Zachary Amsden            2010-08-19 22:07:17 -1000 1084)
        vcpu->arch.hv_clock.tsc_timestamp = 0;                                                      

Signed-off-by: Philipp Hahn <hahn@univention.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    1 +
 arch/x86/kvm/vmx.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2256,6 +2256,7 @@ static int svm_set_msr(struct kvm_vcpu *
 		}
 
 		svm->vmcb->control.tsc_offset = tsc_offset + g_tsc_offset;
+		vcpu->arch.hv_clock.tsc_timestamp = 0;
 
 		break;
 	}
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1067,6 +1067,7 @@ static int vmx_set_msr(struct kvm_vcpu *
 	case MSR_IA32_TSC:
 		rdtscll(host_tsc);
 		guest_write_tsc(data, host_tsc);
+		vcpu->arch.hv_clock.tsc_timestamp = 0;
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {


