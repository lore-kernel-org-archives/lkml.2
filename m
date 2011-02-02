Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1BBBE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:04:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:46559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1BBAnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028356"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [42/139] sparc: Pass buffer pointer all the way down to prom_{get,put}char().
Message-Id: <20110202004357.BBA803E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit e62cac1fd035b4cde707285008499dbe71955a86 ]

This gets us closer to being able to eliminate the use
of dynamic and stack based buffers, so that we can adhere
to the "no buffer addresses above 4GB" rule for PROM calls.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/openprom.h |    2 -
 arch/sparc/include/asm/oplib_32.h |    4 +--
 arch/sparc/include/asm/oplib_64.h |    4 +--
 arch/sparc/prom/console_32.c      |   50 +++++++++++++++++++-------------------
 arch/sparc/prom/console_64.c      |   34 ++++++++++++-------------
 arch/sparc/prom/printf.c          |   15 ++++++-----
 6 files changed, 55 insertions(+), 54 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/openprom.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/openprom.h
+++ linux-2.6.35.y/arch/sparc/include/asm/openprom.h
@@ -37,7 +37,7 @@ struct linux_dev_v2_funcs {
 	int (*v2_dev_open)(char *devpath);
 	void (*v2_dev_close)(int d);
 	int (*v2_dev_read)(int d, char *buf, int nbytes);
-	int (*v2_dev_write)(int d, char *buf, int nbytes);
+	int (*v2_dev_write)(int d, const char *buf, int nbytes);
 	int (*v2_dev_seek)(int d, int hi, int lo);
 
 	/* Never issued (multistage load support) */
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_32.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
@@ -105,10 +105,10 @@ extern int prom_getprev(void);
 /* Character operations to/from the console.... */
 
 /* Blocking get character from console. */
-extern char prom_getchar(void);
+extern void prom_getchar(char *buf);
 
 /* Blocking put character to console. */
-extern void prom_putchar(char character);
+extern void prom_putchar(const char *buf);
 
 /* Prom's internal routines, don't use in kernel/boot code. */
 extern void prom_printf(const char *fmt, ...);
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -97,10 +97,10 @@ extern unsigned char prom_get_idprom(cha
 /* Character operations to/from the console.... */
 
 /* Blocking get character from console. */
-extern char prom_getchar(void);
+extern void prom_getchar(char *buf);
 
 /* Blocking put character to console. */
-extern void prom_putchar(char character);
+extern void prom_putchar(const char *buf);
 
 /* Prom's internal routines, don't use in kernel/boot code. */
 extern void prom_printf(const char *fmt, ...);
Index: linux-2.6.35.y/arch/sparc/prom/console_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_32.c
+++ linux-2.6.35.y/arch/sparc/prom/console_32.c
@@ -19,27 +19,27 @@ extern void restore_current(void);
 /* Non blocking get character from console input device, returns -1
  * if no input was taken.  This can be used for polling.
  */
-static int prom_nbgetchar(void)
+static int prom_nbgetchar(char *buf)
 {
-	static char inc;
-	int i = -1;
 	unsigned long flags;
+	int i = -1;
 
 	spin_lock_irqsave(&prom_lock, flags);
 	switch(prom_vers) {
 	case PROM_V0:
 		i = (*(romvec->pv_nbgetchar))();
+		if (i != -1) {
+			*buf = i;
+			i = 0;
+		}
 		break;
 	case PROM_V2:
 	case PROM_V3:
-		if( (*(romvec->pv_v2devops).v2_dev_read)(*romvec->pv_v2bootargs.fd_stdin , &inc, 0x1) == 1) {
-			i = inc;
-		} else {
-			i = -1;
-		}
+		if ((*(romvec->pv_v2devops).v2_dev_read)(*romvec->pv_v2bootargs.fd_stdin,
+							 buf, 0x1) == 1)
+			i = 0;
 		break;
 	default:
-		i = -1;
 		break;
 	};
 	restore_current();
@@ -50,27 +50,23 @@ static int prom_nbgetchar(void)
 /* Non blocking put character to console device, returns -1 if
  * unsuccessful.
  */
-static int prom_nbputchar(char c)
+static int prom_nbputchar(const char *buf)
 {
-	static char outc;
 	unsigned long flags;
 	int i = -1;
 
 	spin_lock_irqsave(&prom_lock, flags);
 	switch(prom_vers) {
 	case PROM_V0:
-		i = (*(romvec->pv_nbputchar))(c);
+		i = (*(romvec->pv_nbputchar))(*buf);
 		break;
 	case PROM_V2:
 	case PROM_V3:
-		outc = c;
-		if( (*(romvec->pv_v2devops).v2_dev_write)(*romvec->pv_v2bootargs.fd_stdout, &outc, 0x1) == 1)
+		if ((*(romvec->pv_v2devops).v2_dev_write)(*romvec->pv_v2bootargs.fd_stdout,
+							  buf, 0x1) == 1)
 			i = 0;
-		else
-			i = -1;
 		break;
 	default:
-		i = -1;
 		break;
 	};
 	restore_current();
@@ -79,17 +75,21 @@ static int prom_nbputchar(char c)
 }
 
 /* Blocking version of get character routine above. */
-char
-prom_getchar(void)
+void prom_getchar(char *buf)
 {
-	int character;
-	while((character = prom_nbgetchar()) == -1) ;
-	return (char) character;
+	while (1) {
+		int err = prom_nbgetchar(buf);
+		if (!err)
+			break;
+	}
 }
 
 /* Blocking version of put character routine above. */
-void
-prom_putchar(char c)
+void prom_putchar(const char *buf)
 {
-	while(prom_nbputchar(c) == -1) ;
+	while (1) {
+		int err = prom_nbputchar(buf);
+		if (!err)
+			break;
+	}
 }
Index: linux-2.6.35.y/arch/sparc/prom/console_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_64.c
+++ linux-2.6.35.y/arch/sparc/prom/console_64.c
@@ -18,41 +18,37 @@ extern int prom_stdin, prom_stdout;
 /* Non blocking get character from console input device, returns -1
  * if no input was taken.  This can be used for polling.
  */
-static int prom_nbgetchar(void)
+static int prom_nbgetchar(char *buf)
 {
 	unsigned long args[7];
-	char inc;
 
 	args[0] = (unsigned long) "read";
 	args[1] = 3;
 	args[2] = 1;
 	args[3] = (unsigned int) prom_stdin;
-	args[4] = (unsigned long) &inc;
+	args[4] = (unsigned long) buf;
 	args[5] = 1;
 	args[6] = (unsigned long) -1;
 
 	p1275_cmd_direct(args);
 
 	if (args[6] == 1)
-		return inc;
+		return 0;
 	return -1;
 }
 
 /* Non blocking put character to console device, returns -1 if
  * unsuccessful.
  */
-static int prom_nbputchar(char c)
+static int prom_nbputchar(const char *buf)
 {
 	unsigned long args[7];
-	char outc;
-	
-	outc = c;
 
 	args[0] = (unsigned long) "write";
 	args[1] = 3;
 	args[2] = 1;
 	args[3] = (unsigned int) prom_stdout;
-	args[4] = (unsigned long) &outc;
+	args[4] = (unsigned long) buf;
 	args[5] = 1;
 	args[6] = (unsigned long) -1;
 
@@ -65,17 +61,21 @@ static int prom_nbputchar(char c)
 }
 
 /* Blocking version of get character routine above. */
-char
-prom_getchar(void)
+void prom_getchar(char *buf)
 {
-	int character;
-	while((character = prom_nbgetchar()) == -1) ;
-	return (char) character;
+	while (1) {
+		int err = prom_nbgetchar(buf);
+		if (!err)
+			break;
+	}
 }
 
 /* Blocking version of put character routine above. */
-void
-prom_putchar(char c)
+void prom_putchar(const char *buf)
 {
-	prom_nbputchar(c);
+	while (1) {
+		int err = prom_nbputchar(buf);
+		if (!err)
+			break;
+	}
 }
Index: linux-2.6.35.y/arch/sparc/prom/printf.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/printf.c
+++ linux-2.6.35.y/arch/sparc/prom/printf.c
@@ -23,13 +23,14 @@ static char ppbuf[1024];
 
 void notrace prom_write(const char *buf, unsigned int n)
 {
-	char ch;
-
-	while (n != 0) {
-		--n;
-		if ((ch = *buf++) == '\n')
-			prom_putchar('\r');
-		prom_putchar(ch);
+	while (n-- != 0) {
+		char ch = *buf;
+		if (ch == '\n') {
+			char tmp = '\r';
+			prom_putchar(&tmp);
+		}
+		prom_putchar(buf);
+		buf++;
 	}
 }
 
