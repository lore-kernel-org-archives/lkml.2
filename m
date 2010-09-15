Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0IOPms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:42:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0IOPmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:42:46 -0400
Message-ID: <4C90E970.6020700@suse.com>
Date: Wed, 15 Sep 2010 11:42:40 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100824 SUSE/3.1.3 Thunderbird/3.1.3
MIME-Version: 1.0
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] drivers/net/tulip/de4x5.c: prevent reading uninitialized
 stack memory
References: <AANLkTiki4bNP83B2WEPcKnnDqHibxqYyi6V2CjiG9GEO@mail.gmail.com>
In-Reply-To: <AANLkTiki4bNP83B2WEPcKnnDqHibxqYyi6V2CjiG9GEO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2010 07:46 PM, Dan Rosenberg wrote:
> The DE4X5_GET_REG device ioctl allows unprivileged users to read 32
> bytes of uninitialized stack memory, because it copies the
> uninitialized "addr" member instead of the intended "lval" member.
> This patch takes care of it.
>
> Signed-off-by: Dan Rosenberg<dan.j.rosenberg@gmail.com>

No. This patch may be considered for correctness, but there's no 
security issue here.

'tmp' is a union, not a struct. Writes to lval are the same as writes to 
addr. The length is correctly determined so that only initialized memory 
is used.

-Jeff

> --- linux-2.6.35.4.orig/drivers/net/tulip/de4x5.c	2010-09-11
> 19:12:27.000000000 -0400
> +++ linux-2.6.35.4/drivers/net/tulip/de4x5.c	2010-09-11 19:17:12.000000000 -0400
> @@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
>   	tmp.lval[6] = inl(DE4X5_STRR); j+=4;
>   	tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
>   	ioc->len = j;
> -	if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
> +	if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
>   	break;
>
>   #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Jeff Mahoney
SUSE Labs
