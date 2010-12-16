Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0LPE3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 23:29:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33200 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0LPE3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 23:29:35 -0500
Message-ID: <4D09958D.2040907@kernel.org>
Date: Wed, 15 Dec 2010 20:29:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Vivek Goyal <vgoyal@redhat.com>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com>
In-Reply-To: <20101215103954.GA2243@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] x86, crashkernel, 32bit: only try to get range under 512M

Steanishlaw report kdump is 32bit is broken.

in misc.c for decompresser, it will do sanity checking to make sure heap
heap under 512M.

So limit it in first kernel under 512M for 32bit system.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -499,7 +499,19 @@ static inline unsigned long long get_tot
 	return total << PAGE_SHIFT;
 }
 
+/*
+ * arch/x86/boot/compressed/misc.c will check heap size for decompresser
+ *  32bit will have more strict limitation
+ */
 #define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+#define HEAP_LIMIT_32BIT 0x20000000
+
+#ifdef CONFIG_X86_64
+#define CRASH_KERNEL_LIMIT DEFAULT_BZIMAGE_ADDR_MAX
+#else
+#define CRASH_KERNEL_LIMIT HEAP_LIMIT_32BIT
+#endif
+
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -521,7 +533,7 @@ static void __init reserve_crashkernel(v
 		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+			       CRASH_KERNEL_LIMIT, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
