Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1CPJ6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:58:02 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:60045 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1CPJ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:57:57 -0400
Date: Wed, 16 Mar 2011 10:57:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: chenliu@asset.uwaterloo.ca
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, cotte@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]early: Fix possible overlapping data buffer
Message-ID: <20110316095752.GA2825@osiris.boeblingen.de.ibm.com>
References: <20110314152532.GA27277@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314152532.GA27277@asset.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:25:32AM -0400, chenliu@asset.uwaterloo.ca wrote:
> Thanks Heiko. This patch hasn't been tested yet. I've modifed
> the Signed=off-by to make it identical to From. Here is the
> patch:

Yes, obviously untested (see below).

> Signed-off-by: Chen Liu <chenliu@asset.uwaterloo.ca>
> ---
>  arch/s390/kernel/early.c |   16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> --- a/arch/s390/kernel/early.c
> +++ b/arch/s390/kernel/early.c
> @@ -94,6 +94,7 @@ static noinline __init void create_kerne
>  	unsigned int sinitrd_pfn, einitrd_pfn;
>  #endif
>  	int response;
> +	int hlen;
>  	size_t len;
>  	char *savesys_ptr;
>  	char defsys_cmd[DEFSYS_CMD_SIZE];
> @@ -124,22 +125,27 @@ static noinline __init void create_kerne
>  	end_pfn = PFN_UP(__pa(&_end));
>  	min_size = end_pfn << 2;
> 
> -	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
> +	snprintf(defsys_cmd, sizeof(defsys_cmd),
> +		"DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
>  		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
>  		eshared_pfn, end_pfn);
> +	defsys_cmd[DEFSYS_CMD_SIZE - 1] = '\0';
> 
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	if (INITRD_START && INITRD_SIZE) {
>  		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
>  		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
>  		min_size = einitrd_pfn << 2;
> -		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
> -		sinitrd_pfn, einitrd_pfn);
> +		hlen += snprintf(defsys_cmd, DEFSYS_CMD_SIZE - hlen,

hlen is unitialized here, since you forgot to save the size in the
snprintf statement above.

> +			" EW %.5X-%.5X", defsys_cmd,

defsys_cmd is still in the input parameter list. The whole point was to
remove it. ;)

Anyway, I fixed it and applied your patch. Thanks!
