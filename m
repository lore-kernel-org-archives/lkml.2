Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3ADAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:49:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30217 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3ADAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
Date: Thu,  3 Jan 2013 16:48:23 -0800
Message-Id: <1357260531-11115-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trampoline code is executed by APs with kernel low mapping.
We need to set trampoline code to EXEC early before we do smp
AP bootings.

Found the problem after switching to #PF handler set page table,
and we do not set initial kernel low mapping with EXEC anymore in
arch/x86/kernel/head_64.S.

Change to use early_initcall instead that will make sure tramopline
will have EXEC set.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/realmode/init.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 8045026..b96fe6f 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -111,5 +111,9 @@ static int __init set_real_mode_permissions(void)
 
 	return 0;
 }
-
-arch_initcall(set_real_mode_permissions);
+/*
+ * Trampoline will be executed by APs with SMP.
+ * So we need to set it to EXEC in do_pre_smp_initcalls() at least,
+ * and that needs early_initcall().
+ */
+early_initcall(set_real_mode_permissions);
-- 
1.7.10.4

