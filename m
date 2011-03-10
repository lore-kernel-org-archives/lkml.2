Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1CKABF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:01:05 -0500
Received: from kroah.org ([198.145.64.141]:46857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1CJX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.329438570@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: [patch 13/29] netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/netfilter/nf_log.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -85,6 +85,8 @@ EXPORT_SYMBOL(nf_log_unregister);
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return -EINVAL;
 	mutex_lock(&nf_log_mutex);
 	if (__find_logger(pf, logger->name) == NULL) {
 		mutex_unlock(&nf_log_mutex);
@@ -98,6 +100,8 @@ EXPORT_SYMBOL(nf_log_bind_pf);
 
 void nf_log_unbind_pf(u_int8_t pf)
 {
+	if (pf >= ARRAY_SIZE(nf_loggers))
+		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);


