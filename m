Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1C1PMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:12:36 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:59561 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819Ab1C1PMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:12:34 -0400
X-AuditID: 1209190c-b7b7aae0000047c7-02-4d90a439497c
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/6] x86-64: Put vsyscall_gtod_data at a fixed virtual address
Date: Mon, 28 Mar 2011 11:06:43 -0400
Message-Id: <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsUixCmqrWu5ZIKvwfTF4hZ9V46yW7Sunc9u
	cXnXHDaLzZumMlv82PCY1YHVY+esu+wem1Z1snm8O3eO3ePctT5mj8+b5AJYo7hsUlJzMstS
	i/TtErgy/vwNLPjNV9G7fx9zA+MSni5GDg4JAROJ7q+KXYycQKaYxIV769m6GLk4hAT2MUpc
	ePCQDSQhJLCBUaKjJwUi8YxJYv/qY0wgCTYBFYmOpQ+YQAaJCAhJLL1bB1LDLDCJUeLljF52
	kBphAT+JRXOugdksAqoSe4+sYgSxeQWCJL6tnwpkswNtlpNoDgSJcgoYSHSevsoCMlFIQF/i
	4zl7HMITGAUWMDKsYpRNya3SzU3MzClOTdYtTk7My0st0jXUy80s0UtNKd3ECA5HSZ4djG8O
	Kh1iFOBgVOLhDYzq9xViTSwrrsw9xCjJwaQkyvts0QRfIb6k/JTKjMTijPii0pzU4kOMEhzM
	SiK8hxqBcrwpiZVVqUX5MClpDhYlcd4Zkuq+QgLpiSWp2ampBalFMFkZDg4lCd6Fi4EaBYtS
	01Mr0jJzShDSTBycIMN5gIYngdTwFhck5hZnpkPkTzEqSonzLgZJCIAkMkrz4Hph6eIVozjQ
	K8K8k0CqeICpBq77FdBgJqDBgUpgg0sSEVJSDYwyljsirBa07f5keXui7N5gwV8Hk8+0Lzu/
	Ysmiv7mvrokdETmWH6HPeXiO8MfeuZv2sy3L4tW4enf/Atdpv9wKVCxPdeq/nCmWKFnb8+WP
	1syaMuPizcu7nZ1eyMz33Rntut80WUPj8l/5NA2XS+yC00La9nlWeCYtffRoxUS2t9JZnT7e
	bXFKLMUZiYZazEXFiQCRvBfV8gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This generates slightly better code because vclock_gettime doesn't
need to load the address.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |   13 +++++++------
 arch/x86/vdso/vextern.h       |    9 ++++++++-
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..1f545ff 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -174,12 +174,6 @@ SECTIONS
 		*(.vsyscall_fn)
 	}
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
-		*(.vsyscall_gtod_data)
-	}
-
-	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
 		*(.vsyscall_clock)
 	}
@@ -208,6 +202,13 @@ SECTIONS
 		*(.vsyscall_3)
 	}
 
+	 /* This address must be kept in sync with arch/x86/vdso/vextern.h */
+	.vsyscall_gtod_data ADDR(.vsyscall_0) + 3072 + 256:
+	                    AT(VLOAD(.vsyscall_gtod_data)) {
+		*(.vsyscall_gtod_data)
+	}
+	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
+
 	. = __vsyscall_0 + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
diff --git a/arch/x86/vdso/vextern.h b/arch/x86/vdso/vextern.h
index 1683ba2..5bfa77c 100644
--- a/arch/x86/vdso/vextern.h
+++ b/arch/x86/vdso/vextern.h
@@ -2,6 +2,11 @@
 #include <asm/vsyscall.h>
 #define VEXTERN(x) \
 	extern typeof(x) *vdso_ ## x __attribute__((visibility("hidden")));
+#define VEXTERN_FIXED(x, offset) \
+	static typeof(x) * const vdso_ ## x = \
+		(void *)(VSYSCALL_START + (offset));
+#else
+#define VEXTERN_FIXED(x, offset)
 #endif
 
 #define VMAGIC 0xfeedbabeabcdefabUL
@@ -13,4 +18,6 @@
 
 VEXTERN(jiffies)
 VEXTERN(vgetcpu_mode)
-VEXTERN(vsyscall_gtod_data)
+VEXTERN_FIXED(vsyscall_gtod_data, 3072 + 256)  /* Hard-coded in linker script */
+
+#undef VEXTERN_FIXED
-- 
1.7.4

