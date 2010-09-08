Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0IHHfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:35:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31970 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab0IHHfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:35:20 -0400
Date: Wed, 8 Sep 2010 09:34:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia@diku.dk>
Cc: "Ben Dooks (em, bedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers/i2c/busses/i2c-amd8111.c: Fix unsigned
 return  type
Message-ID: <20100908093449.0adef429@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.1009080757050.27892@ask.diku.dk>
References: <Pine.LNX.4.64.1009080757050.27892@ask.diku.dk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Wed, 8 Sep 2010 07:58:45 +0200 (CEST), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, the function has an unsigned return type, but returns a
> negative constant to indicate an error condition.  The result of calling
> the function is always stored in a variable of type (signed) int, and thus
> unsigned can be dropped from the return type.
> 
> A sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @exists@
> identifier f;
> constant C;
> @@
> 
>  unsigned f(...)
>  { <+...
> *  return -C;
>  ...+> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/i2c/busses/i2c-amd8111.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
> index af1e5e2..02a3726 100644
> --- a/drivers/i2c/busses/i2c-amd8111.c
> +++ b/drivers/i2c/busses/i2c-amd8111.c
> @@ -69,7 +69,7 @@ static struct pci_driver amd8111_driver;
>   * ACPI 2.0 chapter 13 access of registers of the EC
>   */
>  
> -static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
> +static int amd_ec_wait_write(struct amd_smbus *smbus)
>  {
>  	int timeout = 500;
>  
> @@ -85,7 +85,7 @@ static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
>  	return 0;
>  }
>  
> -static unsigned int amd_ec_wait_read(struct amd_smbus *smbus)
> +static int amd_ec_wait_read(struct amd_smbus *smbus)
>  {
>  	int timeout = 500;
>  
> 

Thanks for reporting. Unfortunately the fix above is incomplete.
amd_ec_wait_write() and amd_ec_wait_read() are called by amd_ec_read()
and amd_ec_write(), which will now attempt to return negative error
codes as unsigned ints. So amd_ec_read() and amd_ec_write() must have
their return type fixed too.

Note that the driver code never checks for errors returned by
amd_ec_read() or amd_ec_write() anyway, so the fix alone is a no-op. A
real fix would have to also update the caller sites to properly deal
with errors if then happen.

-- 
Jean Delvare
