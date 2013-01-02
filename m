Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3ABW6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:58:53 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:65010 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752787Ab3ABW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:58:23 -0500
X-TM-IMSS-Message-ID: <80b7e41b000c9452@nsa.gov>
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
To: viro@ZenIV.linux.org.uk, konrad.wilk@oracle.com
Cc: david.vrabel@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [PATCH 3/3] xen/gntdev: remove erronous use of copy_to_user
Date: Wed,  2 Jan 2013 17:57:13 -0500
Message-Id: <1357167433-16874-4-git-send-email-dgdegra@tycho.nsa.gov>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
References: <20121221201824.GA31554@phenom.dumpdata.com>
 <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is now a mapping of granted pages in kernel address space in
both PV and HVM, use it for UNMAP_NOTIFY_CLEAR_BYTE instead of accessing
memory via copy_to_user and triggering sleep-in-atomic warnings.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
---
 drivers/xen/gntdev.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 9be3e5e..3c8803f 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -312,17 +312,10 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
 
 	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		int pgno = (map->notify.addr >> PAGE_SHIFT);
-		if (pgno >= offset && pgno < offset + pages && use_ptemod) {
-			void __user *tmp = (void __user *)
-				map->vma->vm_start + map->notify.addr;
-			err = copy_to_user(tmp, &err, 1);
-			if (err)
-				return -EFAULT;
-			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
-		} else if (pgno >= offset && pgno < offset + pages) {
-			uint8_t *tmp = kmap(map->pages[pgno]);
+		if (pgno >= offset && pgno < offset + pages) {
+			/* No need for kmap, pages are in lowmem */
+			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
 			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
-			kunmap(map->pages[pgno]);
 			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
 		}
 	}
-- 
1.7.11.7

