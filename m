Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0CYBNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0CYBNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:13:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Extend gdbstub to support more features of gdb
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 25 Mar 2010 01:13:39 +0000
Message-ID: <20100325011339.645.97950.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend gdbstub to support more features of gdb remote protocol to keep gdb-7
and emacs gud mode happy:

 (*) The D command.  Detach debugger.

 (*) The H command.  Handle setting the target thread by ignoring it.

 (*) The qAttached command.  Indicate we 'attached' to an existing process.

 (*) The qC command.  Indicate that the current thread ID is 0.

 (*) The qOffsets command.  Indicate that no relocation has been done.

 (*) The qSymbol:: command.  Indicate that we're not interested in looking up
     any symbol addresses.

 (*) The qSupported command.  Indicate the maximum packet size and the fact
     that reverse step and continue aren't supported.

 (*) The vCont? command.  Indicate that we don't support any of its variants.

Also make it possible to trace the commands and replies without tracing the
individual character I/O.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/gdb-stub.h |    7 ++++
 arch/frv/kernel/gdb-io.c        |    4 +--
 arch/frv/kernel/gdb-stub.c      |   61 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)


diff --git a/arch/frv/include/asm/gdb-stub.h b/arch/frv/include/asm/gdb-stub.h
index 2da7164..e6bedd0 100644
--- a/arch/frv/include/asm/gdb-stub.h
+++ b/arch/frv/include/asm/gdb-stub.h
@@ -12,6 +12,7 @@
 #ifndef __ASM_GDB_STUB_H
 #define __ASM_GDB_STUB_H
 
+#undef GDBSTUB_DEBUG_IO
 #undef GDBSTUB_DEBUG_PROTOCOL
 
 #include <asm/ptrace.h>
@@ -108,6 +109,12 @@ extern void gdbstub_printk(const char *fmt, ...);
 extern void debug_to_serial(const char *p, int n);
 extern void console_set_baud(unsigned baud);
 
+#ifdef GDBSTUB_DEBUG_IO
+#define gdbstub_io(FMT,...) gdbstub_printk(FMT, ##__VA_ARGS__)
+#else
+#define gdbstub_io(FMT,...) ({ 0; })
+#endif
+
 #ifdef GDBSTUB_DEBUG_PROTOCOL
 #define gdbstub_proto(FMT,...) gdbstub_printk(FMT,##__VA_ARGS__)
 #else
diff --git a/arch/frv/kernel/gdb-io.c b/arch/frv/kernel/gdb-io.c
index c997bcc..2ca641d 100644
--- a/arch/frv/kernel/gdb-io.c
+++ b/arch/frv/kernel/gdb-io.c
@@ -171,11 +171,11 @@ int gdbstub_rx_char(unsigned char *_ch, int nonblock)
 		return -EINTR;
 	}
 	else if (st & (UART_LSR_FE|UART_LSR_OE|UART_LSR_PE)) {
-		gdbstub_proto("### GDB Rx Error (st=%02x) ###\n",st);
+		gdbstub_io("### GDB Rx Error (st=%02x) ###\n",st);
 		return -EIO;
 	}
 	else {
-		gdbstub_proto("### GDB Rx %02x (st=%02x) ###\n",ch,st);
+		gdbstub_io("### GDB Rx %02x (st=%02x) ###\n",ch,st);
 		*_ch = ch & 0x7f;
 		return 0;
 	}
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 7ca8a6b..05050ce 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -1344,6 +1344,44 @@ void gdbstub_get_mmu_state(void)
 
 } /* end gdbstub_get_mmu_state() */
 
+/*
+ * handle general query commands of the form 'qXXXXX'
+ */
+void gdbstub_handle_query(void)
+{
+	if (strcmp(input_buffer, "qAttached") == 0) {
+		/* return current thread ID */
+		sprintf(output_buffer, "1");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qC") == 0) {
+		/* return current thread ID */
+		sprintf(output_buffer, "QC 0");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qOffsets") == 0) {
+		/* return relocation offset of text and data segments */
+		sprintf(output_buffer, "Text=0;Data=0;Bss=0");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qSymbol::") == 0) {
+		sprintf(output_buffer, "OK");
+		return;
+	}
+
+	if (strcmp(input_buffer, "qSupported") == 0) {
+		/* query of supported features */
+		sprintf(output_buffer, "PacketSize=%u;ReverseContinue-;ReverseStep-",
+			sizeof(input_buffer));
+		return;
+	}
+
+	gdbstub_strcpy(output_buffer,"E01");
+}
+
 /*****************************************************************************/
 /*
  * handle event interception and GDB remote protocol processing
@@ -1840,6 +1878,10 @@ void gdbstub(int sigval)
 		case 'k' :
 			goto done;	/* just continue */
 
+			/* detach */
+		case 'D':
+			gdbstub_strcpy(output_buffer, "OK");
+			break;
 
 			/* reset the whole machine (FIXME: system dependent) */
 		case 'r':
@@ -1852,6 +1894,14 @@ void gdbstub(int sigval)
 			__debug_status.dcr |= DCR_SE;
 			goto done;
 
+			/* extended command */
+		case 'v':
+			if (strcmp(input_buffer, "vCont?") == 0) {
+				output_buffer[0] = 0;
+				break;
+			}
+			goto unsupported_cmd;
+
 			/* set baud rate (bBB) */
 		case 'b':
 			ptr = &input_buffer[1];
@@ -1923,8 +1973,19 @@ void gdbstub(int sigval)
 			gdbstub_strcpy(output_buffer,"OK");
 			break;
 
+			/* Thread-setting packet */
+		case 'H':
+			gdbstub_strcpy(output_buffer, "OK");
+			break;
+
+		case 'q':
+			gdbstub_handle_query();
+			break;
+
 		default:
+		unsupported_cmd:
 			gdbstub_proto("### GDB Unsupported Cmd '%s'\n",input_buffer);
+			gdbstub_strcpy(output_buffer,"E01");
 			break;
 		}
 

