Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0HCDbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:31:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:38165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0HCDbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:31:08 -0400
Date: Tue, 3 Aug 2010 03:30:53 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4C57382E.8050501@zytor.com>
References: <4C57382E.8050501@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Allow global variables and functions in the decompressor
Message-ID: <tip-22a57f5896df218356bae6203dfaf04bcfd6c88c@git.kernel.org>
Git-Commit-ID: 22a57f5896df218356bae6203dfaf04bcfd6c88c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 03:30:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22a57f5896df218356bae6203dfaf04bcfd6c88c
Gitweb:     http://git.kernel.org/tip/22a57f5896df218356bae6203dfaf04bcfd6c88c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 2 Aug 2010 15:34:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 2 Aug 2010 15:34:44 -0700

x86, setup: Allow global variables and functions in the decompressor

In order for global variables and functions to work in the
decompressor, we need to fix up the GOT in assembly code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4C57382E.8050501@zytor.com>
---
 arch/x86/boot/compressed/head_32.S     |   13 +++++++++++++
 arch/x86/boot/compressed/head_64.S     |   13 +++++++++++++
 arch/x86/boot/compressed/vmlinux.lds.S |    6 ++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index f543b70..67a655a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -124,6 +124,19 @@ relocated:
 	rep	stosl
 
 /*
+ * Adjust our own GOT
+ */
+	leal	_got(%ebx), %edx
+	leal	_egot(%ebx), %ecx
+1:
+	cmpl	%ecx, %edx
+	jae	2f
+	addl	%ebx, (%edx)
+	addl	$4, %edx
+	jmp	1b
+2:
+
+/*
  * Do the decompression, and jump to the new kernel..
  */
 	leal	z_extract_offset_negative(%ebx), %ebp
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..52f85a1 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -280,6 +280,19 @@ relocated:
 	rep	stosq
 
 /*
+ * Adjust our own GOT
+ */
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+	
+/*
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 5ddabce..34d047c 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -41,6 +41,12 @@ SECTIONS
 		*(.rodata.*)
 		_erodata = . ;
 	}
+	.got : {
+		_got = .;
+		KEEP(*(.got.plt))
+		KEEP(*(.got))
+		_egot = .;
+	}
 	.data :	{
 		_data = . ;
 		*(.data)
