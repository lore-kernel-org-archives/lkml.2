Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030660Ab2HQD1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:27:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46735 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030627Ab2HQD0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:55 -0400
Message-Id: <20120817030245.619442353@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/37] net/tun: fix ioctl() based info leaks
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commits a117dacde0288f3ec60b6e5bcedae8fa37ee0dfc
  and 8bbb181308bc348e02bfdbebdedd4e4ec9d452ce ]

The tun module leaks up to 36 bytes of memory by not fully initializing
a structure located on the stack that gets copied to user memory by the
TUNGETIFF and SIOCGIFHWADDR ioctl()s.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/tun.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7bea9c6..a12c9bf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1243,10 +1243,12 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
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


