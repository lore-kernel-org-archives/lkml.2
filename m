Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0IRTs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:48:57 -0400
Received: from kroah.org ([198.145.64.141]:51499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab0IRTBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:51 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.199764024@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [063/123] x86-64, compat: Retruncate rax after ia32 syscall entry tracing
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=x86-64-compat-retruncate-rax-after-ia32-syscall-entry-tracing.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

commit eefdca043e8391dcd719711716492063030b55ac upstream.

In commit d4d6715, we reopened an old hole for a 64-bit ptracer touching a
32-bit tracee in system call entry.  A %rax value set via ptrace at the
entry tracing stop gets used whole as a 32-bit syscall number, while we
only check the low 32 bits for validity.

Fix it by truncating %rax back to 32 bits after syscall_trace_enter,
in addition to testing the full 64 bits as has already been added.

Reported-by: Ben Hawkes <hawkes@sota.gen.nz>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32entry.S |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -50,7 +50,12 @@
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
-	 * the value it wants us to use in the table lookup.
+	 * the %rax value we should see.  Instead, we just truncate that
+	 * value to 32 bits again as we did on entry from user mode.
+	 * If it's a new value set by user_regset during entry tracing,
+	 * this matches the normal truncation of the user-mode value.
+	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
+	 * an appropriately invalid value.
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
@@ -60,6 +65,7 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
+	movl %eax,%eax			/* zero extension */
 	.endm
 	
 	.macro CFI_STARTPROC32 simple


