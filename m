Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1HCXkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:40:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab1HCX2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.879500135@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [068/102] mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit ccb6108f5b0b541d3eb332c3a73e645c0f84278e upstream.

Vito said:

: The system has many usb disks coming and going day to day, with their
: respective bdi's having min_ratio set to 1 when inserted.  It works for
: some time until eventually min_ratio can no longer be set, even when the
: active set of bdi's seen in /sys/class/bdi/*/min_ratio doesn't add up to
: anywhere near 100.
:
: This then leads to an unrelated starvation problem caused by write-heavy
: fuse mounts being used atop the usb disks, a problem the min_ratio setting
: at the underlying devices bdi effectively prevents.

Fix this leakage by resetting the bdi min_ratio when unregistering the
BDI.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Vito Caputo <lkml@pengaru.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -606,6 +606,7 @@ static void bdi_prune_sb(struct backing_
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 		del_timer_sync(&bdi->wb.wakeup_timer);


