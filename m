Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2IYMP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab2IYMPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:15:54 -0400
Message-ID: <5061A071.2090104@redhat.com>
Date: Tue, 25 Sep 2012 14:15:45 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/1] dm-integrity: integrity protection device-mapper
 target
References: <cover.1348480396.git.dmitry.kasatkin@intel.com> <50606456.7020607@redhat.com> <CALLzPKbRk0NSS44Wq46SMPq7--NLG0+rjK8QxVfnaz25q=LX8Q@mail.gmail.com>
In-Reply-To: <CALLzPKbRk0NSS44Wq46SMPq7--NLG0+rjK8QxVfnaz25q=LX8Q@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/24/2012 06:20 PM, Kasatkin, Dmitry wrote:

>> So it can provide confidentiality but it CANNOT provide integrity protection.
>>
> Yes, it provides confidentiality and via encryption it provides
> certain level of integrity protection.
> Data cannot be modified without being detected.
> Decryption will result in garbage...

It should, but it is not cryptographic integrity protection.
Moreover, you can revert ciphertext sector content.

Btw I think dm-integrity doesn't solve the reply problem as well.

(IOW can you replace/revert both data and hash, still using the same key
in keyring, without dm-integrity able to detect it?)

In dm-verity, root hash will change after such data tampering.

>> Obvious question: can be dm-verity extended to provide read-write integrity?
>>
> 
> I think re-calculating hash trees all the time and syncing block
> hashes and tree itself is heavier operation...

Then why not extend dm-verity to use you hash format? There are options
for that and we can redefine table line if necessary.

(You are duplicating a lot of code here otherwise, not counting userspace yet.)

Whatever, I shortly read the code and have some notes.

First, device-mapper is variable system, you can stack devices in arbitrary order.

Unfortunately, this is something what can be dangerous in crypto, here you can e.g.
 - do mac (integrity) then encrypt
 - do encrypt, then check integrity

In many implementations mac-then-encrypt system was not secure.
Are we sure that it cannot provide side channels here?

Note read-only integrity target (like dm-verity) is specific case, you should
not be able to run any chosen ciphertext attacks here, it is read-only device.

In fact, I am not sure if we should provide separate read-write block integrity
(wihtout encryption) target at all.

Either it should use standard mode of authenticated encryption (like GCM)
or data integrity should be upper layer business (which knows better which data
really need integrity checking and which areas are just unused garbage.
If you consider hashing and encryption as "heavy operation" you should minimize
it to only really used area - and only upper layer know about real used data content.)

(Again, this is different for read-only target, where it usually uses compressed
RO fs image which uses all available space.)


1) discards
It seems the dm-integrity target doesn't solve problem with discards.

If you send discard request to underlying device, data content of discarded area
is undefined (or zeroed if discards zeroes data) but is is definitely "invalid"
form the dm-integrity point of view. And you are allowing discard IOs there.

I am not sure what should happen, but the behaviour should be documented (at least)
or disabled.

2)
All used hash algorithms must be configurable.

>From your doc:

+While NIST does recommend to use SHA256 hash algorithm instead of SHA1,
+this does not apply to HMAC(SHA1), because of keying.
+This target uses HMAC(SHA1), because it takes much less space and it is
+faster to calculate. There is no parameter to change hmac hash algorithm.

While this is technically true, http://csrc.nist.gov/groups/ST/hash/policy.html
disallowing use of another hash algorithm is wrong, and in fact it is regression
in comparison with dm-verity (which already implements all needed calculations
and uses hash name as table line option).

+HMAC(SHA1) size is 20 bytes. So every 4k block on the integrity device can
+store 204 hmacs. In order to get the required size of the integrity device,
+it is necessary to divide data device size by 204.

Why are you hardcoding block and hash sizes?
Again, dm-verity have this configurable with some good default.

ditto for kernel keyring:
+       const char *hmac_algo = "hmac(sha1)"; /* uncompromized yet */

3)
I like that this target can use kernel keyring, in fact, we should implement
similar option to dm crypt/verity. But the target should not be limited
to use TPM keys only.
(And key is stored directly in kernel memory later for hash calculation anyway
allowing hw attacks reading it from RAM.)

4)
reboot notifier cannot be used this way in generic storage stacking IMHO,
but I think there was discussion with Mikulas already
http://www.redhat.com/archives/dm-devel/2012-March/msg00164.html

5)
output target table should not translate device to device symbolic names

Anyway, code can be changed. But the high level questions remains...

Milan
