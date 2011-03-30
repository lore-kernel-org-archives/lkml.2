Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab1C3VIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964940Ab1C3VIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278398"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jengelh@medozas.de, kaber@trash.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [179/275] netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values
Message-Id: <20110330210702.315E03E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jan Engelhardt <jengelh@medozas.de>

commit 9ef0298a8e5730d9a46d640014c727f3b4152870 upstream.

Like many other places, we have to check that the array index is
within allowed limits, or otherwise, a kernel oops and other nastiness
can ensue when we access memory beyond the end of the array.

[ 5954.115381] BUG: unable to handle kernel paging request at 0000004000000000
[ 5954.120014] IP:  __find_logger+0x6f/0xa0
[ 5954.123979]  nf_log_bind_pf+0x2b/0x70
[ 5954.123979]  nfulnl_recv_config+0xc0/0x4a0 [nfnetlink_log]
[ 5954.123979]  nfnetlink_rcv_msg+0x12c/0x1b0 [nfnetlink]
...

The problem goes back to v2.6.30-rc1~1372~1342~31 where nf_log_bind
was decoupled from nf_log_register.

Reported-by: Miguel Di Ciurcio Filho <miguel.filho@gmail.com>,
  via irc.freenode.net/#netfilter
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/netfilter/nf_log.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/net/netfilter/nf_log.c
===================================================================
--- linux-2.6.35.y.orig/net/netfilter/nf_log.c	2011-03-29 22:50:51.752934191 -0700
+++ linux-2.6.35.y/net/netfilter/nf_log.c	2011-03-29 23:03:01.956250115 -0700
@@ -85,6 +85,8 @@
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	if (__find_logger(pf, logger->name) == NULL) {
 		mutex_unlock(&nf_log_mutex);
@@ -98,6 +100,8 @@
 
 void nf_log_unbind_pf(u_int8_t pf)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
