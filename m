Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1LEUTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:19:30 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:34711 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab1LEUTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:19:11 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by host
Date: Mon,  5 Dec 2011 15:18:59 -0500
Message-Id: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: levinsasha928@gmail.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Eric B Munson (5):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add ioctl for KVMCLOCK_GUEST_STOPPED
  Add generic stubs for kvm stop check functions
  Add check for suspended vm in softlockup detector

 Documentation/virtual/kvm/api.txt  |   12 ++++++++++++
 arch/x86/include/asm/kvm_host.h    |    2 ++
 arch/x86/include/asm/kvm_para.h    |    1 +
 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/kernel/kvmclock.c         |   21 +++++++++++++++++++++
 arch/x86/kvm/x86.c                 |   20 ++++++++++++++++++++
 include/asm-generic/kvm_para.h     |   14 ++++++++++++++
 include/linux/kvm.h                |    2 ++
 kernel/watchdog.c                  |   12 ++++++++++++
 9 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/kvm_para.h

-- 
1.7.5.4

