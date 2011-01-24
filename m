Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1AXT4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:56:08 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:6273 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214Ab1AXT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:56:06 -0500
Message-ID: <4D3DD964.9020107@bluewatersys.com>
Date: Tue, 25 Jan 2011 08:56:20 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Russell King <linux@arm.linux.org.uk>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
References: <1295898922-18822-1-git-send-email-julia@diku.dk> <1295898922-18822-3-git-send-email-julia@diku.dk>
In-Reply-To: <1295898922-18822-3-git-send-email-julia@diku.dk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 08:55 AM, Julia Lawall wrote:
> Function clk_get, defined just below this code, returns ERR_PTR not NULL in
> an error case.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier f;
> @@
> f(...) { ... return ERR_PTR(...); }
> 
> @@
> identifier r.f, fld;
> expression x;
> statement S1,S2;
> @@
>  x = f(...)
>  ... when != IS_ERR(x)
> (
>  if (IS_ERR(x) ||...) S1 else S2
> |
> *x->fld
> )
> // </smpl>

I'm always really impressed by this tool :-).

> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/arm/mach-at91/clock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 9113da6..c9ee6d0 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -224,7 +224,7 @@ void __init at91_clock_associate(const char *id, struct device *dev, const char
>  {
>  	struct clk *clk = clk_get(NULL, id);
>  
> -	if (!dev || !clk || !IS_ERR(clk_get(dev, func)))
> +	if (!dev || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
>  		return;

I think we want:

	if (!dev || !clk || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
		return;

Since it is valid to return a NULL clk, and we don't want to try and
dereference it if that is the case.

We could also probably drop the !IS_ERR(clk_get(dev, func)) check, since
as far as I can tell it is just checking to see if the clock is already
associated, but there is no harm in re-assigning the same values, and
the two assignments in at91_clock_associate are going to be much quicker
than the lookup in clk_get.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
