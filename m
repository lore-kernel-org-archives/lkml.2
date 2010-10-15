Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0JOMMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:12:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:60484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0JOMMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:12:51 -0400
Message-ID: <4CB84532.5020809@kernel.org>
Date: Fri, 15 Oct 2010 14:12:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] drm/ttm: use cancel_delayed_work_sync() in ttm_bo
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 12:12:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ttm_bo::ttm_bo_device_release call cancel_delayed_work_sync()
instead of calling cancel_delayed_work() followed by
flush_scheduled_work().

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/gpu/drm/ttm/ttm_bo.c
===================================================================
--- work.orig/drivers/gpu/drm/ttm/ttm_bo.c
+++ work/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1480,8 +1480,7 @@ int ttm_bo_device_release(struct ttm_bo_
 	list_del(&bdev->device_list);
 	mutex_unlock(&glob->device_list_mutex);

-	if (!cancel_delayed_work(&bdev->wq))
-		flush_scheduled_work();
+	cancel_delayed_work_sync(&bdev->wq);

 	while (ttm_bo_delayed_delete(bdev, true))
 		;
