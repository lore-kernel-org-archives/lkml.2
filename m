Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3AIMEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:04:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619Ab3AIMEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:04:50 -0500
Date: Wed, 9 Jan 2013 12:04:47 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: migrate: Check page_count of THP before migrating
 accounting fix
Message-ID: <20130109120447.GB13304@suse.de>
References: <20130107170815.GO3885@suse.de>
 <alpine.LNX.2.00.1301081931530.20504@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301081931530.20504@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Hugh Dickins, "mm: migrate: Check page_count of THP
before migrating" can leave nr_isolated_anon elevated, correct it. This
is a fix to mm-migrate-check-page_count-of-thp-before-migrating.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f466827..c387786 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1689,8 +1689,11 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	if (!isolated || page_count(page) != 2) {
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		put_page(new_page);
-		if (isolated)
+		if (isolated) {
 			putback_lru_page(page);
+			isolated = 0;
+			goto out;
+		}
 		goto out_keep_locked;
 	}
 
