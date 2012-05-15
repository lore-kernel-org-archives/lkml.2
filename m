Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838Ab2EOCTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:19:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:49688 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164Ab2EOCRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 104/179] udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet
Date: Mon, 14 May 2012 22:13:20 -0400
Message-ID: <1337048075-6132-105-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xufeng Zhang <xufeng.zhang@windriver.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9cfaa8def1c795a512bc04f2aec333b03724ca2e upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/udp.c |    3 +++
 net/ipv6/udp.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ff6a18e..7932dc6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1203,6 +1203,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a0a6a08..a1d3d32 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -443,6 +443,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 
-- 
1.7.9.6

