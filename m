Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2FKImB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:42:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2FKImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:42:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,387,1336320000"; 
   d="scan'208";a="5158241"
Message-ID: <4FD5B048.30602@cn.fujitsu.com>
Date: Mon, 11 Jun 2012 16:46:00 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: [PATCH 2/2 v2] x86: reimplement mem boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com>
In-Reply-To: <4FD5AFF2.3040306@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/11 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/11 16:42:35,
	Serialize complete at 2012/06/11 16:42:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot option "mem=" specifies the total memory that the system can
use. But we implement it as max_addr.

The x86 system can be booted by EFI. If the user specify the boot
option "add_efi_memmap", we add all memory map from EFI, but we
donot handle the memory map according to the boot option "mem=".

This patch reimplement the boot option "mem=", and handle the memory
map after calling efi_init().

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |   36 +++++++++++++++++++++++++++++++-----
 arch/x86/kernel/setup.c     |    1 +
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 3778256..d1bb772 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -127,6 +127,7 @@ extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
+extern void set_memlimit(void);
 
 /*
  * Returns true iff the specified range [s,e) is completely contained inside
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index cd07226..b234b25 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -48,6 +48,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
 EXPORT_SYMBOL(pci_mem_start);
 #endif
 static u64 max_addr = ~0ULL;
+static u64 mem_limit = ~0ULL;
 
 /*
  * This function checks if any part of the range <start,end> is mapped
@@ -824,8 +825,6 @@ static int userdef __initdata;
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
-	u64 mem_size;
-
 	if (!p)
 		return -EINVAL;
 
@@ -840,16 +839,43 @@ static int __init parse_memopt(char *p)
 	}
 
 	userdef = 1;
-	mem_size = memparse(p, &p);
+	mem_limit = memparse(p, &p);
 	/* don't remove all of memory when handling "mem={invalid}" param */
-	if (mem_size == 0)
+	if (mem_limit == 0)
 		return -EINVAL;
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
 }
 early_param("mem", parse_memopt);
 
+void __init set_memlimit(void)
+{
+	u64 total_size = 0;
+	int i;
+
+	if (mem_limit == ~0ULL)
+		return;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (ei->type != E820_RAM)
+			continue;
+
+		if (total_size >= mem_limit) {
+			memset(ei, 0, sizeof(struct e820entry));
+			continue;
+		}
+
+		if (mem_limit - total_size <= ei->size)
+			ei->size = mem_limit - total_size;
+
+		total_size += ei->size;
+	}
+
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 static int __init parse_memmax_opt(char *p)
 {
 	char *oldp;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 16be6dc..a3c4ac3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -815,6 +815,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (efi_enabled)
 		efi_init();
+	set_memlimit();
 
 	dmi_scan_machine();
 
-- 
1.7.1

