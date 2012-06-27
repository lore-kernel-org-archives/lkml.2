Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2F0MPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2F0MPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:15:16 -0400
Message-ID: <4FEAF94F.2060109@redhat.com>
Date: Wed, 27 Jun 2012 09:15:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v3 -resend] edac i5000, i5400: fix pointer math in i5000_get_mc_regs()
References: <20120627090758.GQ31212@elgon.mountain>
In-Reply-To: <20120627090758.GQ31212@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2012 06:07, Dan Carpenter escreveu:
> "pvt->ambase" is a u64 datatype.  The intent here is to fill the first
> half in the first call to pci_read_config_dword() and the other half in
> the second.  Unfortunately the pointer math is wrong so we set the wrong
> data.

Applied, thanks!
Mauro

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Redid it as with a union as Walter Harms suggested.
>      Fixed the same bug in i5400_edac.c as well.
> v3: Make the struct __packed just in case.
> 
> I don't have this hardware, so please review carefully.  But the
> original code obviously corrupts memory so my patch could hardly be
> worse...
> 
> This was originally sent on Mon, Mar 5, 2012.  Btw, there are some
> Sparse errors in these files.  The code looks buggy but I don't know
> what the intent was.
> 
> drivers/edac/i5000_edac.c:485:15: warning: right shift by bigger than source value
> drivers/edac/i5000_edac.c:580:23: warning: right shift by bigger than source value
> drivers/edac/i5400_edac.c:391:36: warning: right shift by bigger than source value
> drivers/edac/i5400_edac.c:401:37: warning: right shift by bigger than source value
> 
> diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
> index a5c33df..39c6375 100644
> --- a/drivers/edac/i5000_edac.c
> +++ b/drivers/edac/i5000_edac.c
> @@ -328,7 +328,13 @@ struct i5000_pvt {
>   	struct pci_dev *branch_1;	/* 22.0 */
>   
>   	u16 tolm;		/* top of low memory */
> -	u64 ambase;		/* AMB BAR */
> +	union {
> +		u64 ambase;		/* AMB BAR */
> +		struct {
> +			u32 ambase_bottom;
> +			u32 ambase_top;
> +		} u __packed;
> +	};
>   
>   	u16 mir0, mir1, mir2;
>   
> @@ -1131,9 +1137,9 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
>   	pvt = mci->pvt_info;
>   
>   	pci_read_config_dword(pvt->system_address, AMBASE,
> -			(u32 *) & pvt->ambase);
> +			&pvt->u.ambase_bottom);
>   	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
> -			((u32 *) & pvt->ambase) + sizeof(u32));
> +			&pvt->u.ambase_top);
>   
>   	maxdimmperch = pvt->maxdimmperch;
>   	maxch = pvt->maxch;
> diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
> index 50069c6..2772469 100644
> --- a/drivers/edac/i5400_edac.c
> +++ b/drivers/edac/i5400_edac.c
> @@ -327,7 +327,13 @@ struct i5400_pvt {
>   	struct pci_dev *branch_1;		/* 22.0 */
>   
>   	u16 tolm;				/* top of low memory */
> -	u64 ambase;				/* AMB BAR */
> +	union {
> +		u64 ambase;				/* AMB BAR */
> +		struct {
> +			u32 ambase_bottom;
> +			u32 ambase_top;
> +		} u __packed;
> +	};
>   
>   	u16 mir0, mir1;
>   
> @@ -1055,9 +1061,9 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
>   	pvt = mci->pvt_info;
>   
>   	pci_read_config_dword(pvt->system_address, AMBASE,
> -			(u32 *) &pvt->ambase);
> +			&pvt->u.ambase_bottom);
>   	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
> -			((u32 *) &pvt->ambase) + sizeof(u32));
> +			&pvt->u.ambase_top);
>   
>   	maxdimmperch = pvt->maxdimmperch;
>   	maxch = pvt->maxch;
> 


