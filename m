Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0DVTci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:32:38 -0400
Received: from kroah.org ([198.145.64.141]:41610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab0DVTaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:30:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:24 2010
Message-Id: <20100422190924.336133776@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andre Przywara <andre.przywara@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [189/197] KVM: allow bit 10 to be cleared in MSR_IA32_MC4_CTL
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Przywara <andre.przywara@amd.com>

(Cherry-picked from commit 114be429c8cd44e57f312af2bbd6734e5a185b0d)

There is a quirk for AMD K8 CPUs in many Linux kernels (see
arch/x86/kernel/cpu/mcheck/mce.c:__mcheck_cpu_apply_quirks()) that
clears bit 10 in that MCE related MSR. KVM can only cope with all
zeros or all ones, so it will inject a #GP into the guest, which
will let it panic.
So lets add a quirk to the quirk and ignore this single cleared bit.
This fixes -cpu kvm64 on all machines and -cpu host on K8 machines
with some guest Linux kernels.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -799,9 +799,13 @@ static int set_msr_mce(struct kvm_vcpu *
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
 			u32 offset = msr - MSR_IA32_MC0_CTL;
-			/* only 0 or all 1s can be written to IA32_MCi_CTL */
+			/* only 0 or all 1s can be written to IA32_MCi_CTL
+			 * some Linux kernels though clear bit 10 in bank 4 to
+			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
+			 * this to avoid an uncatched #GP in the guest
+			 */
 			if ((offset & 0x3) == 0 &&
-			    data != 0 && data != ~(u64)0)
+			    data != 0 && (data | (1 << 10)) != ~(u64)0)
 				return -1;
 			vcpu->arch.mce_banks[offset] = data;
 			break;


