Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0LAJjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:39:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41108 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0LAJjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AkmxbSIQzcIghTl2ImbWiFJEKbSP52U3yy1Ysl9NmzkNpoQK6TxUvDvB4hBubqVJ6j
         vlJ1W8eGDXxpyrDiUNpbUGcf113/W53K0JS9ZbYeE8OLk5MwXFU/7rVnPlKXY43J5CgT
         6Xn7g9UhHpn93wgbnEFlajSzV201lHsqLbtmM=
MIME-Version: 1.0
In-Reply-To: <c1b20adfd68fc241611845c0ef42fe8fa91ed981.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
 <c1b20adfd68fc241611845c0ef42fe8fa91ed981.1291187695.git.xiaohui.xin@intel.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 1 Dec 2010 17:38:59 +0800
Message-ID: <AANLkTikiU_diGXRx6yxBx-1k-5JFXsty1MuqZyzXVu2Z@mail.gmail.com>
Subject: Re: [PATCH v16 11/17]Add a hook to intercept external buffers from
 NIC driver.
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 4:08 PM,  <xiaohui.xin@intel.com> wrote:
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> @@ -2891,6 +2925,11 @@ static int __netif_receive_skb(struct sk_buff *skb)
>  ncls:
>  #endif
>
> +       /* To intercept mediate passthru(zero-copy) packets here */
> +       skb = handle_mpassthru(skb, &pt_prev, &ret, orig_dev);
> +       if (!skb)
> +               goto out;
> +
>        /* Handle special case of bridge or macvlan */

I think it won't work if the skbs is captured by the previous ptype.
We need to trace the skb pages(skb_shared_info.frags[*].page), but
currently, there isn't a easy way to do that. skb pages are treated as
normal pages, and anyone can get it freely. And it is the problem in
the way to fix the potential data corruption bug.

Eric thinks af_packets(mmap) isn't worth fixing. But if this patch
serial has the same problem. It will be worth.

My idea is adding a new function dtor pointer  and some other args
pointers to the struct skb_shared_info. If skb_shared_info.dtor
exists, the pages in skb_shared_info.frags are private to this
skb->head. Anyone who wants to get these pages, should copy them
instead.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
