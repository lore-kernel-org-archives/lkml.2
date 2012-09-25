Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2IYPm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:42:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:37754 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757046Ab2IYPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <5061A071.2090104@redhat.com>
References: <cover.1348480396.git.dmitry.kasatkin@intel.com>
	<50606456.7020607@redhat.com>
	<CALLzPKbRk0NSS44Wq46SMPq7--NLG0+rjK8QxVfnaz25q=LX8Q@mail.gmail.com>
	<5061A071.2090104@redhat.com>
Date: Tue, 25 Sep 2012 18:42:09 +0300
Message-ID: <CALLzPKYofrP8w-yim89cGdNKSLGOas3yyaQ9AuZEc3i1DYCvwg@mail.gmail.com>
Subject: Re: [PATCH 0/1] dm-integrity: integrity protection device-mapper target
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 3:15 PM, Milan Broz <mbroz@redhat.com> wrote:
>
> On 09/24/2012 06:20 PM, Kasatkin, Dmitry wrote:
>
>>> So it can provide confidentiality but it CANNOT provide integrity protection.
>>>
>> Yes, it provides confidentiality and via encryption it provides
>> certain level of integrity protection.
>> Data cannot be modified without being detected.
>> Decryption will result in garbage...
>
> It should, but it is not cryptographic integrity protection.
> Moreover, you can revert ciphertext sector content.
>
> Btw I think dm-integrity doesn't solve the reply problem as well.
>
> (IOW can you replace/revert both data and hash, still using the same key
> in keyring, without dm-integrity able to detect it?)

Yes, reply problem is the same. It is context free.

>
> In dm-verity, root hash will change after such data tampering.
>

yes, I know.

>>> Obvious question: can be dm-verity extended to provide read-write integrity?
>>>
>>
>> I think re-calculating hash trees all the time and syncing block
>> hashes and tree itself is heavier operation...
>
> Then why not extend dm-verity to use you hash format? There are options
> for that and we can redefine table line if necessary.
>

dm-integrity does not use hash tree.
switching tree to hmac needs to recalculating everything.
It simply does not make sense.

> (You are duplicating a lot of code here otherwise, not counting userspace yet.)
>
All targets have similarities here and there.
At the end they work in different way.
>From source code point of it is clearer to keep them separately as
they do things in different way.

It does not require any user space tools.

> Whatever, I shortly read the code and have some notes.
>
> First, device-mapper is variable system, you can stack devices in arbitrary order.
>
> Unfortunately, this is something what can be dangerous in crypto, here you can e.g.
>  - do mac (integrity) then encrypt
>  - do encrypt, then check integrity
>
> In many implementations mac-then-encrypt system was not secure.
> Are we sure that it cannot provide side channels here?
>
> Note read-only integrity target (like dm-verity) is specific case, you should
> not be able to run any chosen ciphertext attacks here, it is read-only device.
>
> In fact, I am not sure if we should provide separate read-write block integrity
> (wihtout encryption) target at all.
>
> Either it should use standard mode of authenticated encryption (like GCM)
> or data integrity should be upper layer business (which knows better which data
> really need integrity checking and which areas are just unused garbage.
> If you consider hashing and encryption as "heavy operation" you should minimize
> it to only really used area - and only upper layer know about real used data content.)
>
> (Again, this is different for read-only target, where it usually uses compressed
> RO fs image which uses all available space.)
>


Again, as it is written in cover letter.
It can be used for certain use cases, which does not want encryption
for performance
or data transforming reasons...


>
> 1) discards
> It seems the dm-integrity target doesn't solve problem with discards.
>
> If you send discard request to underlying device, data content of discarded area
> is undefined (or zeroed if discards zeroes data) but is is definitely "invalid"
> form the dm-integrity point of view. And you are allowing discard IOs there.
>

I will check about it.

> I am not sure what should happen, but the behaviour should be documented (at least)
> or disabled.
>
> 2)
> All used hash algorithms must be configurable.
>

dm-integrity uses HASH and HMAC together for HW enabling reasons...
Hash is calculated using async API and HMAC is sync.

Hash algorithm is configurable. There is a target parameter for that

<dev_path> <offset> <hdev_path> <hoffset> <hash_algo> <key_desc> [<opt_params>]

HMAC is different...
Because of using key, hmac(sha1) is not vulnerable to attacks as sha1...
There is currently absolutely no reason to use hmac(sha256) or other.
hmac(sha1) is absolutely enough...

Before I used only sync API and it was a parameter for hmac only.
Now there is hash only parameter..

But this is not an issue. I could easily have a parameter for hmac..

> From your doc:
>
> +While NIST does recommend to use SHA256 hash algorithm instead of SHA1,
> +this does not apply to HMAC(SHA1), because of keying.
> +This target uses HMAC(SHA1), because it takes much less space and it is
> +faster to calculate. There is no parameter to change hmac hash algorithm.
>
> While this is technically true, http://csrc.nist.gov/groups/ST/hash/policy.html
> disallowing use of another hash algorithm is wrong, and in fact it is regression
> in comparison with dm-verity (which already implements all needed calculations
> and uses hash name as table line option).
>
> +HMAC(SHA1) size is 20 bytes. So every 4k block on the integrity device can
> +store 204 hmacs. In order to get the required size of the integrity device,
> +it is necessary to divide data device size by 204.
>

This is just an example to understand space requirements
Documentation/device-mapper/dm-integrity.txt
has scripts examples how to enable target.
No user space tools are required...


> Why are you hardcoding block and hash sizes?
> Again, dm-verity have this configurable with some good default.
>

I do not hard-code hash sized...
there are:
crypto_shash_digestsize(dmi->hmac);
crypto_ahash_digestsize(dmi->ahash)

Yes... block size is hard coded..
Did not use other then 4k.

> ditto for kernel keyring:
> +       const char *hmac_algo = "hmac(sha1)"; /* uncompromized yet */
>

Explained above...

> 3)
> I like that this target can use kernel keyring, in fact, we should implement
> similar option to dm crypt/verity. But the target should not be limited
> to use TPM keys only.
> (And key is stored directly in kernel memory later for hash calculation anyway
> allowing hw attacks reading it from RAM.)

No... It is not limited to TPM....
Encrypted keys use either user master key or TPM to encrypt the key...

Kernel keyring keeps keys in the memory..
And dm-crypt also keeps key in the memory. Right?


>
> 4)
> reboot notifier cannot be used this way in generic storage stacking IMHO,
> but I think there was discussion with Mikulas already
> http://www.redhat.com/archives/dm-devel/2012-March/msg00164.html
>

Yes. I had a question..

reboot norifier is a last resort here...
file system first is remount "RO"... and flushed..
And then dm-integrity will also need to write buffers to the storage...

Are there better way?

> 5)
> output target table should not translate device to device symbolic names

I thought so as well when last time looked to that.

>
> Anyway, code can be changed. But the high level questions remains...
>

Block size parameter might be easily added. Just did not use other
then page size.

Based on my clarifications about hash and hmac do you still think that
hmac(sha1) should also be configurable?

Thanks,
Dmitry


> Milan
