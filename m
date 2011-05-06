Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1EFAYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:22 -0400
Received: from kroah.org ([198.145.64.141]:36581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab1EFAYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.751686889@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [017/143] [PARISC] slub: fix panic with DISCONTIGMEM
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.

Slub makes assumptions about page_to_nid() which are violated by
DISCONTIGMEM and !NUMA.  This violation results in a panic because
page_to_nid() can be non-zero for pages in the discontiguous ranges and
this leads to a null return by get_node().  The assertion by the
maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
mips, parisc violate this.  The panic is a regression against slab, so
just mark slub broken in the problem configuration to prevent users
reporting these panics.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1028,6 +1028,7 @@ config SLAB
 	  per cpu and per node queues.
 
 config SLUB
+	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage


