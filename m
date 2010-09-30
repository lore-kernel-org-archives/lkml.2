Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0I3Czx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:55:53 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61934 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0I3Czv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:55:51 -0400
Date: Thu, 30 Sep 2010 11:54:51 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <ak@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (hwpoison tree related)
Message-ID: <20100930025451.GB10142@spritzera.linux.bs1.fc.nec.co.jp>
References: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 27, 2010 at 03:55:51PM +1000, Stephen Rothwell wrote:
> Hi Andi,
> 
> After merging the final tree, today's linux-next build (powerpc allnoconfig)
> failed like this:
> 
> mm/mprotect.o: In function `migrate_huge_page_move_mapping':
> mprotect.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapping'
> mm/shmem.o:shmem.c:(.text+0x0): first defined here
> mm/rmap.o: In function `migrate_huge_page_move_mapping':
> rmap.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapping'
> mm/shmem.o:shmem.c:(.text+0x0): first defined here
> 
> Caused by commit 7b217c52ce7f33379beb27aa7685109fa74ed6bf ("hugetlb:
> hugepage migration core").
> 
> This function is declared as "extern int ..." with a body in
> include/linux/migrate.h for the non CONFIG_MIGRATION case.

This build error reappears for x86_64 with !CONFIG_MIGRATION.
As you commented, "extern int" declaration causes it.
So please apply the following patch.

Thank you for reporting.

Thanks,
Naoya Horiguchi

---
Date: Thu, 30 Sep 2010 09:56:02 +0900
Subject: [PATCH] fix build error with !CONFIG_MIGRATION

migrate_huge_page_move_mapping() is declared as "extern int ..."
in include/linux/migrate.h for !CONFIG_MIGRATION,
which causes the build error like below:

  mm/mprotect.o: In function `migrate_huge_page_move_mapping':
  mprotect.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapping'
  mm/shmem.o:shmem.c:(.text+0x0): first defined here
  mm/rmap.o: In function `migrate_huge_page_move_mapping':
  rmap.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapping'
  mm/shmem.o:shmem.c:(.text+0x0): first defined here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/migrate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 3c1941e..085527f 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -50,7 +50,7 @@ static inline int migrate_vmas(struct mm_struct *mm,
 static inline void migrate_page_copy(struct page *newpage,
 				     struct page *page) {}
 
-extern int migrate_huge_page_move_mapping(struct address_space *mapping,
+static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page)
 {
 	return -ENOSYS;
-- 
1.7.2.3


