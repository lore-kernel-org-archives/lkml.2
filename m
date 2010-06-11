Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab0FKJUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:20:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39263 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0FKJUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:20:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C11FFC0.1030006@jp.fujitsu.com>
Date: Fri, 11 Jun 2010 18:20:00 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com>
In-Reply-To: <4C11FF10.4060203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the physical address is too high to be handled by ioremap() in
x86_32 PAE (e.g. more than 36-bit physical address), ioremap() must
return error (NULL). However, current x86 ioremap try to map this too
high physical address, and it causes unexpected behavior.

The ioremap() seems to check the specified physical address using
phys_addr_valid(). But current phys_addr_valid() returns true even if
more than 36-bit address range is specified because
boot_cpu_data.x86_phys_bits can have more than 36 even in X86_32 PAE
mode (boot_cpu_data.x86_phys_bits seems to hold maximum capability of
the processor).

To fix the problem, this patch changes phys_addr_valid() function to
return false when more than 36-bit address range is specified in PAE.
The phys_addr_valid() function is used only by ioremap() in X86_32 PAE
mode. So this change only affects ioremap() in X86_32 PAE mode.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/mm/physaddr.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.34/arch/x86/mm/physaddr.h
===================================================================
--- linux-2.6.34.orig/arch/x86/mm/physaddr.h	2010-06-10 07:28:28.177229689 +0900
+++ linux-2.6.34/arch/x86/mm/physaddr.h	2010-06-10 07:28:32.587190857 +0900
@@ -3,8 +3,12 @@
 static inline int phys_addr_valid(resource_size_t addr)
 {
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
+#ifdef CONFIG_X86_64
 	return !(addr >> boot_cpu_data.x86_phys_bits);
 #else
+	return !(addr >> 36);
+#endif
+#else
 	return 1;
 #endif
 }


