Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2JEQ7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:59:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33573 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2JEQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:59:48 -0400
Subject: RE: [PATCH] net: Fix skb_under_panic oops in neigh_resolve_output
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
Cc: "ramesh.nagappa@gmail.com" <ramesh.nagappa@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA3E5132752D1F49871ED0FC40D56BBA43ECF33592@EUSAACMS0701.eamcs.ericsson.se>
References: <1349406325-3157-1-git-send-email-ramesh.nagappa@gmail.com>
	 <1349418445.21172.11.camel@edumazet-glaptop>
	 <CA3E5132752D1F49871ED0FC40D56BBA43ECF33592@EUSAACMS0701.eamcs.ericsson.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 18:59:43 +0200
Message-ID: <1349456383.21172.134.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 12:33 -0400, Ramesh Nagappa wrote:
> Hi Eric,
> 
> Yes, that is a good optimization. neigh_resolve_output() also has the
> __skb_pull() outside the loop, is that required ? The changes would be
> like ...
> 
> neigh_resolve_output()
> ...
> -        __skb_pull(skb, skb_network_offset(skb));
> 
> 
>         if (!neigh_event_send(neigh, skb)) {
>                 int err;
>                 struct net_device *dev = neigh->dev;
>                 unsigned int seq;
> 
>                 if (dev->header_ops->cache && !neigh->hh.hh_len)
>                         neigh_hh_init(neigh, dst);
> 
>                 do {                        
> +			      __skb_pull(skb, skb_network_offset(skb));
>                         seq = read_seqbegin(&neigh->ha_lock);
>                         err = dev_hard_header(skb, dev, ntohs(skb->protocol),
>                                               neigh->ha, NULL, skb->len);
>                 } while (read_seqretry(&neigh->ha_lock, seq));

All similar constructions should be audited.

For example in net/decnet/dn_neigh.c , dn_neigh_output_packet()



