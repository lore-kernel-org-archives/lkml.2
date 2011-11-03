Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab1KCMMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:12:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab1KCMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:12:39 -0400
Message-ID: <4EB2852D.2060300@polito.it>
Date: Thu, 03 Nov 2011 13:12:29 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.lsm,gmane.linux.kernel
CC: David Safford <safford@watson.ibm.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@us.ibm.com, dhowells@redhat.com, jmorris@namei.org
Subject: Re: [PATCH 2/2] trusted-key: added support for loading a key blob
 in the TPM
References: <1320237682-3857-1-git-send-email-roberto.sassu@polito.it>  <1320237682-3857-2-git-send-email-roberto.sassu@polito.it> <1320254766.3225.18.camel@localhost> <4EB18138.6050400@polito.it>
In-Reply-To: <4EB18138.6050400@polito.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 06:43 PM, Roberto Sassu wrote:
> On 11/02/2011 06:26 PM, David Safford wrote:
>> On Wed, 2011-11-02 at 13:41 +0100, Roberto Sassu wrote:
>>> The new functions 'tpm_loadkey2', 'tpm_evictkey' and 'tpm_flushspecific'
>>> allow to load/unload a TPM key whose blob is provided from the userspace
>>> interface and to use it for sealing or unsealing the symmetric key.
>>
>> This looks like a nice extension.
>> I'll test it out thoroughly, but for now here are a couple of
>> minor initial suggestions...
>>
>

Hi Dave

i've just discovered another issue in the patches.
MAX_KEYBLOB_SIZE should not be equal to MAX_BUF_SIZE,
because otherwise a buffer overflow may occur in the
allocated 'tpm_buf' structure during the tpm_loadkey2()
function.

So, in the new patches i've set:

#define MAX_KEYBLOB_SIZE ( MAX_BUF_SIZE - TPM_LOADKEY2_SIZE )


and i've fixed the checks in getoptions()

------
if (strlen(args[0].from) > MAX_KEYBLOB_SIZE * 2)
------

------
if (opt->keyblob_len > MAX_KEYBLOB_SIZE)
------

by replacing '>=' with '>'.


Roberto Sassu


> Thanks, i will fix them and submit a new version of
> the patches after receiving other comments.
>
> Roberto Sassu
>
>
>> dave
>>
>>>
>>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
>>> ---
>>> Documentation/security/keys-trusted-encrypted.txt | 6 +-
>>> include/linux/tpm_command.h | 6 +
>>> security/keys/trusted.c | 203 ++++++++++++++++++++-
>>> security/keys/trusted.h | 27 +++-
>>> 4 files changed, 234 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Documentation/security/keys-trusted-encrypted.txt
>>> b/Documentation/security/keys-trusted-encrypted.txt
>>> index 5f50cca..afebb58 100644
>>> --- a/Documentation/security/keys-trusted-encrypted.txt
>>> +++ b/Documentation/security/keys-trusted-encrypted.txt
>>> @@ -27,8 +27,10 @@ Usage:
>>> keyctl print keyid
>>>
>>> options:
>>> - keyhandle= ascii hex value of sealing key default 0x40000000 (SRK)
>>> - keyauth= ascii hex auth for sealing key default 0x00...i
>>> + keyhandle= ascii hex value of sealing key handle default 0x40000000
>>> (SRK)
>>> + keyblob= ascii hex value of sealing key blob (no default)
>>> + srkauth= ascii hex auth for SRK key default 0x00...
>>> + keyauth= ascii hex auth for sealing key (not SRK) default 0x00...
>>> (40 ascii zeros)
>>> blobauth= ascii hex auth for sealed data default 0x00...
>>> (40 ascii zeros)
>>> diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
>>> index 727512e..e3348b7 100644
>>> --- a/include/linux/tpm_command.h
>>> +++ b/include/linux/tpm_command.h
>>> @@ -15,7 +15,10 @@
>>> #define TPM_TAG_RSP_AUTH2_COMMAND 198
>>>
>>> /* Command Ordinals */
>>> +#define TPM_ORD_EVICTKEY 34
>>> +#define TPM_ORD_FLUSHSPECIFIC 186
>>> #define TPM_ORD_GETRANDOM 70
>>> +#define TPM_ORD_LOADKEY2 65
>>> #define TPM_ORD_OSAP 11
>>> #define TPM_ORD_OIAP 10
>>> #define TPM_ORD_SEAL 23
>>> @@ -24,5 +27,8 @@
>>> /* Other constants */
>>> #define SRKHANDLE 0x40000000
>>> #define TPM_NONCE_SIZE 20
>>> +#define TPM_RT_KEY 0x00000001
>>> +#define TPM_TAG_KEY12 0x0028
>>> +#define TPM_BAD_ORDINAL 10
>>>
>>> #endif
>>> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
>>> index 8777015..c332e3b 100644
>>> --- a/security/keys/trusted.c
>>> +++ b/security/keys/trusted.c
>>> @@ -688,12 +688,118 @@ static int tpm_unseal(struct tpm_buf *tb,
>>> }
>>>
>>> /*
>>> + * Load a TPM key from the blob provided by userspace
>>> + */
>>> +static int tpm_loadkey2(struct tpm_buf *tb,
>>> + uint32_t keyhandle, unsigned char *keyauth,
>>> + const unsigned char *keyblob, int keybloblen,
>>> + uint32_t *newhandle)
>>> +{
>>> + unsigned char nonceodd[TPM_NONCE_SIZE];
>>> + unsigned char enonce[TPM_NONCE_SIZE];
>>> + unsigned char authdata[SHA1_DIGEST_SIZE];
>>> + uint32_t authhandle = 0;
>>> + unsigned char cont = 0;
>>> + uint32_t ordinal;
>>> + int ret;
>>> +
>>> + ordinal = htonl(TPM_ORD_LOADKEY2);
>>> +
>>> + /* session for loading the key */
>>> + ret = oiap(tb,&authhandle, enonce);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: oiap failed (%d)\n", ret);
>>> + return ret;
>>> + }
>>> +
>>> + /* generate odd nonce */
>>> + ret = tpm_get_random(tb, nonceodd, TPM_NONCE_SIZE);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
>>> + return ret;
>>> + }
>>> +
>>> + /* calculate authorization HMAC value */
>>> + ret = TSS_authhmac(authdata, keyauth, SHA1_DIGEST_SIZE, enonce,
>>> + nonceodd, cont, sizeof(uint32_t),&ordinal,
>>> + keybloblen, keyblob, 0, 0);
>>> + if (ret< 0)
>>> + return ret;
>>> +
>>> + /* build the request buffer */
>>> + INIT_BUF(tb);
>>> + store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
>>> + store32(tb, TPM_LOADKEY2_SIZE + keybloblen);
>>> + store32(tb, TPM_ORD_LOADKEY2);
>>> + store32(tb, keyhandle);
>>> + storebytes(tb, keyblob, keybloblen);
>>> + store32(tb, authhandle);
>>> + storebytes(tb, nonceodd, TPM_NONCE_SIZE);
>>> + store8(tb, cont);
>>> + storebytes(tb, authdata, SHA1_DIGEST_SIZE);
>>> +
>>> + ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: authhmac failed (%d)\n", ret);
>>> + return ret;
>>> + }
>>> +
>>> + ret = TSS_checkhmac1(tb->data, ordinal, nonceodd, keyauth,
>>> + SHA1_DIGEST_SIZE, 0, 0);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: TSS_checkhmac1 failed (%d)\n", ret);
>>> + return ret;
>>> + }
>>> +
>>> + *newhandle = LOAD32(tb->data, TPM_DATA_OFFSET);
>>> + return 0;
>>> +}
>>> +
>>> +/*
>>> + * Execute the FlushSpecific TPM command
>>> + */
>>> +uint32_t tpm_flushspecific(struct tpm_buf *tb, uint32_t handle,
>>> + uint32_t resourcetype)
>>
>> static?
>>
>>> +{
>>> + INIT_BUF(tb);
>>> + store16(tb, TPM_TAG_RQU_COMMAND);
>>> + store32(tb, TPM_FLUSHSPECIFIC_SIZE);
>>> + store32(tb, TPM_ORD_FLUSHSPECIFIC);
>>> + store32(tb, handle);
>>> + store32(tb, resourcetype);
>>> +
>>> + return trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
>>> +}
>>> +
>>> +/*
>>> + * Evict a key from the TPM
>>> + */
>>> +uint32_t tpm_evictkey(struct tpm_buf *tb, uint32_t keyhandle)
>>
>> static?
>>
>>> +{
>>> + int ret;
>>> +
>>> + INIT_BUF(tb);
>>> + store16(tb, TPM_TAG_RQU_COMMAND);
>>> + store32(tb, TPM_EVICTKEY_SIZE);
>>> + store32(tb, TPM_ORD_EVICTKEY);
>>> + store32(tb, keyhandle);
>>> +
>>> + ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, sizeof tb->data);
>>> + if (ret< 0)
>>> + ret = tpm_flushspecific(tb, keyhandle, TPM_RT_KEY);
>>> +
>>> + return ret;
>>> +}
>>> +
>>> +/*
>>> * Have the TPM seal(encrypt) the symmetric key
>>> */
>>> static int key_seal(struct trusted_key_payload *p,
>>> struct trusted_key_options *o)
>>> {
>>> struct tpm_buf *tb;
>>> + uint32_t keyhandle;
>>> + unsigned char *parentauth;
>>> int ret;
>>>
>>> tb = kzalloc(sizeof *tb, GFP_KERNEL);
>>> @@ -703,12 +809,40 @@ static int key_seal(struct trusted_key_payload *p,
>>> /* include migratable flag at end of sealed key */
>>> p->key[p->key_len] = p->migratable;
>>>
>>> - ret = tpm_seal(tb, o->keytype, o->keyhandle, o->keyauth,
>>> + /* set default values */
>>> + keyhandle = o->keyhandle;
>>> + parentauth = o->srkauth;
>>> +
>>> + if (o->keytype == SEAL_keytype) {
>>> + parentauth = o->keyauth;
>>> + if (o->keyblob_len> 0) {
>>> + ret = tpm_loadkey2(tb, SRKHANDLE, o->srkauth,
>>> + o->keyblob, o->keyblob_len,
>>> + &keyhandle);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: loadkey2 failed (%d)\n",
>>> + ret);
>>> + goto out;
>>> + }
>>> +
>>> + dump_tpm_key12_handle(keyhandle);
>>> + }
>>> + }
>>> +
>>> + ret = tpm_seal(tb, o->keytype, keyhandle, parentauth,
>>> p->key, p->key_len + 1, p->blob,&p->blob_len,
>>> o->blobauth, o->pcrinfo, o->pcrinfo_len);
>>> if (ret< 0)
>>> pr_info("trusted_key: srkseal failed (%d)\n", ret);
>>>
>>> + if (o->keyblob_len> 0) {
>>> + int evictret = tpm_evictkey(tb, keyhandle);
>>> +
>>> + if (evictret< 0)
>>> + pr_info("trusted_key: evictkey failed (%d)\n",
>>> + evictret);
>>> + }
>>> +out:
>>> kfree(tb);
>>> return ret;
>>> }
>>> @@ -720,13 +854,33 @@ static int key_unseal(struct
>>> trusted_key_payload *p,
>>> struct trusted_key_options *o)
>>> {
>>> struct tpm_buf *tb;
>>> + uint32_t keyhandle;
>>> + unsigned char *parentauth;
>>> int ret;
>>>
>>> tb = kzalloc(sizeof *tb, GFP_KERNEL);
>>> if (!tb)
>>> return -ENOMEM;
>>>
>>> - ret = tpm_unseal(tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
>>> + /* set default values */
>>> + keyhandle = o->keyhandle;
>>> + parentauth = o->srkauth;
>>> +
>>> + if (o->keytype == SEAL_keytype) {
>>> + parentauth = o->keyauth;
>>> + if (o->keyblob_len> 0) {
>>> + ret = tpm_loadkey2(tb, SRKHANDLE, o->srkauth,
>>> + o->keyblob, o->keyblob_len,
>>> + &keyhandle);
>>> + if (ret< 0) {
>>> + pr_info("trusted_key: loadkey2 failed (%d)\n",
>>> + ret);
>>> + goto out;
>>> + }
>>> + }
>>> + }
>>> +
>>> + ret = tpm_unseal(tb, keyhandle, parentauth, p->blob, p->blob_len,
>>> o->blobauth, p->key,&p->key_len);
>>> if (ret< 0)
>>> pr_info("trusted_key: srkunseal failed (%d)\n", ret);
>>> @@ -734,14 +888,22 @@ static int key_unseal(struct
>>> trusted_key_payload *p,
>>> /* pull migratable flag out of sealed key */
>>> p->migratable = p->key[--p->key_len];
>>>
>>> + if (o->keyblob_len> 0) {
>>> + int evictret = tpm_evictkey(tb, keyhandle);
>>> +
>>> + if (evictret< 0)
>>> + pr_info("trusted_key: evictkey failed (%d)\n",
>>> + evictret);
>>> + }
>>> +out:
>>> kfree(tb);
>>> return ret;
>>> }
>>>
>>> enum {
>>> Opt_err = -1,
>>> - Opt_new, Opt_load, Opt_update,
>>> - Opt_keyhandle, Opt_keyauth, Opt_blobauth,
>>> + Opt_new, Opt_load, Opt_update, Opt_srkauth,
>>> + Opt_keyhandle, Opt_keyblob, Opt_keyauth, Opt_blobauth,
>>> Opt_pcrinfo, Opt_pcrlock, Opt_migratable
>>> };
>>>
>>> @@ -749,7 +911,9 @@ static const match_table_t key_tokens = {
>>> {Opt_new, "new"},
>>> {Opt_load, "load"},
>>> {Opt_update, "update"},
>>> + {Opt_srkauth, "srkauth=%s"},
>>> {Opt_keyhandle, "keyhandle=%s"},
>>> + {Opt_keyblob, "keyblob=%s"},
>>> {Opt_keyauth, "keyauth=%s"},
>>> {Opt_blobauth, "blobauth=%s"},
>>> {Opt_pcrinfo, "pcrinfo=%s"},
>>> @@ -768,6 +932,8 @@ static int getoptions(char *c, struct
>>> trusted_key_payload *pay,
>>> int res;
>>> unsigned long handle;
>>> unsigned long lock;
>>> + uint16_t tpm_key_tag;
>>> + uint32_t value;
>>>
>>> while ((p = strsep(&c, " \t"))) {
>>> if (*p == '\0' || *p == ' ' || *p == '\t')
>>> @@ -788,6 +954,35 @@ static int getoptions(char *c, struct
>>> trusted_key_payload *pay,
>>> opt->keytype = SEAL_keytype;
>>> opt->keyhandle = handle;
>>> break;
>>> + case Opt_keyblob:
>>> + if (strlen(args[0].from)>= MAX_KEYBLOB_SIZE * 2)
>>> + return -EINVAL;
>>> + hex2bin(opt->keyblob, args[0].from, MAX_KEYBLOB_SIZE);
>>> + tpm_key_tag = LOAD16(opt->keyblob, 0);
>>> + if (tpm_key_tag != TPM_TAG_KEY12)
>>> + return -EINVAL;
>>> + opt->keytype = SEAL_keytype;
>>> + opt->keyblob_len = TPM_KEY12_EXPSIZE_OFFSET;
>>> + /* key exponent size */
>>> + value = LOAD32(opt->keyblob, opt->keyblob_len);
>>> + opt->keyblob_len += sizeof(uint32_t) + value;
>>> + /* PCRINFO size */
>>> + value = LOAD32(opt->keyblob, opt->keyblob_len);
>>> + opt->keyblob_len += sizeof(uint32_t) + value;
>>> + /* key length */
>>> + value = LOAD32(opt->keyblob, opt->keyblob_len);
>>> + opt->keyblob_len += sizeof(uint32_t) + value;
>>> + /* enc data size */
>>> + value = LOAD32(opt->keyblob, opt->keyblob_len);
>>> + opt->keyblob_len += sizeof(uint32_t) + value;
>>> + if (opt->keyblob_len>= MAX_KEYBLOB_SIZE)
>>> + return -EINVAL;
>>> + break;
>>> + case Opt_srkauth:
>>> + if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
>>> + return -EINVAL;
>>> + hex2bin(opt->srkauth, args[0].from, SHA1_DIGEST_SIZE);
>>> + break;
>>> case Opt_keyauth:
>>> if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
>>> return -EINVAL;
>>> diff --git a/security/keys/trusted.h b/security/keys/trusted.h
>>> index 3249fbd..6a9f373 100644
>>> --- a/security/keys/trusted.h
>>> +++ b/security/keys/trusted.h
>>> @@ -3,12 +3,16 @@
>>>
>>> /* implementation specific TPM constants */
>>> #define MAX_PCRINFO_SIZE 64
>>> -#define MAX_BUF_SIZE 512
>>> +#define MAX_BUF_SIZE 1024
>>> +#define MAX_KEYBLOB_SIZE 1024
>>> #define TPM_GETRANDOM_SIZE 14
>>> #define TPM_OSAP_SIZE 36
>>> #define TPM_OIAP_SIZE 10
>>> #define TPM_SEAL_SIZE 87
>>> #define TPM_UNSEAL_SIZE 104
>>> +#define TPM_LOADKEY2_SIZE 59
>>> +#define TPM_EVICTKEY_SIZE 14
>>> +#define TPM_FLUSHSPECIFIC_SIZE 18
>>> #define TPM_SIZE_OFFSET 2
>>> #define TPM_RETURN_OFFSET 6
>>> #define TPM_DATA_OFFSET 10
>>> @@ -17,6 +21,8 @@
>>> #define LOAD32N(buffer, offset) (*(uint32_t *)&buffer[offset])
>>> #define LOAD16(buffer, offset) (ntohs(*(uint16_t *)&buffer[offset]))
>>>
>>> +#define TPM_KEY12_EXPSIZE_OFFSET 31
>>> +
>>> struct tpm_buf {
>>> int len;
>>> unsigned char data[MAX_BUF_SIZE];
>>> @@ -39,6 +45,9 @@ enum {
>>> struct trusted_key_options {
>>> uint16_t keytype;
>>> uint32_t keyhandle;
>>> + uint32_t keyblob_len;
>>> + unsigned char keyblob[MAX_KEYBLOB_SIZE];
>>> + unsigned char srkauth[SHA1_DIGEST_SIZE];
>>> unsigned char keyauth[SHA1_DIGEST_SIZE];
>>> unsigned char blobauth[SHA1_DIGEST_SIZE];
>>> uint32_t pcrinfo_len;
>>> @@ -52,7 +61,12 @@ struct trusted_key_options {
>>> static inline void dump_options(struct trusted_key_options *o)
>>> {
>>> pr_info("trusted_key: sealing key type %d\n", o->keytype);
>>> - pr_info("trusted_key: sealing key handle %0X\n", o->keyhandle);
>>> + if (o->keyblob_len> 0) {
>>> + pr_info("trusted_key: sealing key blob %d\n", o->keyblob_len);
>>> + print_hex_dump(KERN_INFO, "keyblob ", DUMP_PREFIX_NONE,
>>> + 16, 1, o->keyblob, o->keyblob_len, 0);
>>> + } else
>>> + pr_info("trusted_key: sealing key handle %0X\n", o->keyhandle);
>>> pr_info("trusted_key: pcrlock %d\n", o->pcrlock);
>>> pr_info("trusted_key: pcrinfo %d\n", o->pcrinfo_len);
>>> print_hex_dump(KERN_INFO, "pcrinfo ", DUMP_PREFIX_NONE,
>>> @@ -90,6 +104,11 @@ static inline void dump_tpm_buf(unsigned char *buf)
>>> len = LOAD32(buf, TPM_SIZE_OFFSET);
>>> print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, buf, len, 0);
>>> }
>>> +static inline void dump_tpm_key12_handle(uint32_t handle)
>>> +{
>>> + print_hex_dump(KERN_INFO, "trusted-key: key handle ",
>>> DUMP_PREFIX_NONE,
>>> + 16, 1,&handle, 4, 0);
>>> +}
>>> #else
>>> static inline void dump_options(struct trusted_key_options *o)
>>> {
>>> @@ -106,6 +125,10 @@ static inline void dump_sess(struct osapsess *s)
>>> static inline void dump_tpm_buf(unsigned char *buf)
>>> {
>>> }
>>> +
>>> +static inline void dump_tpm_key12_handle(uint32_t handle)
>>> +{
>>> +}
>>> #endif
>>>
>>> static inline void store8(struct tpm_buf *buf, const unsigned char
>>> value)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

