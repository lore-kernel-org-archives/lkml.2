Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162109Ab2GLWnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:43:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162054Ab2GLWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 131/187] md/raid5: In ops_run_io, inc nr_pending before calling md_wait_for_blocked_rdev
Date: Thu, 12 Jul 2012 15:34:47 -0700
Message-Id: <20120712191534.530236769@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -583,6 +583,12 @@ static void ops_run_io(struct stripe_hea
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


