Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847Ab2ERC5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:57:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40578 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030733Ab2ERCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:51 -0400
Message-Id: <20120518023300.840403606@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Brassow <jbrassow@redhat.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 48/53] MD: Add del_timer_sync to mddev_suspend (fix nasty panic)
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Brassow <jbrassow@redhat.com>

commit 0d9f4f135eb6dea06bdcb7065b1e4ff78274a5e9 upstream.

Use del_timer_sync to remove timer before mddev_suspend finishes.

We don't want a timer going off after an mddev_suspend is called.  This is
especially true with device-mapper, since it can call the destructor function
immediately following a suspend.  This results in the removal (kfree) of the
structures upon which the timer depends - resulting in a very ugly panic.
Therefore, we add a del_timer_sync to mddev_suspend to prevent this.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 477eb2e..01233d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -391,6 +391,8 @@ void mddev_suspend(struct mddev *mddev)
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
+
+	del_timer_sync(&mddev->safemode_timer);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
-- 
1.7.10



