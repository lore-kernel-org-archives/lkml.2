Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1DONvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:51:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:36106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1DONvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:51:46 -0400
Date: Fri, 15 Apr 2011 15:51:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: make expand_downwards symmetrical to expand_upwards
Message-ID: <20110415135144.GE8828@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the following patch is just a cleanup for better readability without any
functional changes. What do you think about it?
---
>From 71de71aaa725ee87459b3a256e8bb0af7de4abeb Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 15 Apr 2011 14:56:26 +0200
Subject: [PATCH] mm: make expand_downwards symmetrical to expand_upwards

Currently we have expand_upwards exported while expand_downwards is
accessible only via expand_stack.

check_stack_guard_page is a nice example of the asymmetry. It uses
expand_stack for VM_GROWSDOWN while expand_upwards is called for
VM_GROWSUP case. Let's make this consistent and export expand_downwards
same way we do with expand_upwards.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/mm.h |    2 ++
 mm/memory.c        |    2 +-
 mm/mmap.c          |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 692dbae..765cf4e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1498,8 +1498,10 @@ unsigned long ra_submit(struct file_ra_state *ra,
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
+  #define expand_downwards(vma, address) do { } while (0)
 #else
   #define expand_upwards(vma, address) do { } while (0)
+extern int expand_downwards(struct vm_area_struct *vma, unsigned long address);
 #endif
 extern int expand_stack_downwards(struct vm_area_struct *vma,
 				  unsigned long address);
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..f404fb6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2969,7 +2969,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_stack(vma, address - PAGE_SIZE);
+		expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
diff --git a/mm/mmap.c b/mm/mmap.c
index e27e0cf..6b2a817 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1782,7 +1782,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
-static int expand_downwards(struct vm_area_struct *vma,
+int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
-- 
1.7.4.1

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
