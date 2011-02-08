Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1BHWPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:15:43 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:56150 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1BHWPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:15:41 -0500
Subject: [PATCH v2 2/2] man-pages: SYSLOG_ACTION_* constants are now exported
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, mtk.manpages@gmail.com
Date: Tue, 08 Feb 2011 23:15:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297203340.1748.15.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel now exports <linux/syslog.h>. This makes the SYSLOG_ACTION_*
constants available to userspace. This allows to replace the magic
numbers used in this man page with (what should be) more descriptive
names. The quote form kernel/printk.c can now also be dropped.

A few (more or less related) things were also fixed or changed:
- add a new sub section "The command types";
- the (userspace) buffer is called bufp everywhere (and not buf);
- add some whitespace to all call descriptions;
- use "ignored" in some call descriptions (instead of "dummy").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 man2/syslog.2 |  110 +++++++++++++++++++++++++++------------------------------
 1 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/man2/syslog.2 b/man2/syslog.2
index fb018a6..9c4438b 100644
--- a/man2/syslog.2
+++ b/man2/syslog.2
@@ -38,6 +38,7 @@ set console_loglevel
 /* The glibc interface */
 .br
 .B "#include <sys/klog.h>"
+.BR "#include <linux/syslog.h>" "    /* For SYSLOG_ACTION_* constants */"
 .sp
 .BI "int klogctl(int " type ", char *" bufp ", int " len );
 .fi
@@ -52,31 +53,6 @@ The system call of this name is about controlling the kernel
 .IR printk ()
 buffer, and the glibc version is called
 .BR klogctl ().
-
-The \fItype\fP argument determines the action taken by this function.
-
-Quoting from
-.IR kernel/printk.c :
-.nf
-/*
- * Commands to sys_syslog:
- *
- *      0 \-\- Close the log.  Currently a NOP.
- *      1 \-\- Open the log. Currently a NOP.
- *      2 \-\- Read from the log.
- *      3 \-\- Read all messages remaining in the ring buffer.
- *      4 \-\- Read and clear all messages remaining in the ring buffer
- *      5 \-\- Clear ring buffer.
- *      6 \-\- Disable printk to console
- *      7 \-\- Enable printk to console
- *      8 \-\- Set level of messages printed to console
- *      9 \-\- Return number of unread characters in the log buffer
- *     10 \-\- Return size of the log buffer
- */
-.fi
-
-Only command types 3 and 10 are allowed to unprivileged processes.
-Type 9 was added in 2.4.10; type 10 in 2.6.6.
 .SS The kernel log buffer
 The kernel has a cyclic buffer of length
 .B LOG_BUF_LEN
@@ -91,12 +67,32 @@ from kernel 2.1.113 it was 16384;
 since 2.4.23/2.6 the value is a kernel configuration option.
 .\" Under "General setup" ==> "Kernel log buffer size"
 .\" For 2.6, precisely the option seems to have appeared in 2.5.55.
-In recent kernels the size can be queried with command type 10.
+Since kernel 2.6.6 the size can be queried with the
+\fBSYSLOG_ACTION_SIZE_BUFFER\fP command.
+.SS The command types
+The \fItype\fP argument determines the action taken by this function.
+Since kernel 2.6.34
+.IR <linux/syslog.h>
+defines these constants:
+
+.nf
+#define SYSLOG_ACTION_CLOSE          0  /* Currently a NOP. */
+#define SYSLOG_ACTION_OPEN           1  /* Currently a NOP. */
+#define SYSLOG_ACTION_READ           2
+#define SYSLOG_ACTION_READ_ALL       3
+#define SYSLOG_ACTION_READ_CLEAR     4
+#define SYSLOG_ACTION_CLEAR          5
+#define SYSLOG_ACTION_CONSOLE_OFF    6
+#define SYSLOG_ACTION_CONSOLE_ON     7
+#define SYSLOG_ACTION_CONSOLE_LEVEL  8
+#define SYSLOG_ACTION_SIZE_UNREAD    9
+#define SYSLOG_ACTION_SIZE_BUFFER   10
+.fi
 
 The call
-.I "syslog(2,buf,len)"
+.I "syslog(SYSLOG_ACTION_READ, bufp, len)"
 waits until this kernel log buffer is nonempty, and then reads
-at most \fIlen\fP bytes into the buffer \fIbuf\fP.
+at most \fIlen\fP bytes into the buffer \fIbufp\fP.
 It returns
 the number of bytes read.
 Bytes read from the log disappear from
@@ -106,37 +102,34 @@ reads
 .IR /proc/kmsg .
 
 The call
-.I syslog(3,buf,len)
+.I syslog(SYSLOG_ACTION_READ_ALL, bufp, len)
 will read the last \fIlen\fP bytes from the log buffer (nondestructively),
 but will not read more than was written into the buffer since the
-last "clear ring buffer" command (which does not clear the buffer at all).
-It returns the number of bytes read.
+last \fBSYSLOG_ACTION_CLEAR\fP command (which does not clear the buffer at
+all). It returns the number of bytes read. This call is allowed to
+unprivileged processes.
 
 The call
-.I syslog(4,buf,len)
-does precisely the same, but also executes the "clear ring buffer" command.
+.I syslog(SYSLOG_ACTION_READ_CLEAR, bufp, len)
+does precisely the same, but also executes the \fBSYSLOG_ACTION_CLEAR\fP
+command.
 
 The call
-.I syslog(5,dummy,dummy)
+.I syslog(SYSLOG_ACTION_CLEAR, ignored, ignored)
 executes just the "clear ring buffer" command.
-(In each call where
-.I buf
-or
-.I len
-is shown as "dummy", the value of the argument is ignored by the call.)
 
 The call
-.I syslog(6,dummy,dummy)
+.I syslog(SYSLOG_ACTION_CONSOLE_OFF, ignored, ignored)
 sets the console log level to minimum, so that no messages are printed
 to the console.
 
 The call
-.I syslog(7,dummy,dummy)
+.I syslog(SYSLOG_ACTION_CONSOLE_ON, ignored, ignored)
 sets the console log level to default, so that messages are printed
 to the console.
 
 The call
-.I syslog(8,dummy,level)
+.I syslog(SYSLOG_ACTION_CONSOLE_LEVEL, ignored, level)
 sets the console log level to
 .IR level ,
 which must be an integer between 1 and 8 (inclusive).
@@ -145,13 +138,14 @@ See the
 section for details.
 
 The call
-.I syslog(9,dummy,dummy)
+.I syslog(SYSLOG_ACTION_SIZE_UNREAD, ignored, ignored)
 returns the number of bytes currently available to be read
-on the kernel log buffer.
+on the kernel log buffer. (This call was added in 2.4.10.)
 
 The call
-.I syslog(10,dummy,dummy)
-returns the total size of the kernel log buffer.
+.I syslog(SYSLOG_ACTION_SIZE_BUFFER, ignored, ignored)
+returns the total size of the kernel log buffer. This call is allowed to
+unprivileged processes. (This call was added in 2.6.6.)
 .SS The loglevel
 The kernel routine
 .BR printk ()
@@ -163,12 +157,10 @@ This variable initially has the value
 (7), but is set to 10 if the
 kernel command line contains the word "debug", and to 15 in case
 of a kernel fault (the 10 and 15 are just silly, and equivalent to 8).
-This variable is set (to a value in the range 1-8) by the call
-.IR syslog(8,dummy,value) .
-The calls
-.I syslog(type,dummy,dummy)
-with \fItype\fP equal to 6 or 7, set it to 1 (kernel panics only)
-or 7 (all except debugging messages), respectively.
+This variable is set (to a value in the range 1-8) by the
+\fBSYSLOG_ACTION_CONSOLE_LEVEL\fP command. The \fBSYSLOG_ACTION_CONSOLE_OFF\fP
+command sets it to 1 (kernel panics only). The \fBSYSLOG_ACTION_CONSOLE_ON\fP
+command sets it to 7 (all messages except debugging messages).
 
 Every text line in a message has its own loglevel.
 This level is
@@ -191,15 +183,16 @@ as follows:
 #define KERN_DEBUG    "<7>"  /* debug-level messages             */
 .fi
 .SH "RETURN VALUE"
-For \fItype\fP equal to 2, 3, or 4, a successful call to
+For \fItype\fP \fBSYSLOG_ACTION_READ\fP, \fBSYSLOG_ACTION_READ_ALL\fP,
+or \fBSYSLOG_ACTION_READ_CLEAR\fP, a successful call to
 .BR syslog ()
 returns the number
 of bytes read.
-For \fItype\fP 9,
+For \fItype\fP \fBSYSLOG_ACTION_SIZE_UNREAD\fP,
 .BR syslog ()
 returns the number of bytes currently
 available to be read on the kernel log buffer.
-For \fItype\fP 10,
+For \fItype\fP \fBSYSLOG_ACTION_SIZE_BUFFER\fP,
 .BR syslog ()
 returns the total size of the kernel log buffer.
 For other values of \fItype\fP, 0 is returned on success.
@@ -214,14 +207,15 @@ bad
 .IR type ;
 or for
 .I type
-2, 3, or 4,
-.I buf
+\fBSYSLOG_ACTION_READ\fP, \fBSYSLOG_ACTION_READ_ALL\fP, or
+\fBSYSLOG_ACTION_READ_CLEAR\fP,
+.I bufp
 is NULL,
 or
 .I len
 is less than zero; or for
 .I type
-8, the
+\fBSYSLOG_ACTION_CONSOLE_LEVEL\fP, the
 .I level
 is outside the range 1 to 8).
 .TP
-- 
1.7.4



