Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab2HGWze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:55:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61848 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030982Ab2HGWqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 19/49] Btrfs: call the ordered free operation without any locks held
Date: Tue,  7 Aug 2012 15:44:37 -0700
Message-Id: <20120807222028.606735219@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <chris.mason@fusionio.com>

commit e9fbcb42201c862fd6ab45c48ead4f47bb2dea9d upstream.

Each ordered operation has a free callback, and this was called with the
worker spinlock held.  Josef made the free callback also call iput,
which we can't do with the spinlock.

This drops the spinlock for the free operation and grabs it again before
moving through the rest of the list.  We'll circle back around to this
and find a cleaner way that doesn't bounce the lock around so much.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/async-thread.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -212,10 +212,17 @@ static noinline int run_ordered_completi
 
 		work->ordered_func(work);
 
-		/* now take the lock again and call the freeing code */
+		/* now take the lock again and drop our item from the list */
 		spin_lock(&workers->order_lock);
 		list_del(&work->order_list);
+		spin_unlock(&workers->order_lock);
+
+		/*
+		 * we don't want to call the ordered free functions
+		 * with the lock held though
+		 */
 		work->ordered_free(work);
+		spin_lock(&workers->order_lock);
 	}
 
 	spin_unlock(&workers->order_lock);


