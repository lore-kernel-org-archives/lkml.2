Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2EVHBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:01:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62781 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2EVHBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:01:37 -0400
X-IronPort-AV: E=Sophos;i="4.75,637,1330876800"; 
   d="scan'208";a="5009893"
Message-ID: <4FBB3AA7.5070307@cn.fujitsu.com>
Date: Tue, 22 May 2012 15:05:11 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: reimplement mem boot option
References: <4FBB3A23.50102@cn.fujitsu.com>
In-Reply-To: <4FBB3A23.50102@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 15:00:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 15:00:09,
	Serialize complete at 2012/05/22 15:00:09
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
index 2a6bec7..0148944 100644
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
index 1a29015..7938fae 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -823,6 +823,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (efi_enabled)
 		efi_init();
+	set_memlimit();
 
 	dmi_scan_machine();
 
-- 
1.7.1

