Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0HXQDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:03:05 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755445Ab0HXQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:26 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154902.101408966@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:31 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 10/10] lib/list_sort: fix bad args in callback to clients cmp()
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-fix-bad-args-in-callback-to-client_s-cmp__.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 835cc0c8477fdbc59e0217891d6f11061b1ac4e2 introduced the bug
that if the list to be sorted is a power-of-two in length, cmp() may
be passed pointers to the list header rather than to a list element.
This typically causes the caller's cmp() to read from invalid memory
locations off one end or the other of the list_head struct.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Alex Elder <aelder@sgi.com>
To: David Airlie <airlied@linux.ie>
Cc: stable@kernel.org
---
Examination of client code in xfs_buf.c and drm_modes.c showed no
obvious vulnerability to crashing: memory at offsets reachable by
cmp() appeared to always be readable, and the cmp() functions do not
dereference any pointers in the struct that they assume they have been
passed.

 lib/list_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:59:59.899177219 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:48.007177492 -0700
@@ -70,7 +70,7 @@ static void merge_and_restore_back_links
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;

