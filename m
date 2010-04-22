Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0DVUIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:08:42 -0400
Received: from kroah.org ([198.145.64.141]:60113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab0DVUCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195418.370836445@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Avi Kivity <avi@redhat.com>
Subject: [130/139] KVM: SVM: Fix memory leaks that happen when svm_create_vcpu() fails
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

(Cherry-picked from commit b7af40433870aa0636932ad39b0c48a0cb319057)

svm_create_vcpu() does not free the pages allocated during the creation
when it fails to complete the allocations. This patch fixes it.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -698,29 +698,28 @@ static struct kvm_vcpu *svm_create_vcpu(
 	if (err)
 		goto free_svm;
 
+	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL);
-	if (!page) {
-		err = -ENOMEM;
+	if (!page)
 		goto uninit;
-	}
 
-	err = -ENOMEM;
 	msrpm_pages = alloc_pages(GFP_KERNEL, MSRPM_ALLOC_ORDER);
 	if (!msrpm_pages)
-		goto uninit;
+		goto free_page1;
 
 	nested_msrpm_pages = alloc_pages(GFP_KERNEL, MSRPM_ALLOC_ORDER);
 	if (!nested_msrpm_pages)
-		goto uninit;
-
-	svm->msrpm = page_address(msrpm_pages);
-	svm_vcpu_init_msrpm(svm->msrpm);
+		goto free_page2;
 
 	hsave_page = alloc_page(GFP_KERNEL);
 	if (!hsave_page)
-		goto uninit;
+		goto free_page3;
+
 	svm->nested.hsave = page_address(hsave_page);
 
+	svm->msrpm = page_address(msrpm_pages);
+	svm_vcpu_init_msrpm(svm->msrpm);
+
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
 
 	svm->vmcb = page_address(page);
@@ -737,6 +736,12 @@ static struct kvm_vcpu *svm_create_vcpu(
 
 	return &svm->vcpu;
 
+free_page3:
+	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
+free_page2:
+	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
+free_page1:
+	__free_page(page);
 uninit:
 	kvm_vcpu_uninit(&svm->vcpu);
 free_svm:


