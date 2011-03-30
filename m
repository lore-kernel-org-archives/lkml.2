Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab1C3VPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:15:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288Ab1C3VKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239424"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dhowells@redhat.com, ebiederm@xmission.com, ak@linux.intel.com,
        daniel.lezcano@free.fr, xemul@openvz.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [258/275] Patch cab9e9848b9a8283b0504a2d7c435a9f5ba026de to the 2.6.35.y stable tree
Message-Id: <20110330210825.548243E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
stored a ref to the current cred struct in struct scm_cookie.  This was fine
with AF_UNIX as that calls scm_destroy() from its packet sending functions, but
AF_NETLINK, which also uses scm_send(), does not call scm_destroy() - meaning
that the copied credentials leak each time SCM data is sent over a netlink
socket.

This can be triggered quite simply on a Fedora 13 or 14 userspace with the
2.6.35.11 kernel (or something based off of that) by calling:

	#!/bin/bash
	for ((i=0; i<100; i++))
	do
		su - -c /bin/true
		cut -d: -f1 /proc/slabinfo | grep 'cred\|key\|task_struct'
		cat /proc/keys | wc -l
	done

This leaks the session key that pam_keyinit creates for 'su -', which appears
in /proc/keys as being revoked (has the R flag set against it) afterward su is
called.

Furthermore, if CONFIG_SLAB=y, then the cred and key slab object usage counts
can be viewed and seen to increase.  The key slab increases by one object per
loop, and this can be seen after the system has had a couple of minutes to
stand after the script above has been run on it.

If the system is working correctly, the key and cred counts should return to
roughly what they were before.

This patch from upstream (b47030c71dfd6c8cd5cb6e551b6f7f7cfc96f6a6) is needed
to fix the problem:

===============================================================================

From: Eric W. Biederman <ebiederm@xmission.com>

af_netlink: Add needed scm_destroy after scm_send.

scm_send occasionally allocates state in the scm_cookie, so I have
modified netlink_sendmsg to guarantee that when scm_send succeeds
scm_destory will be called to free that state.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---

 net/netlink/af_netlink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/netlink/af_netlink.c
===================================================================
--- linux-2.6.35.y.orig/net/netlink/af_netlink.c	2011-03-29 23:57:49.891120088 -0700
+++ linux-2.6.35.y/net/netlink/af_netlink.c	2011-03-30 00:25:02.306350666 -0700
@@ -1323,8 +1323,11 @@
 	if (msg->msg_flags&MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (NULL == siocb->scm)
+	if (NULL == siocb->scm) {
 		siocb->scm = &scm;
+		memset(&scm, 0, sizeof(scm));
+	}
+
 	err = scm_send(sock, msg, siocb->scm);
 	if (err < 0)
 		return err;
