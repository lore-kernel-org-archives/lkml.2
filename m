Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2IZMb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:31:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2IZMb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:31:56 -0400
Date: Wed, 26 Sep 2012 13:31:34 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix build with CMA && !CONFIG_COMPACTION
Message-ID: <20120926123134.GJ11266@suse.de>
References: <1348661586-22970-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1348661586-22970-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 01:13:06PM +0100, Mark Brown wrote:
> In -next 20120926 "mm: compaction: cache if a pageblock was scanned and
> no pages were isolated" adds pageblock skipping operations used when CMA
> is enabled but only provides them if CONFIG_COMPACTION is defined, breaking
> the build. Fix this by also providing them when only CONFIG_CMA is enabled.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks but I've already pushed an alternative patch towards Andrew for
this particular build problem. The patch explains why the fix is different.

---8<---
mm: compaction: cache if a pageblock was scanned and no pages were isolated -fix

Fengguang Wu reported the following

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.5
head:   2f641f902ca76711e47e8d3b18004f0e46ca3d9b
commit: 7faeb2a39c789f1bac69014cc468677a60b73395 [184/186] mm:
compaction: cache if a pageblock was scanned and no pages were isolated
config: i386-randconfig-b083 (attached as .config)

All error/warnings:

mm/compaction.c: In function 'isolation_suitable':
mm/compaction.c:60:2: error: implicit declaration of function 'get_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: In function 'reset_isolation_suitable':
mm/compaction.c:94:3: error: implicit declaration of function 'clear_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: In function 'update_pageblock_skip':
mm/compaction.c:108:3: error: implicit declaration of function 'set_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: At top level:
mm/compaction.c:68:13: warning: 'reset_isolation_suitable' defined but not used [-Wunused-function]
mm/compaction.c:177:13: warning: 'compact_capture_page' defined but not used [-Wunused-function]
cc1: some warnings being treated as errors

Michal Hocko suggested implementing !CONFIG_COMPACTION versions of these
functions but that still leaves the dead version of
reset_isolation_suitable in the !CONFIG_COMPACTION && CONFIG_CMA case.
Create !CONFIG_COMPACTION versions of isolation_suitable() and
update_pageblock_skip() instead.

This is a fix for
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5ffe9a5..fb07abb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -50,6 +50,7 @@ static inline bool migrate_async_suitable(int migratetype)
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
+#ifdef CONFIG_COMPACTION
 /* Returns true if the pageblock should be scanned for pages to isolate. */
 static inline bool isolation_suitable(struct compact_control *cc,
 					struct page *page)
@@ -107,6 +108,17 @@ static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
 	if (!nr_isolated)
 		set_pageblock_skip(page);
 }
+#else
+static inline bool isolation_suitable(struct compact_control *cc,
+					struct page *page)
+{
+	return true;
+}
+
+static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+{
+}
+#endif /* CONFIG_COMPACTION */
 
 static inline bool should_release_lock(spinlock_t *lock)
 {
