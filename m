Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1EFWci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:32:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab1EFWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:32:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM / Hibernate: Make snapshot_release() restore GFP mask
Date: Sat, 7 May 2011 00:31:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexandre Felipe Muller de Souza 
	<alexandrefm@mandriva.com.br>
References: <201105070029.44623.rjw@sisk.pl>
In-Reply-To: <201105070029.44623.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105070031.17048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the process using the hibernate user space interface closes
/dev/snapshot after creating a hibernation image without thawing
tasks, snapshot_release() should call pm_restore_gfp_mask() to
restore the GFP mask used before the creation of the image.  Make
that happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
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

