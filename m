Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab1C3WLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:11:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:9758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032Ab1C3VGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235715"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dhowells@redhat.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [6/275] Fix cred leak in AF_NETLINK
Message-Id: <20110330210400.06F483E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Patch cab9e9848b9a8283b0504a2d7c435a9f5ba026de to the 2.6.35.y stable tree
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

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---

 net/netlink/af_netlink.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/net/netlink/af_netlink.c
===================================================================
--- linux-2.6.35.y.orig/net/netlink/af_netlink.c	2011-03-29 22:52:05.032059161 -0700
+++ linux-2.6.35.y/net/netlink/af_netlink.c	2011-03-29 23:53:42.295455441 -0700
@@ -1330,12 +1330,16 @@
 		return err;
 
 	if (msg->msg_namelen) {
-		if (addr->nl_family != AF_NETLINK)
-			return -EINVAL;
+		if (addr->nl_family != AF_NETLINK) {
+			err = -EINVAL;
+			goto out;
+		}
 		dst_pid = addr->nl_pid;
 		dst_group = ffs(addr->nl_groups);
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
-			return -EPERM;
+		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND)) {
+			err = -EPERM;
+			goto out;
+		}
 	} else {
 		dst_pid = nlk->dst_pid;
 		dst_group = nlk->dst_group;
@@ -1387,6 +1391,8 @@
 	err = netlink_unicast(sk, skb, dst_pid, msg->msg_flags&MSG_DONTWAIT);
 
 out:
+	scm_destroy(siocb->scm);
+	siocb->scm = NULL;
 	return err;
 }
 
