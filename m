Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2GNC1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 22:27:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57580 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2GNC1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 22:27:53 -0400
Message-ID: <5000D926.2020307@gmail.com>
Date: Sat, 14 Jul 2012 03:27:50 +0100
From: Aaron Jones <aaronmdjones@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] New capability CAP_RND_ADD for solely allowing addition of
 entropy
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was interested in modifying haveged to drop privileges after opening
/dev/random but discovered this was not possible because it uses the
ioctl RNDADDENTROPY which requires CAP_SYS_ADMIN.

Retaining CAP_SYS_ADMIN after dropping GID/UID would defeat the point
of doing so, so this program must always run with UID 0 and/or
CAP_SYS_ADMIN, which is undesirable.

I attach a patch to add a new capability CAP_RND_ADD, which allows the
use of ioctls RNDADDENTROPY and RNDADDTOENTCNT. It further modifies
drivers/char/random.c to also check for this capability before returning
-EPERM.

==================

--- a/drivers/char/random.c    2012-07-14 02:52:10.781202854 +0100
+++ b/drivers/char/random.c    2012-07-14 02:52:55.369201089 +0100
@@ -1154,14 +1154,14 @@
              return -EFAULT;
          return 0;
      case RNDADDTOENTCNT:
-        if (!capable(CAP_SYS_ADMIN))
+        if (!capable(CAP_SYS_ADMIN) && !capable(CAP_RND_ADD))
              return -EPERM;
          if (get_user(ent_count, p))
              return -EFAULT;
          credit_entropy_bits(&input_pool, ent_count);
          return 0;
      case RNDADDENTROPY:
-        if (!capable(CAP_SYS_ADMIN))
+        if (!capable(CAP_SYS_ADMIN) && !capable(CAP_RND_ADD))
              return -EPERM;
          if (get_user(ent_count, p++))
              return -EFAULT;
--- a/include/linux/capability.h    2012-07-14 03:15:52.378624902 +0100
+++ b/include/linux/capability.h    2012-07-14 03:16:47.508624928 +0100
@@ -364,7 +364,18 @@

  #define CAP_EPOLLWAKEUP      36

-#define CAP_LAST_CAP         CAP_EPOLLWAKEUP
+/* Allow adding of random entropy and updating entropy estimate,
+   but not clearing the entropy pool (see drivers/char/random.c)
+   Introduced so that software like haveged can drop gid/uid
+   on startup and drop all capabilities except this one.
+   Otherwise it would require CAP_SYS_ADMIN, which would
+   defeat the point of dropping gid/uid. */
+
+#define CAP_RND_ADD          37
+
+
+
+#define CAP_LAST_CAP         CAP_RND_ADD

  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)



