Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab2FGE3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:29:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648Ab2FGEZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:15 -0400
Message-Id: <20120607041403.185172524@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:33 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/47] pktgen: fix module unload for good
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d4b1133558e0d417342d5d2c49e4c35b428ff20d ]

commit c57b5468406 (pktgen: fix crash at module unload) did a very poor
job with list primitives.

1) list_splice() arguments were in the wrong order

2) list_splice(list, head) has undefined behavior if head is not
initialized.

3) We should use the list_splice_init() variant to clear pktgen_threads
list.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3755,13 +3755,13 @@ static void __exit pg_cleanup(void)
 {
 	struct pktgen_thread *t;
 	struct list_head *q, *n;
-	struct list_head list;
+	LIST_HEAD(list);
 
 	/* Stop all interfaces & threads */
 	pktgen_exiting = true;
 
 	mutex_lock(&pktgen_thread_lock);
-	list_splice(&list, &pktgen_threads);
+	list_splice_init(&pktgen_threads, &list);
 	mutex_unlock(&pktgen_thread_lock);
 
 	list_for_each_safe(q, n, &list) {


