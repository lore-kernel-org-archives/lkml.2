Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2LMPGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:06:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2LMOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 030/241] md/raid1: Fix assembling of arrays containing Replacements.
Date: Thu, 13 Dec 2012 11:56:35 -0200
Message-Id: <1355407206-17100-31-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 02b898f2f04e418094f0093a3ad0b415bcdbe8eb upstream.

setup_conf in raid1.c uses conf->raid_disks before assigning
a value.  It is used when including 'Replacement' devices.

The consequence is that assembling an array which contains a
replacement will misbehave and either not include the replacement, or
not include the device being replaced.

Though this doesn't lead directly to data corruption, it could lead to
reduced data safety.

So use mddev->raid_disks, which is initialised, instead.

Bug was introduced by commit c19d57980b38a5bb613a898937a1cf85f422fb9b
      md/raid1: recognise replacements when assembling arrays.

in 3.3, so fix is suitable for 3.3.y thru 3.6.y.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 53aec45..cb781a1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2563,7 +2563,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		    || disk_idx < 0)
 			continue;
 		if (test_bit(Replacement, &rdev->flags))
-			disk = conf->mirrors + conf->raid_disks + disk_idx;
+			disk = conf->mirrors + mddev->raid_disks + disk_idx;
 		else
 			disk = conf->mirrors + disk_idx;
 
-- 
1.7.9.5

