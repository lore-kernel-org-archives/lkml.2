Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0C3XPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:15:32 -0400
Received: from kroah.org ([198.145.64.141]:49286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab0C3XNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:13:07 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:59:00 2010
Message-Id: <20100330225859.499571908@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [82/89] tmpfs: fix oops on mounts with mpol=default
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ravikiran G Thirumalai <kiran@scalex86.org>

commit 413b43deab8377819aba1dbad2abf0c15d59b491 upstream.

Fix an 'oops' when a tmpfs mount point is mounted with the mpol=default
mempolicy.

Upon remounting a tmpfs mount point with 'mpol=default' option, the mount
code crashed with a null pointer dereference.  The initial problem report
was on 2.6.27, but the problem exists in mainline 2.6.34-rc as well.  On
examining the code, we see that mpol_new returns NULL if default mempolicy
was requested.  This 'NULL' mempolicy is accessed to store the node mask
resulting in oops.

The following patch fixes it.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mempolicy.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2142,10 +2142,15 @@ int mpol_parse_str(char *str, struct mem
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
 


