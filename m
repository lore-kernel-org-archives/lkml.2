Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1BNOnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:43:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1BNOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=fd9tCWAKiJd7F8yFDsEcg8/ENa7NWmme6n6TAjxstOonKor2lFe0mkS/XYbP/6cPDv
         4GcOXUJbWrQziLPBVjn57I+lALMHW5b3GhZG+4EW5rYrUn0DENvWqEb9M8AJxWdoaVAO
         y4qr127Pk8dkMVqh7AaQAI/cXiDUmeJUUaZYk=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: [PATCH v2] core: dev: don't call BUG() on bad input
Date: Mon, 14 Feb 2011 17:42:58 +0300
Message-Id: <1297694579-23611-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
other errors.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.
 v2 - fixed checkpatch warning - space before "\n".

 net/core/dev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6392ea0..12ef4b0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5761,7 +5761,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	size_t alloc_size;
 	struct net_device *p;
 
-	BUG_ON(strlen(name) >= sizeof(dev->name));
+	if (strnlen(name, sizeof(dev->name)) >= sizeof(dev->name)) {
+		pr_err("alloc_netdev: Too long device name\n");
+		return NULL;
+	}
 
 	if (txqs < 1) {
 		pr_err("alloc_netdev: Unable to allocate device "
-- 
1.7.0.4

