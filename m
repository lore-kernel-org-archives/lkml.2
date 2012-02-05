Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2BEWuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:50:50 -0500
Received: from 1wt.eu ([62.212.114.60]:61820 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab2BEW0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:09 -0500
Message-Id: <20120205220949.536346997@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 02/91] slub: fix panic with DISCONTIGMEM
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/init/Kconfig
===================================================================
--- longterm-2.6.27.orig/init/Kconfig	2012-02-05 22:34:35.012915163 +0100
+++ longterm-2.6.27/init/Kconfig	2012-02-05 22:34:35.225915821 +0100
@@ -747,6 +747,7 @@
 	  a slab allocator.
 
 config SLUB
+	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage


