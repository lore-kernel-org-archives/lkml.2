Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2DXOxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:53:00 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:48036 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2DXOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:52:59 -0400
Date: Tue, 24 Apr 2012 11:47:08 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] TPM: be silent if disabled or deactivated
Message-ID: <20120424144708.GA29206@localhost.br.ibm.com>
References: <1334223857.2439.5.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334223857.2439.5.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042414-2362-0000-0000-000006F638FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Paul Bolle wrote:

> Since v3.3 the TPM security chip on a laptop I use prints two messages
> at every boot and every resume:
>     tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
>     tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
> 
> The second message is just an informational message, indicating that
> this chip is deactivated (0x6 is TPM_ERR_DEACTIVATED). That doesn't
> bother me. The first message is printed at KERN_ERR level. To me it
> seems that it is not an error if a security chip is deactivated or
> disabled. So suppress that error message in those two cases.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested against v3.3. (This laptop is currently tracking the Fedora 16
> kernel, which is now v3.3 based.) Applies cleanly to v3.4-rc2.
> 
> 1) Sent as an RFC because I don't actually use any TPM functionality.
> (At least, that's what I think. I'm entirely unfamiliar with TPM.)
> Moreover, there are a number of code paths that hit this messages, and
> for some of those this patch might hide this error where people still
> would like to see it. But my usage probably doesn't trigger those code
> paths.
>

Thanks for pointing this out Paul. We indeed don't want this being
thrown out as an error if the TPM is in this state. Although your patch
fits well and solves this neatly, transmit_cmd(), as you mentioned, is
called by essentially all functions attempting to send a command to the
TPM. Therefore, we do want to trigger this as an error in case a faulty
hardware claims to be functional after the tpm_do_selftest(), but decides
to return this error code when already registered. I'll modify
tpm_do_selftest() to handle these two scenarios. 

Rajiv

>  drivers/char/tpm/tpm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 32362cf..40a09b5 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -473,7 +473,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
>  		return -EFAULT;
> 
>  	err = be32_to_cpu(cmd->header.out.return_code);
> -	if (err != 0)
> +	if (err != 0 && err != TPM_ERR_DISABLED && err != TPM_ERR_DEACTIVATED)
>  		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
> 
>  	return err;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 





