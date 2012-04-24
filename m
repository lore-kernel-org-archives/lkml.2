Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2DXWfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2DXWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:36 -0400
Message-Id: <20120424223244.786802919@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Nelles <evilazrael@evilazrael.de>,
        NeilBrown <neilb@suse.de>
Subject: [ 33/62] md: fix possible corruption of array metadata on shutdown.
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 30b8aa9172dfeaac6d77897c67ee9f9fc574cdbb upstream.

commit c744a65c1e2d59acc54333ce8
  md: don't set md arrays to readonly on shutdown.

removed the possibility of a 'BUG' when data is written to an array
that has just been switched to read-only, but also introduced the
possibility that the array metadata could be corrupted.

If, when md_notify_reboot gets the mddev lock, the array is
in a state where it is assembled but hasn't been started (as can
happen if the personality module is not available, or in other unusual
situations), then incorrect metadata will be written out making it
impossible to re-assemble the array.

So only call __md_stop_writes() if the array has actually been
activated.

This patch is needed for any stable kernel which has had the above
commit applied.

Reported-by: Christoph Nelles <evilazrael@evilazrael.de>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8160,7 +8160,8 @@ static int md_notify_reboot(struct notif
 
 	for_each_mddev(mddev, tmp) {
 		if (mddev_trylock(mddev)) {
-			__md_stop_writes(mddev);
+			if (mddev->pers)
+				__md_stop_writes(mddev);
 			mddev->safemode = 2;
 			mddev_unlock(mddev);
 		}


