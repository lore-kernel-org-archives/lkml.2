Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab1FAIG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:06:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933249Ab1FAIGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:20 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:27 2011
Message-Id: <20110601080226.515383104@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:58:57 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [001/146] kmemleak: Do not return a pointer to an object that kmemleak did not get
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1414,9 +1414,12 @@ static void *kmemleak_seq_next(struct se
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


