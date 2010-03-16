Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0CPFtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:49:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58450 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab0CPFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:49:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] tmpfs: fix oops on mounts with mpol=default
Cc: kosaki.motohiro@jp.fujitsu.com, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk,
       lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>, akpm@linux-foundation.org
In-Reply-To: <20100316143406.4C45.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org> <20100316143406.4C45.A69D9226@jp.fujitsu.com>
Message-Id: <20100316144810.4C48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Mar 2010 14:49:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ChangeLog from Ravikiran's original one
  - Fix the patch description. the problem is in mount, not only remount.
  - Skip mpol_new() simply, instead adding NULL check.


=========================
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Fix an 'oops' when a tmpfs mount point is mounted with the mpol=default
mempolicy.

Upon remounting a tmpfs mount point with 'mpol=default' option, the
mount code crashed with a null pointer dereference.  The initial
problem report was on 2.6.27, but the problem exists in mainline
2.6.34-rc as well.  On examining the code, we see that mpol_new returns
NULL if default mempolicy was requested.  This 'NULL' mempolicy is
accessed to store the node mask resulting in oops.

The following patch fixes it.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
---
 mm/mempolicy.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index bda230e..25a0c0f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2213,10 +2213,15 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 			goto out;
 		mode = MPOL_PREFERRED;
 		break;
-
+	case MPOL_DEFAULT:
+		/*
+		 * Insist on a empty nodelist
+		 */
+		if (!nodelist)
+			err = 0;
+		goto out;
 	/*
 	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
-	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
 	 */
 	}
 
-- 
1.6.5.2



