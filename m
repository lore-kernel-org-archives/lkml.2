Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1FOQAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:00:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62478 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1FOQA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:sender:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gsPUc3t7mmae9J2IsLVXwLz7J4hs/m0v+s0CIyPzE7cs8pQ/lK2r0c295kKH63mYyo
         bBMC16JX4Ju7VYnQNXq1elh/szBtuhexhTnSITwoSRXaJ0QVCtHMCOe+lyRDND3GNHF8
         KmI7RiWXcOPr3Gdd5sLO7XTFnze51mzrHXhus=
Date: Wed, 15 Jun 2011 18:00:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] video: don't use flush_scheduled_work() in fb_defio
Message-ID: <20110615160025.GB8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() in on the way out.  fb_deferred_io_cleanup()
can simply sync-cancel info->deferred_work instead of cancel +
flush_scheduled_work().  Drop flush_scheduled_work() usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
---
Compile tested.  I'm planning on marking flush_scheduled_work()
deprecated in linux-next so it would be great if this can show up
there soonish.  Thank you.

Resending because @intworks.biz bounced.  Please update MAINTAINERS
with new email address.

 drivers/video/fb_defio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/video/fb_defio.c
===================================================================
--- work.orig/drivers/video/fb_defio.c
+++ work/drivers/video/fb_defio.c
@@ -216,8 +216,7 @@ void fb_deferred_io_cleanup(struct fb_in
 	int i;
 
 	BUG_ON(!fbdefio);
-	cancel_delayed_work(&info->deferred_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
