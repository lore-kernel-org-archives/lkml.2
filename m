Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769158Ab2K3TYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:24:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:58357 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992684Ab2K3S4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "George Spelvin" <linux@horizon.com>, NeilBrown <neilb@suse.de>
Subject: [ 26/56] md/raid10: decrement correct pending counter when writing to replacement.
Date: Fri, 30 Nov 2012 10:55:18 -0800
Message-Id: <20121130185120.922550056@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 884162df2aadd7414bef4935e1a54976fd4e3988 upstream.

When a write to a replacement device completes, we carefully
and correctly found the rdev that the write actually went to
and the blithely called rdev_dec_pending on the primary rdev,
even if this write was to the replacement.

This means that any writes to an array while a replacement
was ongoing would cause the nr_pending count for the primary
device to go negative, so it could never be removed.

This bug has been present since replacement was introduced in
3.3, so it is suitable for any -stable kernel since then.

Reported-by: "George Spelvin" <linux@horizon.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -476,7 +476,7 @@ static void raid10_end_write_request(str
 	 */
 	one_write_done(r10_bio);
 	if (dec_rdev)
-		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 }
 
 /*


