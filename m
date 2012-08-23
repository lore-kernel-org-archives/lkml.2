Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab2HWCRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:17:40 -0400
Received: from mail1.windriver.com ([147.11.146.13]:42138 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2HWCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:17:38 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v2][PATCH 2/3] powerpc: Bail out of KGDB when we've been triggered
Date: Thu, 23 Aug 2012 10:10:19 +0800
Message-ID: <1345687820-5248-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
References: <1345687820-5248-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to skip a breakpoint exception when it occurs after
a breakpoint has already been removed.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
v2: simply kgdb_skipexception() return path. 

 arch/powerpc/kernel/kgdb.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index bbabc5a..05adb69 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -101,6 +101,21 @@ static int computeSignal(unsigned int tt)
 	return SIGHUP;		/* default for things we don't know about */
 }
 
+/**
+ *
+ *	kgdb_skipexception - Bail out of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ *
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs)
+{
+	return kgdb_isremovedbreak(regs->nip);
+}
+
 static int kgdb_call_nmi_hook(struct pt_regs *regs)
 {
 	kgdb_nmicallback(raw_smp_processor_id(), regs);
-- 
1.5.6

