Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2A3SGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2A3SGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:06:53 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] KVM: Fix assigned device MSI-X entry setting leak
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Date: Mon, 30 Jan 2012 11:06:50 -0700
Message-ID: <20120130180540.17524.62489.stgit@bling.home>
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

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

---

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

Userspace will need to test for this bug (or do we want to set
a feature flag?).

 virt/kvm/assigned-dev.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 758e3b3..798a090 100644
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
@@ -741,17 +741,26 @@ static int kvm_vm_ioctl_set_msix_entry(struct kvm *kvm,
 		goto msix_entry_out;
 	}
 
-	for (i = 0; i < adev->entries_nr; i++)
-		if (adev->guest_msix_entries[i].vector == 0 ||
-		    adev->guest_msix_entries[i].entry == entry->entry) {
+	for (i = 0; i < adev->entries_nr; i++) {
+		if (unused < 0 && !adev->guest_msix_entries[i].vector)
+			unused = i;
+
+		if (adev->guest_msix_entries[i].entry == entry->entry) {
 			adev->guest_msix_entries[i].entry = entry->entry;
 			adev->guest_msix_entries[i].vector = entry->gsi;
 			adev->host_msix_entries[i].entry = entry->entry;
 			break;
 		}
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

