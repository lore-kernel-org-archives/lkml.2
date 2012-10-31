Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504Ab2JaRfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:35:51 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:26973 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965098Ab2JaRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:35:47 -0400
Date: Wed, 31 Oct 2012 17:35:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
In-Reply-To: <509109F9.3030904@gmail.com>
Message-ID: <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com>
References: <509109F9.3030904@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> -
>  	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
>  		struct crypto_comp *tfm;
>
>  		tfms = pos->tfms;
> -		tfm = *per_cpu_ptr(tfms, cpu);
> +
> +		/* This can be any valid CPU ID so we don't need locking. */
> +		tfm = *this_cpu_ptr(tfms);

It would be better to use

	this_cpu_read(tfms)

since that would also make it atomic vs interrupts. The above code (both
original and modified) could determine a pointer to a per cpu structure
and then take an interrupt which would move the task. On return we would
be accessing the per cpu variable of another processor.

