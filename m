Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1FPHKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52953 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685Ab1FPHKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:03 -0400
X-Sasl-enc: EakS7CrtmjORt2lmC3GoBZZoKJGM7oEkRXWHcVejqRrl 1308208202
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:04 2011
Message-Id: <20110616002903.968375956@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:27:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [02/85] kmemleak: Do not return a pointer to an object that kmemleak did not get
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 52c3ce4ec5601ee383a14f1485f6bac7b278896e upstream.

The kmemleak_seq_next() function tries to get an object (and increment
its use count) before returning it. If it could not get the last object
during list traversal (because it may have been freed), the function
should return NULL rather than a pointer to such object that it did not
get.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/kmemleak.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1369,9 +1369,12 @@ static void *kmemleak_seq_next(struct se
 	++(*pos);
 
 	list_for_each_continue_rcu(n, &object_list) {
-		next_obj = list_entry(n, struct kmemleak_object, object_list);
-		if (get_object(next_obj))
+		struct kmemleak_object *obj =
+			list_entry(n, struct kmemleak_object, object_list);
+		if (get_object(obj)) {
+			next_obj = obj;
 			break;
+		}
 	}
 
 	put_object(prev_obj);


