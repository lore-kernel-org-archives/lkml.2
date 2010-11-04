Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KDUzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:55:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26584 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0KDUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:55:37 -0400
Date: Thu, 4 Nov 2010 21:44:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: relayfs-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Tom Zanussi <tzanussi@gmail.com>,
        Karim Yaghmour <karim@opersys.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Mundt <lethal@linux-sh.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH resend] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
Message-ID: <alpine.LNX.2.00.1011042132480.15349@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (please CC me on replies since I'm not subscribed to lists other than lkml),

We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
vzalloc. The patch makes these changes:

 - use vzalloc instead of vmalloc+memset.
 - remove redundant local variable 'array'.
 - declare local 'pa_size' as const.

Cuts down nicely on both source and object-code size.

Now I just need to find someone to actually merge it...


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 relay.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index c7cf397..859ea5a 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -70,17 +70,10 @@ static const struct vm_operations_struct relay_file_mmap_ops = {
  */
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
-
-	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
-	} else {
-		array = kzalloc(pa_size, GFP_KERNEL);
-	}
-	return array;
+	const size_t pa_size = n_pages * sizeof(struct page *);
+	if (pa_size > PAGE_SIZE)
+		return vzalloc(pa_size);
+	return kzalloc(pa_size, GFP_KERNEL);
 }
 
 /*



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

