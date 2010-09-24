Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0IXMYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:24:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:35411 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0IXMYs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 24 Sep 2010 08:24:48 -0400
Message-Id: <4C9CB4DA0200007800018CFE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 24 Sep 2010 13:25:30 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <chris@chris-wilson.co.uk>
Cc: <eric@anholt.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] some clean up to intel-gtt.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit e517a5e97080bbe52857bd0d7df9b66602d53c4d the call to
map_page_into_agp() got removed from intel_i830_setup_flush(), but the
counterpart call from intel_i830_fini_flush() to unmap_page_from_agp()
was left in place.

Additionally, the page allocated here never gets its physical address
used for sending to hardware, so there's no need to allocate it with
GFP_DMA32. Nor is __GFP_ZERO really necessary, as the page is used
only to store data to force flushing of some internal processor state.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Eric Anholt <eric@anholt.net>

---
 drivers/char/agp/intel-gtt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.36-rc5/drivers/char/agp/intel-gtt.c
+++ 2.6.36-rc5-intel-agp-cleanup/drivers/char/agp/intel-gtt.c
@@ -768,7 +768,6 @@ static void intel_i830_fini_flush(void)
 {
 	kunmap(intel_private.i8xx_page);
 	intel_private.i8xx_flush_page = NULL;
-	unmap_page_from_agp(intel_private.i8xx_page);
 
 	__free_page(intel_private.i8xx_page);
 	intel_private.i8xx_page = NULL;
@@ -780,7 +779,7 @@ static void intel_i830_setup_flush(void)
 	if (intel_private.i8xx_page)
 		return;
 
-	intel_private.i8xx_page = alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA32);
+	intel_private.i8xx_page = alloc_page(GFP_KERNEL);
 	if (!intel_private.i8xx_page)
 		return;
 



