Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0H0TsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:48:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38694 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0H0TsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:48:02 -0400
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipv4: Eliminate kstrdup memory leak
Date: Fri, 27 Aug 2010 21:47:43 +0200
Message-Id: <1282938463-26450-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The string clone is only used as a temporary copy of the argument val
within the while loop, and so it should be freed before leaving the
function.  The call to strsep, however, modifies clone, so a pointer to the
front of the string is kept in saved_clone, to make it possible to free it.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier l;
statement S;
@@

*x= \(kasprintf\|kstrdup\)(...);
...
if (x == NULL) S
... when != kfree(x)
    when != E = x
if (...) {
  <... when != kfree(x)
* goto l;
  ...>
* return ...;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/ipv4/tcp_cong.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 0ec9bd0..850c737 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -196,10 +196,10 @@ void tcp_get_allowed_congestion_control(char *buf, size_t maxlen)
 int tcp_set_allowed_congestion_control(char *val)
 {
 	struct tcp_congestion_ops *ca;
-	char *clone, *name;
+	char *saved_clone, *clone, *name;
 	int ret = 0;
 
-	clone = kstrdup(val, GFP_USER);
+	saved_clone = clone = kstrdup(val, GFP_USER);
 	if (!clone)
 		return -ENOMEM;
 
@@ -226,6 +226,7 @@ int tcp_set_allowed_congestion_control(char *val)
 	}
 out:
 	spin_unlock(&tcp_cong_list_lock);
+	kfree(saved_clone);
 
 	return ret;
 }

