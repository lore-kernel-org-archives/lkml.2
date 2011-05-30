Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1E3Dtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:47 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:59190 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab1E3Dto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:44 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-c3-4de31397ad7d
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 07/10] x86-64: Fill unused parts of the vsyscall page with 0xcc
Date: Sun, 29 May 2011 23:48:44 -0400
Message-Id: <7b6450ece98846ac88fb2407d180257183a4c652.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
In-Reply-To: <cover.1306724657.git.luto@mit.edu>
References: <cover.1306724657.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsUixG6nrjtd+LGvwfkWRYs569ewWfRdOcpu
	Mesar8XnDf/YLA78espm8f7qdjaLy7vmsFk8ab7OaLHlUjOrxYeJG9gsNm+aymzxqO8tu8WP
	DY9ZHXg9vrf2sXgcO3OY0eNW2x9mj52z7rJ7bF6h5fH/5RE2j02rOtk83p07x+5xYsZvFo/j
	Z5w9Pm+SC+CO4rJJSc3JLEst0rdL4MrY9fwAY8EVzoqbHx6xNTDeZe9i5OSQEDCRuHJpPzOE
	LSZx4d56ti5GLg4hgX2MEnsmP2GHcDYwSjR+aWaEcJ4xSVxf/4sVpIVNQEWiY+kDpi5GDg4R
	AX2Jq5/BapgFnjNLPHi4ixUkLiwQJHHyjgSIySKgKnH6li1IJy9Q9POL10wQixUkrlyZxwJi
	cwoYAFXfA7OFgCbOu/WWDZf4BEaBBYwMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3SN9HIzS/RS
	U0o3MYLig1OSdwfju4NKhxgFOBiVeHhdix75CrEmlhVX5h5ilORgUhLlfST42FeILyk/pTIj
	sTgjvqg0J7X4EKMEB7OSCK/6L6By3pTEyqrUonyYlDQHi5I470xJdV8hgfTEktTs1NSC1CKY
	rAwHh5IEbxgwDQgJFqWmp1akZeaUIKSZODhBhvMADdcHWcxbXJCYW5yZDpE/xajL0bh2x0FG
	IZa8/LxUKXFeG5BBAiBFGaV5cHNgae0VozjQW8K8V4SAqniAKRFu0iugJUxAS3rfPQRZUpKI
	kJJqYNxxXf2/kHbZhFxr50/5ziceyi27XfCI+SxTuNSG3cnxhqLtmbLnDBO1bee4WSn3TW82
	j8menKz61l2xLnfFPoazMVbXToofTFHgVnar/3RbKKt1wo+pkTVRGknbZF0NV6yKTrPsbU/7
	LLRhur3tN2+flEmp8mmB5bsXTpaOuvasaPWcC/PrlViKMxINtZiLihMBX5rS60YDAAA=
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
index 1583238..8d6a0b7 100644
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

