Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0CSPVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:21:31 -0400
Received: from kroah.org ([198.145.64.141]:45925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0CSPTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/12] driver core: numa: fix BUILD_BUG_ON for node_read_distance
Date: Fri, 19 Mar 2010 08:18:55 -0700
Message-Id: <1269011935-8886-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

node_read_distance() has a BUILD_BUG_ON() to prevent buffer overruns when
the number of nodes printed will exceed the buffer length.

Each node only needs four chars: three for distance (maximum distance is
255) and one for a seperating space or a trailing newline.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/node.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index ad43185..93b3ac6 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -165,8 +165,11 @@ static ssize_t node_read_distance(struct sys_device * dev,
 	int len = 0;
 	int i;
 
-	/* buf currently PAGE_SIZE, need ~4 chars per node */
-	BUILD_BUG_ON(MAX_NUMNODES*4 > PAGE_SIZE/2);
+	/*
+	 * buf is currently PAGE_SIZE in length and each node needs 4 chars
+	 * at the most (distance + space or newline).
+	 */
+	BUILD_BUG_ON(MAX_NUMNODES * 4 > PAGE_SIZE);
 
 	for_each_online_node(i)
 		len += sprintf(buf + len, "%s%d", i ? " " : "", node_distance(nid, i));
-- 
1.7.0.2

