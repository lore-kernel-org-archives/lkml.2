Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2BVQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:06:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2BVQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:06:13 -0500
Date: Wed, 22 Feb 2012 08:04:55 -0800
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-04a3d984d32e47983770d314cdb4e4d8f38fccb7@git.kernel.org>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
        jolsa@redhat.com, anton@redhat.com, jkenisto@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        ananth@in.ibm.com, jistone@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org, hch@infradead.org,
        jolsa@redhat.com, jistone@redhat.com, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        jkenisto@linux.vnet.ibm.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
References: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] uprobes/core: Make instruction tables volatile
Git-Commit-ID: 04a3d984d32e47983770d314cdb4e4d8f38fccb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:05:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04a3d984d32e47983770d314cdb4e4d8f38fccb7
Gitweb:     http://git.kernel.org/tip/04a3d984d32e47983770d314cdb4e4d8f38fccb7
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Wed, 22 Feb 2012 14:45:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 11:26:07 +0100

uprobes/core: Make instruction tables volatile

Some versions of gcc spits a warning about the asm operand for
test_bit and also causes the first long of the instruction table
to be output.

Fix is similar to 7115e3fc on arch/x86/kernel/kprobes.c

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Josh Stone <jistone@redhat.com>
Link: http://lkml.kernel.org/r/20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uprobes.c |   61 +++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index cf2a184..13d616d 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -53,34 +53,12 @@
 	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
 	 << (row % 32))
 
-#ifdef CONFIG_X86_64
-static u32 good_insns_64[256 / 32] = {
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
-	/*      ----------------------------------------------         */
-	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
-	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
-	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
-	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
-	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
-	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
-	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
-	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
-	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
-	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
-	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
-	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
-	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
-	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
-	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
-	/*      ----------------------------------------------         */
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
-};
-#endif
-
-/* Good-instruction tables for 32-bit apps */
-
-static u32 good_insns_32[256 / 32] = {
+/*
+ * Good-instruction tables for 32-bit apps.  This is non-const and volatile
+ * to keep gcc from statically optimizing it out, as variable_test_bit makes
+ * some versions of gcc to think only *(unsigned long*) is used.
+ */
+static volatile u32 good_insns_32[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
 	W(0x00, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) | /* 00 */
@@ -104,7 +82,7 @@ static u32 good_insns_32[256 / 32] = {
 };
 
 /* Using this for both 64-bit and 32-bit apps */
-static u32 good_2byte_insns[256 / 32] = {
+static volatile u32 good_2byte_insns[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
 	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
@@ -127,6 +105,31 @@ static u32 good_2byte_insns[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
 
+#ifdef CONFIG_X86_64
+/* Good-instruction tables for 64-bit apps */
+static volatile u32 good_insns_64[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+	/*      ----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
+	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
+	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
+	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
+	/*      ----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+};
+#endif
 #undef W
 
 /*
