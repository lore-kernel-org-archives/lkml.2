Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0KXCcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:32:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41659 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0KXCcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:32:51 -0500
Date: Tue, 23 Nov 2010 20:32:39 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 3/5] key: add tpm_send command
Message-ID: <20101124023238.GA26540@tiny>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1290556456.2604.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290556456.2604.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> Add internal kernel tpm_send() command used to seal/unseal keys.
> 
> Changelog:
> - replaced module_put in tpm_send() with new tpm_chip_put() wrapper
>   (suggested by David Howells)
> - Make tpm_send() cmd argument a 'void *' (suggested by David Howells)
> 
> Signed-off-by: David Safford <safford@watson.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: David Howells <dhowells@redhat.com>
> ---
>  drivers/char/tpm/tpm.c |   16 ++++++++++++++++
>  include/linux/tpm.h    |    4 ++++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 26c09f3..068bac8 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -780,6 +780,22 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  }
>  EXPORT_SYMBOL_GPL(tpm_pcr_extend);
>  
> +int tpm_send(u32 chip_num, void *cmd, size_t buflen)

Hate to nit-pick, but any particular reason you're not following the
rest of the file and using 'struct tpm_cmd_t *cmd' here?

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> +{
> +	struct tpm_chip *chip;
> +	int rc;
> +
> +	chip = tpm_chip_find_get(chip_num);
> +	if (chip == NULL)
> +		return -ENODEV;
> +
> +	rc = transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
> +
> +	tpm_chip_put(chip);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(tpm_send);
> +
>  ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
>  		      char *buf)
>  {
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index ac5d1c1..fdc718a 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -31,6 +31,7 @@
>  
>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
> +extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
>  #else
>  static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>  	return -ENODEV;
> @@ -38,5 +39,8 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>  static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
>  	return -ENODEV;
>  }
> +static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
> +	return -ENODEV;
> +}
>  #endif
>  #endif
> -- 
> 1.7.2.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
