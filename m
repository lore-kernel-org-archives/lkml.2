Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2E1DjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:39:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab2E1D3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:43 -0400
Message-Id: <20120528031212.540584498@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@kernel.org>,
        Shaohua Li <shli@fusionio.com>, Holger Kiehl <Holger.Kiehl@dwd.de>,
        Hugh Dickins <hughd@google.com>
Subject: [ 070/117] swap: dont do discard if no discard option added
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 052b1987faca3606109d88d96bce124851f7c4c2 upstream.

When swapon() was not passed the SWAP_FLAG_DISCARD option, sys_swapon()
will still perform a discard operation.  This can cause problems if
discard is slow or buggy.

Reverse the order of the check so that a discard operation is performed
only if the sys_swapon() caller is attempting to enable discard.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Tested-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b82c028..21b5694 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2103,7 +2103,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
+		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
 	}
 


