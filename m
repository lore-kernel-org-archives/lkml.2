Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1DZVNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:30103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625Ab1DZVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483459"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [18/106] UBIFS: fix oops on error path in read_pnode
Message-Id: <20110426211256.ACB8D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 54acbaaa523ca0bd284a18f67ad213c379679e86 upstream.

Thanks to coverity which spotted that UBIFS will oops if 'kmalloc()'
in 'read_pnode()' fails and we dereference a NULL 'pnode' pointer
when we 'goto out'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ubifs/lpt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/fs/ubifs/lpt.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/lpt.c
+++ linux-2.6.35.y/fs/ubifs/lpt.c
@@ -1270,10 +1270,9 @@ static int read_pnode(struct ubifs_info 
 	lnum = branch->lnum;
 	offs = branch->offs;
 	pnode = kzalloc(sizeof(struct ubifs_pnode), GFP_NOFS);
-	if (!pnode) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!pnode)
+		return -ENOMEM;
+
 	if (lnum == 0) {
 		/*
 		 * This pnode was not written which just means that the LEB
