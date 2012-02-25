Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2BYCdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 21:33:00 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:39964 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab2BYCc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 21:32:58 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Feb 2012 21:32:58 EST
Date: Sat, 25 Feb 2012 02:27:10 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fadvise: avoid EINVAL if user input is valid
Message-ID: <20120225022710.GA29455@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel is not required to act on fadvise, so fail silently
and ignore advice as long as it has a valid descriptor and
parameters.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Wong <normalperson@yhbt.net>
---

 Of course I wouldn't knowingly call posix_fadvise() on a file in
 tmpfs, but a userspace app often doesn't know (nor should it
 care) what type of filesystem it's on.

 I encountered EINVAL while running the Ruby 1.9.3 test suite on a
 stock Debian wheezy installation.  Wheezy uses tmpfs for "/tmp" by
 default and the test suite creates a temporary file to test the
 Ruby wrapper for posix_fadvise() on.

 mm/fadvise.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 469491e0..f9e48dd 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -43,13 +43,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		goto out;
 	}
 
-	mapping = file->f_mapping;
-	if (!mapping || len < 0) {
+	if (len < 0) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (mapping->a_ops->get_xip_mem) {
+	mapping = file->f_mapping;
+	if (!mapping || mapping->a_ops->get_xip_mem) {
 		switch (advice) {
 		case POSIX_FADV_NORMAL:
 		case POSIX_FADV_RANDOM:
@@ -93,10 +93,9 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
-		if (!mapping->a_ops->readpage) {
-			ret = -EINVAL;
+		/* ignore the advice if readahead isn't possible (tmpfs) */
+		if (!mapping->a_ops->readpage)
 			break;
-		}
 
 		/* First and last PARTIAL page! */
 		start_index = offset >> PAGE_CACHE_SHIFT;
@@ -106,12 +105,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
-		ret = force_page_cache_readahead(mapping, file,
-				start_index,
-				nrpages);
-		if (ret > 0)
-			ret = 0;
+
+		force_page_cache_readahead(mapping, file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
-- 
Eric Wong
