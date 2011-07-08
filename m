Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1GHFCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1GHFCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001656.978237250@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Kubecek <mkubecek@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [044/107] PM: Free memory bitmaps if opening /dev/snapshot fails
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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


