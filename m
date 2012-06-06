Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2FFQFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:05:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2FFQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:05:04 -0400
Date: Wed, 6 Jun 2012 09:04:49 -0700
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1334961696-19580-5-git-send-email-asharma@fb.com>
References: <1334961696-19580-5-git-send-email-asharma@fb.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Check user address explicitly in copy_from_user_nmi()
Git-Commit-ID: db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
Gitweb:     http://git.kernel.org/tip/db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Fri, 20 Apr 2012 15:41:36 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:08:04 +0200

perf/x86: Check user address explicitly in copy_from_user_nmi()

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334961696-19580-5-git-send-email-asharma@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/usercopy.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index f61ee67..677b1ed 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 
 #include <asm/word-at-a-time.h>
+#include <linux/sched.h>
 
 /*
  * best effort, GUP based copy_from_user() that is NMI-safe
@@ -21,6 +22,9 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
+	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+		return len;
+
 	do {
 		ret = __get_user_pages_fast(addr, 1, 0, &page);
 		if (!ret)
