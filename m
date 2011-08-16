Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1HPNRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:17:31 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:58044 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1HPNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:17:24 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjUQEnt0KA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 1/3] xen/pv-on-hvm kexec: prevent crash in xenwatch_thread() when stale watch events arrive
Date: Tue, 16 Aug 2011 15:16:51 +0200
Message-Id: <1313500613-21394-2-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
References: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During repeated kexec boots xenwatch_thread() can crash because
xenbus_watch->callback is cleared by xenbus_watch_path() if a node/token
combo for a new watch happens to match an already registered watch from
an old kernel.  In this case xs_watch returns -EEXISTS, then
register_xenbus_watch() does not remove the to-be-registered watch from
the list of active watches but returns the -EEXISTS to the caller
anyway.

Because the watch is still active in xenstored it will cause an event
which will arrive in the new kernel. process_msg() will find the
encapsulated struct xenbus_watch in its list of registered watches and
puts the "empty" watch handle in the queue for xenwatch_thread().
xenwatch_thread() then calls ->callback which was cleared earlier by
xenbus_watch_path().

To prevent that crash in a guest running on an old xen toolstack, add a
check wether xenbus_watch->callback is active.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/xen/xenbus/xenbus_xs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 5534690..64248b2 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -828,7 +828,7 @@ static int process_msg(void)
 		spin_lock(&watches_lock);
 		msg->u.watch.handle = find_watch(
 			msg->u.watch.vec[XS_WATCH_TOKEN]);
-		if (msg->u.watch.handle != NULL) {
+		if (msg->u.watch.handle && msg->u.watch.handle->callback) {
 			spin_lock(&watch_events_lock);
 			list_add_tail(&msg->list, &watch_events);
 			wake_up(&watch_events_waitq);
-- 
1.7.3.4

