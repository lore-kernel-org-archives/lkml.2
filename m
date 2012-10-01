Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2JAPQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:16:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48724 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab2JAPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:16:04 -0400
Date: Mon, 1 Oct 2012 10:14:07 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Issue TPM_STARTUP at driver load if the TPM has not
 been started
Message-ID: <20121001151406.GA3478@ennui.austin.ibm.com>
References: <20120930233012.GH30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930233012.GH30637@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100115-3534-0000-0000-00000D4E3A15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Sun, Sep 30, 2012 at 05:30:12PM -0600, Jason Gunthorpe wrote:
> The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> TPM_STARTUP has not been issued. This will result in the TPM driver
> failing to load and no way to recover. Detect this and automatically
> issue TPM_STARTUP.
> 
> This is for embedded applications where the kernel is the first thing
> to touch the TPM.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  drivers/char/tpm/tpm.h |    6 ++++++
>  2 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 817f0ee..60e8442 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -473,7 +473,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
>  		return -EFAULT;
> 
>  	err = be32_to_cpu(cmd->header.out.return_code);
> -	if (err != 0)
> +	if (err != 0 && desc)
>  		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
> 
>  	return err;
> @@ -489,6 +489,15 @@ static const struct tpm_input_header tpm_getcap_header = {
>  	.ordinal = TPM_ORD_GET_CAP
>  };
> 
> +
> +#define TPM_ORD_STARTUP cpu_to_be32(153)
> +#define TPM_ST_CLEAR cpu_to_be32(1)
> +static const struct tpm_input_header tpm_startup_header = {
> +	.tag = TPM_TAG_RQU_COMMAND,
> +	.length = cpu_to_be32(12),
> +	.ordinal = TPM_ORD_STARTUP
> +};
> +
>  ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
>  		   const char *desc)
>  {
> @@ -545,11 +554,33 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>  	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
> +
> +	if (rc == TPM_ERR_INVALID_POSTINIT) {
> +		struct tpm_cmd_t start_cmd;
> +		/* The TPM is not started, we are the first to talk to it.
> +		   Execute a startup command. */
> +		start_cmd.header.in = tpm_startup_header;
> +		start_cmd.params.startup_in.startup_type = TPM_ST_CLEAR;

 Please make this its own function instead of putting it inside
tpm_get_timeouts.

Kent

> +
> +		dev_info(chip->dev, "Issuing TPM_STARTUP");
> +		rc = transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
> +			"attempting to start the TPM");
> +		if (rc)
> +			return -EINVAL;
> 
> -	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> -			"attempting to determine the timeouts");
> -	if (rc)
> +		tpm_cmd.header.in = tpm_getcap_header;
> +		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> +		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0);
> +	}
> +	if (rc) {
> +		dev_err(chip->dev,
> +			"A TPM error (%d) occurred attempting to determine the timeouts\n",
> +			rc);
>  		goto duration;
> +	}
> 
>  	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
>  	    be32_to_cpu(tpm_cmd.header.out.length)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 917f727..2d583ef 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -41,6 +41,7 @@ enum tpm_addr {
>  #define TPM_WARN_DOING_SELFTEST 0x802
>  #define TPM_ERR_DEACTIVATED     0x6
>  #define TPM_ERR_DISABLED        0x7
> +#define TPM_ERR_INVALID_POSTINIT 38
> 
>  #define TPM_HEADER_SIZE		10
>  extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
> @@ -269,6 +270,10 @@ struct tpm_pcrextend_in {
>  	u8	hash[TPM_DIGEST_SIZE];
>  }__attribute__((packed));
> 
> +struct tpm_startup_in {
> +	__be16	startup_type;
> +} __packed;
> +
>  typedef union {
>  	struct	tpm_getcap_params_out getcap_out;
>  	struct	tpm_readpubek_params_out readpubek_out;
> @@ -277,6 +282,7 @@ typedef union {
>  	struct	tpm_pcrread_in	pcrread_in;
>  	struct	tpm_pcrread_out	pcrread_out;
>  	struct	tpm_pcrextend_in pcrextend_in;
> +	struct tpm_startup_in startup_in;
>  } tpm_cmd_params;
> 
>  struct tpm_cmd_t {
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

