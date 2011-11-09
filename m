Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319Ab1KJDlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:41:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965276Ab1KJDlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.200062634@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [120/264] io-mapping: ensure io_mapping_map_atomic _is_ atomic
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 24dd85ff723f142093f44244764b9b5c152235b8 upstream.

For the !HAVE_ATOMIC_IOMAP case the stub functions did not call
pagefault_disable/_enable. The i915 driver relies on the map
actually being atomic, otherwise it can deadlock with it's own
pagefault handler in the gtt pwrite fastpath.

This is exercised by gem_mmap_gtt from the intel-gpu-toosl gem
testsuite.

v2: Chris Wilson noted the lack of an include.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38115
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/io-mapping.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -117,6 +117,8 @@ io_mapping_unmap(void __iomem *vaddr)
 
 #else
 
+#include <linux/uaccess.h>
+
 /* this struct isn't actually defined anywhere */
 struct io_mapping;
 
@@ -138,12 +140,14 @@ static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset)
 {
+	pagefault_disable();
 	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
 io_mapping_unmap_atomic(void __iomem *vaddr)
 {
+	pagefault_enable();
 }
 
 /* Non-atomic map/unmap */


