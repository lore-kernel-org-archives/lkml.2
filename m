Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab0HEOil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:38:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:41164 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab0HEOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 03/17] kgdb,kdb: individual register set and and get API
Date: Thu,  5 Aug 2010 09:37:44 -0500
Message-Id: <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:13.0465 (UTC) FILETIME=[D568AC90:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kdb shell specification includes the ability to get and set
architecture specific registers by name.

For the time being individual register get and set will be implemented
on a per architecture basis.  If an architecture defines
DBG_MAX_REG_NUM > 0 then kdb and the gdbstub will use the capability
for individually getting and setting architecture specific registers.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h        |   13 ++++
 kernel/debug/gdbstub.c      |   26 +++++++++
 kernel/debug/kdb/kdb_main.c |  132 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 159 insertions(+), 12 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 9340f34..d5eb882 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -90,6 +90,19 @@ struct kgdb_bkpt {
 	enum kgdb_bpstate	state;
 };
 
+struct dbg_reg_def_t {
+	char *name;
+	int size;
+	int offset;
+};
+
+#ifndef DBG_MAX_REG_NUM
+#define DBG_MAX_REG_NUM 0
+#else
+extern struct dbg_reg_def_t dbg_reg_def[];
+extern char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs);
+extern int dbg_set_reg(int regno, void *mem, struct pt_regs *regs);
+#endif
 #ifndef KGDB_MAX_BREAKPOINTS
 # define KGDB_MAX_BREAKPOINTS	1000
 #endif
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index e117cfd..006bad8 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -328,6 +328,32 @@ static int kgdb_ebin2mem(char *buf, char *mem, int count)
 	return probe_kernel_write(mem, c, size);
 }
 
+#if DBG_MAX_REG_NUM > 0
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int i;
+	int idx = 0;
+	char *ptr = (char *)gdb_regs;
+
+	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
+		dbg_get_reg(i, ptr + idx, regs);
+		idx += dbg_reg_def[i].size;
+	}
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int i;
+	int idx = 0;
+	char *ptr = (char *)gdb_regs;
+
+	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
+		dbg_set_reg(i, ptr + idx, regs);
+		idx += dbg_reg_def[i].size;
+	}
+}
+#endif /* DBG_MAX_REG_NUM > 0 */
+
 /* Write memory due to an 'M' or 'X' packet. */
 static int write_mem_msg(int binary)
 {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index ebe4a28..8577e45 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -312,7 +312,7 @@ int kdbgetularg(const char *arg, unsigned long *value)
 
 	if (endp == arg) {
 		/*
-		 * Try base 16, for us folks too lazy to type the
+		 * Also try base 16, for us folks too lazy to type the
 		 * leading 0x...
 		 */
 		val = simple_strtoul(arg, &endp, 16);
@@ -325,6 +325,25 @@ int kdbgetularg(const char *arg, unsigned long *value)
 	return 0;
 }
 
+int kdbgetu64arg(const char *arg, u64 *value)
+{
+	char *endp;
+	u64 val;
+
+	val = simple_strtoull(arg, &endp, 0);
+
+	if (endp == arg) {
+
+		val = simple_strtoull(arg, &endp, 16);
+		if (endp == arg)
+			return KDB_BADINT;
+	}
+
+	*value = val;
+
+	return 0;
+}
+
 /*
  * kdb_set - This function implements the 'set' command.  Alter an
  *	existing environment variable or create a new one.
@@ -1770,11 +1789,65 @@ static int kdb_go(int argc, const char **argv)
  */
 static int kdb_rd(int argc, const char **argv)
 {
-	int diag = kdb_check_regs();
-	if (diag)
-		return diag;
+	int len = kdb_check_regs();
+#if DBG_MAX_REG_NUM > 0
+	int i;
+	char *rname;
+	int rsize;
+	u64 reg64;
+	u32 reg32;
+	u16 reg16;
+	u8 reg8;
+
+	if (len)
+		return len;
+
+	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
+		rsize = dbg_reg_def[i].size * 2;
+		if (rsize > 16)
+			rsize = 2;
+		if (len + strlen(dbg_reg_def[i].name) + 4 + rsize > 80) {
+			len = 0;
+			kdb_printf("\n");
+		}
+		if (len)
+			len += kdb_printf("  ");
+		switch(dbg_reg_def[i].size * 8) {
+		case 8:
+			rname = dbg_get_reg(i, &reg8, kdb_current_regs);
+			if (!rname)
+				break;
+			len += kdb_printf("%s: %02x", rname, reg8);
+			break;
+		case 16:
+			rname = dbg_get_reg(i, &reg16, kdb_current_regs);
+			if (!rname)
+				break;
+			len += kdb_printf("%s: %04x", rname, reg16);
+			break;
+		case 32:
+			rname = dbg_get_reg(i, &reg32, kdb_current_regs);
+			if (!rname)
+				break;
+			len += kdb_printf("%s: %08x", rname, reg32);
+			break;
+		case 64:
+			rname = dbg_get_reg(i, &reg64, kdb_current_regs);
+			if (!rname)
+				break;
+			len += kdb_printf("%s: %016llx", rname, reg64);
+			break;
+		default:
+			len += kdb_printf("%s: ??", dbg_reg_def[i].name);
+		}
+	}
+	kdb_printf("\n");
+#else
+	if (len)
+		return len;
 
 	kdb_dumpregs(kdb_current_regs);
+#endif
 	return 0;
 }
 
@@ -1782,32 +1855,67 @@ static int kdb_rd(int argc, const char **argv)
  * kdb_rm - This function implements the 'rm' (register modify)  command.
  *	rm register-name new-contents
  * Remarks:
- *	Currently doesn't allow modification of control or
- *	debug registers.
+ *	Allows register modification with the same restrictions as gdb
  */
 static int kdb_rm(int argc, const char **argv)
 {
+#if DBG_MAX_REG_NUM > 0
 	int diag;
-	int ind = 0;
-	unsigned long contents;
+	const char *rname;
+	int i;
+	u64 reg64;
+	u32 reg32;
+	u16 reg16;
+	u8 reg8;
 
 	if (argc != 2)
 		return KDB_ARGCOUNT;
 	/*
 	 * Allow presence or absence of leading '%' symbol.
 	 */
-	if (argv[1][0] == '%')
-		ind = 1;
+	rname = argv[1];
+	if (*rname == '%')
+		rname++;
 
-	diag = kdbgetularg(argv[2], &contents);
+	diag = kdbgetu64arg(argv[2], &reg64);
 	if (diag)
 		return diag;
 
 	diag = kdb_check_regs();
 	if (diag)
 		return diag;
+
+	diag = KDB_BADREG;
+	for (i = 0; i < DBG_MAX_REG_NUM; i++) {
+		if (strcmp(rname, dbg_reg_def[i].name) == 0) {
+			diag = 0;
+			break;
+		}
+	}
+	if (!diag) {
+		switch(dbg_reg_def[i].size * 8) {
+		case 8:
+			reg8 = reg64;
+			dbg_set_reg(i, &reg8, kdb_current_regs);
+			break;
+		case 16:
+			reg16 = reg64;
+			dbg_set_reg(i, &reg16, kdb_current_regs);
+			break;
+		case 32:
+			reg32 = reg64;
+			dbg_set_reg(i, &reg32, kdb_current_regs);
+			break;
+		case 64:
+			dbg_set_reg(i, &reg64, kdb_current_regs);
+			break;
+		}
+	}
+	return diag;
+#else
 	kdb_printf("ERROR: Register set currently not implemented\n");
-	return 0;
+    return 0;
+#endif
 }
 
 #if defined(CONFIG_MAGIC_SYSRQ)
-- 
1.6.3.3

