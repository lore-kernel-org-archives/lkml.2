Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab2KVV4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:56:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:49604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab2KVSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>,
        Aaditya Kumar <aaditya.kumar@ap.sony.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/83] mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()
Date: Wed, 21 Nov 2012 16:41:23 -0800
Message-Id: <20121122004212.521159410@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2953,6 +2953,8 @@ static int kswapd(void *p)
 						&balanced_classzone_idx);
 		}
 	}
+
+	current->reclaim_state = NULL;
 	return 0;
 }
 


