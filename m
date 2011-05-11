Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1EKV0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:26:02 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34344 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1EKV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rRScnNV0FR++wXxZxGxCuLknKBKrzMEAfg0xbjVDW92zgDGoKJcLPvcvn2zgGpW33n
         YabE4j1FyDcSDT8Zz/oIvGfuo86b6ZwTagPz3wiMJS6NeZnWcodYFzYREw2wHBuZlTwQ
         IyO4s2kxxHMatZEgLg9Mm4t1XwxQreQqc6a4g=
Subject: [PATCH] input: remove useless synchronize_rcu() calls
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 23:25:55 +0200
Message-ID: <1305149155.3232.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call synchronize_rcu() after a list insertion,
or a NULL->ptr assignment.

However, the reverse operations do need this call.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>,
---
 drivers/input/evdev.c    |    2 --
 drivers/input/input.c    |    1 -
 drivers/input/joydev.c   |    1 -
 drivers/input/mousedev.c |    1 -
 4 files changed, 5 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 88d8e4c..c00e751 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -159,7 +159,6 @@ static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
 		return error;
 
 	rcu_assign_pointer(evdev->grab, client);
-	synchronize_rcu();
 
 	return 0;
 }
@@ -182,7 +181,6 @@ static void evdev_attach_client(struct evdev *evdev,
 	spin_lock(&evdev->client_lock);
 	list_add_tail_rcu(&client->node, &evdev->client_list);
 	spin_unlock(&evdev->client_lock);
-	synchronize_rcu();
 }
 
 static void evdev_detach_client(struct evdev *evdev,
diff --git a/drivers/input/input.c b/drivers/input/input.c
index ebbceed..75e11c7 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -451,7 +451,6 @@ int input_grab_device(struct input_handle *handle)
 	}
 
 	rcu_assign_pointer(dev->grab, handle);
-	synchronize_rcu();
 
  out:
 	mutex_unlock(&dev->mutex);
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 5688b5c..c24ec2d 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -180,7 +180,6 @@ static void joydev_attach_client(struct joydev *joydev,
 	spin_lock(&joydev->client_lock);
 	list_add_tail_rcu(&client->node, &joydev->client_list);
 	spin_unlock(&joydev->client_lock);
-	synchronize_rcu();
 }
 
 static void joydev_detach_client(struct joydev *joydev,
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 7630273..257e033 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -508,7 +508,6 @@ static void mousedev_attach_client(struct mousedev *mousedev,
 	spin_lock(&mousedev->client_lock);
 	list_add_tail_rcu(&client->node, &mousedev->client_list);
 	spin_unlock(&mousedev->client_lock);
-	synchronize_rcu();
 }
 
 static void mousedev_detach_client(struct mousedev *mousedev,


