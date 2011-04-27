Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1D0A0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1D0A0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:26:09 -0400
Date: Tue, 26 Apr 2011 20:21:50 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [stable] [PATCH] [0/106] 2.6.35.13 longterm review
Message-ID: <20110426202150.1bec600d@katamari>
In-Reply-To: <20110426212.641772347@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 14:12:37 -0700 (PDT)
Andi Kleen <andi@firstfloor.org> wrote:

> 

Also please revert the patch "fix-cred-leak-in-af_netlink" from 2.6.35.12.
The proper fix was "af_netlink-add-needed-scm_destroy-after-scm_send" which
was also added in that release. Here's a revert patch:

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1330,16 +1330,12 @@
 		return err;
 
 	if (msg->msg_namelen) {
+		if (addr->nl_family != AF_NETLINK)
+			return -EINVAL;
-		if (addr->nl_family != AF_NETLINK) {
-			err = -EINVAL;
-			goto out;
-		}
 		dst_pid = addr->nl_pid;
 		dst_group = ffs(addr->nl_groups);
+		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND))
+			return -EPERM;
-		if (dst_group && !netlink_capable(sock, NL_NONROOT_SEND)) {
-			err = -EPERM;
-			goto out;
-		}
 	} else {
 		dst_pid = nlk->dst_pid;
 		dst_group = nlk->dst_group;
@@ -1391,8 +1387,6 @@
 	err = netlink_unicast(sk, skb, dst_pid, msg->msg_flags&MSG_DONTWAIT);
 
 out:
-	scm_destroy(siocb->scm);
-	siocb->scm = NULL;
 	return err;
 }
 
_
