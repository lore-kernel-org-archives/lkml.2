Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab2JAXBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:10 -0400
Received: from 1wt.eu ([62.212.114.60]:35267 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab2JAXA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:57 -0400
Message-Id: <20121001225159.224802134@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 038/180] KVM: x86: Prevent starting PIT timers in the absence of irqchip support
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 0924ab2cfa98b1ece26c033d696651fd62896c69 upstream

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
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kvm/i8254.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 88ad162..7e361b4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -277,11 +277,15 @@ static struct kvm_timer_ops kpit_ops = {
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
 
 	pr_debug("pit: create pit timer, interval is %llu nsec\n", interval);
@@ -333,13 +337,13 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
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
1.7.2.1.45.g54fbc



