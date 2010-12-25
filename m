Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0LYS0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:26:48 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14468 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0LYS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:26:47 -0500
Date: Sat, 25 Dec 2010 19:17:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: ceph-devel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sage Weil <sage@newdream.net>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] Ceph: Fix a use-after-free bug in ceph_destroy_client().
Message-ID: <alpine.LNX.2.00.1012251914370.10759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In net/ceph/ceph_common.c::ceph_destroy_client() the pointer 'client' is 
freed by kfree() and subsequently used in a call to dout() - use after 
free bug.
Easily fixed by simply moving the kfree() call after the dout() call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ceph_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index f3e4a13..890bbbf 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -408,8 +408,8 @@ void ceph_destroy_client(struct ceph_client *client)
 
 	ceph_destroy_options(client->options);
 
-	kfree(client);
 	dout("destroy_client %p done\n", client);
+	kfree(client);
 }
 EXPORT_SYMBOL(ceph_destroy_client);
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

