Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab2HXQSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:18:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63843 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794Ab2HXQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:20 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, ncardwell@google.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <5037A4B0.3080208@lwfinger.net>
References: <50369925.3050705@lwfinger.net>
	 <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>
	 <20120824.111948.680531915905273128.davem@davemloft.net>
	 <5037A4B0.3080208@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Aug 2012 18:18:15 +0200
Message-ID: <1345825095.19483.19.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 10:58 -0500, Larry Finger wrote:
> On 08/24/2012 10:19 AM, David Miller wrote:
> >
> > This looks like full-on data corruption to me.
> 
> I agree. The question is why does it happen with r8712u, and only after the 
> commit in the subject. Drivers for other devices that I have are OK. Thus far, I 
> have tested b43, rtl8187, ath9k_htc, and rtl8192cu. To my knowledge, there are 
> no reports posted for this bug with any other device.

bugs can sit unnoticed, and one change somewhere can uncover them.

Really this driver must have a bug, if not half a dozen of bugs.

For example this sequence of code is a clear bug :

sub_skb = dev_alloc_skb(nSubframe_Length + 12); 
skb_reserve(sub_skb, 12);


Also the free_recv_skb_queue looks really suspect to me

What the hell is doing recv_tasklet() I really wonder.

This code, combined with the skb_clone() in recvbuf2recvframe()
can clearly reuse an skb passed to upper stacks.


queueing one skb in free_recv_skb_queue should be done
only if no clone of this skb exist somewhere.

Please someone fix this buggy driver.


