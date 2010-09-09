Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0IIPZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:25:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24938 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0IIPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:25:31 -0400
Date: Thu, 9 Sep 2010 08:23:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mm/Kconfig: warning: (COMPACTION && EXPERIMENTAL &&
 HUGETLB_PAGE && MMU) selects MIGRATION which has unmet direct dependencies
 (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE)
Message-Id: <20100909082331.7278e76b.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
References: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 17:10:34 +0200 Sedat Dilek wrote:

> Hi,
> 
> while build latest 2.6.36-rc3 I get this warning:
> 
> [ build.log]
> ...
> warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE && MMU) selects
> MIGRATION which has unmet direct dependencies (NUMA ||
> ARCH_ENABLE_MEMORY_HOTREMOVE)
> ...
> 
> Here the excerpt of...
> 
> [ mm/Kconfig ]
> ...
> # support for memory compaction
> config COMPACTION
>         bool "Allow for memory compaction"
>         select MIGRATION
>         depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
>         help
>           Allows the compaction of memory for the allocation of huge pages.
> ...
> 
> I have set the following kernel-config parameters:
> 
> $ egrep 'COMPACTION|HUGETLB_PAGE|MMU|MIGRATION|NUMA|ARCH_ENABLE_MEMORY_HOTREMOVE'
> linux-2.6.36-rc3/debian/build/build_i386_none_686/.config
> CONFIG_MMU=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_IOMMU_API=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_HUGETLB_PAGE=y
> # CONFIG_IOMMU_STRESS is not set
> 
> Looks like I have no NUMA or ARCH_ENABLE_MEMORY_HOTREMOVE set.
> 
> Ok, it is a *warning*...


Andrea Arcangeli posted a patch for this on linux-mm on 2010-SEP-03.
(below)

---
From: Andrea Arcangeli <aarcange@redhat.com>

COMPACTION enables MIGRATION, but MIGRATION spawns a warning if numa
or memhotplug aren't selected. However MIGRATION doesn't depend on
them. I guess it's just trying to be strict doing a double check on
who's enabling it, but it doesn't know that compaction also enables
MIGRATION.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/Kconfig b/mm/Kconfig
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -189,7 +189,7 @@ config COMPACTION
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
+	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful in
