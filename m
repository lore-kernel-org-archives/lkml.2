Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3ADAzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:55:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3ADAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:41 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v7u1 05/31] x86, 64bit: copy zero-page early
Date: Thu,  3 Jan 2013 16:48:25 -0800
Message-Id: <1357260531-11115-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real_mode_data aka zero-page could be above 4g.
We will have #PF handler to set page table for not accessible ram
early, but could limit it before x86_64_start_reservations to limit
the change to native path.

Also we will need to ramdisk info in zero-page to access microcode
blob in ramdisk in x86_64_start_kernel, so copy zero-page early make
it accessing ramdisk info simple.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head64.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7b215a5..c0a25e0 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -87,6 +87,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
+	copy_bootdata(__va(real_mode_data));
+
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
@@ -95,7 +97,9 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/* version is always not zero if it is copied */
+	if (!boot_params.hdr.version)
+		copy_bootdata(__va(real_mode_data));
 
 	memblock_reserve(__pa_symbol(_text),
 			 (unsigned long)__bss_stop - (unsigned long)_text);
-- 
1.7.10.4

