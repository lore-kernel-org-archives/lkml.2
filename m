Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab2B1BSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:18:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab2B1BMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.225.231 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.857755344@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Wei <lw@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/72] ipv4: Fix wrong order of ip_rt_get_source() and update iph->daddr.
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit 5dc7883f2a7c25f8df40d7479687153558cd531b ]

This patch fix a bug which introduced by commit ac8a4810 (ipv4: Save
nexthop address of LSRR/SSRR option to IPCB.).In that patch, we saved
the nexthop of SRR in ip_option->nexthop and update iph->daddr until
we get to ip_forward_options(), but we need to update it before
ip_rt_get_source(), otherwise we may get a wrong src.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_options.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -573,8 +573,8 @@ void ip_forward_options(struct sk_buff *
 		}
 		if (srrptr + 3 <= srrspace) {
 			opt->is_changed = 1;
-			ip_rt_get_source(&optptr[srrptr-1], skb, rt);
 			ip_hdr(skb)->daddr = opt->nexthop;
+			ip_rt_get_source(&optptr[srrptr-1], skb, rt);
 			optptr[2] = srrptr+4;
 		} else if (net_ratelimit())
 			printk(KERN_CRIT "ip_forward(): Argh! Destination lost!\n");


