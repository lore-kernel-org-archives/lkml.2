Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0CaAEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:04:48 -0400
Received: from kroah.org ([198.145.64.141]:45287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab0C3XSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:31 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:46 2010
Message-Id: <20100330225645.735196426@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Grazvydas Ignotas <notasas@gmail.com>, Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [073/116] wl1251: fix potential crash
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit 3f60ebc9d6291863652d564bacc430629271e6a9 upstream.

In case debugfs does not init for some reason (or is disabled
on older kernels) driver does not allocate stats.fw_stats
structure, but tries to clear it later and trips on a NULL
pointer:

Unable to handle kernel NULL pointer dereference at virtual address
00000000
PC is at __memzero+0x24/0x80
Backtrace:
[<bf0ddb88>] (wl1251_debugfs_reset+0x0/0x30 [wl1251])
[<bf0d6a2c>] (wl1251_op_stop+0x0/0x12c [wl1251])
[<bf0bc228>] (ieee80211_stop_device+0x0/0x74 [mac80211])
[<bf0b0d10>] (ieee80211_stop+0x0/0x4ac [mac80211])
[<c02deeac>] (dev_close+0x0/0xb4)
[<c02deac0>] (dev_change_flags+0x0/0x184)
[<c031f478>] (devinet_ioctl+0x0/0x704)
[<c0320720>] (inet_ioctl+0x0/0x100)

Add a NULL pointer check to fix this.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Acked-by: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -443,7 +443,8 @@ out:
 
 void wl1251_debugfs_reset(struct wl1251 *wl)
 {
-	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
+	if (wl->stats.fw_stats != NULL)
+		memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
 	wl->stats.retry_count = 0;
 	wl->stats.excessive_retries = 0;
 }


