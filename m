Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1I1WpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab1I1Wo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.513433242@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Keir Fraser <keir.xen@gmail.com>
Subject: [125/244] mm: sync vmalloc address space page tables in alloc_vm_area()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 461ae488ecb125b140d7ea29ceeedbcce9327003 upstream.

Xen backend drivers (e.g., blkback and netback) would sometimes fail to
map grant pages into the vmalloc address space allocated with
alloc_vm_area().  The GNTTABOP_map_grant_ref would fail because Xen could
not find the page (in the L2 table) containing the PTEs it needed to
update.

(XEN) mm.c:3846:d0 Could not find L1 PTE for address fbb42000

netback and blkback were making the hypercall from a kernel thread where
task->active_mm != &init_mm and alloc_vm_area() was only updating the page
tables for init_mm.  The usual method of deferring the update to the page
tables of other processes (i.e., after taking a fault) doesn't work as a
fault cannot occur during the hypercall.

This would work on some systems depending on what else was using vmalloc.

Fix this by reverting ef691947d8a3 ("vmalloc: remove vmalloc_sync_all()
from alloc_vm_area()") and add a comment to explain why it's needed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Keir Fraser <keir.xen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2154,6 +2154,14 @@ struct vm_struct *alloc_vm_area(size_t s
 		return NULL;
 	}
 
+	/*
+	 * If the allocated address space is passed to a hypercall
+	 * before being used then we cannot rely on a page fault to
+	 * trigger an update of the page tables.  So sync all the page
+	 * tables here.
+	 */
+	vmalloc_sync_all();
+
 	return area;
 }
 EXPORT_SYMBOL_GPL(alloc_vm_area);


