Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2ATRni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:43:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56905 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2ATRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:42:47 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [PATCH v3 3/6] ARM: Allow ASID 0 to be allocated to tasks
Date: Fri, 20 Jan 2012 17:42:29 +0000
Message-Id: <1327081352-13178-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.rc1.3.gb6310
In-Reply-To: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 20 Jan 2012 17:42:38.0599 (UTC) FILETIME=[E6EAE170:01CCD79A]
X-MC-Unique: 112012017424406901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q0KHhiob006983

From: Will Deacon <will.deacon@arm.com>

Now that ASID 0 is no longer used as a reserved value, allow it to be
allocated to tasks.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 97842a0..efa413a 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -118,7 +118,7 @@ static void reset_context(void *info)
 		return;
 
 	smp_rmb();
-	asid = cpu_last_asid + cpu + 1;
+	asid = cpu_last_asid + cpu;
 
 	flush_context();
 	set_mm_context(mm, asid);
@@ -167,13 +167,13 @@ void __new_context(struct mm_struct *mm)
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

