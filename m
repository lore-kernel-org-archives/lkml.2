Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1BXH2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:28:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56427 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1BXH2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rCKEgBF258plaM5qZQkB1wW5qzKK5QY+EdzCWd7tIkTJpQUU2tOBmU9oL/WWILAZdU
         VlmuUvgf3IVkl37OImA0yDEj8NbEU7miAYc0Ls5aAFfaU2iukIJgXdC4C6jgQ2eynzP6
         LLT679qHu+yulB2ek3+i866FOzwSdyPSQ2u3w=
MIME-Version: 1.0
In-Reply-To: <20110131.203556.193730771.davem@davemloft.net>
References: <AANLkTimWuBfeYPOsOFpTiAGS5uHysevAHiOg0svBQ4zW@mail.gmail.com>
 <AANLkTimz7gx7BAQG8RBswDCxnTuVtt3u+YoBZk8+RgEz@mail.gmail.com>
 <AANLkTikgDsM15DO7u2SP15xx=Y_pg6JdCLrie8ACobJP@mail.gmail.com> <20110131.203556.193730771.davem@davemloft.net>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 24 Feb 2011 15:27:55 +0800
Message-ID: <AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
To: David Miller <davem@davemloft.net>
Cc: mirqus@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, ratbert@faraday-tech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Feb 1, 2011 at 12:35 PM, David Miller <davem@davemloft.net> wrote:
> From: Po-Yu Chuang <ratbert.chuang@gmail.com>
> Date: Tue, 1 Feb 2011 11:56:16 +0800
>
>> If I simply allocate a page for each rx ring entry, I still need to allocate
>> an skb and copy at least packet header in first page to skb->data. Then
>> add the page of rest of payload to skb by skb_fill_page_desc().
>
> You should attach the pages, the use __pskb_pull_tail() to bring in the
> headers to the linear skb->data area.
>
> See drivers/net/niu.c:niu_process_rx_pkt().

I tried two ways to implement zero-copy.
One is to preallocate skb big enough for any rx packet and use the skb
as rx buffer.
The other is use page as rx buffer, use skb_fill_page_desc() to add a
data page to
skb and then pull only header to skb by __pskb_pull_tail() as you suggested.

Two implementations are slower than the original memcpy version.
(benchmarked with iperf)

I guess the problem is because a HW restriction that the rx buffer must be
64 bits aligned. Since I cannot make rx buffer starts at offset 2 bytes, the
IP header, TCP header and data are not 4 bytes aligned. The performance
drops drastically.

Therefore, I will submit later a v6 which is still using memcpy().

best regards,
Po-Yu Chuang
