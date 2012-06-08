Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974Ab2FHFX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:23:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43243 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761257Ab2FHFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:19 -0400
Message-Id: <20120608041849.268516783@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        Yevgen Pronenko <yevgen.pronenko@sonymobile.com>
Subject: [ 63/82] ipv4: Do not use dead fib_info entries.
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit dccd9ecc374462e5d6a5b8f8110415a86c2213d8 ]

Due to RCU lookups and RCU based release, fib_info objects can
be found during lookup which have fi->fib_dead set.

We must ignore these entries, otherwise we risk dereferencing
the parts of the entry which are being torn down.

Reported-by: Yevgen Pronenko <yevgen.pronenko@sonymobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/fib_trie.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3ce23f9..cd2d639 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1372,6 +1372,8 @@ static int check_leaf(struct fib_table *tb, struct trie *t, struct leaf *l,
 
 			if (fa->fa_tos && fa->fa_tos != flp->flowi4_tos)
 				continue;
+			if (fi->fib_dead)
+				continue;
 			if (fa->fa_info->fib_scope < flp->flowi4_scope)
 				continue;
 			fib_alias_accessed(fa);


