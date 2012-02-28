Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403Ab2B1BMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:12:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365Ab2B1BMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.132.40 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010434.778180682@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 61/72] ipvs: fix matching of fwmark templates during scheduling
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@verge.net.au>

commit e0aac52e17a3db68fe2ceae281780a70fc69957f upstream.

	Commit f11017ec2d1859c661f4e2b12c4a8d250e1f47cf (2.6.37)
moved the fwmark variable in subcontext that is invalidated before
reaching the ip_vs_ct_in_get call. As vaddr is provided as pointer
in the param structure make sure the fwmark variable is in
same context. As the fwmark templates can not be matched,
more and more template connections are created and the
controlled connections can not go to single real server.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -232,6 +232,7 @@ ip_vs_sched_persist(struct ip_vs_service
 	__be16 dport = 0;		/* destination port to forward */
 	unsigned int flags;
 	struct ip_vs_conn_param param;
+	const union nf_inet_addr fwmark = { .ip = htonl(svc->fwmark) };
 	union nf_inet_addr snet;	/* source network of the client,
 					   after masking */
 
@@ -267,7 +268,6 @@ ip_vs_sched_persist(struct ip_vs_service
 	{
 		int protocol = iph.protocol;
 		const union nf_inet_addr *vaddr = &iph.daddr;
-		const union nf_inet_addr fwmark = { .ip = htonl(svc->fwmark) };
 		__be16 vport = 0;
 
 		if (dst_port == svc->port) {


