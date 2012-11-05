Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2KEUNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:13:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40925 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2KEUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:13:13 -0500
MIME-Version: 1.0
Date: Tue, 6 Nov 2012 01:43:12 +0530
Message-ID: <CAEtiSasbEXUeFwCNO09nT8TsEzLF-zZVyJ_pCO9V49hDPbpbAQ@mail.gmail.com>
Subject: [PATCH] mm: bugfix: set current->reclaim_state to NULL while
 returning from kswapd()
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>, takamori.yamaguchi@jp.sony.com,
        takuzo.ohara@ap.sony.com, amit.agarwal@ap.sony.com,
        tim.bird@am.sony.com, frank.rowand@am.sony.com,
        kan.iibuchi@jp.sony.com, aaditya.kumar@ap.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>

In kswapd(), set current->reclaim_state to NULL before returning, as
current->reclaim_state holds reference to variable on kswapd()'s stack.

In rare cases, while returning from kswapd() during memory off lining,
__free_slab() can access dangling pointer of current->reclaim_state.

Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>

---
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
