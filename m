Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab1KDQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:55:47 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:35670 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873Ab1KDQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:55:18 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6 V3]  Avoid soft lockup message when KVM is stopped by host
Date: Fri,  4 Nov 2011 12:55:06 -0400
Message-Id: <1320425712-5312-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Eric B Munson (6):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add ioctl for KVM_GUEST_STOPPED
  Add generic stubs for kvm stop check functions
  Add check for suspended vm in softlockup detector
  Add age out of guest paused flag

 arch/x86/include/asm/kvm_host.h    |    3 ++
 arch/x86/include/asm/kvm_para.h    |    1 +
 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/kernel/kvmclock.c         |   21 ++++++++++++++
 arch/x86/kvm/x86.c                 |   52 ++++++++++++++++++++++++++++++++++++
 include/asm-generic/kvm_para.h     |   14 +++++++++
 include/linux/kvm.h                |    4 +++
 include/linux/kvm_host.h           |    2 +
 kernel/watchdog.c                  |    9 ++++++
 9 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/kvm_para.h

-- 
1.7.5.4

