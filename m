Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3AHXjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:39:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:63993 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab3AHXjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:39:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 66/77] KVM: x86: Prevent starting PIT timers in the absence of irqchip support
Date: Tue, 8 Jan 2013 18:35:45 -0500
Message-ID: <1357688156-25387-67-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0924ab2cfa98b1ece26c033d696651fd62896c69 upstream.

User space may create the PIT and forgets about setting up the irqchips.
In that case, firing PIT IRQs will crash the host:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000128
IP: [<ffffffffa10f6280>] kvm_set_irq+0x30/0x170 [kvm]
...
Call Trace:
 [<ffffffffa11228c1>] pit_do_work+0x51/0xd0 [kvm]
 [<ffffffff81071431>] process_one_work+0x111/0x4d0
 [<ffffffff81071bb2>] worker_thread+0x152/0x340
 [<ffffffff81075c8e>] kthread+0x7e/0x90
 [<ffffffff815a4474>] kernel_thread_helper+0x4/0x10

Prevent this by checking the irqchip mode before starting a timer. We
can't deny creating the PIT if the irqchips aren't set up yet as
current user land expects this order to work.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kvm/i8254.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 0150aff..ac06e2a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -280,11 +280,15 @@ static struct kvm_timer_ops kpit_ops = {
 	.is_periodic = kpit_is_periodic,
 };
 
-static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
+static void create_pit_timer(struct kvm *kvm, u32 val, int is_period)
 {
+	struct kvm_kpit_state *ps = &kvm->arch.vpit->pit_state;
 	struct kvm_timer *pt = &ps->pit_timer;
 	s64 interval;
 
+	if (!irqchip_in_kernel(kvm))
+		return;
+
 	interval = muldiv64(val, NSEC_PER_SEC, KVM_PIT_FREQ);
 
 	pr_debug("create pit timer, interval is %llu nsec\n", interval);
@@ -336,13 +340,13 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
         /* FIXME: enhance mode 4 precision */
 	case 4:
 		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)) {
-			create_pit_timer(ps, val, 0);
+			create_pit_timer(kvm, val, 0);
 		}
 		break;
 	case 2:
 	case 3:
 		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)){
-			create_pit_timer(ps, val, 1);
+			create_pit_timer(kvm, val, 1);
 		}
 		break;
 	default:
-- 
1.7.12.1

