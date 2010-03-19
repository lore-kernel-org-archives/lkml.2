Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab0CSTZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:25:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0CSTZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:25:35 -0400
Message-ID: <4BA3CF67.9000107@kernel.org>
Date: Fri, 19 Mar 2010 12:24:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org>
In-Reply-To: <4B914A61.20409@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    3 ++-
 kernel/early_res.c             |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef6370b..89a3205 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
 #ifdef CONFIG_NO_BOOTMEM
 	u64 start = __pa(ptr);
 	u64 end = start + size;
-	free_early_partial(start, end);
+	if (start < end)
+		free_early_partial(start, end);
 #else
 	free_bootmem(__pa(ptr), size);
 #endif
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..f3a861b 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	if (WARN_ONCE(start >= end,
+		      "free_early_partial got wrong start/end %#llx/%#llx\n",
+		      start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
-- 
1.5.6.5
