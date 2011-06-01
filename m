Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161847Ab1FAIPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:15:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:43756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161808Ab1FAIPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:11 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:48 2011
Message-Id: <20110601081047.776958419@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:31 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [001/165] tmpfs: fix highmem swapoff crash regression
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1204
Lines: 45

From: Hugh Dickins <hughd@google.com>

commit e6c9366b2adb52cba64b359b3050200743c7568c upstream.

Commit 778dd893ae78 ("tmpfs: fix race between umount and swapoff")
forgot the new rules for strict atomic kmap nesting, causing

  WARNING: at arch/x86/mm/highmem_32.c:81

from __kunmap_atomic(), then

  BUG: unable to handle kernel paging request at fffb9000

from shmem_swp_set() when shmem_unuse_inode() is handling swapoff with
highmem in use.  My disgrace again.

See
  https://bugzilla.kernel.org/show_bug.cgi?id=35352

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -916,11 +916,12 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
+			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
+				ptr = shmem_swp_map(subdir);
 				goto found;
 			}
-			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:


