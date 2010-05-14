Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0ENA2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:28:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53030 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0ENAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/35] x86,lmb: Add lmb_reserve_area/lmb_free_area
Date: Thu, 13 May 2010 17:19:29 -0700
Message-Id: <1273796396-29649-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BEC97C8.0170,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

they are wrappers for core versions.

they are taking start/end/name instead of base/size.

could add more debug print out

-v2: change get_max_mapped() to lmb.default_alloc_limit according to Michael
      Ellerman and Ben
     change to lmb_reserve_area and lmb_free_area according to Michael Ellerman
-v3: call check_and_double after reserve/free, so could avoid to use
      find_lmb_area. Suggested by Michael Ellerman

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    4 ++++
 arch/x86/mm/lmb.c          |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 2f06714..bc85c1e 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -6,4 +6,8 @@
 u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
 void lmb_to_bootmem(u64 start, u64 end);
 
+void lmb_reserve_area(u64 start, u64 end, char *name);
+void lmb_free_area(u64 start, u64 end);
+void lmb_add_memory(u64 start, u64 end);
+
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 37a05e2..0dbe05b 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -117,3 +117,30 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 	lmb.reserved.cnt = 0;
 }
 #endif
+
+void __init lmb_add_memory(u64 start, u64 end)
+{
+	lmb_add_region(&lmb.memory, start, end - start);
+}
+
+void __init lmb_reserve_area(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	lmb_add_region(&lmb.reserved, start, end - start);
+}
+
+void __init lmb_free_area(u64 start, u64 end)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "lmb_free_area: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	lmb_free(start, end - start);
+}
-- 
1.6.4.2

