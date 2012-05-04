Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2EDVHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:07:55 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab2EDUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:04 -0400
Message-Id: <20120504204229.411480457@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, majianpeng <majianpeng@gmail.com>,
        NeilBrown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [ 59/75] md/raid5: Fix a bug about judging if the operation is syncing or replacing
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit c6d2e084c7411f61f2b446d94989e5aaf9879b0f upstream.

When create a raid5 using assume-clean and echo check or repair to
sync_action.Then component disks did not operated IO but the raid
check/resync faster than normal.
Because the judgement in function analyse_stripe():
		if (do_recovery ||
		    sh->sector >= conf->mddev->recovery_cp)
			s->syncing = 1;
		else
			s->replacing = 1;
When check or repair,the recovery_cp == MaxSectore,so syncing equal zero
not one.

This bug was introduced by commit 9a3e1101b827
    md/raid5:  detect and handle replacements during recovery.
so this patch is suitable for 3.3-stable.

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3277,12 +3277,14 @@ static void analyse_stripe(struct stripe
 		/* If there is a failed device being replaced,
 		 *     we must be recovering.
 		 * else if we are after recovery_cp, we must be syncing
+		 * else if MD_RECOVERY_REQUESTED is set, we also are syncing.
 		 * else we can only be replacing
 		 * sync and recovery both need to read all devices, and so
 		 * use the same flag.
 		 */
 		if (do_recovery ||
-		    sh->sector >= conf->mddev->recovery_cp)
+		    sh->sector >= conf->mddev->recovery_cp ||
+		    test_bit(MD_RECOVERY_REQUESTED, &(conf->mddev->recovery)))
 			s->syncing = 1;
 		else
 			s->replacing = 1;


