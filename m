Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab1FAJWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:22:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161524Ab1FAIKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:40 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:11 2011
Message-Id: <20110601080310.570644950@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:46 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [050/146] irda: fix locking unbalance in irda_sendmsg
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Dave Jones <davej@redhat.com>

[ Upstream commit 020318d0d2af51e0fd59ba654ede9b2171558720 ]

5b40964eadea40509d353318d2c82e8b7bf5e8a5 ("irda: Remove BKL instances
from af_irda.c") introduced a path where we have a locking unbalance.
If we pass invalid flags, we unlock a socket we never locked,
resulting in this...

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
trinity/20101 is trying to release lock (sk_lock-AF_IRDA) at:
[<ffffffffa057f001>] irda_sendmsg+0x207/0x21d [irda]
but there are no more locks to release!

other info that might help us debug this:
no locks held by trinity/20101.

stack backtrace:
Pid: 20101, comm: trinity Not tainted 2.6.39-rc3+ #3
Call Trace:
 [<ffffffffa057f001>] ? irda_sendmsg+0x207/0x21d [irda]
 [<ffffffff81085041>] print_unlock_inbalance_bug+0xc7/0xd2
 [<ffffffffa057f001>] ? irda_sendmsg+0x207/0x21d [irda]
 [<ffffffff81086aca>] lock_release+0xcf/0x18e
 [<ffffffff813ed190>] release_sock+0x2d/0x155
 [<ffffffffa057f001>] irda_sendmsg+0x207/0x21d [irda]
 [<ffffffff813e9f8c>] __sock_sendmsg+0x69/0x75
 [<ffffffff813ea105>] sock_sendmsg+0xa1/0xb6
 [<ffffffff81100ca3>] ? might_fault+0x5c/0xac
 [<ffffffff81086b7c>] ? lock_release+0x181/0x18e
 [<ffffffff81100cec>] ? might_fault+0xa5/0xac
 [<ffffffff81100ca3>] ? might_fault+0x5c/0xac
 [<ffffffff81133b94>] ? fcheck_files+0xb9/0xf0
 [<ffffffff813f387a>] ? copy_from_user+0x2f/0x31
 [<ffffffff813f3b70>] ? verify_iovec+0x52/0xa6
 [<ffffffff813eb4e3>] sys_sendmsg+0x23a/0x2b8
 [<ffffffff81086b7c>] ? lock_release+0x181/0x18e
 [<ffffffff810773c6>] ? up_read+0x28/0x2c
 [<ffffffff814bec3d>] ? do_page_fault+0x360/0x3b4
 [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff810458aa>] ? finish_task_switch+0xb2/0xe3
 [<ffffffff8104583e>] ? finish_task_switch+0x46/0xe3
 [<ffffffff8108364a>] ? trace_hardirqs_off_caller+0x33/0x90
 [<ffffffff814bbaf9>] ? retint_swapgs+0x13/0x1b
 [<ffffffff81087043>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff810a9dd3>] ? audit_syscall_entry+0x11c/0x148
 [<ffffffff8125609e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff814c22c2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/irda/af_irda.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1297,8 +1297,7 @@ static int irda_sendmsg(struct kiocb *io
 	/* Note : socket.c set MSG_EOR on SEQPACKET sockets */
 	if (msg->msg_flags & ~(MSG_DONTWAIT | MSG_EOR | MSG_CMSG_COMPAT |
 			       MSG_NOSIGNAL)) {
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	lock_sock(sk);


