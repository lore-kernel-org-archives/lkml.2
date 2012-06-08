Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2FHTNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:13:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39741 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab2FHTNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:13:21 -0400
Message-ID: <1339182791.2297.11.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] tpm: Move tpm_get_random api into the TPM device
 driver
From: David Safford <safford@linux.vnet.ibm.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, David Safford <safford@us.ibm.com>
Date: Fri, 08 Jun 2012 15:13:11 -0400
In-Reply-To: <1339094834.21398.4.camel@key-ThinkPad-W510>
References: <1339094567.21398.2.camel@key-ThinkPad-W510>
	 <1339094834.21398.4.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060819-7182-0000-0000-000001B467FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:47 -0500, Kent Yoder wrote:
> Move the tpm_get_random api from the trusted keys code into the TPM
> device driver itself so that other callers can make use of it. Also,
> change the api slightly so that the number of bytes read is returned in
> the call, since the TPM command can potentially return fewer bytes than
> requested.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

checkpatch had minor complaints, but otherwise,
Acked-by: David Safford <safford@linux.vnet.ibm.com>

> ---
>  drivers/char/tpm/tpm.c  |   53 +++++++++++++++++++++++++++++++++++++++++-----
>  drivers/char/tpm/tpm.h  |   23 ++++++++++++++++++++
>  include/linux/tpm.h     |    4 +++
>  security/keys/trusted.c |   47 ++++++++--------------------------------
>  4 files changed, 84 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index ad7c732..8c74b24 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -31,12 +31,6 @@
>  
>  #include "tpm.h"
>  
> -enum tpm_const {
> -	TPM_MINOR = 224,	/* officially assigned */
> -	TPM_BUFSIZE = 4096,
> -	TPM_NUM_DEVICES = 256,
> -};
> -
>  enum tpm_duration {
>  	TPM_SHORT = 0,
>  	TPM_MEDIUM = 1,
> @@ -482,6 +476,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
>  #define TPM_INTERNAL_RESULT_SIZE 200
>  #define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
>  #define TPM_ORD_GET_CAP cpu_to_be32(101)
> +#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
>  
>  static const struct tpm_input_header tpm_getcap_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
> @@ -1318,6 +1313,52 @@ int tpm_pm_resume(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  
> +#define TPM_GETRANDOM_RESULT_SIZE	18
> +static struct tpm_input_header tpm_getrandom_header = {
> +	.tag = TPM_TAG_RQU_COMMAND,
> +	.length = cpu_to_be32(14),
> +	.ordinal = TPM_ORD_GET_RANDOM
> +};
> +
> +/**
> + * tpm_get_random() - Get random bytes from the tpm's RNG
> + * @chip_num: A specific chip number for the request or TPM_ANY_NUM
> + * @out: destination buffer for the random bytes
> + * @max: on input, the max number of bytes to write to @out, on output
> + *       this is set to the actual number of bytes written to @out
> + *
> + * Note that @max will be capped at TPM_MAX_RNG_DATA bytes.
> + */
> +int tpm_get_random(u32 chip_num, u8 *out, size_t *max)
> +{
> +	struct tpm_chip *chip;
> +	struct tpm_cmd_t tpm_cmd;
> +	u32 num_bytes = min_t(u32, *max, TPM_MAX_RNG_DATA);
> +	int err;
> +
> +	chip = tpm_chip_find_get(chip_num);
> +	if (chip == NULL)
> +		return -ENODEV;
> +
> +	if (!num_bytes)
> +		return -EINVAL;
> +
> +	tpm_cmd.header.in = tpm_getrandom_header;
> +	tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
> +
> +	err = transmit_cmd(chip, &tpm_cmd,
> +			   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
> +			   "attempting get random");
> +	if (err)
> +		goto out;
> +
> +	*max = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
> +	memcpy(out, tpm_cmd.params.getrandom_out.rng_data, *max);
> +out:
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(tpm_get_random);
> +
>  /* In case vendor provided release function, call it too.*/
>  
>  void tpm_dev_vendor_release(struct tpm_chip *chip)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index b1c5280..610fe42 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -28,6 +28,12 @@
>  #include <linux/io.h>
>  #include <linux/tpm.h>
>  
> +enum tpm_const {
> +	TPM_MINOR = 224,	/* officially assigned */
> +	TPM_BUFSIZE = 4096,
> +	TPM_NUM_DEVICES = 256,
> +};
> +
>  enum tpm_timeout {
>  	TPM_TIMEOUT = 5,	/* msecs */
>  };
> @@ -269,6 +275,21 @@ struct tpm_pcrextend_in {
>  	u8	hash[TPM_DIGEST_SIZE];
>  }__attribute__((packed));
>  
> +/* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
> + * bytes, but 128 is still a relatively large number of random bytes and
> + * anything much bigger causes users of struct tpm_cmd_t to start getting
> + * compiler warnings about stack frame size. */
> +#define TPM_MAX_RNG_DATA	128
> +
> +struct tpm_getrandom_out {
> +	__be32 rng_data_len;
> +	u8     rng_data[TPM_MAX_RNG_DATA];
> +}__attribute__((packed));
> +
> +struct tpm_getrandom_in {
> +	__be32 num_bytes;
> +}__attribute__((packed));
> +
>  typedef union {
>  	struct	tpm_getcap_params_out getcap_out;
>  	struct	tpm_readpubek_params_out readpubek_out;
> @@ -277,6 +298,8 @@ typedef union {
>  	struct	tpm_pcrread_in	pcrread_in;
>  	struct	tpm_pcrread_out	pcrread_out;
>  	struct	tpm_pcrextend_in pcrextend_in;
> +	struct	tpm_getrandom_in getrandom_in;
> +	struct	tpm_getrandom_out getrandom_out;
>  } tpm_cmd_params;
>  
>  struct tpm_cmd_t {
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index fdc718a..d5b2f2d 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -32,6 +32,7 @@
>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
>  extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
> +extern int tpm_get_random(u32 chip_num, u8 *data, size_t *max);
>  #else
>  static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>  	return -ENODEV;
> @@ -42,5 +43,8 @@ static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
>  static inline int tpm_send(u32 chip_num, void *cmd, size_t buflen) {
>  	return -ENODEV;
>  }
> +static inline int tpm_get_random(u32 chip_num, u8 *data, size_t *max) {
> +	return -ENODEV;
> +}
>  #endif
>  #endif
> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
> index 2d5d041..48a9eabc 100644
> --- a/security/keys/trusted.c
> +++ b/security/keys/trusted.c
> @@ -369,38 +369,6 @@ static int trusted_tpm_send(const u32 chip_num, unsigned char *cmd,
>  }
>  
>  /*
> - * get a random value from TPM
> - */
> -static int tpm_get_random(struct tpm_buf *tb, unsigned char *buf, uint32_t len)
> -{
> -	int ret;
> -
> -	INIT_BUF(tb);
> -	store16(tb, TPM_TAG_RQU_COMMAND);
> -	store32(tb, TPM_GETRANDOM_SIZE);
> -	store32(tb, TPM_ORD_GETRANDOM);
> -	store32(tb, len);
> -	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, sizeof tb->data);
> -	if (!ret)
> -		memcpy(buf, tb->data + TPM_GETRANDOM_SIZE, len);
> -	return ret;
> -}
> -
> -static int my_get_random(unsigned char *buf, int len)
> -{
> -	struct tpm_buf *tb;
> -	int ret;
> -
> -	tb = kmalloc(sizeof *tb, GFP_KERNEL);
> -	if (!tb)
> -		return -ENOMEM;
> -	ret = tpm_get_random(tb, buf, len);
> -
> -	kfree(tb);
> -	return ret;
> -}
> -
> -/*
>   * Lock a trusted key, by extending a selected PCR.
>   *
>   * Prevents a trusted key that is sealed to PCRs from being accessed.
> @@ -409,11 +377,12 @@ static int my_get_random(unsigned char *buf, int len)
>  static int pcrlock(const int pcrnum)
>  {
>  	unsigned char hash[SHA1_DIGEST_SIZE];
> +	size_t digest_size = SHA1_DIGEST_SIZE;
>  	int ret;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	ret = my_get_random(hash, SHA1_DIGEST_SIZE);
> +	ret = tpm_get_random(TPM_ANY_NUM, hash, &digest_size);
>  	if (ret < 0)
>  		return ret;
>  	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;
> @@ -427,9 +396,10 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
>  {
>  	unsigned char enonce[TPM_NONCE_SIZE];
>  	unsigned char ononce[TPM_NONCE_SIZE];
> +	size_t nonce_size = TPM_NONCE_SIZE;
>  	int ret;
>  
> -	ret = tpm_get_random(tb, ononce, TPM_NONCE_SIZE);
> +	ret = tpm_get_random(TPM_ANY_NUM, ononce, &nonce_size);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -500,6 +470,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
>  	uint32_t ordinal;
>  	uint32_t pcrsize;
>  	uint32_t datsize;
> +	size_t nonce_size = TPM_NONCE_SIZE;
>  	int sealinfosize;
>  	int encdatasize;
>  	int storedsize;
> @@ -524,7 +495,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
>  	if (ret < 0)
>  		goto out;
>  
> -	ret = tpm_get_random(tb, td->nonceodd, TPM_NONCE_SIZE);
> +	ret = tpm_get_random(TPM_ANY_NUM, td->nonceodd, &nonce_size);
>  	if (ret < 0)
>  		goto out;
>  	ordinal = htonl(TPM_ORD_SEAL);
> @@ -618,6 +589,7 @@ static int tpm_unseal(struct tpm_buf *tb,
>  	unsigned char cont = 0;
>  	uint32_t ordinal;
>  	uint32_t keyhndl;
> +	size_t nonce_size = TPM_NONCE_SIZE;
>  	int ret;
>  
>  	/* sessions for unsealing key and data */
> @@ -634,7 +606,7 @@ static int tpm_unseal(struct tpm_buf *tb,
>  
>  	ordinal = htonl(TPM_ORD_UNSEAL);
>  	keyhndl = htonl(SRKHANDLE);
> -	ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
> +	ret = tpm_get_random(TPM_ANY_NUM, nonceodd, &nonce_size);
>  	if (ret < 0) {
>  		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
>  		return ret;
> @@ -974,7 +946,8 @@ static int trusted_instantiate(struct key *key, const void *data,
>  			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
>  		break;
>  	case Opt_new:
> -		ret = my_get_random(payload->key, payload->key_len);
> +		ret = tpm_get_random(TPM_ANY_NUM, payload->key,
> +				     &payload->key_len);
>  		if (ret < 0) {
>  			pr_info("trusted_key: key_create failed (%d)\n", ret);
>  			goto out;

