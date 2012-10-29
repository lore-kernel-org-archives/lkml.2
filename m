Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2J2Ine (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:43:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab2J2InI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:43:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,670,1344182400"; 
   d="scan'208";a="6091105"
From: Wen Congyang <wency@cn.fujitsu.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 2/2] x86: make 'mem=' option to work for efi platform
Date: Mon, 29 Oct 2012 16:48:44 +0800
Message-Id: <1351500524-23907-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
References: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:24,
	Serialize complete at 2012/10/29 16:42:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mem boot option only can work for non efi environment. If the user
specifies add_efi_memmap, it cannot work for efi environment. In
the efi environment, we call e820_add_region() to add the memory map. So
we can modify __e820_add_region() and the mem boot option can work for
efi environment.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/kernel/e820.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..b15b341 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(pci_mem_start);
 #endif
+static u64 mem_limit = ~0ULL;
 
 /*
  * This function checks if any part of the range <start,end> is mapped
@@ -119,6 +120,20 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 		return;
 	}
 
+	if (start >= mem_limit) {
+		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long)start,
+		       (unsigned long long)(start + size - 1));
+		return;
+	}
+
+	if (mem_limit - start < size) {
+		printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long)mem_limit,
+		       (unsigned long long)(start + size - 1));
+		size = mem_limit - start;
+	}
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -809,7 +824,7 @@ static int userdef __initdata;
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
-	u64 mem_size;
+	char *oldp;
 
 	if (!p)
 		return -EINVAL;
@@ -825,11 +840,11 @@ static int __init parse_memopt(char *p)
 	}
 
 	userdef = 1;
-	mem_size = memparse(p, &p);
+	oldp = p;
+	mem_limit = memparse(p, &p);
 	/* don't remove all of memory when handling "mem={invalid}" param */
-	if (mem_size == 0)
+	if (mem_limit == 0 || p == oldp)
 		return -EINVAL;
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
 }
@@ -881,6 +896,12 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
+	if (mem_limit != ~0ULL) {
+		userdef = 1;
+		e820_remove_range(mem_limit, ULLONG_MAX - mem_limit,
+				  E820_RAM, 1);
+	}
+
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-- 
1.8.0

