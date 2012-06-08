Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2FHOu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:50:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2FHOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:50:27 -0400
Date: Fri, 8 Jun 2012 07:50:12 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-1bccd58bfffc5a677051937b332b71f0686187c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>
References: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Try to spread IRQ vectors to different priority levels
Git-Commit-ID: 1bccd58bfffc5a677051937b332b71f0686187c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:50:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bccd58bfffc5a677051937b332b71f0686187c1
Gitweb:     http://git.kernel.org/tip/1bccd58bfffc5a677051937b332b71f0686187c1
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 7 Jun 2012 15:15:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:44:28 +0200

x86/apic: Try to spread IRQ vectors to different priority levels

When assigning a new vector it is primarially done by adding 8
to the previously given out vector number. Hence, two
consequently allocated vector numbers would likely fall into the
same priority level. Try to spread vector numbers to different
priority levels better by changing the step from 8 to 16.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120607131514.GD4759@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 74c5697..05af3d3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1112,7 +1112,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
-	static int current_offset = VECTOR_OFFSET_START % 8;
+	static int current_offset = VECTOR_OFFSET_START % 16;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
@@ -1148,10 +1148,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 		vector = current_vector;
 		offset = current_offset;
 next:
-		vector += 8;
+		vector += 16;
 		if (vector >= first_system_vector) {
-			/* If out of vectors on large boxen, must share them. */
-			offset = (offset + 1) % 8;
+			offset = (offset + 1) % 16;
 			vector = FIRST_EXTERNAL_VECTOR + offset;
 		}
 		if (unlikely(current_vector == vector))
