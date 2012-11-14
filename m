Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2KNGDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:03:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab2KNFu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:26 -0500
Message-Id: <20121114053942.803321723@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>,
        Aaditya Kumar <aaditya.kumar@ap.sony.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 65/82] mm: bugfix: set current->reclaim_state to NULL while returning from
 kswapd()
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>

commit b0a8cc58e6b9aaae3045752059e5e6260c0b94bc upstream.

In kswapd(), set current->reclaim_state to NULL before returning, as
current->reclaim_state holds reference to variable on kswapd()'s stack.

In rare cases, while returning from kswapd() during memory offlining,
__free_slab() and freepages() can access the dangling pointer of
current->reclaim_state.

Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2624edc..8b055e9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3017,6 +3017,8 @@ static int kswapd(void *p)
 						&balanced_classzone_idx);
 		}
 	}
+
+	current->reclaim_state = NULL;
 	return 0;
 }
 


