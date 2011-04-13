Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1DMS0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:26:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab1DMS0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T+IhtOISUal7R3MF35Nh9mSdh/ftJGCEOQKue+1ZXPiZzNQRAgkBfviFAGhLWY5/Sk
         YMZ/OYelmTIt8E+MTR2g==
MIME-Version: 1.0
In-Reply-To: <20110413.105446.183041592.davem@davemloft.net>
References: <BANLkTin5kWej_pThqBvL7dypVB_JGYU7=A@mail.gmail.com>
	<20110413.105446.183041592.davem@davemloft.net>
Date: Wed, 13 Apr 2011 11:26:02 -0700
Message-ID: <BANLkTimkwCNUGPW8mdJb2424u20OKE=4iA@mail.gmail.com>
Subject: Re: System crash, bisect points to "connector: convert to synchronous
 netlink message processing"
From: Venkatesh Pallipadi <venki@google.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, zbr@ioremap.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:54 AM, David Miller <davem@davemloft.net> wrote:
> From: Venkatesh Pallipadi <venki@google.com>
> Date: Wed, 13 Apr 2011 10:25:39 -0700
>
>> I started seeing crashes with linus git recently. The failure
>> signature is something like:
>
> There is a fix in net-2.6 for this already:
>

Yes. That works..

Thanks,
Venki

> --------------------
> commit 0e08785845093ef4ed220463a739bc8d0db95de7
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Tue Apr 12 05:39:51 2011 +0000
>
>    connector: fix skb double free in cn_rx_skb()
>
>    When a skb is delivered to a registered callback, cn_call_callback()
>    incorrectly returns -ENODEV after freeing the skb, causing cn_rx_skb()
>    to free the skb a second time.
>
>    Reported-by: Eric B Munson <emunson@mgebm.net>
>    Signed-off-by: Patrick McHardy <kaber@trash.net>
>    Tested-by: Eric B Munson <emunson@mgebm.net>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
> index d770058..219d88a 100644
> --- a/drivers/connector/connector.c
> +++ b/drivers/connector/connector.c
> @@ -142,6 +142,7 @@ static int cn_call_callback(struct sk_buff *skb)
>                cbq->callback(msg, nsp);
>                kfree_skb(skb);
>                cn_queue_release_callback(cbq);
> +               err = 0;
>        }
>
>        return err;
>
