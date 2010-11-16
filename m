Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0KPVzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443Ab0KPVzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:55:41 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] netfilter: allow hooks to pass error code back up the
	stack
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org
Cc: eparis@redhat.com, equinox@diac24.net, eric.dumazet@gmail.com,
        davem@davemloft.net, hzhong@gmail.com, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru, paul.moore@hp.com,
        pekkas@netcore.fi, sds@tycho.nsa.gov, yoshfuji@linux-ipv6.org
Date: Tue, 16 Nov 2010 16:52:38 -0500
Message-ID: <20101116215238.6727.39248.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SELinux would like to pass certain fatal errors back up the stack.  This patch
implements the generic netfilter support for this functionality.

Based-on-patch-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/netfilter.h |    2 ++
 net/netfilter/core.c      |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 03317c8..1893837 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -33,6 +33,8 @@
 
 #define NF_QUEUE_NR(x) ((((x) << NF_VERDICT_BITS) & NF_VERDICT_QMASK) | NF_QUEUE)
 
+#define NF_DROP_ERR(x) (((-x) << NF_VERDICT_BITS) | NF_DROP)
+
 /* only for userspace compatibility */
 #ifndef __KERNEL__
 /* Generic cache responses from hook functions.
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 85dabb8..32fcbe2 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -173,9 +173,11 @@ next_hook:
 			     outdev, &elem, okfn, hook_thresh);
 	if (verdict == NF_ACCEPT || verdict == NF_STOP) {
 		ret = 1;
-	} else if (verdict == NF_DROP) {
+	} else if ((verdict & NF_VERDICT_MASK) == NF_DROP) {
 		kfree_skb(skb);
-		ret = -EPERM;
+		ret = -(verdict >> NF_VERDICT_BITS);
+		if (ret == 0)
+			ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
 		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
 			      verdict >> NF_VERDICT_BITS))

