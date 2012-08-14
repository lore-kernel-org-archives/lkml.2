Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2HNWua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:50:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:7736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2HNWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:50:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,769,1336374000"; 
   d="scan'208";a="180764173"
From: John Fastabend <john.r.fastabend@intel.com>
Subject: [net PATCH v3 2/3] net: netprio: fd passed in SCM_RIGHTS datagram not
	set correctly
To: viro@ZenIV.linux.org.uk, nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        joe@perches.com
Date: Tue, 14 Aug 2012 15:34:30 -0700
Message-ID: <20120814223430.3551.88909.stgit@jf-dev1-dcblab>
In-Reply-To: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
References: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A socket fd passed in a SCM_RIGHTS datagram was not getting
updated with the new tasks cgrp prioidx. This leaves IO on
the socket tagged with the old tasks priority.

To fix this add a check in the scm recvmsg path to update the
sock cgrp prioidx with the new tasks value.

Thanks to Al Viro for catching this.

CC: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
---

 net/core/scm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 8f6ccfd..040cebe 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -265,6 +265,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
 	     i++, cmfptr++)
 	{
+		struct socket *sock;
 		int new_fd;
 		err = security_file_receive(fp[i]);
 		if (err)
@@ -281,6 +282,9 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 		}
 		/* Bump the usage count and install the file. */
 		get_file(fp[i]);
+		sock = sock_from_file(fp[i], &err);
+		if (sock)
+			sock_update_netprioidx(sock->sk, current);
 		fd_install(new_fd, fp[i]);
 	}
 

