Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2JRUvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:51:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42516 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2JRUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 18/19] x86, mm: Let "memmap=" take more entries one time
Date: Thu, 18 Oct 2012 13:50:29 -0700
Message-Id: <1350593430-24470-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current "memmap=" only can take one entry every time.
when we have more entries, we have to use memmap= for each of them.

For pxe booting, we have command line length limitation, those extra
"memmap=" would waste too much space.

This patch make memmap= could take several entries one time,
and those entries will be split with ','

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index ed858e9..f281328 100644
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

