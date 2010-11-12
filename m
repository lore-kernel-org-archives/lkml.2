Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab0KLQxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:53:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab0KLQxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:53:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 3/4] keys: add new trusted key-type
Date: Fri, 12 Nov 2010 16:52:59 +0000
Message-ID: <24801.1289580779@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +enum {
> +	Opt_err = -1,
> +	Opt_new = 1, Opt_load, Opt_update,
> +	Opt_keyhandle, Opt_keyauth, Opt_blobauth,
> +	Opt_pcrinfo, Opt_pcrlock, Opt_migratable
> +};

The compiler can generate slightly more efficient code if you don't skip 0 in
your enum.

> +static match_table_t key_tokens = {

const.

> +static int getoptions(char *c, struct trusted_key_payload *pay,
> +		      struct trusted_key_options *opt)
> +{
> +	substring_t args[MAX_OPT_ARGS];
> +	char *p = c;
> +	int token;
> +	int res;
> +	unsigned long handle;
> +	unsigned long lock;
> +
> +	while ((p = strsep(&c, " \t"))) {
> +		if ((*p == '\0') || (*p == ' ') || (*p == '\t'))

Superfluous brackets round the individual comparisons.

> +			continue;
> +		token = match_token(p, key_tokens, args);
> +
> +		switch (token) {
> +		case Opt_pcrinfo:
> +			opt->pcrinfo_len = strlen(args[0].from) / 2;
> +			if (opt->pcrinfo_len > MAX_PCRINFO_SIZE)
> +				return -EINVAL;
> +			hex2bin(opt->pcrinfo, args[0].from, opt->pcrinfo_len);
> +			break;
> +		case Opt_keyhandle:
> +			res = strict_strtoul(args[0].from, 16, &handle);
> +			if (res < 0)
> +				return -EINVAL;
> +			opt->keytype = SEALKEYTYPE;
> +			opt->keyhandle = (uint32_t) handle;

Unnecessary cast.

> +			break;
> +		case Opt_keyauth:
> +			if (strlen(args[0].from) != 2 * TPM_HASH_SIZE)
> +				return -EINVAL;
> +			hex2bin(opt->keyauth, args[0].from, TPM_HASH_SIZE);
> +			break;
> +		case Opt_blobauth:
> +			if (strlen(args[0].from) != 2 * TPM_HASH_SIZE)
> +				return -EINVAL;
> +			hex2bin(opt->blobauth, args[0].from, TPM_HASH_SIZE);
> +			break;
> +		case Opt_migratable:
> +			if (*args[0].from == '0')
> +				pay->migratable = 0;
> +			else
> +				return -EINVAL;
> +			break;
> +		case Opt_pcrlock:
> +			res = strict_strtoul(args[0].from, 10, &lock);
> +			if (res < 0)
> +				return -EINVAL;
> +			opt->pcrlock = (int)lock;

Unnecessary cast.

> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * datablob_parse - parse the keyctl data and fill in the
> + * 		    payload and options structures
> + *
> + * On success returns 0, otherwise -EINVAL.
> + */
> +static int datablob_parse(char *datablob, struct trusted_key_payload *p,
> +			  struct trusted_key_options *o)
> +{
> ...
> +		ret = strict_strtol(c, 10, (long *)&p->key_len);

NAK!  You cannot do this.  It won't work on 64-bit machines, especially
big-endian ones.  Casting the pointer does not change the size of the
destination variable.  You must use a temporary var.

> +		if ((ret < 0) || (p->key_len < MIN_KEY_SIZE) ||
> +		    (p->key_len > MAX_KEY_SIZE))

Superfluous parenthesization.

> +static int trusted_instantiate(struct key *key, const void *data,
> +			       size_t datalen)
> +{
> ...
> +	switch (key_cmd) {
> +	case Opt_load:
> +		ret = key_unseal(payload, options);
> +		if (ret < 0)
> +			pr_info("trusted_key: key_unseal failed (%d)\n", ret);
> +		break;
> +	case Opt_new:
> +		ret = my_get_random(payload->key, payload->key_len);
> +		if (ret < 0) {
> +			pr_info("trusted_key: key_create failed (%d)\n", ret);
> +			goto out;
> +		}
> +		ret = key_seal(payload, options);
> +		if (ret < 0)
> +			pr_info("trusted_key: key_seal failed (%d)\n", ret);
> +		break;

Aha!  I see how this works now.  Using add/update key seems the right way to
do things.

> +	default:
> +		ret = -EINVAL;
> +	}
> +	if (options->pcrlock)
> +		ret = pcrlock(options->pcrlock);

Do you really want to go through pcrlock() if you're going to return -EINVAL?

> +out:
> +	kfree(datablob);
> +	if (options)
> +		kfree(options);

kfree() can handle NULL pointers.

> +	if (!ret)
> +		rcu_assign_pointer(key->payload.data, payload);
> +	else if (payload)
> +		kfree(payload);

Again, kfree() can handle a NULL pointer.

> +#define TPM_MAX_BUF_SIZE		512
> +#define TPM_TAG_RQU_COMMAND		193
> +#define TPM_TAG_RQU_AUTH1_COMMAND	194
> +#define TPM_TAG_RQU_AUTH2_COMMAND	195
> +#define TPM_TAG_RSP_COMMAND		196
> +#define TPM_TAG_RSP_AUTH1_COMMAND	197
> +#define TPM_TAG_RSP_AUTH2_COMMAND	198
> +#define TPM_NONCE_SIZE			20
> +#define TPM_HASH_SIZE			20
> +#define TPM_SIZE_OFFSET			2
> +#define TPM_RETURN_OFFSET		6
> +#define TPM_DATA_OFFSET			10
> +#define TPM_U32_SIZE			4
> +#define TPM_GETRANDOM_SIZE		14
> +#define TPM_GETRANDOM_RETURN		14
> +#define TPM_ORD_GETRANDOM		70
> +#define TPM_RESET_SIZE			10
> +#define TPM_ORD_RESET			90
> +#define TPM_OSAP_SIZE			36
> +#define TPM_ORD_OSAP			11
> +#define TPM_OIAP_SIZE			10
> +#define TPM_ORD_OIAP			10
> +#define TPM_SEAL_SIZE			87
> +#define TPM_ORD_SEAL			23
> +#define TPM_ORD_UNSEAL			24
> +#define TPM_UNSEAL_SIZE			104
> +#define SEALKEYTYPE			1
> +#define SRKKEYTYPE			4
> +#define SRKHANDLE			0x40000000
> +#define TPM_ANY_NUM			0xFFFF
> +#define MAX_PCRINFO_SIZE		64

I suspect some of these should be in somewhere like linux/tpm.h rather than
here.  They're specific to TPM access not TPM key management.

> +#define LOAD32(buffer, offset)	(ntohl(*(uint32_t *)&buffer[offset]))
> +#define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
> +#define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
> +
> +struct tpm_buf {
> +	int len;
> +	unsigned char data[TPM_MAX_BUF_SIZE];
> +};
> +
> +#define INIT_BUF(tb) (tb->len = 0)
> +
> +struct osapsess {
> +	uint32_t handle;
> +	unsigned char secret[TPM_HASH_SIZE];
> +	unsigned char enonce[TPM_NONCE_SIZE];
> +};
> +
> +struct trusted_key_options {
> +	uint16_t keytype;

key type enum?

> +	uint32_t keyhandle;
> +	unsigned char keyauth[TPM_HASH_SIZE];
> +	unsigned char blobauth[TPM_HASH_SIZE];
> +	uint32_t pcrinfo_len;
> +	unsigned char pcrinfo[MAX_PCRINFO_SIZE];
> +	int pcrlock;
> +};
> +
> +#define TPM_DEBUG 0

The TPM_DEBUG stuff should probably be in the directory with the sources, not
in a directory for others to include.

> +#if TPM_DEBUG
> +static inline void dump_options(struct trusted_key_options *o)
> +{
> +	pr_info("trusted_key: sealing key type %d\n", o->keytype);
> +	pr_info("trusted_key: sealing key handle %0X\n", o->keyhandle);
> +	pr_info("trusted_key: pcrlock %d\n", o->pcrlock);
> +	pr_info("trusted_key: pcrinfo %d\n", o->pcrinfo_len);
> +	print_hex_dump(KERN_INFO, "pcrinfo ", DUMP_PREFIX_NONE,
> +		       16, 1, o->pcrinfo, o->pcrinfo_len, 0);
> +}
> +
> +static inline void dump_payload(struct trusted_key_payload *p)
> +{
> +	pr_info("trusted_key: key_len %d\n", p->key_len);
> +	print_hex_dump(KERN_INFO, "key ", DUMP_PREFIX_NONE,
> +		       16, 1, p->key, p->key_len, 0);
> +	pr_info("trusted_key: bloblen %d\n", p->blob_len);
> +	print_hex_dump(KERN_INFO, "blob ", DUMP_PREFIX_NONE,
> +		       16, 1, p->blob, p->blob_len, 0);
> +	pr_info("trusted_key: migratable %d\n", p->migratable);
> +}
> +
> +static inline void dump_sess(struct osapsess *s)
> +{
> +	print_hex_dump(KERN_INFO, "trusted-key: handle ", DUMP_PREFIX_NONE,
> +		       16, 1, &s->handle, 4, 0);
> +	pr_info("trusted-key: secret:\n");
> +	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
> +		       16, 1, &s->secret, TPM_HASH_SIZE, 0);
> +	pr_info("trusted-key: enonce:\n");
> +	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE,
> +		       16, 1, &s->enonce, TPM_HASH_SIZE, 0);
> +}
> +
> +static inline void dump_tpm_buf(unsigned char *buf)
> +{
> +	int len;
> +
> +	pr_info("\ntrusted-key: tpm buffer\n");
> +	len = LOAD32(buf, TPM_SIZE_OFFSET);
> +	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
> +}
> +#else
> +static inline void dump_options(struct trusted_key_options *o)
> +{
> +}
> +
> +static inline void dump_payload(struct trusted_key_payload *p)
> +{
> +}
> +
> +static inline void dump_sess(struct osapsess *s)
> +{
> +}
> +
> +static inline void dump_tpm_buf(unsigned char *buf)
> +{
> +}
> +#endif
> +
> +static inline void store8(struct tpm_buf *buf, unsigned char value)
> +{
> +	buf->data[buf->len++] = value;
> +}
> +
> +static inline void store16(struct tpm_buf *buf, uint16_t value)
> +{
> +	*(uint16_t *) & buf->data[buf->len] = htons(value);
> +	buf->len += sizeof(value);
> +}
> +
> +static inline void store32(struct tpm_buf *buf, uint32_t value)
> +{
> +	*(uint32_t *) & buf->data[buf->len] = htonl(value);
> +	buf->len += sizeof(value);
> +}
> +
> +static inline void storebytes(struct tpm_buf *buf, unsigned char *in, int len)
> +{
> +	memcpy(buf->data + buf->len, in, len);
> +	buf->len += len;
> +}

Also these look like internal functions which shouldn't be in the global
headers.

David
