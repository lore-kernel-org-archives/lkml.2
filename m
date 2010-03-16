Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208Ab0CPFu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:50:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49499 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab0CPFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:50:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] tmpfs: mpol=bind:0 don't cause mount error.
Cc: kosaki.motohiro@jp.fujitsu.com, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk,
       lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>, akpm@linux-foundation.org
In-Reply-To: <20100316143406.4C45.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org> <20100316143406.4C45.A69D9226@jp.fujitsu.com>
Message-Id: <20100316144929.4C4B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Mar 2010 14:50:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, following mount operation cause mount error.

% mount -t tmpfs -ompol=bind:0 none /tmp

Because commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) corrupted MPOL_BIND parse code.

This patch restore the needed one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
---
 mm/mempolicy.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 25a0c0f..3f77062 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2220,9 +2220,13 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		if (!nodelist)
 			err = 0;
 		goto out;
-	/*
-	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 */
+	case MPOL_BIND:
+		/* 
+		 * Insist on a nodelist
+		 */
+		if (!nodelist)
+			goto out;
+		err = 0;
 	}
 
 	mode_flags = 0;
-- 
1.6.5.2



