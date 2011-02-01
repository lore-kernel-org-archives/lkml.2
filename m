Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1BAD4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:56:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62828 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BAD4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DIKmhoKWdj22Da2JawsaHreqA+/h/08umbKfa5hfj7WJ0e0lCmyAzlejXdHba8kDeF
         RGOumMzn7IV3kVFi/rV0VJM1cBMPoVosy1PiMrWJqwjJJ2uiRMNZPpNvjyTpZrZEIFQ6
         uyKRzlHS6Rr7pDTmbQUPT0Ztg+YfGe1Tg/q8g=
MIME-Version: 1.0
In-Reply-To: <AANLkTimz7gx7BAQG8RBswDCxnTuVtt3u+YoBZk8+RgEz@mail.gmail.com>
References: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
 <1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com>
 <AANLkTikpu05V92T+YvuHW+jcTH-Bu2t6=HoQn5OR3ZhX@mail.gmail.com>
 <AANLkTinsWVHj6qdSS-_ztztcNPHAkwZQnimPbjzvcHb2@mail.gmail.com>
 <AANLkTimWuBfeYPOsOFpTiAGS5uHysevAHiOg0svBQ4zW@mail.gmail.com> <AANLkTimz7gx7BAQG8RBswDCxnTuVtt3u+YoBZk8+RgEz@mail.gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 1 Feb 2011 11:56:16 +0800
Message-ID: <AANLkTikgDsM15DO7u2SP15xx=Y_pg6JdCLrie8ACobJP@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michał

2011/1/25 Po-Yu Chuang <ratbert.chuang@gmail.com>:
> 2011/1/25 Michał Mirosław <mirqus@gmail.com>:
>>
>> Ah, I blindly assumed that you're just appending the buffers to the
>> skb (using skb_fill_page_desc() and friends). Since you have to mark
>> descriptors for the device anyway, it might be faster to allocate new
>> skbs and map those as rx buffers (changing the descriptor's buffer
>> address after every RX) instead of keeping static buffer and copying
>> every time. (For small packets it wastes lot of memory, though - so
>> the right choice depends on the expected workload.)
>
> The reason I chose to use memcpy rx buffer to skb is that I didn't know
> how to deal with multi-segment packets if I preallocated skb for each
> rx descriptor. This function seems to be what I need.
> Let me rework this. Thanks.

After looking at some drivers using skb_fill_page_desc(), I am still
confused.

It seems that this function is mainly for jumbo packet and the
beginning of data of received packet should still be in skb->data.

Scheme 1)
If I simply allocate a page for each rx ring entry, I still need to allocate
an skb and copy at least packet header in first page to skb->data. Then
add the page of rest of payload to skb by skb_fill_page_desc().

Scheme 2)
If I simply allocate an skb for each rx ring entry, zero copy can be easily
achieved if the packet contains only one segment (one rx ring entry).
However, if the received packet has more than one segment, I guess I
might need to allocate a bigger skb and copy data of all segments
(skb->data) to the new skb?


The problem is, in most cases, the received packets are one-segment only.
(TBH, I don't know when will multi-segment packets appear.)

If all packets are one-segment, I can just allocate an skb for each rx ring
enry and achieve zero-copy. However, since there might be multi-segment
packets, I need to deal with them.

How can I do?

best regards,
Po-Yu Chuang
