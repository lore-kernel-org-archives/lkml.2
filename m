Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0IMUAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:00:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab0IMUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:00:45 -0400
Date: Mon, 13 Sep 2010 13:00:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ACPI: apei: Cast u64 to unsigned long, fix compile
 warning
Message-Id: <20100913130035.decb0d44.akpm@linux-foundation.org>
In-Reply-To: <1284299305.7239.4.camel@lenovo>
References: <1284299305.7239.4.camel@lenovo>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010 09:48:25 -0400
Javier Martinez Canillas <martinez.javier@gmail.com> wrote:

> In today linux-net I got a compile warning in acpi/apei
> 
> drivers/acpi/apei/erst.c: In function ___erst_exec_move_data___:
> drivers/acpi/apei/erst.c:273: warning: cast to pointer from integer of different size
> drivers/acpi/apei/erst.c:274: warning: cast to pointer from integer of different size
> 
> The problem is that apei_exec_context->dst_base type is u64.
> But in 32 bits architecture void * is 32 bits long. 
> Casting it to unsigned long solves the issue
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/acpi/apei/erst.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index a4904f1..37d7a05 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -270,8 +270,8 @@ static int erst_exec_move_data(struct apei_exec_context *ctx,
>  	rc = __apei_exec_read_register(entry, &offset);
>  	if (rc)
>  		return rc;
> -	memmove((void *)ctx->dst_base + offset,
> -		(void *)ctx->src_base + offset,
> +	memmove((void *)(unsigned long)ctx->dst_base + offset,
> +		(void *)(unsigned long)ctx->src_base + offset,
>  		ctx->var2);
>  
>  	return 0;

This might indicate that the incorrect types were used within the
`struct apei_exec_context'.  I can't tell (or can't be bothered working
it out), because whoever wrote that didn't bother documenting any of it
at all.

Are those things kernel virtual addresses?  If so, a pointer type
should have been used.
