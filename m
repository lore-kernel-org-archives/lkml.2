Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0C2CrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:47:04 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19546 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0C2Cq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/31] x86: Do not free zero sized per cpu areas
Date: Sun, 28 Mar 2010 19:42:56 -0700
Message-Id: <1269830604-26214-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BB01465.0008,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

-v5: put back start > end back into WARN_ONCE()
-v6: use one line for warning according to linus
-v7: more test by
-v8: remove the function name according to Johannes
     WARN_ONCE will print that function name.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Joel Becker <joel.becker@oracle.com>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/early_res.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..31aa933 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,12 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "  wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
-- 
1.6.4.2

