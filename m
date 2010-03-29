Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0C2SoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:44:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab0C2SoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:44:04 -0400
Date: Mon, 29 Mar 2010 18:43:11 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, hpa@zytor.com,
       mingo@redhat.com, konrad.wilk@oracle.com, yinghai@kernel.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       ian.campbell@citrix.com, hannes@cmpxchg.org, davem@davemloft.net,
       benh@kernel.crashing.org, tglx@linutronix.de, sgruszka@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, joel.becker@oracle.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org,
       konrad.wilk@oracle.com, torvalds@linux-foundation.org,
       ian.campbell@citrix.com, peterz@infradead.org, hannes@cmpxchg.org,
       davem@davemloft.net, benh@kernel.crashing.org, tglx@linutronix.de,
       sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <1269830604-26214-4-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-4-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Do not free zero sized per cpu areas
Message-ID: <tip-eed63519e3e74d515d2007ecd895338d0ba2a85c@git.kernel.org>
Git-Commit-ID: eed63519e3e74d515d2007ecd895338d0ba2a85c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 18:43:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eed63519e3e74d515d2007ecd895338d0ba2a85c
Gitweb:     http://git.kernel.org/tip/eed63519e3e74d515d2007ecd895338d0ba2a85c
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Sun, 28 Mar 2010 19:42:56 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Mar 2010 18:55:40 +0200

x86: Do not free zero sized per cpu areas

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial() to catch future problems.

-v5: put back start > end back into WARN_ONCE()
-v6: use one line for warning, suggested by Linus
-v7: more tests
-v8: remove the function name as suggested by Johannes
     WARN_ONCE() will print out that function name.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Joel Becker <joel.becker@oracle.com>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1269830604-26214-4-git-send-email-yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
