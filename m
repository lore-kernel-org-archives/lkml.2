Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab2ECUOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:14:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53723 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755317Ab2ECUOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:14:45 -0400
Message-ID: <1336076080.13866.49.camel@joe2Laptop>
Subject: Re: [PULL] TPM: MAINTAINERS contacts update and error report fix
From: Joe Perches <joe@perches.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: jmorris@namei.org, pebolle@tiscali.nl, linux-kernel@vger.kernel.org,
        tpmdd@selhorst.net
Date: Thu, 03 May 2012 13:14:40 -0700
In-Reply-To: <20120503171054.GA6165@localhost.br.ibm.com>
References: <20120503171054.GA6165@localhost.br.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 14:10 -0300, Rajiv Andrade wrote:
> The first as the subject implies is just a contacts update, and the second
> makes the driver avoid to mistakenly report the disabled and deactivated TPM
> states as an error.

trivia:

> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
[]
> @@ -845,7 +845,16 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  		return rc;
>  
>  	do {
> -		rc = __tpm_pcr_read(chip, 0, digest);
> +		/* Attempt to read a PCR value */
> +		cmd.header.in = pcrread_header;
> +		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
> +		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
> +
> +		if (rc < TPM_HEADER_SIZE)
> +			return -EFAULT;
> +		else
> +			rc = be32_to_cpu(cmd.header.out.return_code);

The else shouldn't be used here.
Indented code followed by an unindented test is not nice.

> +
>  		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
>  			dev_info(chip->dev,
>  				 "TPM is disabled/deactivated (0x%X)\n", rc);

A more kernel style conformant style looks like:

		rc = tpm_transmit(chip, (u8 *)&cmd, READ_PCR_RESULT_SIZE);
		if (rc < TPM_HEADER_SIZE)
			return -EFAULT;

		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
			etc...


