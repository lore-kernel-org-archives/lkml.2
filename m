Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1FUAAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1FUAAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:00 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 3/9] Leave TSC synchronization window open with each new sync
Date: Mon, 20 Jun 2011 16:59:31 -0700
Message-Id: <1308614377-18627-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when the TSC is written by the guest, the variable
ns is updated to force the current write to appear to have taken
place at the time of the first write in this sync phase.  This
leaves a cliff at the end of the match window where updates will
fall of the end.  There are two scenarios where this can be a
problem in practe - first, on a system with a large number of
VCPUs, the sync period may last for an extended period of time.

The second way this can happen is if the VM reboots very rapidly
and we catch a VCPU TSC synchronization just around the edge.
We may be unaware of the reboot, and thus the first VCPU might
synchronize with an old set of the timer (at, say 0.97 seconds
ago, when first powered on).  The second VCPU can come in 0.04
seconds later to try to synchronize, but it misses the window
because it is just over the threshold.

Instead, stop doing this artificial setback of the ns variable
and just update it with every write of the TSC.

It may be observed that doing so causes values computed by
compute_guest_tsc to diverge slightly across CPUs - note that
the last_tsc_ns and last_tsc_write variable are used here, and
now they last_tsc_ns will be different for each VCPU, reflecting
the actual time of the update.

However, compute_guest_tsc is used only for guests which already
have TSC stability issues, and further, note that the previous
patch has caused last_tsc_write to be incremented by the difference
in nanoseconds, converted back into guest cycles.  As such, only
boundary rounding errors should be visible, which given the
resolution in nanoseconds, is going to only be a few cycles and
only visible in cross-CPU consistency tests.  The problem can be
fixed by adding a new set of variables to track the start offset
and start write value for the current sync cycle.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 457bd79..2176714 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1076,7 +1076,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 			offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
 			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
-		ns = kvm->arch.last_tsc_nsec;
 	}
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = data;
-- 
1.7.1

