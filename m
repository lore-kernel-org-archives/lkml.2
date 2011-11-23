Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1KWAhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:37:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab1KWAhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:58 2011
Message-Id: <20111123002557.917179781@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [53/53] vmscan: fix shrinker callback bug in fs/super.c
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 09f363c7363eb10cfb4b82094bd7064e5608258b upstream.

The callback must not return -1 when nr_to_scan is zero. Fix the bug in
fs/super.c and add this requirement to the callback specification.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/super.c               |    2 +-
 include/linux/shrinker.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -61,7 +61,7 @@ static int prune_super(struct shrinker *
 		return -1;
 
 	if (!grab_super_passive(sb))
-		return -1;
+		return !sc->nr_to_scan ? 0 : -1;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -20,6 +20,7 @@ struct shrink_control {
  * 'nr_to_scan' entries and attempt to free them up.  It should return
  * the number of objects which remain in the cache.  If it returns -1, it means
  * it cannot do any scanning at this time (eg. there is a risk of deadlock).
+ * The callback must not return -1 if nr_to_scan is zero.
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.


