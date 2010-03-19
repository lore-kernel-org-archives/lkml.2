Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0CSFu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 01:50:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:56238 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab0CSFu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 01:50:58 -0400
Subject: Re: [PATCH] PPC: Skip over OF_DT_NOP when unflattening the device
 tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20100309193021.GD30462@obsidianresearch.com>
References: <20100309193021.GD30462@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 16:50:38 +1100
Message-ID: <1268977838.8599.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 12:30 -0700, Jason Gunthorpe wrote:
> NOPs within the property section are skipped, but NOPs between
> OF_DT_END_NODE and OF_DT_BEGIN_NODE were not. My firmware NOPs out
> entire nodes depending on various environment parameters.
> 
> of_scan_flat_dt already handles NOP more generally..

Good catch, though that code has now moved over to drivers/of
and is a bit different. Grant is going to fix it up though.

Cheers,
Ben.

> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  arch/powerpc/kernel/prom.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 4ec3008..92137b2 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -408,8 +408,11 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
>  		if (!np->type)
>  			np->type = "<NULL>";
>  	}
> -	while (tag == OF_DT_BEGIN_NODE) {
> -		mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
> +	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
> +		if (tag == OF_DT_NOP)
> +			*p += 4;
> +		else
> +			mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
>  		tag = *((u32 *)(*p));
>  	}
>  	if (tag != OF_DT_END_NODE) {


