Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2K1V6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:58:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2K1Vso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 46/46] x86, mm: Let "memmap=" take more entries one time
Date: Wed, 28 Nov 2012 13:47:57 -0800
Message-Id: <1354139277-17376-47-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current "memmap=" only can take one entry every time.
when we have more entries, we have to use memmap= for each of them.

For pxe booting, we have command line length limitation, those extra
"memmap=" would waste too much space.

This patch make memmap= could take several entries one time,
and those entries will be split with ','

-v2: add doc in kernel-parameters.txt according to Konard.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 arch/x86/kernel/e820.c              |   16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..11c4125 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1514,6 +1514,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			         or
 			         memmap=0x10000$0x18690000
 
+	memmap=option[,option...]  [KNL,X86] various options together
+			option could be
+				exactmap
+				nn[KMG]@ss[KMG]
+				nn[KMG]#ss[KMG]
+				nn[KMG]$ss[KMG]
+
 	memory_corruption_check=0/1 [X86]
 			Some BIOSes seem to corrupt the first 64k of
 			memory when doing things like suspend/resume.
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..d32abea 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -835,7 +835,7 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
-static int __init parse_memmap_opt(char *p)
+static int __init parse_memmap_one(char *p)
 {
 	char *oldp;
 	u64 start_at, mem_size;
@@ -877,6 +877,20 @@ static int __init parse_memmap_opt(char *p)
 
 	return *p == '\0' ? 0 : -EINVAL;
 }
+static int __init parse_memmap_opt(char *str)
+{
+	while (str) {
+		char *k = strchr(str, ',');
+
+		if (k)
+			*k++ = 0;
+
+		parse_memmap_one(str);
+		str = k;
+	}
+
+	return 0;
+}
 early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
-- 
1.7.7

