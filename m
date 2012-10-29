Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab2J2ED7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 00:03:59 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:34940 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab2J2ED5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 00:03:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIBAG6Zu08YNPuJ/2dsb2JhbAANN4UtqxuHEARRNgIFFgsCCwMCAQIBSwEMCAEBrxiSe4EmjgqBFAOoEA
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="203047618"
Message-ID: <508E002B.4090200@teksavvy.com>
Date: Mon, 29 Oct 2012 00:03:55 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Regression from 3.4.9 to 3.4.16 "stable" kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My server here runs the 3.4.xx series of "stable" kernels.
Until today, it was running 3.4.9.
Today I tried to upgrade it to 3.4.16.
It hangs in setup.c.

I've isolated the fault down to this specific change
that was made between 3.4.9 and 3.4.16.
Reverting this change allows the system to boot/run normally again.


--- linux-3.4.9/arch/x86/kernel/setup.c	2012-08-15 11:17:17.000000000 -0400
+++ linux-3.4.16/arch/x86/kernel/setup.c	2012-10-28 13:36:33.000000000 -0400
@@ -927,8 +927,21 @@

 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
+		int i;
+		for (i = 0; i < e820.nr_map; i++) {
+			struct e820entry *ei = &e820.map[i];
+
+			if (ei->addr + ei->size <= 1UL << 32)
+				continue;
+
+			if (ei->type == E820_RESERVED)
+				continue;
+
+			max_pfn_mapped = init_memory_mapping(
+				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
+				ei->addr + ei->size);
+		}
+
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn = max_pfn;
 	}
