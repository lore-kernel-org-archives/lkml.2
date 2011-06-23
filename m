Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab1FWSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:01:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:35005 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab1FWRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Engelhardt <jengelh@medozas.de>,
        Patrick McHardy <kaber@trash.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 162/247] netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values
Date: Thu, 23 Jun 2011 13:33:50 -0400
Message-Id: <1308850515-15242-103-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netfilter/nf_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 015725a..eda826b 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL(nf_log_unregister);
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	if (__find_logger(pf, logger->name) == NULL) {
 		mutex_unlock(&nf_log_mutex);
@@ -96,6 +98,8 @@ EXPORT_SYMBOL(nf_log_bind_pf);
 
 void nf_log_unbind_pf(u_int8_t pf)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
-- 
1.7.4.4

