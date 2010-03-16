Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966418Ab0CPOtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:49:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966317Ab0CPOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:49:08 -0400
Date: Tue, 16 Mar 2010 14:48:27 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, justinmattock@gmail.com, hpa@zytor.com,
       mingo@redhat.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B9E15D30200007800034D23@vpn.id2.novell.com>
References: <4B9E15D30200007800034D23@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix placement of FIX_OHCI1394_BASE
Message-ID: <tip-ff30a0543e9a6cd732582063e7cae951cdb7acf2@git.kernel.org>
Git-Commit-ID: ff30a0543e9a6cd732582063e7cae951cdb7acf2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:48:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff30a0543e9a6cd732582063e7cae951cdb7acf2
Gitweb:     http://git.kernel.org/tip/ff30a0543e9a6cd732582063e7cae951cdb7acf2
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 15 Mar 2010 10:11:15 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 11:16:27 +0100

x86: Fix placement of FIX_OHCI1394_BASE

Ever for 32-bit with sufficiently high NR_CPUS, and starting
with commit 789d03f584484af85dbdc64935270c8e45f36ef7 also for
64-bit, the statically allocated early fixmap page tables were
not covering FIX_OHCI1394_BASE, leading to a boot time crash
when "ohci1394_dma=early" was used. Despite this entry not being
a permanently used one, it needs to be moved into the permanent
range since it has to be close to FIX_DBGP_BASE and
FIX_EARLYCON_MEM_BASE.

Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>
Fixes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org> # [as far back as long as it still applies]
LKML-Reference: <4B9E15D30200007800034D23@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 635f03b..d07b44f 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -132,9 +135,6 @@ enum fixed_addresses {
 	   (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
 	 : __end_of_permanent_fixed_addresses,
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
