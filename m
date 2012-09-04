Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2IDRZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:25:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab2IDRYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:24:46 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chuck Lever <chuck.lever@oracle.com>, Joonsoo Kim <js1304@gmail.com>,
        Pekka@suse.de, "Enberg <penberg"@kernel.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/4] Squelch compiler warning in sk_rmem_schedule()
Date: Tue,  4 Sep 2012 18:24:39 +0100
Message-Id: <1346779479-1097-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1346779479-1097-1-git-send-email-mgorman@suse.de>
References: <1346779479-1097-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

In file included from linux/include/linux/tcp.h:227:0,
                 from linux/include/linux/ipv6.h:221,
                 from linux/include/net/ipv6.h:16,
                 from linux/include/linux/sunrpc/clnt.h:26,
                 from linux/net/sunrpc/stats.c:22:
linux/include/net/sock.h: In function ‘sk_rmem_schedule’:
linux/nfs-2.6/include/net/sock.h:1339:13: warning: comparison between
  signed and unsigned integer expressions [-Wsign-compare]

Seen with gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2) using the
-Wextra option.

[c76562b6: netvm: prevent a stream-specific deadlock] accidentally replaced
the "size" parameter of sk_rmem_schedule() with an unsigned int. This
changes the semantics of the comparison in the return statement.

In sk_wmem_schedule we have syntactically the same comparison, but
"size" is a signed integer.  In addition, __sk_mem_schedule() takes
a signed integer for its "size" parameter, so there is an implicit
type conversion in sk_rmem_schedule() anyway.

Revert the "size" parameter back to a signed integer so that the
semantics of the expressions in both sk_[rw]mem_schedule() are
exactly the same.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 72132ae..adb7da2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1332,7 +1332,7 @@ static inline bool sk_wmem_schedule(struct sock *sk, int size)
 }
 
 static inline bool
-sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, unsigned int size)
+sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 {
 	if (!sk_has_account(sk))
 		return true;
-- 
1.7.9.2

