Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0GZJ2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:28:30 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:4487 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971Ab0GZJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:28:28 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L65RN3-01-CHB-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH] Fix off-by-one bug in mbind() syscall implementation
Date: Mon, 26 Jul 2010 11:28:18 +0200
Message-ID: <1280136498-28219-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the mbind() syscall implementation processes the node mask
provided by the user, the last node is accidentally masked out.
This is present since the dawn of time (aka Before Git), I guess
nobody realized that because libnuma as the most prominent user of
mbind() uses large masks (sizeof(long)) and nobody cared if the
64th node is not handled properly. But if the user application
defers the masking to the kernel and provides the number of valid bits
in maxnodes, there is always the last node missing.
However this also affect the special case with maxnodes=0, the manpage
reads that mbind(ptr, len, MPOL_DEFAULT, &some_long, 0, 0); should
reset the policy to the default one, but in fact it returns EINVAL.
This patch just removes the decrease-by-one statement, I hope that
there is no workaround code in the wild that relies on the bogus
behavior.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 mm/mempolicy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5bc0a96..e70025b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1174,7 +1174,6 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 	unsigned long nlongs;
 	unsigned long endmask;
 
-	--maxnode;
 	nodes_clear(*nodes);
 	if (maxnode == 0 || !nmask)
 		return 0;
-- 
1.6.4


