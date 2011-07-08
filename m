Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1GIFyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:54:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49666 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab1GIFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:10 -0400
X-Sasl-enc: Q2QqD79i0dtXce2UBRlMoAJGEpUDBbw++xTZYvdY0VBC 1310190849
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:19 2011
Message-Id: <20110708225119.510053976@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:49:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Kubecek <mkubecek@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [07/35] PM: Free memory bitmaps if opening /dev/snapshot fails
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Kubecek <mkubecek@suse.cz>

commit 8440f4b19494467883f8541b7aa28c7bbf6ac92b upstream.

When opening /dev/snapshot device, snapshot_open() creates memory
bitmaps which are freed in snapshot_release(). But if any of the
callbacks called by pm_notifier_call_chain() returns NOTIFY_BAD, open()
fails, snapshot_release() is never called and bitmaps are not freed.
Next attempt to open /dev/snapshot then triggers BUG_ON() check in
create_basic_memory_bitmaps(). This happens e.g. when vmwatchdog module
is active on s390x.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -113,8 +113,10 @@ static int snapshot_open(struct inode *i
 		if (error)
 			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
-	if (error)
+	if (error) {
+		free_basic_memory_bitmaps();
 		atomic_inc(&snapshot_device_available);
+	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;


