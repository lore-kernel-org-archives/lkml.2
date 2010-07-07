Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0GGNCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:02:47 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:60582 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408Ab0GGNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:02:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: avi@redhat.com
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: [PATCH] x86: KVM, fix lock imbalance
Date: Wed,  7 Jul 2010 15:02:25 +0200
Message-Id: <1278507745-32746-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that there is an omitted unlock in kvm_create_pit in one fail
path. Add proper unlock there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Gleb Natapov <gleb@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/i8254.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 467cc47..70db4d4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -696,6 +696,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 
 	pit->wq = create_singlethread_workqueue("kvm-pit-wq");
 	if (!pit->wq) {
+		mutex_unlock(&pit->pit_state.lock);
 		kfree(pit);
 		return NULL;
 	}
-- 
1.7.1


