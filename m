Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2FSTT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:19:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52357 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753658Ab2FSTT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:19:57 -0400
Message-ID: <1340133595.27131.6.camel@joe2Laptop>
Subject: Re: [PATCH V2 3/3] staging/rtl8192u: use for loop to assign bit
 shifted addr
From: Joe Perches <joe@perches.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Jun 2012 12:19:55 -0700
In-Reply-To: <1340132894-19003-1-git-send-email-devendra.aaru@gmail.com>
References: <1340132894-19003-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 00:38 +0530, Devendra Naga wrote:
> this change is a rewrite of that bitshifted addr copying
> logic with for loop, which can easily understandable.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8180_93cx6.c |   27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
> index a72bbd4..815b0f3 100644
> --- a/drivers/staging/rtl8192u/r8180_93cx6.c
> +++ b/drivers/staging/rtl8192u/r8180_93cx6.c
> @@ -102,25 +102,16 @@ u32 eprom_read(struct net_device *dev, u32 addr)
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  
> -	if (priv->epromtype==EPROM_93c56){
> -		addr_str[7]=addr & 1;
> -		addr_str[6]=addr & (1<<1);
> -		addr_str[5]=addr & (1<<2);
> -		addr_str[4]=addr & (1<<3);
> -		addr_str[3]=addr & (1<<4);
> -		addr_str[2]=addr & (1<<5);
> -		addr_str[1]=addr & (1<<6);
> -		addr_str[0]=addr & (1<<7);
> -		addr_len=8;
> -	}else{
> -		addr_str[5]=addr & 1;
> -		addr_str[4]=addr & (1<<1);
> -		addr_str[3]=addr & (1<<2);
> -		addr_str[2]=addr & (1<<3);
> -		addr_str[1]=addr & (1<<4);
> -		addr_str[0]=addr & (1<<5);
> -		addr_len=6;
> +	if (priv->epromtype == EPROM_93c56) {
> +		addr_len = 8;
> +		for (i = 0; i < addr_len; i++)
> +			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
> +	} else {
> +		addr_len = 6;
> +		for (i = 0; i < addr_len; i++)
> +			addr_str[i] = addr & (1 << (addr_len - (i + 1)));
>  	}

It's also got a bit of code duplication.
Maybe something like:

	if (priv->epromtype == EPROM_93c56) {
		addr_len = 8;
	else
		addr_len = 6;

	test_bit = 1 << (addr_len - 1);
	for (i = 0; i < addr_len; i++) {
		addr_str[i] = addr & test_bit;
		test_bit >>= 1;
	}


