Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2EKKjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:39:41 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42825 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2EKKji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:39:38 -0400
Date: Fri, 11 May 2012 12:39:35 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm: take iphdr size into account for esp payload
 size calculation
Message-ID: <20120511103935.GA1841@secunet.com>
References: <1336602952-10479-1-git-send-email-bpoirier@suse.de>
 <20120510121857.GJ1021@secunet.com>
 <20120511010249.GA23584@d2.synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511010249.GA23584@d2.synalogic.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 May 2012 10:39:35.0538 (UTC) FILETIME=[5BB32520:01CD2F62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 09:02:49PM -0400, Benjamin Poirier wrote:
> 
> The value returned by this function is tuned for tcp segment size:
> 1) from tcp_mtu_to_mss()
> mss = pmtu - tcp_hlen - net_hlen
> 2) frame structure for transport mode
> mtu = mss + tcp_hlen + esp_header_len(esp_payload_len) + ah_len + net_hlen

I think you can simplify the calculations here, this
calculation should not depend on any special layer 4
protocol.

> 
> The "mtu" parameter of esp4_get_mtu is in fact mtu - ah_len.
> The return value of esp4_get_mtu is put into pmtu.
> 
> If we put 1 and 2 together we have:
> pmtu = mtu - ah_len - esp_header_len(esp_payload_len)
> with esp_payload_len = mss + tcp_hlen
> 
> This formula expands to:
> pmtu = mtu - ah_len - (header_len + align(align(pmtu - net_hlen + 2, blksize),
> 	esp->padlen) - (pmtu - net_hlen) + alen)
> 
> and simplifies to:
> pmtu = (mtu - ah_len - net_hlen - header_len - alen) & ~(max(blksize,
> 	esp->padlen) - 1) + (net_hlen - 2)
> 
> which, in the context of esp4_get_mtu, becomes:
> ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) - sizeof(struct
> iphdr)) & ~(align - 1)) + (sizeof(struct iphdr) - 2)
> 
> This is the same formula as before, except for sizeof(struct iphdr) which was
> missing.
> 

Well, makes sense. I use transport mode very rarely, so I never noticed this.
But I was sure that it worked correct in tunnel mode. 

Thanks.

