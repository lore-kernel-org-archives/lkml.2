Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0DVURF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:17:05 -0400
Received: from kroah.org ([198.145.64.141]:59832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab0DVUAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:53 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:12 2010
Message-Id: <20100422195412.687569787@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>, David Airlie <airlied@linux.ie>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [078/139] intel-agp: Switch to wbinvd_on_all_cpus
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 48a719c238bcbb72d6da79de9c5b3b93ab472107 upstream.

Simplify if-statement while at it.

[ hpa: we need to #include <asm/smp.h> ]

Cc: Dave Jones <davej@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-3-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
+#include <asm/smp.h>
 #include "agp.h"
 
 /*
@@ -815,12 +816,6 @@ static void intel_i830_setup_flush(void)
 		intel_i830_fini_flush();
 }
 
-static void
-do_wbinvd(void *null)
-{
-	wbinvd();
-}
-
 /* The chipset_flush interface needs to get data that has already been
  * flushed out of the CPU all the way out to main memory, because the GPU
  * doesn't snoop those buffers.
@@ -837,12 +832,10 @@ static void intel_i830_chipset_flush(str
 
 	memset(pg, 0, 1024);
 
-	if (cpu_has_clflush) {
+	if (cpu_has_clflush)
 		clflush_cache_range(pg, 1024);
-	} else {
-		if (on_each_cpu(do_wbinvd, NULL, 1) != 0)
-			printk(KERN_ERR "Timed out waiting for cache flush.\n");
-	}
+	else if (wbinvd_on_all_cpus() != 0)
+		printk(KERN_ERR "Timed out waiting for cache flush.\n");
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.


