Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab2FGEYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:24:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2FGEYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:24:47 -0400
Message-Id: <20120607041402.488333447@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:28 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Yevgen Pronenko <yevgen.pronenko@sonymobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/47] ipv4: Do not use dead fib_info entries.
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit dccd9ecc374462e5d6a5b8f8110415a86c2213d8 ]

Due to RCU lookups and RCU based release, fib_info objects can
be found during lookup which have fi->fib_dead set.

We must ignore these entries, otherwise we risk dereferencing
the parts of the entry which are being torn down.

Reported-by: Yevgen Pronenko <yevgen.pronenko@sonymobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1371,6 +1371,8 @@ static int check_leaf(struct fib_table *
 
 			if (fa->fa_tos && fa->fa_tos != flp->flowi4_tos)
 				continue;
+			if (fi->fib_dead)
+				continue;
 			if (fa->fa_info->fib_scope < flp->flowi4_scope)
 				continue;
 			fib_alias_accessed(fa);


