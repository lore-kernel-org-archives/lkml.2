Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946378Ab2I1Vpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:45:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032317Ab2I1UZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [ 072/218] md: make sure metadata is updated when spares are activated or removed.
Date: Fri, 28 Sep 2012 13:14:49 -0700
Message-Id: <20120928201509.839556782@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7420,6 +7420,8 @@ static int remove_and_add_spares(struct
 			}
 		}
 	}
+	if (removed)
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	return spares;
 }
 
@@ -7433,9 +7435,11 @@ static void reap_sync_thread(struct mdde
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


