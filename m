Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1FOO51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:57:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1FOO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:57:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Tp7d2zu8t0vXE7tqMk6kpC90F5b5/FW/TiZSjEP4ovEPoDNbI+jYunYFfx+sPt259Y
         KUn4o2YDu6bUmT2SY7zvpeW/2x3C7/Lx233hKPNGRUi7N4+3+dALlzNFd9OiXOIrcv67
         g2lHM0bqcG4PdLgNLZZJrYhJZOqyMwTtGHDw4=
Date: Wed, 15 Jun 2011 16:57:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Jaya Kumar <jayalk@intworks.biz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] video: don't use flush_scheduled_work() in fb_defio
Message-ID: <20110615145721.GA8141@htj.dyndns.org>
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
Cc: Jaya Kumar <jayalk@intworks.biz>
---
Compile tested.  I'm planning on marking flush_scheduled_work()
deprecated in linux-next so it would be great if this can show up
there soonish.  Thank you.

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
