Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161132Ab1FAIGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:06:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161108Ab1FAIGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:06:46 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:33 2011
Message-Id: <20110601080232.319170094@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:02 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [006/146] net: recvmmsg: Strip MSG_WAITFORONE when calling recvmsg
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit b9eb8b8752804cecbacdb4d24b52e823cf07f107 upstream.

recvmmsg fails on a raw socket with EINVAL. The reason for this is
packet_recvmsg checks the incoming flags:

        err = -EINVAL;
        if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
                goto out;

This patch strips out MSG_WAITFORONE when calling recvmmsg which
fixes the issue.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2117,14 +2117,16 @@ int __sys_recvmmsg(int fd, struct mmsghd
 		 */
 		if (MSG_CMSG_COMPAT & flags) {
 			err = __sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags & ~MSG_WAITFORONE,
+					    datagrams);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
 			err = __sys_recvmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, datagrams);
+					    &msg_sys, flags & ~MSG_WAITFORONE,
+					    datagrams);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);


