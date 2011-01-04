Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1AMF2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:28:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1AMF2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:28:01 -0500
Date: Tue, 4 Jan 2011 09:51:33 -0500
From: Rik van Riel <riel@redhat.com>
To: "Zhai, Edwin" <edwin.zhai@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: [PATCH -v2] vmx: increase ple_gap default to 64
Message-ID: <20110104095133.62525567@annuminas.surriel.com>
In-Reply-To: <4D229221.8070305@intel.com>
References: <20110103101907.2926ecca@annuminas.surriel.com>
	<4D229221.8070305@intel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some CPUs, a ple_gap of 41 is simply insufficient to ever trigger
PLE exits, even with the minimalistic PLE test from kvm-unit-tests.

http://git.kernel.org/?p=virt/kvm/kvm-unit-tests.git;a=commitdiff;h=eda71b28fa122203e316483b35f37aaacd42f545

For example, the Xeon X5670 CPU needs a ple_gap of at least 48 in
order to get pause loop exits:

# modprobe kvm_intel ple_gap=47
# taskset 1 /usr/local/bin/qemu-system-x86_64 -device testdev,chardev=log -chardev stdio,id=log -kernel x86/vmexit.flat -append ple-round-robin -smp 2
VNC server running on `::1:5900'
enabling apic
enabling apic
ple-round-robin 58298446
# rmmod kvm_intel
# modprobe kvm_intel ple_gap=48
# taskset 1 /usr/local/bin/qemu-system-x86_64 -device testdev,chardev=log -chardev stdio,id=log -kernel x86/vmexit.flat -append ple-round-robin -smp 2
VNC server running on `::1:5900'
enabling apic
enabling apic
ple-round-robin 36616

Increase the ple_gap to 128 to be on the safe side.  Is this enough
for a CPU with HT that has a busy sibling thread, or should it be
even larger?   On the X5670, loading up the sibling thread with an
infinite loop does not seem to increase the required ple_gap.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 81fcbe9..c61fcbf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -90,14 +90,14 @@ module_param(vmm_exclusive, bool, S_IRUGO);
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
  *             executions of PAUSE in a loop. Also indicate if ple enabled.
- *             According to test, this time is usually small than 41 cycles.
+ *             According to test, this time is usually smaller than 128 cycles.
  * ple_window: upper bound on the amount of time a guest is allowed to execute
  *             in a PAUSE loop. Tests indicate that most spinlocks are held for
  *             less than 2^12 cycles
  * Time is measured based on a counter that runs at the same rate as the TSC,
  * refer SDM volume 3b section 21.6.13 & 22.1.3.
  */
-#define KVM_VMX_DEFAULT_PLE_GAP    41
+#define KVM_VMX_DEFAULT_PLE_GAP    128
 #define KVM_VMX_DEFAULT_PLE_WINDOW 4096
 static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);

