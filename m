Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab0HMIXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356Ab0HMIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:23:21 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: kvm@vger.kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] kvm: destroy workqueue on kvm_create_pit() failures
Date: Fri, 13 Aug 2010 16:23:06 +0800
Message-Id: <1281687786-3200-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel needs to destroy workqueue if kvm_create_pit() fails, otherwise
after pit is freed, the workqueue is leaked.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 0fd6378..f539c3c 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -742,7 +742,7 @@ fail:
 	kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	kvm_unregister_irq_ack_notifier(kvm, &pit_state->irq_ack_notifier);
 	kvm_free_irq_source_id(kvm, pit->irq_source_id);
-
+	destroy_workqueue(pit->wq);
 	kfree(pit);
 	return NULL;
 }
-- 
1.7.2.1

