Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1JaUHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:07:35 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:47613 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1JaUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:07:33 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 0/6 V2] Avoid soft lockup message when KVM is stopped by host
Date: Mon, 31 Oct 2011 16:07:24 -0400
Message-Id: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



Eric B Munson (6):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add ioctl for KVM_GUEST_STOPPED
  Add generic stubs for kvm stop check functions
  Add check for suspended vm in softlockup detector
  Add age out of guest paused flag

 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/include/asm/pvclock.h     |    7 +++++
 arch/x86/kernel/kvmclock.c         |   19 ++++++++++++++
 arch/x86/kvm/x86.c                 |   48 ++++++++++++++++++++++++++++++++++++
 include/asm-generic/pvclock.h      |   19 ++++++++++++++
 include/linux/kvm.h                |    4 +++
 include/linux/kvm_host.h           |    2 +
 kernel/watchdog.c                  |    9 ++++++
 8 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/pvclock.h

-- 
1.7.5.4

