Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136Ab2KBRNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:13:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:33316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762378Ab2KBRHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [ 05/24] md/raid1: Fix assembling of arrays containing Replacements.
Date: Fri,  2 Nov 2012 10:06:53 -0700
Message-Id: <20121102170247.813639343@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2699,7 +2699,7 @@ static struct r1conf *setup_conf(struct
 		    || disk_idx < 0)
 			continue;
 		if (test_bit(Replacement, &rdev->flags))
-			disk = conf->mirrors + conf->raid_disks + disk_idx;
+			disk = conf->mirrors + mddev->raid_disks + disk_idx;
 		else
 			disk = conf->mirrors + disk_idx;
 


