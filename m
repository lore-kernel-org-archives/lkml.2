Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab0LNVTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:19:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57534 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab0LNVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:organization:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=WwJkrvrQkKi32RKnidos+KBM9Qh7+QKpUn/9bydoZZKWMPvYW6HqDa5BU3Zgh2tsrT
         wUnujnQ7ZyZLL5XOYkMuOE8BbR3XNzerqcwuVuGX5SB6ycjAsq3GsPH2ZeiRefoPK7JH
         I42Ryk1sL383u/NwkWMg17euWUhjfkwhUkll8=
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.brandewie@gmail.com>,
        sodaville@linutronix.de, Ingo Molnar <mingo@elte.hu>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86/trampoline: fallback to fixed trampoline address if no e820 map is provided
Date: Tue, 14 Dec 2010 22:19:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012142219.40062.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <ffainelli@freebox.fr>

Since 893f38d1 (x86: Use find_e820() instead of hard coded trampoline address),
the trampoline base address should be provided by the BIOS as an e820 area.
Some minimalistic BIOSes (like CEFDK on CE4100) may not provide any e820 area,
still we should fallback to a fixed trampoline base address for SMP to work
correctly.

Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: sodaville@linutronix.de
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index f4500fb..908b395 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -16,6 +16,7 @@ extern unsigned long initial_code;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
+#define TRAMPOLINE_BASE 0x6000
 
 extern unsigned long setup_trampoline(void);
 extern void __init reserve_trampoline_memory(void);
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index f1488a3..d025aae 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -21,8 +21,11 @@ void __init reserve_trampoline_memory(void)
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
-	if (mem == -1L)
-		panic("Cannot allocate trampoline\n");
+	if (mem == -1L) {
+		printk(KERN_INFO "BIOS did not provide e820 area for trampoline"
+				" ,using static trampoline address\n");
+		mem = TRAMPOLINE_BASE;
+	}
 
 	trampoline_base = __va(mem);
 	reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
-- 
1.7.1

