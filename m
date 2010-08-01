Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab0HAEqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 00:46:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40872 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab0HAEqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 00:46:13 -0400
Date: Sat, 31 Jul 2010 21:46:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/acpi: call rcu_read_unlock in default case
Message-ID: <20100801044608.GG2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.1007312234590.12199@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007312234590.12199@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 10:35:28PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Adjust the default case so that it benefits from the call to rcu_read_unlock.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @rcu@
> position p1;
> @@
> 
> rcu_read_lock@p1();
> ...
> rcu_read_unlock();
> 
> @@
> position rcu.p1;
> @@
> 
> *rcu_read_lock@p1();
> ... when != rcu_read_unlock();
> // </smpl>

I don't claim to understand the SmPL above, but I do like the patch.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/acpi/atomicio.c             |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
> index 8f8bd73..f426010 100644
> --- a/drivers/acpi/atomicio.c
> +++ b/drivers/acpi/atomicio.c
> @@ -267,6 +267,7 @@ EXPORT_SYMBOL_GPL(acpi_post_unmap_gar);
>  static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
>  {
>  	void __iomem *addr;
> +	int res = 0;
> 
>  	rcu_read_lock();
>  	addr = __acpi_ioremap_fast(paddr, width);
> @@ -284,16 +285,17 @@ static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
>  		*val = readq(addr);
>  		break;
>  	default:
> -		return -EINVAL;
> +		res = -EINVAL;
>  	}
>  	rcu_read_unlock();
> 
> -	return 0;
> +	return res;
>  }
> 
>  static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
>  {
>  	void __iomem *addr;
> +	int res = 0;
> 
>  	rcu_read_lock();
>  	addr = __acpi_ioremap_fast(paddr, width);
> @@ -311,11 +313,11 @@ static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
>  		writeq(val, addr);
>  		break;
>  	default:
> -		return -EINVAL;
> +		res = -EINVAL;
>  	}
>  	rcu_read_unlock();
> 
> -	return 0;
> +	return res;
>  }
> 
>  /* GAR accessing in atomic (including NMI) or process context */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
