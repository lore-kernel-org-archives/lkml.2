Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2HPVLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:11:39 -0400
Received: from mga05.intel.com ([192.55.52.89]:8662 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463Ab2HPVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7usufUFqCGQEKsYn81eFinbAczcJmgqTTrNnUEx-nJxg@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<66e0f332c823b82701a48aba320f589cec27e904.1345055639.git.dmitry.kasatkin@intel.com>
	<CA+5PVA7usufUFqCGQEKsYn81eFinbAczcJmgqTTrNnUEx-nJxg@mail.gmail.com>
Date: Fri, 17 Aug 2012 00:11:34 +0300
Message-ID: <CALLzPKaTSe9wK=un45cRkxUTQo8b9t5+ASbY5Q7GcQveYVGt2A@mail.gmail.com>
Subject: Re: [RFC v2 3/7] integrity: create and inititialize a keyring with
 builtin public key
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 9:37 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
>> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
>>
>> Create and initialize a keyring with the builtin public key. This could
>> be an ephemeral key, created and destroyed during module install for
>> custom built kernels, or a key used to label the entire filesystem for
>> EVM/IMA-appraisal. Uses .incbin based on David Howell's post.
>>
>> Load the builtin public key on the specified keyring, creating the
>> keyring if it doesn't already exist.
>>
>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> ---
>>  security/integrity/Kconfig         |   10 ++++
>>  security/integrity/Makefile        |   17 +++++++
>>  security/integrity/digsig_pubkey.c |   96 ++++++++++++++++++++++++++++++++++++
>>  security/integrity/integrity.h     |   10 ++++
>>  4 files changed, 133 insertions(+)
>>  create mode 100644 security/integrity/digsig_pubkey.c
>>
>> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
>> index 5bd1cc1..f789018 100644
>> --- a/security/integrity/Kconfig
>> +++ b/security/integrity/Kconfig
>> @@ -17,5 +17,15 @@ config INTEGRITY_SIGNATURE
>>           This is useful for evm and module keyrings, when keys are
>>           usually only added from initramfs.
>>
>> +config INTEGRITY_PUBKEY
>> +       boolean "Create a keyring and initialize with builtin public key"
>> +       depends on INTEGRITY_SIGNATURE
>> +       default n
>> +       help
>> +         Create and initialize a keyring with the builtin public key. This could
>> +         be an ephemeral key, created and destroyed during module install for
>> +         custom built kernels, or a key used to label the entire filesystem for
>> +         EVM/IMA-appraisal.
>> +
>
> It could also be a key that is reused explicitly for signing kernels
> and kernel modules but has nothing to do with EVM/IMA filesystem
> labels, right?  E.g. a distro key.  I think the commit log and help
> text is a bit too restrictive here.
>
>> +int integrity_init_keyring(const unsigned int id)
>> +{
>> +       const struct cred *cred = current_cred();
>> +       struct user_struct *user = cred->user;
>> +       struct key *new_keyring, *key;
>> +       u8 digest[SHA1_DIGEST_SIZE];
>> +       char keyid[20];
>> +       int ret, pubkey_size = pubkey_end - pubkey;
>> +
>> +       if (pubkey_size == 0) {
>> +               pr_info("pubkey is missing, skipping...\n");
>> +               return 0;
>> +       }
>> +
>> +       new_keyring = keyring_alloc(keyring_name[id], user->uid, (gid_t) -1,
>> +                                   cred, KEY_ALLOC_NOT_IN_QUOTA,
>> +                                   user->uid_keyring);
>> +       if (IS_ERR(new_keyring)) {
>> +               ret = PTR_ERR(new_keyring);
>> +               goto out;
>> +       }
>> +
>> +       ret = integrity_calc_digest("sha1", pubkey, pubkey_size, digest);
>> +       if (ret < 0)
>> +               goto out;
>> +
>> +       sprintf(keyid, "%llX", __be64_to_cpup((uint64_t *)(digest+12)));
>
> keyid is only 20 bytes.  Is there a guarantee somewhere that restricts
> the digest+12 value to be 20 bytes or less and NUL termintated?  If
> not, should you use snprintf?
>

No.. Digest here is 20 bytes, but keyid is 8 bytes - it is u64...
It cannot go beyond here...

>> +
>> +       key = key_alloc(&key_type_user, keyid, 0, 0, current_cred(),
>> +                       (KEY_POS_ALL & ~KEY_POS_SETATTR) |
>> +                       KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_READ,
>> +                       KEY_ALLOC_NOT_IN_QUOTA);
>> +       if (IS_ERR(key)) {
>> +               ret = PTR_ERR(key);
>> +               goto out;
>
> You leak new_keyring if here, right?
>
>> +       }
>> +
>> +       ret = key_instantiate_and_link(key, pubkey, pubkey_end - pubkey,
>> +                                      new_keyring, NULL);
>> +out:
>> +       pr_info("integrity: loaded public key %s on %s %s\n", keyid,
>> +               keyring_name[id], !ret ? "succeeded" : "failed");
>> +       return ret;
>> +}
>
> josh
