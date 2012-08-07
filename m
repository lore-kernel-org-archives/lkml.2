Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031352Ab2HGWvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:51:03 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42489 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031257Ab2HGWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/49] net/tun: fix ioctl() based info leaks
Date: Tue,  7 Aug 2012 15:44:57 -0700
Message-Id: <20120807222030.374267580@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commits a117dacde0288f3ec60b6e5bcedae8fa37ee0dfc
  and 8bbb181308bc348e02bfdbebdedd4e4ec9d452ce ]

The tun module leaks up to 36 bytes of memory by not fully initializing
a structure located on the stack that gets copied to user memory by the
TUNGETIFF and SIOCGIFHWADDR ioctl()s.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1239,10 +1239,12 @@ static long __tun_chr_ioctl(struct file
 	int vnet_hdr_sz;
 	int ret;
 
-	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89)
+	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89) {
 		if (copy_from_user(&ifr, argp, ifreq_len))
 			return -EFAULT;
-
+	} else {
+		memset(&ifr, 0, sizeof(ifr));
+	}
 	if (cmd == TUNGETFEATURES) {
 		/* Currently this just means: "what IFF flags are valid?".
 		 * This is needed because we never checked for invalid flags on


