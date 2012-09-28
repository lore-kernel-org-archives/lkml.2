Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031681Ab2I1TtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:49:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965079Ab2I1S6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robin Hill <robin@robinhill.me.uk>,
        John Drescher <drescherjm@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 093/262] md/raid5: fix calculate of degraded when a replacement becomes active.
Date: Fri, 28 Sep 2012 11:50:22 -0700
Message-Id: <20120928183009.088123561@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit e5c86471f933608db5d43679f84cb4346c32033e upstream.

When a replacement device becomes active, we mark the device that it
replaces as 'faulty' so that it can subsequently get removed.
However 'calc_degraded' only pays attention to the primary device, not
the replacement, so the array appears to become degraded, which is
wrong.

So teach 'calc_degraded' to consider any replacement if a primary
device is faulty.

This is suitable for -stable as an incorrect 'degraded' value can
confuse md and could lead to data corruption.
This is only relevant for 3.3 and later.

Reported-by: Robin Hill <robin@robinhill.me.uk>
Reported-by: John Drescher <drescherjm@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -380,6 +380,8 @@ static int calc_degraded(struct r5conf *
 	degraded = 0;
 	for (i = 0; i < conf->previous_raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rdev && test_bit(Faulty, &rdev->flags))
+			rdev = rcu_dereference(conf->disks[i].replacement);
 		if (!rdev || test_bit(Faulty, &rdev->flags))
 			degraded++;
 		else if (test_bit(In_sync, &rdev->flags))
@@ -404,6 +406,8 @@ static int calc_degraded(struct r5conf *
 	degraded2 = 0;
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rdev && test_bit(Faulty, &rdev->flags))
+			rdev = rcu_dereference(conf->disks[i].replacement);
 		if (!rdev || test_bit(Faulty, &rdev->flags))
 			degraded2++;
 		else if (test_bit(In_sync, &rdev->flags))


