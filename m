Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2GIOv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38099 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306Ab2GIOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:58 -0400
Message-Id: <20120709143119.018962208@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, majianpeng <majianpeng@gmail.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 16/48] md/raid5: In ops_run_io, inc nr_pending before calling
 md_wait_for_blocked_rdev
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 1850753d2e6d9ca7856581ca5d3cf09521e6a5d7 upstream.

In ops_run_io(), the call to md_wait_for_blocked_rdev will decrement
nr_pending so we lose the reference we hold on the rdev.
So atomic_inc it first to maintain the reference.

This bug was introduced by commit  73e92e51b7969ef5477d
    md/raid5.  Don't write to known bad block on doubtful devices.

which appeared in 3.0, so patch is suitable for stable kernels since
then.

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9567a9c..befadb4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -606,6 +606,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 					 * a chance*/
 					md_check_recovery(conf->mddev);
 				}
+				/*
+				 * Because md_wait_for_blocked_rdev
+				 * will dec nr_pending, we must
+				 * increment it first.
+				 */
+				atomic_inc(&rdev->nr_pending);
 				md_wait_for_blocked_rdev(rdev, conf->mddev);
 			} else {
 				/* Acknowledged bad block - skip the write */


