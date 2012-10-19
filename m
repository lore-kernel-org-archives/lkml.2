Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2JSCrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:51177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab2JSCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Simon Kirby <sim@hostway.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [ 19/62] firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)
Date: Thu, 18 Oct 2012 19:44:47 -0700
Message-Id: <20121019024259.062318664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/core-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -471,8 +471,8 @@ static int ioctl_get_info(struct client
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


