Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2FHOsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:48:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2FHOss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:48:48 -0400
Date: Fri, 8 Jun 2012 07:48:26 -0700
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-bd2753b2dda7bb43c7468826de75f49c6a7e8965@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, holt@sgi.com, xiyou.wangcong@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, holt@sgi.com, xiyou.wangcong@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t=MOzJ=9BZMYA@mail.gmail.com>
References: <CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t=MOzJ=9BZMYA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Only add extra pages count for the first memory range during pre-allocation early page table space
Git-Commit-ID: bd2753b2dda7bb43c7468826de75f49c6a7e8965
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:48:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd2753b2dda7bb43c7468826de75f49c6a7e8965
Gitweb:     http://git.kernel.org/tip/bd2753b2dda7bb43c7468826de75f49c6a7e8965
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 Jun 2012 10:55:40 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:40:50 +0200

x86/mm: Only add extra pages count for the first memory range during pre-allocation early page table space

Robin found this regression:

| I just tried to boot an 8TB system.  It fails very early in boot with:
| Kernel panic - not syncing: Cannot find space for the kernel page tables

git bisect commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.

A git revert of that commit does boot past that point on the 8TB
configuration.

That commit will add up extra pages for all memory range even
above 4g.

Try to limit that extra page count adding to first entry only.

Bisected-by: Robin Holt <holt@sgi.com>
Tested-by: Robin Holt <holt@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t%3DMOzJ%3D9BZMYA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 97141c2..bc4e9d8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -62,7 +62,8 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 		extra += PMD_SIZE;
 #endif
 		/* The first 2/4M doesn't use large pages. */
-		extra += mr->end - mr->start;
+		if (mr->start < PMD_SIZE)
+			extra += mr->end - mr->start;
 
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
