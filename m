Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2KZSKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:10:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2KZRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 059/270] firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)
Date: Mon, 26 Nov 2012 14:55:49 -0200
Message-Id: <1353949160-26803-60-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 790198f74c9d1b46b6a89504361b1a844670d050 upstream.

Fix two bugs of the /dev/fw* character device concerning the
FW_CDEV_IOC_GET_INFO ioctl with nonzero fw_cdev_get_info.bus_reset.
(Practically all /dev/fw* clients issue this ioctl right after opening
the device.)

Both bugs are caused by sizeof(struct fw_cdev_event_bus_reset) being 36
without natural alignment and 40 with natural alignment.

 1) Memory corruption, affecting i386 userland on amd64 kernel:
    Userland reserves a 36 bytes large buffer, kernel writes 40 bytes.
    This has been first found and reported against libraw1394 if
    compiled with gcc 4.7 which happens to order libraw1394's stack such
    that the bug became visible as data corruption.

 2) Information leak, affecting all kernel architectures except i386:
    4 bytes of random kernel stack data were leaked to userspace.

Hence limit the respective copy_to_user() to the 32-bit aligned size of
struct fw_cdev_event_bus_reset.

Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/firewire/core-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 2783f69..f8d2287 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -473,8 +473,8 @@ static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
 	client->bus_reset_closure = a->bus_reset_closure;
 	if (a->bus_reset != 0) {
 		fill_bus_reset_event(&bus_reset, client);
-		ret = copy_to_user(u64_to_uptr(a->bus_reset),
-				   &bus_reset, sizeof(bus_reset));
+		/* unaligned size of bus_reset is 36 bytes */
+		ret = copy_to_user(u64_to_uptr(a->bus_reset), &bus_reset, 36);
 	}
 	if (ret == 0 && list_empty(&client->link))
 		list_add_tail(&client->link, &client->device->client_list);
-- 
1.7.9.5

