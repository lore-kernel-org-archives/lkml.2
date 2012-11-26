Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2KZUJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:09:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43840 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2KZUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:09:21 -0500
Date: Mon, 26 Nov 2012 14:08:24 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter H?we <PeterHuewe@gmx.de>, Peter.Huewe@infineon.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH v5] TPM: Issue TPM_STARTUP at driver load if the TPM has
 not been started
Message-ID: <20121126200823.GB12737@ennui.austin.ibm.com>
References: <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121121183713.GA12822@obsidianresearch.com>
 <201211212117.55040.PeterHuewe@gmx.de>
 <20121121205433.GA15285@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121205433.GA15285@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112620-7182-0000-0000-0000035A4925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 01:54:33PM -0700, Jason Gunthorpe wrote:
> The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> TPM_STARTUP has not been issued. Detect this and automatically
> issue TPM_STARTUP.
> 
> This is for embedded applications where the kernel is the first thing
> to touch the TPM.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Tested-by: Peter Huewe <peter.huewe@infineon.com>
> Reviewed-by: Peter Huewe <peter.huewe@infineon.com>
> ---
>  drivers/char/tpm/tpm.c |   44 ++++++++++++++++++++++++++++++++++++++++----
>  drivers/char/tpm/tpm.h |    6 ++++++
>  2 files changed, 46 insertions(+), 4 deletions(-)
> 
> v5 changes:
>  - Use %zd for printing ssize_t

Applied!

Thanks,
Kent

> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 93211df..433ad6b 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -468,7 +468,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
>  		return -EFAULT;
> 
>  	err = be32_to_cpu(cmd->header.out.return_code);
> -	if (err != 0)
> +	if (err != 0 && desc)
>  		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
> 
>  	return err;
> @@ -528,6 +528,25 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>  }
>  EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
> 
> +#define TPM_ORD_STARTUP cpu_to_be32(153)
> +#define TPM_ST_CLEAR cpu_to_be16(1)
> +#define TPM_ST_STATE cpu_to_be16(2)
> +#define TPM_ST_DEACTIVATED cpu_to_be16(3)
> +static const struct tpm_input_header tpm_startup_header = {
> +	.tag = TPM_TAG_RQU_COMMAND,
> +	.length = cpu_to_be32(12),
> +	.ordinal = TPM_ORD_STARTUP
> +};
> +
> +static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
> +{
> +	struct tpm_cmd_t start_cmd;
> +	start_cmd.header.in = tpm_startup_header;
> +	start_cmd.params.startup_in.startup_type = startup_type;
> +	return transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
> +			    "attempting to start the TPM");
> +}
> +
>  int tpm_get_timeouts(struct tpm_chip *chip)
>  {
>  	struct tpm_cmd_t tpm_cmd;
> @@ -541,11 +560,28 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>  	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
> 
> -	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> -			"attempting to determine the timeouts");
> -	if (rc)
> +	if (rc == TPM_ERR_INVALID_POSTINIT) {
> +		/* The TPM is not started, we are the first to talk to it.
> +		   Execute a startup command. */
> +		dev_info(chip->dev, "Issuing TPM_STARTUP");
> +		if (tpm_startup(chip, TPM_ST_CLEAR))
> +			return rc;
> +
> +		tpm_cmd.header.in = tpm_getcap_header;
> +		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> +		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +		rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +				  NULL);
> +	}
> +	if (rc) {
> +		dev_err(chip->dev,
> +			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> +			rc);
>  		goto duration;
> +	}
> 
>  	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
>  	    be32_to_cpu(tpm_cmd.header.out.length)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8ef7649..8971b12 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -47,6 +47,7 @@ enum tpm_addr {
>  #define TPM_WARN_DOING_SELFTEST 0x802
>  #define TPM_ERR_DEACTIVATED     0x6
>  #define TPM_ERR_DISABLED        0x7
> +#define TPM_ERR_INVALID_POSTINIT 38
> 
>  #define TPM_HEADER_SIZE		10
>  extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
> @@ -291,6 +292,10 @@ struct tpm_getrandom_in {
>  	__be32 num_bytes;
>  }__attribute__((packed));
> 
> +struct tpm_startup_in {
> +	__be16	startup_type;
> +} __packed;
> +
>  typedef union {
>  	struct	tpm_getcap_params_out getcap_out;
>  	struct	tpm_readpubek_params_out readpubek_out;
> @@ -301,6 +306,7 @@ typedef union {
>  	struct	tpm_pcrextend_in pcrextend_in;
>  	struct	tpm_getrandom_in getrandom_in;
>  	struct	tpm_getrandom_out getrandom_out;
> +	struct tpm_startup_in startup_in;
>  } tpm_cmd_params;
> 
>  struct tpm_cmd_t {
> -- 
> 1.7.5.4
> 

