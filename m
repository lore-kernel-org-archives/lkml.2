Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab2EOCQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:16:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:48906 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab2EOCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:15:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 002/179] kmemleak: Do not return a pointer to an object that kmemleak did not get
Date: Mon, 14 May 2012 22:11:38 -0400
Message-ID: <1337048075-6132-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 52c3ce4ec5601ee383a14f1485f6bac7b278896e upstream.

The kmemleak_seq_next() function tries to get an object (and increment
its use count) before returning it. If it could not get the last object
during list traversal (because it may have been freed), the function
should return NULL rather than a pointer to such object that it did not
get.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/kmemleak.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..49c94b5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1368,9 +1368,12 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
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
-- 
1.7.9.6

