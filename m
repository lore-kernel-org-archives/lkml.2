Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1LRL7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 06:59:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54895 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1LRL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 06:59:19 -0500
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-mm@kvack.org, stable@kernel.org
Subject: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
Date: Sun, 18 Dec 2011 20:58:49 +0900
Message-Id: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/devices/system/node/{online,possible} involve a garbage byte
because print_nodes_state returns content size + 1. To fix the bug,
the patch changes the use of cpuset_sprintf_cpulist to follow the
use at other places, which is clearer and safer.

This bug was introduced since v2.6.24.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
---
 drivers/base/node.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5693ece..ef7c1f9 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -587,11 +587,9 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
 {
 	int n;
 
-	n = nodelist_scnprintf(buf, PAGE_SIZE, node_states[state]);
-	if (n > 0 && PAGE_SIZE > n + 1) {
-		*(buf + n++) = '\n';
-		*(buf + n++) = '\0';
-	}
+	n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);
+	buf[n++] = '\n';
+	buf[n] = '\0';
 	return n;
 }
 
-- 
1.7.5.4

