Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148Ab2CBII6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:08:58 -0500
Received: from mx.anti-virus.by ([93.125.111.29]:51472 "EHLO tux.vba.com.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2CBII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:08:57 -0500
X-Greylist: delayed 715 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 03:08:57 EST
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Jason Wang <jasowang@redhat.com>,
        Glauber Costa <glommer@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCHv 2] tcp: properly initialize tcp memory limits part 2 (fix nfs regression)
Date: Fri,  2 Mar 2012 10:59:33 +0300
Message-Id: <1330675173-18968-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

The commit c43b874d5d7 introduced NFS file transfer hangup (proved by bisection).
> Commit 4acb4190 tries to fix the using uninitialized value
> introduced by commit 3dc43e3,  but it would make the
> per-socket memory limits too small.
>
> This patch fixes this and also remove the redundant codes
> introduced in 4acb4190.

The change looks like a typo (division flipped to multiplication):
> limit = nr_free_buffer_pages() / 8;
> limit = nr_free_buffer_pages() << (PAGE_SHIFT - 10);

Patch restores division.

CC: Jason Wang <jasowang@redhat.com>
CC: Glauber Costa <glommer@parallels.com>
CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
---

Change since v1: added forgotten commit ID

 net/ipv4/tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 22ef5f9..b11667b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3299,7 +3299,7 @@ void __init tcp_init(void)
 
 	tcp_init_mem(&init_net);
 	/* Set per-socket limits to no more than 1/128 the pressure threshold */
-	limit = nr_free_buffer_pages() << (PAGE_SHIFT - 10);
+	limit = nr_free_buffer_pages() >> (PAGE_SHIFT - 10);
 	limit = max(limit, 128UL);
 	max_share = min(4UL*1024*1024, limit);
 
-- 
1.7.8.5

