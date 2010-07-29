Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab0G2Tsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:48:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab0G2Tsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:48:36 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/17] x86,memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
Date: Thu, 29 Jul 2010 12:45:25 -0700
Message-Id: <1280432737-1808-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
References: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C51DAE3.00AA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

they are wrappers for core versions.
they are taking start/end/name instead of base/size.
will make x86 conversion more easy

could add more debug print out

-v2: change get_max_mapped() to memblock.default_alloc_limit according to Michael
      Ellerman and Ben
     change to memblock_x86_reserve_range and memblock_x86_free_range according to Michael Ellerman
-v3: call check_and_double after reserve/free, so could avoid to use
      find_memblock_area. Suggested by Michael Ellerman

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    3 +++
 arch/x86/mm/memblock.c          |   22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 69cf853..e11ddf0 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -6,4 +6,7 @@
 u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
 void memblock_x86_to_bootmem(u64 start, u64 end);
 
+void memblock_x86_reserve_range(u64 start, u64 end, char *name);
+void memblock_x86_free_range(u64 start, u64 end);
+
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 8101084..9829eaf 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -114,3 +114,25 @@ void __init memblock_x86_to_bootmem(u64 start, u64 end)
 	memblock_reserve_reserved_regions();
 }
 #endif
+
+void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	memblock_reserve(start, end - start);
+}
+
+void __init memblock_x86_free_range(u64 start, u64 end)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	memblock_free(start, end - start);
+}
-- 
1.6.4.2

