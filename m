Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2LQT6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:58:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52333 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753343Ab2LQT5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:57:01 -0500
Message-ID: <1355774221.13361.48.camel@joe-AO722>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
From: Joe Perches <joe@perches.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 11:57:01 -0800
In-Reply-To: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 13:39 -0600, Jacob Shin wrote:
> Currently only AMD Family 15h processors have special handling for MC2
> errors, since upcoming Family 16h will also need unique handling,
> let's make MC2 handling part of amd_decoder_ops.

[]

> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
[]
> @@ -399,12 +399,9 @@ static void decode_mc1_mce(struct mce *m)
>  		pr_emerg(HW_ERR "Corrupted MC1 MCE info?\n");
>  }
>  
> -static void decode_mc2_mce(struct mce *m)
> +static bool k8_mc2_mce(u16 ec, u8 xec)
>  {
> -	u16 ec = EC(m->status);
> -	u8 xec = XEC(m->status, xec_mask);
> -
> -	pr_emerg(HW_ERR "MC2 Error");
> +	bool ret = true;
>  
>  	if (xec == 0x1)
>  		pr_cont(" in the write data buffers.\n");

It'd be better to change the pr_cont uses to pr_emerg

[]

> +static void decode_mc2_mce(struct mce *m)
> +{
> +	u16 ec = EC(m->status);
> +	u8 xec = XEC(m->status, xec_mask);
> +
> +	pr_emerg(HW_ERR "MC2 Error: ");

Remove this and

> +	if (fam_ops->mc2_mce(ec, xec))
> +		;
> +	else
> +		pr_emerg(HW_ERR "Corrupted MC2 MCE info?\n");
>  }

And make this

	if (!fam_ops->mc2_mce(ec, xec))
		pr_emerg(etc...);


