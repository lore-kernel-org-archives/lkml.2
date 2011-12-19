Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1LSO6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:58:30 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43856 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1LSO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:58:23 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [RFC PATCH v2 3/6] ARM: Allow ASID 0 to be allocated to tasks
Date: Mon, 19 Dec 2011 14:57:50 +0000
Message-Id: <1324306673-4282-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
References: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 19 Dec 2011 14:58:09.0402 (UTC) FILETIME=[9F32EDA0:01CCBE5E]
X-MC-Unique: 111121914581808001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pBJEwZcD030988

From: Will Deacon <will.deacon@arm.com>

Now that ASID 0 is no longer used as a reserved value, allow it to be
allocated to tasks.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
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

