Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1EaOPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:21 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:43565 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab1EaOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:17 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-96-4de4f7b39e28
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
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 07/10] x86-64: Fill unused parts of the vsyscall page with 0xcc
Date: Tue, 31 May 2011 10:14:05 -0400
Message-Id: <8b8deba846a0b163cd92a693092623f277acb89a.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsUixCmqrLv5+xNfg7V/FSzmrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxYFfT9ks3l/dzmZxedccNosnzdcZLbZcama1+DBxA5vF5k1TmS0e
	9b1lt/ix4TGrA5/H99Y+Fo9jZw4zetxq+8PsMX/nR0aPnbPusntsXqHl8f/lETaPTas62Tze
	nTvH7nFixm8Wj+NnnD0+b5IL4InisklJzcksSy3St0vgylj24Q5bwRXOioV/lzI2MN5l72Lk
	5JAQMJF41fILyhaTuHBvPVsXIxeHkMA+Rom5B76xgSSEBDYwSuxbzAyReMYkcWPxW0aQBJuA
	ikTH0gdMXYwcHCIC+hJXPzOC1DALTGKROPz3NAtIjbBAkMS+q6uZQGwWAVWJ2fMmg9XzAsU3
	XzGHWKwgceXKPLByTgEDie1XVzGClAgBjTz+QReH8ARGgQWMDKsYZVNyq3RzEzNzilOTdYuT
	E/PyUot0jfRyM0v0UlNKNzGC40WSdwfju4NKhxgFOBiVeHhZ9z/2FWJNLCuuzD3EKMnBpCTK
	W/Htia8QX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd5vfEA53pTEyqrUonyYlDQHi5I470xJdV8h
	gfTEktTs1NSC1CKYrAwHh5IErxEwLQgJFqWmp1akZeaUIKSZODhBhvMADS8EWcxbXJCYW5yZ
	DpE/xajL0bh2x0FGIZa8/LxUKXFeK5BBAiBFGaV5cHNgae4VozjQW8K8CiBVPMAUCTfpFdAS
	JqAlve8egiwpSURISTUwVt1S3ijB0b2Esz4wW3+mV1Vatn3I9zC14NjrK79zfols3Sr8hT3M
	YUYjy6bo36+9HxZ7lis3qz2cXby6PibAQcZ3gYrw1jkRMh55k6LPeRscrui01fwwu3/ppIuM
	XWxVm9Qk5rzfeIDhmWvEtLrV92r5H3mzM3104v/TIC0cwtV4+FH0uQNKLMUZiYZazEXFiQCY
	X2HTTgMAAA==
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
index dc8ac70..c3b37d6 100644
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
1.7.5.1

