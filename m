Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0JFSGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab0JFSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/8] arm: generalize asm/termios.h
Date: Wed,  6 Oct 2010 20:06:19 +0200
Message-Id: <1286388380-20646-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xVvKRblTJCmypujh1OD7+jIAsh6TQZ4qktmKmS7nfVk
 t1476T+tbOxAl3+EwXBlHUEEdWyuUPQuOupi8V0gN5K0O1/zf6
 PZWDiUOeT32pn4/aB+72MdXobVHjAYjGsWs3abCgpzY3D7iys3
 gVOM5MOqc6DpDv5tWD6nbIVJST6ZGXv11MqA4Ke7pxoLCgLI5f
 BCPoF1xc08SzoP+pF/owg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The termios header on arm differs from the asm-generic
version practically only in the definition of
user_termio_to_kernel_termios and user_termio_to_kernel_termios.

Using the generic definition fixes multiple problems:

- type safety of the functions
- missing check of user space pointer access
- incorrect behaviour on big-endian kernels
- missing copy of the c_line field

Moreover, once the code is identical to the generic version,
we can simply use that code instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/termios.h |  136 +++++++++++++++++++++++++++++-----------
 1 files changed, 99 insertions(+), 37 deletions(-)

diff --git a/arch/arm/include/asm/termios.h b/arch/arm/include/asm/termios.h
index 293e3f1..94ce9ec 100644
--- a/arch/arm/include/asm/termios.h
+++ b/arch/arm/include/asm/termios.h
@@ -1,5 +1,12 @@
 #ifndef __ASM_ARM_TERMIOS_H
 #define __ASM_ARM_TERMIOS_H
+/*
+ * Most architectures have straight copies of the x86 code, with
+ * varying levels of bug fixes on top. Usually it's a good idea
+ * to use this generic version instead, but be careful to avoid
+ * ABI changes.
+ * New architectures should not provide their own version.
+ */
 
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
@@ -21,16 +28,6 @@ struct termio {
 	unsigned char c_cc[NCC];	/* control characters */
 };
 
-#ifdef __KERNEL__
-/*	intr=^C		quit=^|		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-#endif
-
 /* modem lines */
 #define TIOCM_LE	0x001
 #define TIOCM_DTR	0x002
@@ -51,41 +48,106 @@ struct termio {
 
 #ifdef __KERNEL__
 
+#include <asm/uaccess.h>
+
+/*	intr=^C		quit=^\		erase=del	kill=^U
+	eof=^D		vtime=\0	vmin=\1		sxtc=\0
+	start=^Q	stop=^S		susp=^Z		eol=\0
+	reprint=^R	discard=^U	werase=^W	lnext=^V
+	eol2=\0
+*/
+#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
+
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) {		\
-	unsigned short __tmp;					\
-	get_user(__tmp,&(termio)->x);				\
-	*(unsigned short *) &(termios)->x = __tmp;		\
-}
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
+						const struct termio __user *termio)
+{
+	unsigned short tmp;
+
+	if (get_user(tmp, &termio->c_iflag) < 0)
+		goto fault;
+	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
 
-#define user_termio_to_kernel_termios(termios, termio) \
-({ \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
-	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
-})
+	if (get_user(tmp, &termio->c_oflag) < 0)
+		goto fault;
+	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
+
+	if (get_user(tmp, &termio->c_cflag) < 0)
+		goto fault;
+	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
+
+	if (get_user(tmp, &termio->c_lflag) < 0)
+		goto fault;
+	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
+
+	if (get_user(termios->c_line, &termio->c_line) < 0)
+		goto fault;
+
+	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
+		goto fault;
+
+	return 0;
+
+ fault:
+	return -EFAULT;
+}
 
 /*
  * Translate a "termios" structure into a "termio". Ugh.
  */
-#define kernel_termios_to_user_termio(termio, termios) \
-({ \
-	put_user((termios)->c_iflag, &(termio)->c_iflag); \
-	put_user((termios)->c_oflag, &(termio)->c_oflag); \
-	put_user((termios)->c_cflag, &(termio)->c_cflag); \
-	put_user((termios)->c_lflag, &(termio)->c_lflag); \
-	put_user((termios)->c_line,  &(termio)->c_line); \
-	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
-})
-
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
-#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
+static inline int kernel_termios_to_user_termio(struct termio __user *termio,
+						struct ktermios *termios)
+{
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+#ifdef TCGETS2
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios2 __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios2));
+}
+
+static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios2));
+}
+
+static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
+						   struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
+						   struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
+#else /* TCGETS2 */
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios(struct termios __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
+#endif /* TCGETS2 */
 
 #endif	/* __KERNEL__ */
 
-- 
1.7.1

