Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab1ESSUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:20:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39662 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933963Ab1ESSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:22 -0400
X-Sasl-enc: nrRZpJyUc5LjgEdYTsg5rBQk+/Lb8jXbQeP8rAJSdxS9 1305828501
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.795118184@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [26/71] PM / Hibernate: Make snapshot_release() restore GFP mask
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 9744997a8a2280e67984d4bffd87221d24f3b6b1 upstream.

If the process using the hibernate user space interface closes
/dev/snapshot after creating a hibernation image without thawing
tasks, snapshot_release() should call pm_restore_gfp_mask() to
restore the GFP mask used before the creation of the image.  Make
that happen.

Tested-by: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -135,8 +135,10 @@ static int snapshot_release(struct inode
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap);
-	if (data->frozen)
+	if (data->frozen) {
+		pm_restore_gfp_mask();
 		thaw_processes();
+	}
 	pm_notifier_call_chain(data->mode == O_RDONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);


