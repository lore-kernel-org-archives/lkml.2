Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab2DKXOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:14:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab2DKXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:42 -0400
Message-Id: <20120411231019.089444081@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/78] rose_dev: fix memcpy-bug in rose_set_mac_address
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "danborkmann@iogearbox.net" <danborkmann@iogearbox.net>

[ Upstream commit 81213b5e8ae68e204aa7a3f83c4f9100405dbff9 ]

If both addresses equal, nothing needs to be done. If the device is down,
then we simply copy the new address to dev->dev_addr. If the device is up,
then we add another loopback device with the new address, and if that does
not fail, we remove the loopback device with the old address. And only
then, we update the dev->dev_addr.

Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -96,11 +96,11 @@ static int rose_set_mac_address(struct n
 	struct sockaddr *sa = addr;
 	int err;
 
-	if (!memcpy(dev->dev_addr, sa->sa_data, dev->addr_len))
+	if (!memcmp(dev->dev_addr, sa->sa_data, dev->addr_len))
 		return 0;
 
 	if (dev->flags & IFF_UP) {
-		err = rose_add_loopback_node((rose_address *)dev->dev_addr);
+		err = rose_add_loopback_node((rose_address *)sa->sa_data);
 		if (err)
 			return err;
 


