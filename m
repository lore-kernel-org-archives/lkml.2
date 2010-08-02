Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0HBVAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:00:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41084 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0HBVA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:00:29 -0400
Message-ID: <4C5731AF.9040009@zytor.com>
Date: Mon, 02 Aug 2010 13:59:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com> <4C571DF2.5080100@kernel.org>
In-Reply-To: <4C571DF2.5080100@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------050107020407080804000802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107020407080804000802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/02/2010 12:35 PM, Yinghai Lu wrote:
> 
> it seems I can not global variables in arch/x86/boot/compressed/misc.c
> 

I just looked at it, it's the fact that we don't relocate the GOT that
is causing problems.  It's relatively easy to fix: here is a patch, but
in grand Linus tradition it is completely untested.

	-hpa

--------------050107020407080804000802
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index f543b70..6597aeb 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -124,6 +124,19 @@ relocated:
 	rep	stosl
 
 /*
+ * Adjust our own GOT
+ */
+	leal	_got(%ebx), %esi
+	leal	_egot(%ebx), %edi
+1:
+	cmpl	%esi, %edi
+	jae	2f
+	addl	%ebx, (%esi)
+	addl	$4, %esi
+	jmp	1b
+2:
+
+/*
  * Do the decompression, and jump to the new kernel..
  */
 	leal	z_extract_offset_negative(%ebx), %ebp
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index faff0dc..ef69e97 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -280,6 +280,19 @@ relocated:
 	rep	stosq
 
 /*
+ * Adjust our own GOT
+ */
+	leaq	_got(%rip), %rsi
+	leaq	_egot(%rip), %rdi
+1:
+	cmpq	%rsi, %rdi
+	jae	2f
+	addq	%rbx, (%rsi)
+	addq	$8, %rsi
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

--------------050107020407080804000802--
