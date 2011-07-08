Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1GHFUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:20:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1GHFA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.340173405@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xufeng Zhang <xufeng.zhang@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [016/107] udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Xufeng Zhang <xufeng.zhang@windriver.com>

[ Upstream commit 9cfaa8def1c795a512bc04f2aec333b03724ca2e ]

Consider this scenario: When the size of the first received udp packet
is bigger than the receive buffer, MSG_TRUNC bit is set in msg->msg_flags.
However, if checksum error happens and this is a blocking socket, it will
goto try_again loop to receive the next packet.  But if the size of the
next udp packet is smaller than receive buffer, MSG_TRUNC flag should not
be set, but because MSG_TRUNC bit is not cleared in msg->msg_flags before
receive the next packet, MSG_TRUNC is still set, which is wrong.

Fix this problem by clearing MSG_TRUNC flag when starting over for a
new packet.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/udp.c |    3 +++
 net/ipv6/udp.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1241,6 +1241,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -455,6 +455,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 


