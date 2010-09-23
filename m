Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0IWIwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:52:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57582 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0IWIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:52:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
Date: Thu, 23 Sep 2010 01:51:59 -0700
In-Reply-To: <m1ocborgq7.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 23 Sep 2010 01:45:04 -0700")
Message-ID: <m1bp7oq1u8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 8/8] net: Implement socketat.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a system call for creating sockets in a specified network namespace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/socket.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 2270b94..1116f3c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1269,7 +1269,7 @@ int sock_create_kern(int family, int type, int protocol, struct socket **res)
 }
 EXPORT_SYMBOL(sock_create_kern);
 
-SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
+static int do_socket(struct net *net, int family, int type, int protocol)
 {
 	int retval;
 	struct socket *sock;
@@ -1289,7 +1289,7 @@ SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	retval = sock_create(family, type, protocol, &sock);
+	retval = __sock_create(net, family, type, protocol, &sock, 0);
 	if (retval < 0)
 		goto out;
 
@@ -1306,6 +1306,28 @@ out_release:
 	return retval;
 }
 
+SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
+{
+	return do_socket(current->nsproxy->net_ns, family, type, protocol);
+}
+
+SYSCALL_DEFINE4(socketat, int, fd, int, family, int, type, int, protocol)
+{
+	struct net *net;
+	int retval;
+
+	if (fd == -1) {
+		net = get_net(current->nsproxy->net_ns);
+	} else {
+		net = get_net_ns_by_fd(fd);
+		if (IS_ERR(net))
+			return  PTR_ERR(net);
+	}
+	retval = do_socket(net, family, type, protocol);
+	put_net(net);
+	return retval;
+}
+
 /*
  *	Create a pair of connected sockets.
  */
-- 
1.6.5.2.143.g8cc62

