Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2EVG7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:59:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2EVG7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:59:23 -0400
X-IronPort-AV: E=Sophos;i="4.75,637,1330876800"; 
   d="scan'208";a="5009877"
Message-ID: <4FBB3A23.50102@cn.fujitsu.com>
Date: Tue, 22 May 2012 15:02:59 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: add max_addr boot option
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 14:57:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 14:57:55,
	Serialize complete at 2012/05/22 14:57:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the boot option max_addr is only supported on ia64 platform.
We also need it on x86 platform.
For example:
There are two nodes:
 NODE#0  address range 0x00000000 00000000 - 0x00010000 00000000 
 NODE#1  address range 0x00010000 00000000 - 0x00020000 00000000
If we only want to use node0, we can specify the max_addr. The boot
option "mem=" can do the same thing now. But the boot option "mem="
means the total memory used by the system. If we tell the user
that the boot option "mem=" can do this, it will confuse the user.
So we need an new boot option "max_addr" on x86 platform.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/kernel/e820.c              |   36 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..fe80e58 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1409,7 +1409,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			 yeeloong laptop.
 			Example: machtype=lemote-yeeloong-2f-7inch
 
-	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater
+	max_addr=nn[KMG]	[KNL,BOOT,ia64,X86] All physical memory greater
 			than or equal to this physical address is ignored.
 
 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 62d61e9..2a6bec7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(pci_mem_start);
 #endif
+static u64 max_addr = ~0ULL;
 
 /*
  * This function checks if any part of the range <start,end> is mapped
@@ -117,6 +118,20 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 		return;
 	}
 
+	if (start >= max_addr) {
+		printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
+		       (unsigned long long)start,
+		       (unsigned long long)(start + size));
+		return;
+	}
+
+	if (max_addr - start < size) {
+		printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
+		       (unsigned long long)max_addr,
+		       (unsigned long long)(start + size));
+		size = max_addr - start;
+	}
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -835,6 +850,22 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
+static int __init parse_memmax_opt(char *p)
+{
+	char *oldp;
+
+	if (!p)
+		return -EINVAL;
+
+	oldp = p;
+	max_addr = memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	return 0;
+}
+early_param("max_addr", parse_memmax_opt);
+
 static int __init parse_memmap_opt(char *p)
 {
 	char *oldp;
@@ -881,6 +912,11 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
+	if (max_addr != ~0ULL) {
+		userdef = 1;
+		e820_remove_range(max_addr, ULLONG_MAX - max_addr, E820_RAM, 1);
+	}
+
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-- 
1.7.1
