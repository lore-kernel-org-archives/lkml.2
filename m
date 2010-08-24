Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0HXLKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0HXLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:10:33 -0400
From: Avi Kivity <avi@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86 emulator: add macros for executing instructions that may trap
Date: Tue, 24 Aug 2010 14:10:28 +0300
Message-Id: <1282648229-19575-3-git-send-email-avi@redhat.com>
In-Reply-To: <1282648229-19575-1-git-send-email-avi@redhat.com>
References: <1282648229-19575-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like DIV and IDIV.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 808934c..f82e43a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -331,6 +331,27 @@ struct group_dual {
 			  "a" (_rax), "d" (_rdx));			\
 	} while (0)
 
+#define __emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx, _eflags, _suffix, _ex) \
+	do {								\
+		unsigned long _tmp;					\
+									\
+		__asm__ __volatile__ (					\
+			_PRE_EFLAGS("0", "5", "1")			\
+			"1: \n\t"					\
+			_op _suffix " %6; "				\
+			"2: \n\t"					\
+			_POST_EFLAGS("0", "5", "1")			\
+			".pushsection .fixup,\"ax\" \n\t"		\
+			"3: movb $1, %4 \n\t"				\
+			"jmp 2b \n\t"					\
+			".popsection \n\t"				\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "=m" (_eflags), "=&r" (_tmp),			\
+			  "+a" (_rax), "+d" (_rdx), "+qm"(_ex)		\
+			: "i" (EFLAGS_MASK), "m" ((_src).val),		\
+			  "a" (_rax), "d" (_rdx));			\
+	} while (0)
+
 /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
 #define emulate_1op_rax_rdx(_op, _src, _rax, _rdx, _eflags)			\
 	do {									\
@@ -342,6 +363,28 @@ struct group_dual {
 		}							\
 	} while (0)
 
+#define emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx, _eflags, _ex)	\
+	do {								\
+		switch((_src).bytes) {					\
+		case 1:							\
+			__emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx,	\
+						 _eflags, "b", _ex);	\
+			break;						\
+		case 2:							\
+			__emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx, \
+						 _eflags, "w", _ex);	\
+			break;						\
+		case 4:							\
+			__emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx, \
+						 _eflags, "l", _ex);	\
+			break;						\
+		case 8: ON64(						\
+			__emulate_1op_rax_rdx_ex(_op, _src, _rax, _rdx, \
+						 _eflags, "q", _ex));	\
+			break;						\
+		}							\
+	} while (0)
+
 /* Fetch next part of the instruction being emulated. */
 #define insn_fetch(_type, _size, _eip)                                  \
 ({	unsigned long _x;						\
-- 
1.7.1

