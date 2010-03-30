Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab0C3XVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:09 -0400
Received: from kroah.org ([198.145.64.141]:46043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab0C3XUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:03 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:55 2010
Message-Id: <20100330224754.998156869@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [054/156] tmpfs: mpol=bind:0 dont cause mount error.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit d69b2e63e9172afb4d07c305601b79a55509ac4c upstream.

Currently, following mount operation cause mount error.

% mount -t tmpfs -ompol=bind:0 none /tmp

Because commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) corrupted MPOL_BIND parse code.

This patch restore the needed one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mempolicy.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2194,9 +2194,13 @@ int mpol_parse_str(char *str, struct mem
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


