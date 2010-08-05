Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab0HEOiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:38:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:41180 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760628Ab0HEOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 07/17] gdbstub: Implement gdbserial 'p' and 'P' packets
Date: Thu,  5 Aug 2010 09:37:48 -0500
Message-Id: <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:16.0793 (UTC) FILETIME=[D7647C90:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gdbserial 'p' and 'P' packets allow gdb to individually get and
set registers instead of querying for all the available registers.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h   |    2 +-
 kernel/debug/gdbstub.c |   97 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index d5eb882..cc96f0f 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -294,7 +294,7 @@ extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern struct kgdb_io *dbg_io_ops;
 
 extern int kgdb_hex2long(char **ptr, unsigned long *long_val);
-extern int kgdb_mem2hex(char *mem, char *buf, int count);
+extern char *kgdb_mem2hex(char *mem, char *buf, int count);
 extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 006bad8..4ef9ddd 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -225,7 +225,7 @@ void gdbstub_msg_write(const char *s, int len)
  * buf.  Return a pointer to the last char put in buf (null). May
  * return an error.
  */
-int kgdb_mem2hex(char *mem, char *buf, int count)
+char *kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
@@ -237,17 +237,16 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 	tmp = buf + count;
 
 	err = probe_kernel_read(tmp, mem, count);
-	if (!err) {
-		while (count > 0) {
-			buf = pack_hex_byte(buf, *tmp);
-			tmp++;
-			count--;
-		}
-
-		*buf = 0;
+	if (err)
+		return NULL;
+	while (count > 0) {
+		buf = pack_hex_byte(buf, *tmp);
+		tmp++;
+		count--;
 	}
+	*buf = 0;
 
-	return err;
+	return buf;
 }
 
 /*
@@ -481,8 +480,7 @@ static void gdb_cmd_status(struct kgdb_state *ks)
 	pack_hex_byte(&remcom_out_buffer[1], ks->signo);
 }
 
-/* Handle the 'g' get registers request */
-static void gdb_cmd_getregs(struct kgdb_state *ks)
+static void gdb_get_regs_helper(struct kgdb_state *ks)
 {
 	struct task_struct *thread;
 	void *local_debuggerinfo;
@@ -523,6 +521,12 @@ static void gdb_cmd_getregs(struct kgdb_state *ks)
 		 */
 		sleeping_thread_to_gdb_regs(gdb_regs, thread);
 	}
+}
+
+/* Handle the 'g' get registers request */
+static void gdb_cmd_getregs(struct kgdb_state *ks)
+{
+	gdb_get_regs_helper(ks);
 	kgdb_mem2hex((char *)gdb_regs, remcom_out_buffer, NUMREGBYTES);
 }
 
@@ -545,13 +549,13 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 	char *ptr = &remcom_in_buffer[1];
 	unsigned long length;
 	unsigned long addr;
-	int err;
+	char *err;
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
 					kgdb_hex2long(&ptr, &length) > 0) {
 		err = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
-		if (err)
-			error_packet(remcom_out_buffer, err);
+		if (!err)
+			error_packet(remcom_out_buffer, -EINVAL);
 	} else {
 		error_packet(remcom_out_buffer, -EINVAL);
 	}
@@ -568,6 +572,52 @@ static void gdb_cmd_memwrite(struct kgdb_state *ks)
 		strcpy(remcom_out_buffer, "OK");
 }
 
+#if DBG_MAX_REG_NUM > 0
+static char *gdb_hex_reg_helper(int regnum, char *out)
+{
+	int i;
+	int offset = 0;
+
+	for (i = 0; i < regnum; i++)
+		offset += dbg_reg_def[i].size;
+	return kgdb_mem2hex((char *)gdb_regs + offset, out,
+			    dbg_reg_def[i].size);
+}
+
+/* Handle the 'p' individual regster get */
+static void gdb_cmd_reg_get(struct kgdb_state *ks)
+{
+	unsigned long regnum;
+	char *ptr = &remcom_in_buffer[1];
+
+	kgdb_hex2long(&ptr, &regnum);
+	if (regnum >= DBG_MAX_REG_NUM) {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+	gdb_get_regs_helper(ks);
+	gdb_hex_reg_helper(regnum, remcom_out_buffer);
+}
+
+/* Handle the 'P' individual regster set */
+static void gdb_cmd_reg_set(struct kgdb_state *ks)
+{
+	unsigned long regnum;
+	char *ptr = &remcom_in_buffer[1];
+
+	kgdb_hex2long(&ptr, &regnum);
+	if (*ptr++ != '=' ||
+	    !(!kgdb_usethread || kgdb_usethread == current) ||
+	    !dbg_get_reg(regnum, gdb_regs, ks->linux_regs)) {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+	kgdb_hex2mem(ptr, (char *)gdb_regs, dbg_reg_def[regnum].size);
+	dbg_set_reg(regnum, gdb_regs, ks->linux_regs);
+	strcpy(remcom_out_buffer, "OK");
+}
+#endif /* DBG_MAX_REG_NUM > 0 */
+
 /* Handle the 'X' memory binary write bytes */
 static void gdb_cmd_binwrite(struct kgdb_state *ks)
 {
@@ -874,8 +924,11 @@ int gdb_serial_stub(struct kgdb_state *ks)
 	int error = 0;
 	int tmp;
 
-	/* Clear the out buffer. */
+	/* Initialize comm buffer and globals. */
 	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
+	kgdb_usethread = kgdb_info[ks->cpu].task;
+	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
+	ks->pass_exception = 0;
 
 	if (kgdb_connected) {
 		unsigned char thref[BUF_THREAD_ID_SIZE];
@@ -892,10 +945,6 @@ int gdb_serial_stub(struct kgdb_state *ks)
 		put_packet(remcom_out_buffer);
 	}
 
-	kgdb_usethread = kgdb_info[ks->cpu].task;
-	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
-	ks->pass_exception = 0;
-
 	while (1) {
 		error = 0;
 
@@ -920,6 +969,14 @@ int gdb_serial_stub(struct kgdb_state *ks)
 		case 'M': /* MAA..AA,LLLL: Write LLLL bytes at address AA..AA */
 			gdb_cmd_memwrite(ks);
 			break;
+#if DBG_MAX_REG_NUM > 0
+		case 'p': /* pXX Return gdb register XX (in hex) */
+			gdb_cmd_reg_get(ks);
+			break;
+		case 'P': /* PXX=aaaa Set gdb register XX to aaaa (in hex) */
+			gdb_cmd_reg_set(ks);
+			break;
+#endif /* DBG_MAX_REG_NUM > 0 */
 		case 'X': /* XAA..AA,LLLL: Write LLLL bytes at address AA..AA */
 			gdb_cmd_binwrite(ks);
 			break;
-- 
1.6.3.3

