Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0ISAiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0ISAiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:38:20 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping fixes 1/4] Fix kvmclock bug
Date: Sat, 18 Sep 2010 14:38:12 -1000
Message-Id: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If preempted after kvmclock values are updated, but before hardware
virtualization is entered, the last tsc time as read by the guest is
never set.  It underflows the next time kvmclock is updated if there
has not yet been a successful entry / exit into hardware virt.

Fix this by simply setting last_tsc to the newly read tsc value so
that any computed nsec advance of kvmclock is nulled.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a51635e..0b021e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1095,6 +1095,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_kernel_ns = kernel_ns;
+	vcpu->last_guest_tsc = tsc_timestamp;
 	vcpu->hv_clock.flags = 0;
 
 	/*
-- 
1.6.6.1

