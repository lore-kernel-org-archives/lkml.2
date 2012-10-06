Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2JFMNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 08:13:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50770 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2JFMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 08:13:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Oct 2012 14:12:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Simon Kirby <sim@hostway.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: cdev: fix user memory corruption (i386 userland
 on amd64 kernel)
Message-ID: <20121006141256.6adc4afc@stein>
In-Reply-To: <20121005203220.21fbd20a@stein>
References: <20121005082250.GA21132@hostway.ca>
	<20121005203220.21fbd20a@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 drivers/firewire/core-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -473,8 +473,8 @@ static int ioctl_get_info(struct client
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
Stefan Richter
-=====-===-- =-=- --==-
http://arcgraph.de/sr/
