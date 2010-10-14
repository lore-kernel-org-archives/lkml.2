Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0JNA1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:27:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62743 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0JNA1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jCz2DLNuPKRlUPOXjc8D8gecweJPyMKNy7US4a4jbin985p+SVXsEJsyhfOgJC7iHi
         ND/GfPmA3ZZY9mEJM0N1TorCwlp5xks2mxvDP3pgSWZcyOsQDndPLxE38Ew/hJDzGsZI
         80HzYXiI8BjdqdhiSuMTnqVWkmO3XMUjh/Vdc=
MIME-Version: 1.0
In-Reply-To: <20101011205208.GA8527@redhat.com>
References: <20101011205208.GA8527@redhat.com>
Date: Wed, 13 Oct 2010 17:27:47 -0700
X-Google-Sender-Auth: gfZXwQljLIHqYDyBSAVn7MIZNoE
Message-ID: <AANLkTikyCBrXsvV_ZqYt7tHPRK4WGNLt8654Mhec70rB@mail.gmail.com>
Subject: Re: [PATCH RFC] tun: dma engine support
From: Dan Williams <dan.j.williams@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Anatolij Gustschin <agust@denx.de>, Magnus Damm <damm@opensource.se>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Maciej ]

On Mon, Oct 11, 2010 at 1:52 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> Simple hack to use dma engine for tun RX.
> Only one skb in flight at the moment.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> I am still looking at handling multiple skbs, but
> sending this out for early flames and improvement suggestions.
>
> Loopback testing seems to show only minor performance gains:
> this is not really suprising as data is hot in cache already.
> Where I would expect this to help more is with incoming
> traffic from an external NIC. This still needs to be tested.

Actually it is interesting that you did not see a performance loss
because the dma performs the transfer in memory so the destination
will be cache cold in the dma case compared to a cpu copy.

[..]
> +int tun_dma_copybreak = 0x10000;
> +module_param_named(dma_copybreak, tun_dma_copybreak, int, 0644);

What platform are you using for testing?  If this proves beneficial we
may need to adjust this value to have a platform specific default,
similar to how ioatdma sets tcp_dma_copybreak depending on the
hardware version.  You will notice that on Nehalem class hardware
(drivers/dma/ioat/dma_v3.c) the default is set to 256K effectively
disabling offload as the overhead of managing the dma engine
overshadows any offload advantage.

--
Dan
