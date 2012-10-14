Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2JNPHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:07:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab2JNOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:30 -0400
Message-Id: <20121014143549.703403843@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Simon Kirby <sim@hostway.ca>
Subject: [ 118/147] firewire: cdev: fix user memory corruption (i386 userland on amd64
 kernel)
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


