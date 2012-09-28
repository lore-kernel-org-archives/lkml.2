Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031964Ab2I1UWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:22:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37576 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031950Ab2I1UWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 020/218] ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
Date: Fri, 28 Sep 2012 13:13:57 -0700
Message-Id: <20120928201503.658743929@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 2d8a041b7bfe1097af21441cb77d6af95f4f4680 ]

If at least one of CONFIG_IP_VS_PROTO_TCP or CONFIG_IP_VS_PROTO_UDP is
not set, __ip_vs_get_timeouts() does not fully initialize the structure
that gets copied to userland and that for leaks up to 12 bytes of kernel
stack. Add an explicit memset(0) before passing the structure to
__ip_vs_get_timeouts() to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2713,6 +2713,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cm
 	{
 		struct ip_vs_timeout_user t;
 
+		memset(&t, 0, sizeof(t));
 		__ip_vs_get_timeouts(net, &t);
 		if (copy_to_user(user, &t, sizeof(t)) != 0)
 			ret = -EFAULT;


