Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2FFRXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:23:46 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33575 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2FFRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:23:44 -0400
Message-ID: <201206061723.q56HNgtR016254@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 6 Jun 2012 13:11:05 -0400
Subject: [PATCH] edac: Do alignment logic properly in edac_align_ptr()
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic was checking the sizeof the structure being allocated to
determine whether an alignment fixup was required.  This isn't right;
what we actually care about is the alignment of the actual pointer that's
about to be returned.  This became an issue recently because struct
edac_mc_layer has a size that is not zero modulo eight, so we were
taking the correctly-aligned pointer and forcing it to be misaligned.
On Tile this caused an alignment exception.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
Mauro, I assume you will push this through your tree?  I am also happy
to push it through the tile tree.  Let me know!

 drivers/edac/edac_mc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 10f3750..de5ba86 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -164,7 +164,7 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
 	else
 		return (char *)ptr;
 
-	r = size % align;
+	r = (unsigned long)p % align;
 
 	if (r == 0)
 		return (char *)ptr;
-- 
1.6.5.2

