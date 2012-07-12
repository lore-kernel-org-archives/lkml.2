Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162199Ab2GLXAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:00:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50847 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162075Ab2GLWnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Balzer <chibi@gol.com>, NeilBrown <neilb@suse.de>
Subject: [ 129/187] md/raid10: Dont try to recovery unmatched (and unused) chunks.
Date: Thu, 12 Jul 2012 15:34:45 -0700
Message-Id: <20120712191534.337887403@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

commit fc448a18ae6219af9a73257b1fbcd009efab4a81 upstream.

If a RAID10 has an odd number of chunks - as might happen when there
are an odd number of devices - the last chunk has no pair and so is
not mirrored.  We don't store data there, but when recovering the last
device in an array we retry to recover that last chunk from a
non-existent location.  This results in an error, and the recovery
aborts.

When we get to that last chunk we should just stop - there is nothing
more to do anyway.

This bug has been present since the introduction of RAID10, so the
patch is appropriate for any -stable kernel.

Reported-by: Christian Balzer <chibi@gol.com>
Tested-by: Christian Balzer <chibi@gol.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2772,6 +2772,12 @@ static sector_t sync_request(struct mdde
 			/* want to reconstruct this device */
 			rb2 = r10_bio;
 			sect = raid10_find_virt(conf, sector_nr, i);
+			if (sect >= mddev->resync_max_sectors) {
+				/* last stripe is not complete - don't
+				 * try to recover this sector.
+				 */
+				continue;
+			}
 			/* Unless we are doing a full sync, or a replacement
 			 * we only need to recover the block if it is set in
 			 * the bitmap


