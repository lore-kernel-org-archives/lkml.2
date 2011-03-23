Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1CWNa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:30:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35903 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab1CWNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f3oo/SFHwSkoVOyOZGp65WVETggObsnL6ZEw0+Zk0G/wrM2YuWJb3gL4UQcgcrswng
         cBRNXO1fN7Xtmp0igNLdowfYVo9L60c0rkvq+qwjUYmn2iGTJMq9OCOw4qhdLITC1BpL
         hS9eXvce4A6gUeqpRNRYqk4Ga/ZoRZ35nGpAo=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH RESEND 1/2] vsprintf: introduce %pT format specifier
Date: Wed, 23 Mar 2011 22:29:57 +0900
Message-Id: <1300886997-30781-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <20110323131213.GA25467@elte.hu>
References: <20110323131213.GA25467@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %pT format specifier is for stack backtrace. Its handler
sprint_trace() does symbol lookup using (address-1) to ensure
the address will not point outside of the function.

If there is a tail-call to the function marked "noreturn",
gcc optimized out the code after the call then causes saved
return address points outside of the function (i.e. the start
of the next function), so pollutes call trace somewhat.
This patch will fix it.

before:
[   18.345923] Call Trace:
[   18.346001]  [<ffffffff812a8502>] panic+0x8c/0x18d
[   18.346257]  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
[   18.346347]  [<ffffffff81104666>] proc_file_write+0x73/0x8d
[   18.346432]  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
[   18.346516]  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
[   18.346603]  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
[   18.346801]  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b

after:
[   22.224483] Call Trace:
[   22.224569]  [<ffffffff812bce69>] panic+0x8c/0x18d
[   22.224848]  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- ok
[   22.224979]  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
[   22.225089]  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
[   22.225199]  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
[   22.225304]  [<ffffffff810d91cb>] sys_write+0x45/0x6c
[   22.225408]  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: linux-arch@vger.kernel.org
---
 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c           |    7 ++++++-
 3 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d1c23c..4964ed2021cc 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_trace(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
@@ -79,6 +80,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
 	return 0;
 }
 
+static inline int sprint_trace(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	return -ERANGE;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091b5757..1e889477ff618 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -368,6 +368,46 @@ int sprint_symbol(char *buffer, unsigned long address)
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
+/**
+ * sprint_trace - Look up a kernel trace symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function is for stack trace and does the same thing as sprint_symbol()
+ * but with modified/decreased @address. If there is a tail-call to the
+ * function marked "noreturn", gcc optimized out code after the call so that
+ * the stack-saved return address could point outside of the caller. This
+ * function ensures that kallsyms will find the original caller by decreasing
+ * @address and then adjusts the result by increasing offset.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_trace(char *buffer, unsigned long address)
+{
+	char *modname;
+	const char *name;
+	unsigned long offset, size;
+	int len;
+
+	name = kallsyms_lookup(address-1, &size, &offset, &modname, buffer);
+	if (!name)
+		return sprintf(buffer, "0x%lx", address);
+
+	if (name != buffer)
+		strcpy(buffer, name);
+	len = strlen(buffer);
+	buffer += len;
+	offset++;
+
+	if (modname)
+		len += sprintf(buffer, "+%#lx/%#lx [%s]",
+						offset, size, modname);
+	else
+		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+
+	return len;
+}
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df8477f..c9c56a54cc42 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -574,7 +574,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f' && ext != 's')
+	if (ext == 'T')
+		sprint_trace(sym, value);
+	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -949,6 +951,7 @@ int kptr_restrict = 1;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'T' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -1008,6 +1011,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		/* Fallthrough */
 	case 'S':
 	case 's':
+	case 'T':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -1279,6 +1283,7 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
+ * %pT output the name of a trace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
-- 
1.7.4

