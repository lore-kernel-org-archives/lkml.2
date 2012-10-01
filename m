Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2JAXZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:25:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35306 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932841Ab2JAXBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:10 -0400
Message-Id: <20121001225202.523982455@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 116/180] net/tun: fix ioctl() based info leaks
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/tun.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0f77aca..894ad84 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1121,10 +1121,12 @@ static long tun_chr_ioctl(struct file *file, unsigned int cmd,
 	int sndbuf;
 	int ret;
 
-	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89)
+	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89) {
 		if (copy_from_user(&ifr, argp, sizeof ifr))
 			return -EFAULT;
-
+	} else {
+		memset(&ifr, 0, sizeof(ifr));
+	}
 	if (cmd == TUNGETFEATURES) {
 		/* Currently this just means: "what IFF flags are valid?".
 		 * This is needed because we never checked for invalid flags on
-- 
1.7.2.1.45.g54fbc



