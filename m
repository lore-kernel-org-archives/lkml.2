Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1K2MYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:24:08 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52341 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1K2MWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:48 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 3/6] ARM: Allow ASID 0 to be allocated to tasks
Date: Tue, 29 Nov 2011 12:22:29 +0000
Message-Id: <1322569352-23584-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 29 Nov 2011 12:22:39.0363 (UTC) FILETIME=[95CCF530:01CCAE91]
X-MC-Unique: 111112912224501801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pATCONMa007604

From: Will Deacon <will.deacon@arm.com>

Now that ASID 0 is no longer used as a reserved value, allow it to be
allocated to tasks.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mm/context.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index a062230..1d5014b 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -100,7 +100,7 @@ static void reset_context(void *info)
 		return;
 
 	smp_rmb();
-	asid = cpu_last_asid + cpu + 1;
+	asid = cpu_last_asid + cpu;
 
 	flush_context();
 	set_mm_context(mm, asid);
@@ -149,13 +149,13 @@ void __new_context(struct mm_struct *mm)
 	 * to start a new version and flush the TLB.
 	 */
 	if (unlikely((asid & ~ASID_MASK) == 0)) {
-		asid = cpu_last_asid + smp_processor_id() + 1;
+		asid = cpu_last_asid + smp_processor_id();
 		flush_context();
 #ifdef CONFIG_SMP
 		smp_wmb();
 		smp_call_function(reset_context, NULL, 1);
 #endif
-		cpu_last_asid += NR_CPUS;
+		cpu_last_asid += NR_CPUS - 1;
 	}
 
 	set_mm_context(mm, asid);

