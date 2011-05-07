Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1EGFhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:37:47 -0400
Received: from mout.perfora.net ([74.208.4.195]:52776 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1EGFhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:37:46 -0400
Date: Sat, 7 May 2011 01:37:29 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, Stephen Wilson <wilsons@start.ca>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2011-05-06-16-39 uploaded (fs/proc/task_mmu)
Message-ID: <20110507053729.GA3205@fibrous.localdomain>
References: <201105070015.p470FlAR013200@imap1.linux-foundation.org> <20110506183517.29369143.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506183517.29369143.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:nKZ+sdpU9xfqxST0lYObTC1g3n4qwyZd/i5vXZbDmi9
 f4AsE9ycDBkSl4hY/gvFiVDNoK6PPf8DHO9YQUasdIoREA5PIA
 RqzsPjtrZKz/91QhmdaSwnS7fmaGXzUYSYMIMxldpoFulab9B7
 kft1FzX8Po7GMUCULUrhn4/6GWyMywgSvoTMmCbdAvj+CbOtQF
 p+5s0JkYxjCy7DkM/Sv4WkLuDqfpCo/uhWA22T54AQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 06:35:17PM -0700, Randy Dunlap wrote:
> On Fri, 06 May 2011 16:39:31 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-05-06-16-39 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.39-rc6:
> 
> from "mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch":
> 
> on i386 (X86_32):
> 
> fs/proc/task_mmu.c:981: error: implicit declaration of function 'mpol_to_str'
> 
> when CONFIG_SHMEM=n, CONFIG_TMPFS=n, and these NUMA config settings:

OK, thanks for finding this!  The key here is CONFIG_TMPFS=n.  I think
the only path forward is the obvious one.  If reasonable, the following
can be appied just prior to
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch.



>From 83aea2021566dd0ceb720b6493df9682cde373f7 Mon Sep 17 00:00:00 2001
From: Stephen Wilson <wilsons@start.ca>
Date: Fri, 6 May 2011 23:45:07 -0400
Subject: [PATCH] mm: declare mpol_to_str() when CONFIG_TMPFS=n

When CONFIG_TMPFS=n mpol_to_str() is not declared in mempolicy.h.
However, in the NUMA case, the definition is always compiled.

Since it is not strictly true that tmpfs is the only client, and since
the symbol was always lurking around anyways, export mpol_to_str()
unconditionally.  Furthermore, this will allow us to move
show_numa_map() out of mempolicy.c and into the procfs subsystem.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/mempolicy.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index c2f6032..7978eec 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -231,10 +231,10 @@ int do_migrate_pages(struct mm_struct *mm,
 
 #ifdef CONFIG_TMPFS
 extern int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context);
+#endif
 
 extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 			int no_context);
-#endif
 
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
@@ -371,13 +371,13 @@ static inline int mpol_parse_str(char *str, struct mempolicy **mpol,
 {
 	return 1;	/* error */
 }
+#endif
 
 static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 				int no_context)
 {
 	return 0;
 }
-#endif
 
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
-- 
1.7.3.5

