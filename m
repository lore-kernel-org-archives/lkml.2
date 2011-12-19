Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1LSR3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:29:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38649 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1LSR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:29:15 -0500
Date: Mon, 19 Dec 2011 09:29:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Eugene Surovegin <ebs@ebshome.net>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: [GIT PULL] percpu: fixes for v3.2-rc6
Message-ID: <20111219172910.GK24519@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

per_cpu_ptr_to_phys() had another silly bug where it chopped off page
offset of translated addresses if they are in vmalloc area, which of
course makes kdump quite unhappy.

Please pull from the following branch to receive the fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.2-fixes

Thanks.

Eugene Surovegin (1):
      percpu: fix per_cpu_ptr_to_phys() handling of non-page-aligned addresses

 mm/percpu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
---
diff --git a/mm/percpu.c b/mm/percpu.c
index 3bb810a..716eb4a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1023,9 +1023,11 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
-			return page_to_phys(vmalloc_to_page(addr));
+			return page_to_phys(vmalloc_to_page(addr)) +
+			       offset_in_page(addr);
 	} else
-		return page_to_phys(pcpu_addr_to_page(addr));
+		return page_to_phys(pcpu_addr_to_page(addr)) +
+		       offset_in_page(addr);
 }
 
 /**
