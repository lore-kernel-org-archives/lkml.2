Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0JZGo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:44:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:55641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab0JZGoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:44:55 -0400
Date: Tue, 26 Oct 2010 06:44:33 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1288015419-29543-2-git-send-email-robert.richter@amd.com>
References: <1288015419-29543-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] mce, amd: Implement mce_threshold_block_init() helper function
Message-ID: <tip-9c37c9d89773ee9da9f6af28ee37d931bd045711@git.kernel.org>
Git-Commit-ID: 9c37c9d89773ee9da9f6af28ee37d931bd045711
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:44:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c37c9d89773ee9da9f6af28ee37d931bd045711
Gitweb:     http://git.kernel.org/tip/9c37c9d89773ee9da9f6af28ee37d931bd045711
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 25 Oct 2010 16:03:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 18:59:42 +0200

mce, amd: Implement mce_threshold_block_init() helper function

This patch adds a helper function for the initial setup of an
mce threshold block. The LVT offset is passed as argument. Also
making variable threshold_defaults local as it is only used in
function mce_amd_feature_init(). Function
threshold_restart_bank() is extended to setup the LVT offset,
the change is backward compatible. Thus, now there is only a
single wrmsrl() to setup the block.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1288015419-29543-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   48 ++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 80c4823..f438318 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -59,12 +59,6 @@ struct threshold_block {
 	struct list_head	miscj;
 };
 
-/* defaults used early on boot */
-static struct threshold_block threshold_defaults = {
-	.interrupt_enable	= 0,
-	.threshold_limit	= THRESHOLD_MAX,
-};
-
 struct threshold_bank {
 	struct kobject		*kobj;
 	struct threshold_block	*blocks;
@@ -89,6 +83,8 @@ static void amd_threshold_interrupt(void);
 struct thresh_restart {
 	struct threshold_block	*b;
 	int			reset;
+	int			set_lvt_off;
+	int			lvt_off;
 	u16			old_limit;
 };
 
@@ -116,6 +112,12 @@ static void threshold_restart_bank(void *_tr)
 		    (new_count & THRESHOLD_MAX);
 	}
 
+	if (tr->set_lvt_off) {
+		/* set new lvt offset */
+		mci_misc_hi &= ~MASK_LVTOFF_HI;
+		mci_misc_hi |= tr->lvt_off << 20;
+	}
+
 	tr->b->interrupt_enable ?
 	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
 	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
@@ -124,13 +126,25 @@ static void threshold_restart_bank(void *_tr)
 	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
 }
 
+static void mce_threshold_block_init(struct threshold_block *b, int offset)
+{
+	struct thresh_restart tr = {
+		.b			= b,
+		.set_lvt_off		= 1,
+		.lvt_off		= offset,
+	};
+
+	b->threshold_limit		= THRESHOLD_MAX;
+	threshold_restart_bank(&tr);
+};
+
 /* cpu init entry point, called from mce.c with preempt off */
 void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
+	struct threshold_block b;
 	unsigned int cpu = smp_processor_id();
 	u32 low = 0, high = 0, address = 0;
 	unsigned int bank, block;
-	struct thresh_restart tr;
 	int lvt_off = -1;
 	u8 offset;
 
@@ -186,16 +200,13 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 				continue;
 			}
 
-			high &= ~MASK_LVTOFF_HI;
-			high |= lvt_off << 20;
-			wrmsr(address, low, high);
-
-			threshold_defaults.address = address;
-			tr.b = &threshold_defaults;
-			tr.reset = 0;
-			tr.old_limit = 0;
-			threshold_restart_bank(&tr);
+			memset(&b, 0, sizeof(b));
+			b.cpu		= cpu;
+			b.bank		= bank;
+			b.block		= block;
+			b.address	= address;
 
+			mce_threshold_block_init(&b, offset);
 			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
@@ -298,9 +309,8 @@ store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
 
 	b->interrupt_enable = !!new;
 
+	memset(&tr, 0, sizeof(tr));
 	tr.b		= b;
-	tr.reset	= 0;
-	tr.old_limit	= 0;
 
 	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
@@ -321,10 +331,10 @@ store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
 	if (new < 1)
 		new = 1;
 
+	memset(&tr, 0, sizeof(tr));
 	tr.old_limit = b->threshold_limit;
 	b->threshold_limit = new;
 	tr.b = b;
-	tr.reset = 0;
 
 	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
