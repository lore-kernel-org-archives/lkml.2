Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031257Ab2ERX07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:26:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946376Ab2ERXE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:29 -0400
Message-Id: <20120518211602.799417138@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 37/54] MD: Add del_timer_sync to mddev_suspend (fix nasty panic)
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -348,6 +348,8 @@ void mddev_suspend(mddev_t *mddev)
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
+
+	del_timer_sync(&mddev->safemode_timer);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 


