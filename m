Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2BTRW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:22:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2BTRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:22:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.128.202 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 04/22] mm: drain percpu lru add/rotate page-vectors on cpu
 hot-unplug
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:22:50 +0400
Message-ID: <20120220172250.22196.16894.stgit@zurg>
In-Reply-To: <20120220171138.22196.65847.stgit@zurg>
References: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cpu hotplug hook was accidentally removed in commit v2.6.30-rc4-18-g00a62ce
("mm: fix Committed_AS underflow on large NR_CPUS environment")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/swap.h |    1 +
 mm/page_alloc.c      |    1 +
 mm/swap.c            |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index f7df3ea..ba2c8d7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -229,6 +229,7 @@ extern void lru_add_page_tail(struct zone* zone,
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
+extern void lru_add_drain_cpu(int cpu);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a547177..85517af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4873,6 +4873,7 @@ static int page_alloc_cpu_notify(struct notifier_block *self,
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		lru_add_drain_cpu(cpu);
 		drain_pages(cpu);
 
 		/*
diff --git a/mm/swap.c b/mm/swap.c
index fff1ff7..38b2686 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -496,7 +496,7 @@ static void lru_deactivate_fn(struct page *page, void *arg)
  * Either "cpu" is the current CPU, and preemption has already been
  * disabled; or "cpu" is being hot-unplugged, and is already dead.
  */
-static void drain_cpu_pagevecs(int cpu)
+void lru_add_drain_cpu(int cpu)
 {
 	struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
 	struct pagevec *pvec;
@@ -553,7 +553,7 @@ void deactivate_page(struct page *page)
 
 void lru_add_drain(void)
 {
-	drain_cpu_pagevecs(get_cpu());
+	lru_add_drain_cpu(get_cpu());
 	put_cpu();
 }
 

