Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1HYUKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:10:46 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:50281 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab1HYUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:10:44 -0400
X-AuditID: 1209190f-b7b44ae000000a24-62-4e56aba856fd
From: Andy Lutomirski <luto@MIT.EDU>
To: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86-32: Fix boot with CONFIG_X86_INVD_BUG
Date: Thu, 25 Aug 2011 16:10:33 -0400
Message-Id: <0a627e9f49e26554cacdb4049e4c09fa94ca76b6.1314302910.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
References: <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsUixG6nortidZifwfv/yhZz1q9hs+i7cpTd
	YtpGcYtdd84wW1zeNYfNYsulZlaLzZumMls86nvL7sDhcavtD7PHzll32T3enTvH7nFixm8W
	j8+b5DxOtHxhDWCL4rJJSc3JLEst0rdL4Mp4cP8Pc8EO7or98+YxNTCe5uxi5OSQEDCR+LB6
	GhuELSZx4d56IJuLQ0hgH6PElc7DjCAJIYENjBIdtz0gEs+YJO62LWYCSbAJqEh0LH0AZosI
	eEpsbvjCClLELNDEJLHjwwmwbmEBK4mP7Z/ZQWwWAVWJ1n/rgIo4OHgFgiQ2P9aB2CwnceTy
	c7A5nAKBEk82PWOFWBwgsfzqauYJjHwLGBlWMcqm5Fbp5iZm5hSnJusWJyfm5aUW6Zro5WaW
	6KWmlG5iBAUkpyT/DsZvB5UOMQpwMCrx8F7MCfMTYk0sK67MPcQoycGkJMq7HBjOQnxJ+SmV
	GYnFGfFFpTmpxYcYJTiYlUR4m0OBcrwpiZVVqUX5MClpDhYlcd7GHQ5+QgLpiSWp2ampBalF
	MFkZDg4lCd7NIEMFi1LTUyvSMnNKENJMHJwgw3mAhq8EqeEtLkjMLc5Mh8ifYlSUEufdA5IQ
	AElklObB9cISxitGcaBXhHnngVTxAJMNXPcroMFMQIM5fgWBDC5JREhJNTCyBG8pK1kaf8yl
	NIY/ImLbBVkn6y+3zkpbyt5rvsp+x8r9xuFb7Rfntu/4I3BrhUJB/JuH/7p8pPM7bk55sa3q
	yvsbPz+s2Vl5MMGLZY9YK3/r0Q/cK70qZjGFrGDJN02deTz379UXb+WimW4fnbRFesPMI6sW
	vU3csP6ikmhV+MJ3HUe5tn51V2Ipzkg01GIuKk4EAM8+1J3zAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

entry_32.S contained a hardcoded alternative instruction entry, and
the format changed in:

commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
Author: Andy Lutomirski <luto@mit.edu>
Date:   Wed Jul 13 09:24:10 2011 -0400

    x86: Make alternative instruction pointers relative

Replace it with the altinstruction_entry macro.  This fixes the
32-bit boot with CONFIG_X86_INVD_BUG=y.

Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

Arnaud, can you test this?

Thanks,
Andy

 arch/x86/kernel/entry_32.S |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5c1a9197..f3f6f53 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -54,6 +54,7 @@
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -873,12 +874,7 @@ ENTRY(simd_coprocessor_error)
 661:	pushl_cfi $do_general_protection
 662:
 .section .altinstructions,"a"
-	.balign 4
-	.long 661b
-	.long 663f
-	.word X86_FEATURE_XMM
-	.byte 662b-661b
-	.byte 664f-663f
+	altinstruction_entry 661b, 663f, X86_FEATURE_XMM, 662b-661b, 664f-663f
 .previous
 .section .altinstr_replacement,"ax"
 663:	pushl $do_simd_coprocessor_error
-- 
1.7.6

