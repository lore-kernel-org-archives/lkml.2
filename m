Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab2CGBwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:52:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964983Ab2CGBwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:52:04 -0500
X-IronPort-AV: E=Sophos;i="4.73,542,1325433600"; 
   d="scan'208";a="4474578"
Message-ID: <4F56BFA8.10300@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 09:53:44 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 1/2 v2] kvm: notify host when guest paniced
References: <4F56BEF2.4020405@cn.fujitsu.com>
In-Reply-To: <4F56BEF2.4020405@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:50:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 09:50:08,
	Serialize complete at 2012-03-07 09:50:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation is the same as xen:
register panic notifier, and call hypercall when the guest
is paniced.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/kernel/kvm.c    |   12 ++++++++++++
 include/linux/kvm_para.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f0c6fd6..7f9afc5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -331,6 +331,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
+static int
+kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
+{
+	kvm_hypercall0(KVM_HC_GUEST_PANICED);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_panic_nb = {
+	.notifier_call = kvm_pv_panic_notify,
+};
+
 static u64 kvm_steal_clock(int cpu)
 {
 	u64 steal;
@@ -417,6 +428,7 @@ void __init kvm_guest_init(void)
 
 	paravirt_ops_setup();
 	register_reboot_notifier(&kvm_pv_reboot_nb);
+	atomic_notifier_chain_register(&panic_notifier_list, &kvm_pv_panic_nb);
 	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
 		spin_lock_init(&async_pf_sleepers[i].lock);
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index ff476dd..d030a22 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_GUEST_PANICED		5
 
 /*
  * hypercalls use architecture specific
-- 
1.7.1

