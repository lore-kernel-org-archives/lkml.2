Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2FXQZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab2FXQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:24:51 -0400
Date: Sun, 24 Jun 2012 19:24:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv9 5/8] kvm: eoi msi documentation
Message-ID: <6a07482e6f728fdd00fd00c688a87edb59bbd700.1340554550.git.mst@robin.redhat.com>
References: <cover.1340554550.git.mst@robin.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1340554550.git.mst@robin.redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new EOI MSR. Couldn't decide whether this change belongs
conceptually on guest or host side, so a separate patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/virtual/kvm/msr.txt |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/msr.txt b/Documentation/virtual/kvm/msr.txt
index 96b41bd..5ed05b0 100644
--- a/Documentation/virtual/kvm/msr.txt
+++ b/Documentation/virtual/kvm/msr.txt
@@ -223,3 +223,37 @@ MSR_KVM_STEAL_TIME: 0x4b564d03
 		steal: the amount of time in which this vCPU did not run, in
 		nanoseconds. Time during which the vcpu is idle, will not be
 		reported as steal time.
+
+MSR_KVM_EOI_EN: 0x4b564d04
+	data: Bit 0 is 1 when PV end of interrupt is enabled on the vcpu; 0
+	when disabled.  Bit 1 is reserved and must be zero.  When PV end of
+	interrupt is enabled (bit 0 set), bits 63-2 hold a 4-byte aligned
+	physical address of a 4 byte memory area which must be in guest RAM and
+	must be zeroed.
+
+	The first, least significant bit of 4 byte memory location will be
+	written to by the hypervisor, typically at the time of interrupt
+	injection.  Value of 1 means that guest can skip writing EOI to the apic
+	(using MSR or MMIO write); instead, it is sufficient to signal
+	EOI by clearing the bit in guest memory - this location will
+	later be polled by the hypervisor.
+	Value of 0 means that the EOI write is required.
+
+	It is always safe for the guest to ignore the optimization and perform
+	the APIC EOI write anyway.
+
+	Hypervisor is guaranteed to only modify this least
+	significant bit while in the current VCPU context, this means that
+	guest does not need to use either lock prefix or memory ordering
+	primitives to synchronise with the hypervisor.
+
+	However, hypervisor can set and clear this memory bit at any time:
+	therefore to make sure hypervisor does not interrupt the
+	guest and clear the least significant bit in the memory area
+	in the window between guest testing it to detect
+	whether it can skip EOI apic write and between guest
+	clearing it to signal EOI to the hypervisor,
+	guest must both read the least significant bit in the memory area and
+	clear it using a single CPU instruction, such as test and clear, or
+	compare and exchange.
+
-- 
1.6.3.2.307.gdf0b

