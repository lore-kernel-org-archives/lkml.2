Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0H0UP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:15:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37737 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0H0UPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lFfEmTsnm1Ozq6tsVjaQapDLqu3bBYD/wPmgjloUCI8yiqFlcGo5KOF5HZ+LPxhW2i
         a8J/5J/xeWATXGSVn2MKJho28W3M1oV8rV56B9oQori2yvGiG43FhhQrbhU3HXL+0LbM
         +MRva4KSkblxz9fQQakW470VeIftf/34GxmRU=
MIME-Version: 1.0
In-Reply-To: <4C780888.9000301@zytor.com>
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com> <4C780888.9000301@zytor.com>
From: Matteo Croce <matteo@openwrt.org>
Date: Fri, 27 Aug 2010 22:15:33 +0200
X-Google-Sender-Auth: 5jdJ7amArOFxpDifamOYMKcZc_Y
Message-ID: <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Natale Vinto <ebballon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 8:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> You're doing user-space references without get_user().
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>

Here with get_user.
I CC Natale which is my beta tester, he have some Alix boards running 24/24
with my patch

--- a/arch/x86/kernel/Makefile	2010-08-27 19:42:01.795858001 +0200
+++ b/arch/x86/kernel/Makefile	2010-08-27 19:42:12.525858001 +0200
@@ -88,6 +88,8 @@
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o

 obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_GEODE_NOPL)	+= nopl_emu.o
+obj-$(CONFIG_GEODE_NOPL)	+= nopl_emu.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o

--- a/arch/x86/kernel/cpu/amd.c	2010-08-27 19:42:01.855858001 +0200
+++ b/arch/x86/kernel/cpu/amd.c	2010-08-27 19:42:12.535858001 +0200
@@ -137,11 +137,15 @@
 		return;
 	}

+#ifdef CONFIG_GEODE_NOPL
 	if (c->x86_model == 10) {
-		/* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
+		/* Geode only lacks the NOPL instruction to be i686,
+		   but we can promote it to a i686 class cpu
+		   and emulate NOPLs in the exception handler*/
+		boot_cpu_data.x86 = 6;
 		return;
 	}
+#endif
 }

 static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/entry_32.S	2010-08-27 19:42:01.735858001 +0200
+++ b/arch/x86/kernel/entry_32.S	2010-08-27 19:42:12.535858001 +0200
@@ -978,7 +978,11 @@
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_GEODE_NOPL
+	pushl $do_nopl_emu
+#else
 	pushl $do_invalid_op
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/arch/x86/kernel/nopl_emu.c	2010-08-27 22:09:58.005858001 +0200
@@ -0,0 +1,124 @@
+/*
+ *  linux/arch/x86/kernel/nopl_emu.c
+ *
+ *  Copyright (C) 2002  Willy Tarreau
+ *  Copyright (C) 2010  Matteo Croce
+ */
+
+#include <asm/processor.h>
+#include <asm/traps.h>
+#include <asm/uaccess.h>
+
+/* This code can be used to allow the AMD Geode to hopefully correctly execute
+ * some code which was originally compiled for an i686, by emulating NOPL,
+ * the only missing i686 instruction in the CPU
+ *
+ * Willy Tarreau <willy@meta-x.org>
+ * Matteo Croce <technoboy85@gmail.com>
+ */
+
+static inline int do_1f(u8 *ip)
+{
+	u8 val1, val2;
+	int length = 3;
+	get_user(val1, ip);
+	switch (val1) {
+	case 0x84:
+		get_user(val1, ip + 5);
+		if (!val1)
+			length++;
+		else
+			return 0;
+	case 0x80:
+		get_user(val1, ip + 4);
+		get_user(val2, ip + 3);
+		if (!val1 && !val2)
+			length += 2;
+		else
+			return 0;
+	case 0x44:
+		get_user(val1, ip + 2);
+		if (!val1)
+			length++;
+		else
+			return 0;
+	case 0x40:
+		get_user(val1, ip + 1);
+		if (!val1)
+			length++;
+		else
+			return 0;
+	case 0x00:
+		return length;
+	}
+	return 0;
+}
+
+static inline int do_0f(u8 *ip)
+{
+	u8 val;
+	get_user(val, ip);
+	if (val == 0x1f)
+		return do_1f(ip + 1);
+	return 0;
+}
+
+static inline int do_66(u8 *ip)
+{
+	u8 val;
+	get_user(val, ip);
+	if (val == 0x90)
+		return 2;
+	if (val == 0x0f) {
+		int res = do_0f(ip + 1);
+		if (res)
+			return res + 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+
+static inline int do_start(u8 *ip)
+{
+	u8 val;
+	get_user(val, ip);
+	if (val == 0x0f)
+		return do_0f(ip + 1);
+	if (val == 0x66)
+		return do_66(ip + 1);
+	return 0;
+}
+
+/* [do_nopl_emu] is called by exception 6 after an invalid opcode has been
+ * encountered. It will try to emulate it by doing nothing,
+ * and will send a SIGILL or SIGSEGV to the process if not possible.
+ * the NOPL can have variable length opcodes:
+
+bytes number	opcode
+	2	66 90
+	3	0f 1f 00
+	4	0f 1f 40 00
+	5	0f 1f 44 00 00
+	6	66 0f 1f 44 00 00
+	7	0f 1f 80 00 00 00 00
+	8	0f 1f 84 00 00 00 00 00
+	9	66 0f 1f 84 00 00 00 00 00
+*/
+void do_nopl_emu(struct pt_regs *regs, long error_code)
+{
+	u8 *ip = (u8 *)instruction_pointer(regs);
+	int res = do_start(ip);
+
+	if (res) {
+		int i = 0;
+		do {
+			ip += res;
+			i++;
+			res = do_start(ip);
+		} while(res);
+		printk(KERN_DEBUG "geode_nopl: emulated %d instructions\n", i);
+		regs->ip = (typeof(regs->ip))ip;
+	} else
+		do_invalid_op(regs, error_code);
+}


-- 
Matteo Croce
OpenWrt developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) ------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
