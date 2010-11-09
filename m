Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab0KIFht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:37:49 -0500
Received: from mail.perches.com ([173.55.12.10]:4688 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab0KIFhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:37:47 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <litorvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] include/linux/kernel.h: Move logging bits to include/linux/logging.h
Date: Mon,  8 Nov 2010 21:37:46 -0800
Message-Id: <1289281066-8529-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the logging bits from kernel.h into logging.h so that
there is a bit more logical separation of the generic from
the logging specific parts.

Add pr_<level>_once macros to logging.h.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h  |  246 +-----------------------------------
 include/linux/logging.h |  322 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 324 insertions(+), 244 deletions(-)
 create mode 100644 include/linux/logging.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b526947..a8be3e4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -17,13 +17,11 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
+#include <linux/logging.h>
 #include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
-extern const char linux_banner[];
-extern const char linux_proc_banner[];
-
 #define USHRT_MAX	((u16)(~0U))
 #define SHRT_MAX	((s16)(USHRT_MAX>>1))
 #define SHRT_MIN	((s16)(-SHRT_MAX - 1))
@@ -42,7 +40,7 @@ extern const char linux_proc_banner[];
 #define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
 #define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
@@ -110,31 +108,6 @@ extern const char linux_proc_banner[];
  */
 #define lower_32_bits(n) ((u32)(n))
 
-#define	KERN_EMERG	"<0>"	/* system is unusable			*/
-#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define	KERN_CRIT	"<2>"	/* critical conditions			*/
-#define	KERN_ERR	"<3>"	/* error conditions			*/
-#define	KERN_WARNING	"<4>"	/* warning conditions			*/
-#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define	KERN_INFO	"<6>"	/* informational			*/
-#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
-
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
-/*
- * Annotation for a "continued" line of log printout (only done after a
- * line that had no enclosing \n). Only to be used by core/arch code
- * during early bootup (a continued line is not SMP-safe otherwise).
- */
-#define	KERN_CONT	"<c>"
-
-extern int console_printk[];
-
-#define console_loglevel (console_printk[0])
-#define default_message_loglevel (console_printk[1])
-#define minimum_console_loglevel (console_printk[2])
-#define default_console_loglevel (console_printk[3])
-
 struct completion;
 struct pt_regs;
 struct user;
@@ -187,11 +160,6 @@ static inline void might_fault(void)
 }
 #endif
 
-struct va_format {
-	const char *fmt;
-	va_list *va;
-};
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
@@ -245,114 +213,8 @@ extern int func_ptr_is_kernel_text(void *ptr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-/*
- * FW_BUG
- * Add this to a message where you are sure the firmware is buggy or behaves
- * really stupid or out of spec. Be aware that the responsible BIOS developer
- * should be able to fix this issue or at least get a concrete idea of the
- * problem by reading your message without the need of looking at the kernel
- * code.
- * 
- * Use it for definite and high priority BIOS bugs.
- *
- * FW_WARN
- * Use it for not that clear (e.g. could the kernel messed up things already?)
- * and medium priority BIOS bugs.
- *
- * FW_INFO
- * Use this one if you want to tell the user or vendor about something
- * suspicious, but generally harmless related to the firmware.
- *
- * Use it for information or very low priority BIOS bugs.
- */
-#define FW_BUG		"[Firmware Bug]: "
-#define FW_WARN		"[Firmware Warn]: "
-#define FW_INFO		"[Firmware Info]: "
-
-/*
- * HW_ERR
- * Add this to a message for hardware errors, so that user can report
- * it to hardware vendor instead of LKML or software vendor.
- */
-#define HW_ERR		"[Hardware Error]: "
-
-#ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2))) __cold;
-
-/*
- * Please don't use printk_ratelimit(), because it shares ratelimiting state
- * with all other unrelated printk_ratelimit() callsites.  Instead use
- * printk_ratelimited() or plain old __ratelimit().
- */
-extern int __printk_ratelimit(const char *func);
-#define printk_ratelimit() __printk_ratelimit(__func__)
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				   unsigned int interval_msec);
-
-extern int printk_delay_msec;
-
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(x...) ({			\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(x);			\
-	}					\
-})
-
-void log_buf_kexec_setup(void);
-#else
-static inline int vprintk(const char *s, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
-	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
-static inline int printk_ratelimit(void) { return 0; }
-static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
-					  unsigned int interval_msec)	\
-		{ return false; }
-
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
-
-static inline void log_buf_kexec_setup(void)
-{
-}
-#endif
-
-/*
- * Dummy printk for disabled debugging statements to use whilst maintaining
- * gcc's format and side-effect checking.
- */
-static inline __attribute__ ((format (printf, 1, 2)))
-int no_printk(const char *s, ...) { return 0; }
-
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
-extern void asmlinkage __attribute__((format(printf, 1, 2)))
-	early_printk(const char *fmt, ...);
-
 unsigned long int_sqrt(unsigned long);
 
-static inline void console_silent(void)
-{
-	console_loglevel = 0;
-}
-
-static inline void console_verbose(void)
-{
-	if (console_loglevel)
-		console_loglevel = 15;
-}
-
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
@@ -389,22 +251,6 @@ extern enum system_states {
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
 
-extern void dump_stack(void) __cold;
-
-enum {
-	DUMP_PREFIX_NONE,
-	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
-};
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
-extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
-extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
-
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
@@ -418,94 +264,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 
 extern int hex_to_bin(char ch);
 
-#ifndef pr_fmt
-#define pr_fmt(fmt) fmt
-#endif
-
-#define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warn pr_warning
-#define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
-	printk(KERN_CONT fmt, ##__VA_ARGS__)
-
-/* pr_devel() should produce zero code unless DEBUG is defined */
-#ifdef DEBUG
-#define pr_devel(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#else
-#define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-#endif
-
-/* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
-/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
-#define pr_debug(fmt, ...) \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__)
-#else
-#define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-#endif
-
-/*
- * ratelimited messages with local ratelimit_state,
- * no local ratelimit_state used in the !PRINTK case
- */
-#ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({				\
-	static DEFINE_RATELIMIT_STATE(_rs,				\
-				      DEFAULT_RATELIMIT_INTERVAL,	\
-				      DEFAULT_RATELIMIT_BURST);		\
-									\
-	if (__ratelimit(&_rs))						\
-		printk(fmt, ##__VA_ARGS__);				\
-})
-#else
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_ratelimited printk
-#endif
-
-#define pr_emerg_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warn_ratelimited pr_warning_ratelimited
-#define pr_notice_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-/* no pr_cont_ratelimited, don't do that... */
-/* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
-	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#else
-#define pr_debug_ratelimited(fmt, ...) \
-	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
-				     ##__VA_ARGS__); 0; })
-#endif
-
 /*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
diff --git a/include/linux/logging.h b/include/linux/logging.h
new file mode 100644
index 0000000..97d0258
--- /dev/null
+++ b/include/linux/logging.h
@@ -0,0 +1,322 @@
+#ifndef __KERNEL_LOGGING__
+#define __KERNEL_LOGGING__
+
+extern const char linux_banner[];
+extern const char linux_proc_banner[];
+
+#define	KERN_EMERG	"<0>"	/* system is unusable			*/
+#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define	KERN_CRIT	"<2>"	/* critical conditions			*/
+#define	KERN_ERR	"<3>"	/* error conditions			*/
+#define	KERN_WARNING	"<4>"	/* warning conditions			*/
+#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define	KERN_INFO	"<6>"	/* informational			*/
+#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+
+/* Use the default kernel loglevel */
+#define KERN_DEFAULT	"<d>"
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define	KERN_CONT	"<c>"
+
+/*
+ * FW_BUG
+ * Add this to a message where you are sure the firmware is buggy or behaves
+ * really stupid or out of spec. Be aware that the responsible BIOS developer
+ * should be able to fix this issue or at least get a concrete idea of the
+ * problem by reading your message without the need of looking at the kernel
+ * code.
+ *
+ * Use it for definite and high priority BIOS bugs.
+ *
+ * FW_WARN
+ * Use it for not that clear (e.g. could the kernel messed up things already?)
+ * and medium priority BIOS bugs.
+ *
+ * FW_INFO
+ * Use this one if you want to tell the user or vendor about something
+ * suspicious, but generally harmless related to the firmware.
+ *
+ * Use it for information or very low priority BIOS bugs.
+ */
+#define FW_BUG		"[Firmware Bug]: "
+#define FW_WARN		"[Firmware Warn]: "
+#define FW_INFO		"[Firmware Info]: "
+
+/*
+ * HW_ERR
+ * Add this to a message for hardware errors, so that user can report
+ * it to hardware vendor instead of LKML or software vendor.
+ */
+#define HW_ERR		"[Hardware Error]: "
+
+extern int console_printk[];
+
+#define console_loglevel (console_printk[0])
+#define default_message_loglevel (console_printk[1])
+#define minimum_console_loglevel (console_printk[2])
+#define default_console_loglevel (console_printk[3])
+
+/*
+ * Dummy printk for disabled debugging statements to use whilst maintaining
+ * gcc's format and side-effect checking.
+ */
+static inline __attribute__ ((format(printf, 1, 2)))
+int no_printk(const char *fmt, ...)
+{
+	return 0;
+}
+
+/* vsprintf %pV extension struct */
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
+extern int printk_needs_cpu(int cpu);
+extern void printk_tick(void);
+
+extern void asmlinkage __attribute__ ((format(printf, 1, 2)))
+	early_printk(const char *fmt, ...);
+
+static inline void console_silent(void)
+{
+	console_loglevel = 0;
+}
+
+static inline void console_verbose(void)
+{
+	if (console_loglevel)
+		console_loglevel = 15;
+}
+
+extern void dump_stack(void) __cold;
+
+/*
+ * printk message logging
+ */
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#ifdef CONFIG_PRINTK
+asmlinkage int vprintk(const char *fmt, va_list args)
+	__attribute__ ((format(printf, 1, 0)));
+asmlinkage int printk(const char *fmt, ...)
+	__attribute__ ((format(printf, 1, 2))) __cold;
+
+#else
+
+static inline __attribute__ ((format(printf, 1, 0)))
+int vprintk(const char *fmt, va_list args)
+{
+	return 0;
+}
+static inline __attribute__ ((format(printf, 1, 2)))
+int __cold printk(const char *fmt, ...)
+{
+	return 0;
+}
+
+#endif
+
+#define pr_emerg(fmt, ...)				\
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)				\
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)				\
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)				\
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...)				\
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn pr_warning
+#define pr_notice(fmt, ...)				\
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)				\
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...)				\
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
+
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...)				\
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...)					\
+({								\
+	if (0)							\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
+	0;							\
+})
+#endif
+
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug(fmt, ...)				\
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define pr_debug(fmt, ...)			\
+	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#else
+#define pr_debug(fmt, ...)					\
+({								\
+	if (0)							\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
+	0;							\
+})
+#endif
+
+/*
+ * ratelimited messages with local ratelimit_state,
+ * no local ratelimit_state used in the !PRINTK case
+ *
+ * Please don't use printk_ratelimit(), because it shares ratelimiting state
+ * with all other unrelated printk_ratelimit() callsites.  Instead use
+ * printk_ratelimited() or plain old __ratelimit().
+ */
+#ifdef CONFIG_PRINTK
+extern int __printk_ratelimit(const char *func);
+extern int printk_delay_msec;
+#define printk_ratelimit() __printk_ratelimit(__func__)
+extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+				   unsigned int interval_msec);
+#define printk_ratelimited(fmt, ...)					\
+({									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+									\
+	if (__ratelimit(&_rs))						\
+		printk(fmt, ##__VA_ARGS__);				\
+})
+
+#else
+
+static inline int printk_ratelimit(void) { return 0; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+					  unsigned int interval_msec)
+{
+	return false;
+}
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_ratelimited printk
+
+#endif
+
+#define pr_emerg_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_ratelimited(fmt, ...)				\
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_ratelimited pr_warning_ratelimited
+#define pr_notice_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_ratelimited, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+
+#define pr_debug_ratelimited(fmt, ...)					\
+({									\
+	if (0)								\
+		printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); \
+	0;								\
+})
+#endif
+
+/*
+ * printk_once messages,
+ * no local state used in the !CONFIG_PRINTK case
+ */
+
+#ifdef CONFIG_PRINTK
+
+/*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+#define printk_once(fmt, ...)			\
+({						\
+	static bool __print_once;		\
+						\
+	if (!__print_once) {			\
+		__print_once = true;		\
+		printk(fmt, ##__VA_ARGS__);	\
+	}					\
+})
+
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_once(fmt, ...) printk(fmt, ##__VA_ARGS__)
+#endif
+
+#define pr_emerg_once(fmt, ...)					\
+	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_once(fmt, ...)					\
+	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_once(fmt, ...)					\
+	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_once(fmt, ...)					\
+	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_once(fmt, ...)					\
+	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_once(fmt, ...)				\
+	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_once(fmt, ...)					\
+	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+
+#if defined(DEBUG)
+#define pr_debug_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_once(fmt, ...)						\
+({									\
+	if (0)								\
+		printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
+	0;								\
+})
+#endif
+
+/*
+ * hex_dump utilities
+ */
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
+extern void print_hex_dump(const char *level, const char *prefix_str,
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+				 const void *buf, size_t len);
+
+#ifdef CONFIG_PRINTK
+
+void log_buf_kexec_setup(void);
+
+#else
+
+static inline void log_buf_kexec_setup(void)
+{
+}
+#endif
+
+#endif
-- 
1.7.3.2.146.gca209

