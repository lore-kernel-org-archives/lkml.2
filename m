Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0EKFXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:23:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39221 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab0EKFXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QrtEWX/PUANhjEDsLjicqI57GG7ZCYljxQUHQp7N6OhoHczfzwMctB5ahsHf0DTkUP
         QtubvnVSspEzJRqElFsR3vbvhiI+yY+dxyJlbfuNvHXNpRHUR0WOls3ybo5EK696G8Rt
         Cav63GgDenxtmfhpMlMF7E03PIZvSNaJBzBKk=
Subject: Re: Question about more headroom in skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sharat Masetty <sharat_masetty@yahoo.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <682359.68270.qm@web112510.mail.gq1.yahoo.com>
References: <682359.68270.qm@web112510.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:06:27 +0200
Message-ID: <1273554387.10889.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 10 mai 2010 à 13:09 -0700, Sharat Masetty a écrit :
> Hello All,

Please dont use too long lines

> 
> For my project I need 3 words of headroom in the skb in the network

>  driver level, to add a  custom header to the ethernet packet. I 

> looked into the tcp code and figured out tcp uses sk->sk_prot->max_header 

> for header allocation size. But I was not able to confirm that all other 

> transport protocol use the same mechanism(?) For example in UDP/ICMP I was 

> not able to figure out from the code where the allocation and header

>  reservation happens(Any light here would be really helpful.)
> 
> I have also looked at an API in skbuff skb_pad() which does what I want

> (add either headroom or tailroom), but I want to avoid that for performance

>  reasons(skb_pad does kmalloc and memcpy). I want to figure out a good way

> (may be tune some parameters) to allocate extra 3 words for any skbuff 

> independant of the transport protocol being used. 

> Any light here would be very much appreciated.

LL_RESERVED_SPACE() is the magic you need.

#define LL_RESERVED_SPACE(dev) \
	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)

sendmsg() -> ip_append_data()
...
hh_len = LL_RESERVED_SPACE(rt->u.dst.dev);
fragheaderlen = sizeof(struct iphdr) + (opt ? opt->optlen : 0);
...

                if (transhdrlen) {
                        skb = sock_alloc_send_skb(sk,
                                        alloclen + hh_len + 15,
                                        (flags & MSG_DONTWAIT), &err);
                } else {
                        skb = NULL;
                        if (atomic_read(&sk->sk_wmem_alloc) <=
                            2 * sk->sk_sndbuf)
                                skb = sock_wmalloc(sk,
                                                   alloclen + hh_len + 15, 1,
                                                   sk->sk_allocation);


