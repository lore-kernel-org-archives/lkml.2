Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab2EIGet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:34:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38648 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714Ab2EIFwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:39 -0400
Message-Id: <20120509055033.031140643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Christoph Nelles <evilazrael@evilazrael.de>
Subject: [ 025/167] [PATCH] md: fix possible corruption of array metadata on shutdown.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 30b8aa9172dfeaac6d77897c67ee9f9fc574cdbb upstream.

commit c744a65c1e2d59acc54333ce8
  md: don't set md arrays to readonly on shutdown.

removed the possibility of a 'BUG' when data is written to an array
that has just been switched to read-only, but also introduced the
possibility that the array metadata could be corrupted.

If, when md_notify_reboot gets the mddev lock, the array is
in a state where it is assembled but hasn't been started (as can
happen if the personality module is not available, or in other unusual
situations), then incorrect metadata will be written out making it
impossible to re-assemble the array.

So only call __md_stop_writes() if the array has actually been
activated.

This patch is needed for any stable kernel which has had the above
commit applied.

Reported-by: Christoph Nelles <evilazrael@evilazrael.de>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8beb19c..477eb2e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8140,7 +8140,8 @@ static int md_notify_reboot(struct notifier_block *this,
 
 	for_each_mddev(mddev, tmp) {
 		if (mddev_trylock(mddev)) {
-			__md_stop_writes(mddev);
+			if (mddev->pers)
+				__md_stop_writes(mddev);
 			mddev->safemode = 2;
 			mddev_unlock(mddev);
 		}
-- 
1.7.10



