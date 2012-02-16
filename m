Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2BPUTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:19:12 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:46014 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab2BPUTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:19:08 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 V14] Avoid soft lockup message when KVM is stopped by host
Date: Thu, 16 Feb 2012 15:18:57 -0500
Message-Id: <1329423541-11677-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V13:
Expand on KVM_KVMCLOCK_CTRL ioctl documentation

Changes from V12:
Re-add missing kvm.c code after rebase
Rename CAP to KVM_CAP_KVMCLOCK_CTRL
Rename ioctl to KVM_KVMCLOCK_CTRL

Changes from V11:
Re-add asm-generic stub
Correct api.txt typo
add kvm_make_request() call after setting PVCLOCK_GUEST_STOPPED

Changes from V10:
Return ioctl to per vcpu instead of per vm

Changes from V9:
Use kvm_for_each_vcpu to iterate online vcpu's

Changes from V8:
Make KVM_GUEST_PAUSED a per vm ioctl instead of per vcpu

Changes from V7:
Define KVM_CAP_GUEST_PAUSED and support check
Call mark_page_dirty () after setting PVCLOCK_GUEST_STOPPED

Changes from V6:
Use __this_cpu_and when clearing the PVCLOCK_GUEST_STOPPED flag

Changes from V5:
Collapse generic check_and_clear_guest_stopped into patch 2
Include check_and_clear_guest_stopped defintion to ia64, s390, and powerpc
Change check_and_clear_guest_stopped to use __get_cpu_var instead of taking the
 cpuid arg.
Protect check_and_clear_guest_stopped declaration with CONFIG_KVM_CLOCK check

Changes from V4:
Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt

Changes from V3:
Include CC's on patch 3
Drop clear flag ioctl and have the watchdog clear the flag when it is reset

Changes from V2:
A new kvm functions defined in kvm_para.h, the only change to pvclock is the
initial flag definition

Changes from V1:
(Thanks Marcelo)
Host code has all been moved to arch/x86/kvm/x86.c
KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED

When a guest kernel is stopped by the host hypervisor it can look like a soft
lockup to the guest kernel.  This false warning can mask later soft lockup
warnings which may be real.  This patch series adds a method for a host
hypervisor to communicate to a guest kernel that it is being stopped.  The
final patch in the series has the watchdog check this flag when it goes to
issue a soft lockup warning and skip the warning if the guest knows it was
stopped.

It was attempted to solve this in Qemu, but the side effects of saving and
restoring the clock and tsc for each vcpu put the wall clock of the guest behind
by the amount of time of the pause.  This forces a guest to have ntp running
in order to keep the wall clock accurate.

Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Eric B Munson (4):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add ioctl for KVM_KVMCLOCK_CTRL
  Add check for suspended vm in softlockup detector

 Documentation/virtual/kvm/api.txt   |   21 +++++++++++++++++++++
 arch/ia64/include/asm/kvm_para.h    |    5 +++++
 arch/powerpc/include/asm/kvm_para.h |    5 +++++
 arch/s390/include/asm/kvm_para.h    |    5 +++++
 arch/x86/include/asm/kvm_para.h     |    8 ++++++++
 arch/x86/include/asm/pvclock-abi.h  |    1 +
 arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
 arch/x86/kvm/x86.c                  |   22 ++++++++++++++++++++++
 include/asm-generic/kvm_para.h      |   14 ++++++++++++++
 include/linux/kvm.h                 |    3 +++
 kernel/watchdog.c                   |   12 ++++++++++++
 11 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/kvm_para.h

-- 
1.7.5.4

