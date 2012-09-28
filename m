Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2I1UwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:52:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45906 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945936Ab2I1Usk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:40 -0400
X-Sasl-enc: 5US7jk3UnrUzFA9/OU67NLAyT3qHwaHLX9a+18th5KFo 1348865319
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [ 094/127] md: make sure metadata is updated when spares are activated or removed.
Date: Fri, 28 Sep 2012 13:34:27 -0700
Message-Id: <20120928203056.912250649@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 6dafab6b1383e912cd252fa809570b484eb6e0dc upstream.

It isn't always necessary to update the metadata when spares are
removed as the presence-or-not of a spare isn't really important to
the integrity of an array.
Also activating a spare doesn't always require updating the metadata
as the update on 'recovery-completed' is usually sufficient.

However the introduction of 'replacement' devices have made these
transitions sometimes more important.  For example the 'Replacement'
flag isn't cleared until the original device is removed, so we need
to ensure a metadata update after that 'spare' is removed.

So set MD_CHANGE_DEVS whenever a spare is activated or removed, to
complement the current situation where it is set when a spare is added
or a device is failed (or a number of other less common situations).

This is suitable for -stable as out-of-data metadata could lead
to data corruption.
This is only relevant for 3.3 and later 9when 'replacement' as
introduced.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7096,6 +7096,7 @@ static int remove_and_add_spares(mddev_t
 {
 	mdk_rdev_t *rdev;
 	int spares = 0;
+	int removed = 0;
 
 	mddev->curr_resync_completed = 0;
 
@@ -7111,6 +7112,7 @@ static int remove_and_add_spares(mddev_t
 				sprintf(nm,"rd%d", rdev->raid_disk);
 				sysfs_remove_link(&mddev->kobj, nm);
 				rdev->raid_disk = -1;
+				removed = 1;
 			}
 		}
 
@@ -7139,6 +7141,8 @@ static int remove_and_add_spares(mddev_t
 			}
 		}
 	}
+	if (removed)
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	return spares;
 }
 
@@ -7152,9 +7156,11 @@ static void reap_sync_thread(mddev_t *md
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* success...*/
 		/* activate any spares */
-		if (mddev->pers->spare_active(mddev))
+		if (mddev->pers->spare_active(mddev)) {
 			sysfs_notify(&mddev->kobj, NULL,
 				     "degraded");
+			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		}
 	}
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    mddev->pers->finish_reshape)


