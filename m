Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1LASar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:30:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43998 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab1LASak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:30:40 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: SVM: Notify if SVM is already in use
Date: Thu,  1 Dec 2011 20:30:18 +0200
Message-Id: <1322764218-4698-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc4
In-Reply-To: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we silently fail if SVM is already in use by a different
virtualization technology.

This is bad since it's non-obvious for the user, and its not too uncommon
for users to have several of these installed on same host.

This patch adds a message to notify the user of the problem.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 arch/x86/kvm/svm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e32243e..8d1a066 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -587,8 +587,11 @@ static int svm_hardware_enable(void *garbage)
 	int me = raw_smp_processor_id();
 
 	rdmsrl(MSR_EFER, efer);
-	if (efer & EFER_SVME)
+	if (efer & EFER_SVME) {
+		printk(KERN_ERR "svm_hardware_enable: SVM already in use on CPU%d. "
+				"Are you already another hypervisor?\n", me);
 		return -EBUSY;
+	}
 
 	if (!has_svm()) {
 		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",
-- 
1.7.8.rc4

