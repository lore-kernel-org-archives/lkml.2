Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2A3VGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:06:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2A3VF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:05:59 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2] KVM: Fix assigned device MSI-X entry setting leak
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Date: Mon, 30 Jan 2012 14:05:54 -0700
Message-ID: <20120130210346.22952.5215.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to prioritize our matching when setting MSI-X vector
entries.  Unused entries should only be used if we don't find
an exact match or else we risk duplicating entries.  This was
causing an ENOSPC return when trying to mask and unmask MSI-X
vectors based on guest MSI-X table updates.

The new KVM_CAP_DEVICE_MSIX_MASK extension indicates the
presence of this fix.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Add capability indicating MSIX_MASKing now works.

The faulting sequence went something like:

Start:
[0] entry 0, vector A
[1] entry 1, vector B
[2] entry 2, vector C

Set entry 1 to 0:
[0] entry 0, vector A
[1] entry 1->1, vector B->0
[2] entry 2, vector C

Set entry 2 to 0:
[0] entry 0, vector A
[1] entry 1->2, vector 0->0 <- incorrectly matched
[2] entry 2, vector C

Set entry 2 to C:
[0] entry 0, vector A
[1] entry 2->2, vector 0->C <- incorrectly matched again
[2] entry 2, vector C

Set entry 1 to B:
[0] entry 0, vector A
[1] entry 2, vector C
[2] entry 2, vector C
-ENOSPC

 Documentation/virtual/kvm/api.txt |    5 +++--
 arch/x86/kvm/x86.c                |    1 +
 include/linux/kvm.h               |    1 +
 virt/kvm/assigned-dev.c           |   21 ++++++++++++++-------
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e1d94bf..dd0b554 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1304,8 +1304,9 @@ Type: vm ioctl
 Parameters: struct kvm_assigned_msix_entry (in)
 Returns: 0 on success, -1 on error
 
-Specifies the routing of an MSI-X assigned device interrupt to a GSI. Setting
-the GSI vector to zero means disabling the interrupt.
+Specifies the routing of an MSI-X assigned device interrupt to a GSI. If
+KVM_CAP_DEVICE_MSIX_MASK is available, setting the GSI vector to zero means
+disabling the interrupt.
 
 struct kvm_assigned_msix_entry {
 	__u32 assigned_dev_id;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14d6cad..a35255e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2057,6 +2057,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_DEVICE_MSIX_MASK:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 68e67e5..64438e6 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -558,6 +558,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_PAPR 68
 #define KVM_CAP_S390_GMAP 71
 #define KVM_CAP_TSC_DEADLINE_TIMER 72
+#define KVM_CAP_DEVICE_MSIX_MASK 73
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 758e3b3..58f3f6b 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -728,7 +728,7 @@ msix_nr_out:
 static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
 				       struct kvm_assigned_msix_entry *entry)
 {
-	int r = 0, i;
+	int r = 0, i, unused = -1;
 	struct kvm_assigned_dev_kernel *adev;
 
 	mutex_lock(&kvm->lock);
@@ -741,17 +741,24 @@ static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
 		goto msix_entry_out;
 	}
 
-	for (i = 0; i < adev->entries_nr; i++)
-		if (adev->guest_msix_entries[i].vector == 0 ||
-		    adev->guest_msix_entries[i].entry == entry->entry) {
+	for (i = 0; i < adev->entries_nr; i++) {
+		if (adev->guest_msix_entries[i].entry == entry->entry) {
 			adev->guest_msix_entries[i].entry = entry->entry;
 			adev->guest_msix_entries[i].vector = entry->gsi;
 			adev->host_msix_entries[i].entry = entry->entry;
 			break;
-		}
+		} else if (unused < 0 && !adev->guest_msix_entries[i].vector)
+			unused = i;
+	}
+
 	if (i == adev->entries_nr) {
-		r = -ENOSPC;
-		goto msix_entry_out;
+		if (unused < 0) {
+			r = -ENOSPC;
+			goto msix_entry_out;
+		}
+		adev->guest_msix_entries[unused].entry = entry->entry;
+		adev->guest_msix_entries[unused].vector = entry->gsi;
+		adev->host_msix_entries[unused].entry = entry->entry;
 	}
 
 msix_entry_out:

