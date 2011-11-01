Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1KAPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:42:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54432 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1KAPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:42:17 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [RFC] Input: Remove unsafe device module references
Date: Tue,  1 Nov 2011 16:41:40 +0100
Message-Id: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and Greg

It doesn't make sense to take a reference to our own module. When we call
module_put(THIS_MODULE) we cannot make sure that our module is still alive when
this function returns. Therefore, module_put() will return to invalid memory and
our input_dev_release() function is no longer available.

It would be interesting if Greg could elaborate what else we could do to replace
this module-refcount as it is definitely needed here. However, "struct device"
doesn't provide an owner field so there is no way for us to let the device core
keep a reference to our module.

I have no clue what to do here but the current implementation is definitely
unsafe so this is marked as RFC. Currently, the device_attributes probably
already keep a reference to our module so applying this patch would probably not
break anything, however, this does not look like something we can trust on.

My bug-thread kind of died (https://lkml.org/lkml/2011/10/29/75) so I now try to
show this with an example here.

Regards
David

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/input/input.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index da38d97..f691502 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1417,8 +1417,6 @@ static void input_dev_release(struct device *device)
 	input_mt_destroy_slots(dev);
 	kfree(dev->absinfo);
 	kfree(dev);
-
-	module_put(THIS_MODULE);
 }
 
 /*
@@ -1657,8 +1655,6 @@ struct input_dev *input_allocate_device(void)
 		spin_lock_init(&dev->event_lock);
 		INIT_LIST_HEAD(&dev->h_list);
 		INIT_LIST_HEAD(&dev->node);
-
-		__module_get(THIS_MODULE);
 	}
 
 	return dev;
-- 
1.7.7.1

