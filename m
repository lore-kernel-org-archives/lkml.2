Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1G0WFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:05:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:17376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1G0Vse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32274649"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [35/99] UBIFS: fix memory leak on error path
Message-Id: <20110727214833.EA8F32403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 812eb258311f89bcd664a34a620f249d54a2cd83 upstream.

UBIFS leaks memory on error path in 'ubifs_jnl_update()' in case of write
failure because it forgets to free the 'struct ubifs_dent_node *dent' object.
Although the object is small, the alignment can make it large - e.g., 2KiB
if the min. I/O unit is 2KiB.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ubifs/journal.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/fs/ubifs/journal.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/journal.c
+++ linux-2.6.35.y/fs/ubifs/journal.c
@@ -665,6 +665,7 @@ out_free:
 
 out_release:
 	release_head(c, BASEHD);
+	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
 	if (last_reference)
