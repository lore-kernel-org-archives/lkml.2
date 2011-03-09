Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab1CIAdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:33:46 -0500
Received: from mout.perfora.net ([74.208.4.195]:61976 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab1CIAdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:33:45 -0500
From: Stephen Wilson <wilsons@start.ca>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 2/5] x86: mark associated mm when running a task in 32 bit compatibility mode
Date: Tue,  8 Mar 2011 19:31:58 -0500
Message-Id: <1299630721-4337-3-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1299630721-4337-1-git-send-email-wilsons@start.ca>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:mWb1fSxCj29l1TiE00UZxNclCfxdsVQ2bZfalgGwvu4
 2CQWcgRrO6TJy7OR7CvB6l4a8N9+vrlrD123JH56Qhe1KmuNT7
 0kgW0OGKx5k81MkcyJhVUulUg93PnEcN+YNVLvsr8p4tJCfQPc
 4okRmKZqWrMi3zDJB6U4VEtZsZSb6qTVnwBIC6DuLZQ/Oe38p2
 jfTT4SDoQUJVP4sBKZA1bDwxuPxRT0Xm51VrbSmQCY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply follows the same practice as for setting the TIF_IA32 flag.
In particular, an mm is marked as holding 32-bit tasks when a 32-bit binary is
exec'ed.  Both ELF and a.out formats are updated.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 arch/x86/ia32/ia32_aout.c    |    1 +
 arch/x86/kernel/process_64.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 2d93bdb..95cde43 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -298,6 +298,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* OK, This is the point of no return */
 	set_personality(PER_LINUX);
 	set_thread_flag(TIF_IA32);
+	current->mm->context.compat = 1;
 
 	setup_new_exec(bprm);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bd387e8..35f1221 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -501,6 +501,10 @@ void set_personality_64bit(void)
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
 
+	/* Ensure the corresponding mm is not marked. */
+	if (current->mm)
+		current->mm->context.compat = 0;
+
 	/* TBD: overwrites user setup. Should have two bits.
 	   But 64bit processes have always behaved this way,
 	   so it's not too bad. The main problem is just that
@@ -516,6 +520,10 @@ void set_personality_ia32(void)
 	set_thread_flag(TIF_IA32);
 	current->personality |= force_personality32;
 
+	/* Mark the associated mm as containing 32-bit tasks. */
+	if (current->mm)
+		current->mm->context.compat = 1;
+
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
 }
-- 
1.7.3.5

