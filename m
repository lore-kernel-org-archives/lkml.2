Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0FIQT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:19:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab0FIQTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:19:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Implement the GDB remote protocol 'p' command to
	retrieve a register
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 09 Jun 2010 17:19:09 +0100
Message-ID: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the GDB remote protocol 'p' command to retrieve a single register
value.

The 'p' command is tried by some gdb versions before they consider using the
'g' command (to batch-retrieve all the registers).  Before the following
commit:

	commit 7ca8b9c0dafd1cb36289aa4c92c7beae7adcd34f
	Author: David Howells <dhowells@redhat.com>
	Date:   Mon May 24 14:32:54 2010 -0700
	Subject: frv: extend gdbstub to support more features of gdb

the 'p' command just returned an empty reply, which causes gdb to then go and
use the 'g' command.  However, since that commit, the 'p' command returns an
error string, which causes gdb to abort its connection to the target.

Not all gdb versions are affected, some use try 'g' first, and if that works,
don't bother with 'p', and so don't see the error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/gdb-stub.h |    2 +
 arch/frv/kernel/gdb-stub.c      |  116 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+), 0 deletions(-)


diff --git a/arch/frv/include/asm/gdb-stub.h b/arch/frv/include/asm/gdb-stub.h
index e6bedd0..8bb0288 100644
--- a/arch/frv/include/asm/gdb-stub.h
+++ b/arch/frv/include/asm/gdb-stub.h
@@ -60,6 +60,8 @@
 #define GDB_REG_SCR(N)	(141+(N))
 #define GDB_REG_LR	145
 #define GDB_REG_LCR	146
+#define GDB_REG_IACC0H	147
+#define GDB_REG_IACC0L	148
 #define GDB_REG_FSR0	149
 #define GDB_REG_ACC(N)	(150+(N))
 #define GDB_REG_ACCG(N)	(158+(N)/4)
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 84d103c..1a65d7b 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -1789,6 +1789,104 @@ void gdbstub(int sigval)
 			flush_cache = 1;
 			break;
 
+			/* pNN: Read value of reg N and return it */
+		case 'p':
+			ptr = &input_buffer[1];
+
+			if (!hexToInt(&ptr, &addr)) {
+				gdbstub_strcpy(output_buffer, "E01");
+				break;
+			}
+
+			temp2 = 1;
+			switch (addr) {
+			case GDB_REG_GR(0):
+				temp = 0;
+				break;
+			case GDB_REG_GR(1) ... GDB_REG_GR(63):
+				temp = __debug_user_context->i.gr[addr - GDB_REG_GR(0)];
+				break;
+			case GDB_REG_FR(0) ... GDB_REG_FR(63):
+				temp = __debug_user_context->f.fr[addr - GDB_REG_FR(0)];
+				break;
+			case GDB_REG_PC:
+				temp = __debug_user_context->i.pc;
+				break;
+			case GDB_REG_PSR:
+				temp = __debug_user_context->i.psr;
+				break;
+			case GDB_REG_CCR:
+				temp = __debug_user_context->i.ccr;
+				break;
+			case GDB_REG_CCCR:
+				temp = __debug_user_context->i.cccr;
+				break;
+			case GDB_REG_BRR:
+				temp = __debug_status.brr;
+				break;
+			case GDB_REG_LR:
+				temp = __debug_user_context->i.lr;
+				break;
+			case GDB_REG_LCR:
+				temp = __debug_user_context->i.lcr;
+				break;
+			case GDB_REG_TBR:
+				temp = __debug_user_context->i.tbr;
+				break;
+			case GDB_REG_FSR0:
+				temp = __debug_user_context->f.fsr[0];
+				break;
+			case GDB_REG_ACC(0) ... GDB_REG_ACC(7):
+				temp = __debug_user_context->f.acc[addr - GDB_REG_ACC(0)];
+				break;
+			case GDB_REG_ACCG(0):
+				temp = *(uint32_t *) &__debug_user_context->f.accg[0];
+				break;
+			case GDB_REG_ACCG(4):
+				temp = *(uint32_t *) &__debug_user_context->f.accg[4];
+				break;
+			case GDB_REG_IACC0H:
+				temp = ((u32*)&__debug_frame->iacc0)[0];
+				break;
+			case GDB_REG_IACC0L:
+				temp = ((u32*)&__debug_frame->iacc0)[1];
+				break;
+			case GDB_REG_MSR(0) ... GDB_REG_MSR(1):
+				temp = __debug_user_context->f.msr[addr - GDB_REG_MSR(0)];
+				break;
+			case GDB_REG_GNER(0) ... GDB_REG_GNER(1):
+				temp = __debug_user_context->i.gner[addr - GDB_REG_GNER(0)];
+				break;
+			case GDB_REG_FNER(0) ... GDB_REG_FNER(1):
+				temp = __debug_user_context->f.fner[addr - GDB_REG_FNER(0)];
+				break;
+			case GDB_REG_DBAR(0):
+				asm volatile("movsg dbar0,%0" : "=r"(temp));
+				break;
+			case GDB_REG_DBAR(1):
+				asm volatile("movsg dbar1,%0" : "=r"(temp));
+				break;
+			case GDB_REG_DBAR(2):
+				asm volatile("movsg dbar2,%0" : "=r"(temp));
+				break;
+			case GDB_REG_DBAR(3):
+				asm volatile("movsg dbar3,%0" : "=r"(temp));
+				break;
+			default:
+				temp = 0;
+				temp2 = 0;
+				break;
+			}
+
+			if (temp2) {
+				ptr = output_buffer;
+				ptr = mem2hex(&temp, ptr, 4, 0);
+			}
+			else {
+				gdbstub_strcpy(output_buffer, "E02");
+			}
+			break;
+
 			/* PNN,=RRRRRRRR: Write value R to reg N return OK */
 		case 'P':
 			ptr = &input_buffer[1];
@@ -1844,6 +1942,12 @@ void gdbstub(int sigval)
 			case GDB_REG_ACCG(4):
 				*(uint32_t *) &__debug_user_context->f.accg[4] = temp;
 				break;
+			case GDB_REG_IACC0H:
+				((u32*)&__debug_frame->iacc0)[0] = temp;
+				break;
+			case GDB_REG_IACC0L:
+				((u32*)&__debug_frame->iacc0)[1] = temp;
+				break;
 			case GDB_REG_MSR(0) ... GDB_REG_MSR(1):
 				__debug_user_context->f.msr[addr - GDB_REG_MSR(0)] = temp;
 				break;
@@ -1853,6 +1957,18 @@ void gdbstub(int sigval)
 			case GDB_REG_FNER(0) ... GDB_REG_FNER(1):
 				__debug_user_context->f.fner[addr - GDB_REG_FNER(0)] = temp;
 				break;
+			case GDB_REG_DBAR(0):
+				asm volatile("movgs %0,dbar0" :: "r"(temp));
+				break;
+			case GDB_REG_DBAR(1):
+				asm volatile("movgs %0,dbar1" :: "r"(temp));
+				break;
+			case GDB_REG_DBAR(2):
+				asm volatile("movgs %0,dbar2" :: "r"(temp));
+				break;
+			case GDB_REG_DBAR(3):
+				asm volatile("movgs %0,dbar3" :: "r"(temp));
+				break;
 			default:
 				temp2 = 0;
 				break;

