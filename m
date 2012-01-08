Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2AHNTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:19:44 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:43665 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2AHNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:19:42 -0500
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH][trace-cmd] blk plugin: replace BLK_TC_BARRIER with BLK_TC_FLUSH/BLK_TC_FUA
Date: Sun,  8 Jan 2012 13:19:21 +0000
Message-Id: <1326028761-25209-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.3
x-cbid: 12010813-5024-0000-0000-000001492B34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BLK_TC_BARRIER flag was dropped in Linux commit c09c47caedc in
August 2011.  The blk plugin fails to build against recent kernel
headers.  Since no flag bits were left, the new BLK_TC_FLUSH flag reused
the BLK_TC_BARRIER bit.  The new BLK_TC_FUA flag was also added.

This patch updates fill_rwbs() to reflect the new
BLK_TC_FLUSH/BLK_TC_FUA flags.  This allows plugin_blk.c to build
successfully on recent kernels.  The drawback is that this breaks the
build for pre-c09c47caedc kernel headers.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
There is an alternative version of this patch with a build test in the Makefile
so that we know whether to use BLK_TC_BARRIER or BLK_TC_FLUSH/BLK_TC_FUA.  That
would support both old and new kernel headers using a HAVE_BLK_TC_FLUSH #ifdef.

I wasn't able to find the right makefile shell escaping magic to get the
build-test function to work.  If anyone knows how to test a snippet like the
following, then that would be nicer:

  #include <linux/blktrace_api.h>
  int main(void) { return BLK_TC_FLUSH; }

 plugin_blk.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/plugin_blk.c b/plugin_blk.c
index 9327b17..4352cb7 100644
--- a/plugin_blk.c
+++ b/plugin_blk.c
@@ -54,6 +54,9 @@ static void fill_rwbs(char *rwbs, int action, unsigned int bytes)
 		goto out;
 	}
 
+	if (tc & BLK_TC_FLUSH)
+		rwbs[i++] = 'F';
+
 	if (tc & BLK_TC_DISCARD)
 		rwbs[i++] = 'D';
 	else if (tc & BLK_TC_WRITE)
@@ -63,10 +66,10 @@ static void fill_rwbs(char *rwbs, int action, unsigned int bytes)
 	else
 		rwbs[i++] = 'N';
 
+	if (tc & BLK_TC_FUA)
+		rwbs[i++] = 'F';
 	if (tc & BLK_TC_AHEAD)
 		rwbs[i++] = 'A';
-	if (tc & BLK_TC_BARRIER)
-		rwbs[i++] = 'B';
 	if (tc & BLK_TC_SYNC)
 		rwbs[i++] = 'S';
 	if (tc & BLK_TC_META)
-- 
1.7.7.3

