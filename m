Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1FESDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:03:44 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:44934 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644Ab1FESDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:03:02 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-33-4debc4d7b5b1
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 7/9] x86-64: Fill unused parts of the vsyscall page with 0xcc
Date: Sun,  5 Jun 2011 13:50:23 -0400
Message-Id: <ed54bfcfbe50a9070d20ec1edbe0d149e22a4568.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsUixCmqrXv9yGtfg8btZhZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4uwhCYsDv56yWby/up3N4vKuOWwWO+5cYbN40nyd0WLLpWZWi8dr
	njNbfJi4gc1i86apzBaP+t6yW1x6/4HF4seGx6wOQh7fW/tYPI6dOczocavtD7PH/J0fGT2W
	dPxg99g56y67x+YVWh7/Xx5h85j45gajx6ZVnWwe786dY/c4MeM3i8fxM84enzfJeRza/oYt
	gD+KyyYlNSezLLVI3y6BK+PLgUvMBVc4K9asEW5gvMvexcjJISFgIjHh914oW0ziwr31bCC2
	kMA+Rond2z26GLmA7PWMEj+ufWCFcJ4ySWybMh2sik1ARaJj6QOmLkYODhEBfYmrnxlBapgF
	5rNKbDrdzQJSIywQIPHx9Dcwm0VAVeJ4YzcriM0rECSx6vc2NpBeCQEFifOr8kHCnAIGEheu
	n2WFOEJf4tDbk2y4xCcwCixgZFjFKJuSW6Wbm5iZU5yarFucnJiXl1qka6KXm1mil5pSuokR
	HHWS/DsYvx1UOsQowMGoxMO7Y81rXyHWxLLiytxDjJIcTEqivAsOA4X4kvJTKjMSizPii0pz
	UosPMUpwMCuJ8NaJvPIV4k1JrKxKLcqHSUlzsCiJ886SVPcVEkhPLEnNTk0tSC2CycpwcChJ
	8GoAk4uQYFFqempFWmZOCUKaiYMTZDgP0HBzkBre4oLE3OLMdIj8KUZdjq0n3h5kFGLJy89L
	lRLnNQQpEgApyijNg5sDS5avGMWB3hLm5QSp4gEmWrhJr4CWMAEtOe4E8kFxSSJCSqqB0fDH
	qZUdFYc61e4lcKsk9az5Hhp2w2e59RrBeuXCidN0FsrMeFw/2fx51ofLT5afD/KYciH3+NxL
	nssFZ1q/N/nuMdl4+gbvfZc3/pxbWuE6K/TPVdPWdC3O8iKmn44T6oz51qczVxSmzj91dFbS
	Eqs1kZJKxlM+fEjbIS3geFlH1avzTv3iOCWW4oxEQy3mouJEALPKOfhxAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jumping to 0x00 might do something depending on the following bytes.
Jumping to 0xcc is a trap.  So fill the unused parts of the vsyscall
page with 0xcc to make it useless for exploits to jump there.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4f90082..8017471 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -166,22 +166,20 @@ SECTIONS
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
+	.vsyscall : AT(VLOAD(.vsyscall)) {
 		*(.vsyscall_0)
-	} :user
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		. = ALIGN(L1_CACHE_BYTES);
 		*(.vsyscall_fn)
-	}
 
-	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		. = 1024;
 		*(.vsyscall_1)
-	}
-	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+
+		. = 2048;
 		*(.vsyscall_2)
-	}
 
+		. = 4096;  /* Pad the whole page. */
+	} :user =0xcc
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
-- 
1.7.5.2

