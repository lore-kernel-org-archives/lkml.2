Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0L2Xq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:46:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0L2Xq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:46:26 -0500
Message-ID: <4D1BC80F.1060409@kernel.org>
Date: Wed, 29 Dec 2010 15:45:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 1/6] x86: Change get_max_mapped() to inline
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933BA.8000508@kernel.org>
In-Reply-To: <4D1933BA.8000508@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move it into head file. to prepare use it in other files.

-v2: hpa pointed out that u64 should not be used here.
     Actually We could unsigned long here. because for 32bit it will under 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_types.h |    5 +++++
 arch/x86/kernel/setup.c           |    9 ---------
 2 files changed, 5 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/page_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_types.h
+++ linux-2.6/arch/x86/include/asm/page_types.h
@@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+static inline unsigned long get_max_mapped(void)
+{
+	return max_pfn_mapped<<PAGE_SHIFT;
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -680,15 +680,6 @@ static int __init parse_reservelow(char
 
 early_param("reservelow", parse_reservelow);
 
-static u64 __init get_max_mapped(void)
-{
-	u64 end = max_pfn_mapped;
-
-	end <<= PAGE_SHIFT;
-
-	return end;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
