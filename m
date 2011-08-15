Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1HOLuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1HOLur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:50:47 -0400
Date: Mon, 15 Aug 2011 07:50:39 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110815115038.GA2227@zod.bos.redhat.com>
References: <20110811164040.GB2167@zod.bos.redhat.com>
 <20110815071528.GA29656@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815071528.GA29656@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 03:15:28PM +0800, Herbert Xu wrote:
> On Thu, Aug 11, 2011 at 12:40:41PM -0400, Josh Boyer wrote:
> > The ablkcipher structure in ablk_ecb_alg is lacking an ivsize setting.
> > This causes the algorithm to fail it's self-test when it's registered
> > with the error message:
> > 
> > [    0.806920] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2
> > 
> > crypto_lookup_skcipher doesn't like a missing ivsize.  Adding the ivsize
> > allows the self-test lookup to pass.
> 
> That's not right.  ECB does not require an IV and therefore it
> shouldn't have a non-zero IV size.

Hm.  OK.  
 
> I'm not quite sure what you mean by crypto_lookup_skcipher not
> liking a missing IV size.  It appears to handle that case just
> fine by returning the algorithm as is.

Well, yes, it does in this code:

	if (!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
					  alg->cra_ablkcipher.ivsize)) {

		printk(KERN_ERR "%s: %d\n", __func__, __LINE__);
		return alg;
	}

But the lookup seems to fail after it returns (see traces below).

> Can you show me what your /proc/crypto contains after you get the
> aformentioned error?


Sure.

Without the patch:

[jwboyer@zod ~]$ cat /proc/crypto 
name         : arc4
driver       : arc4-generic
module       : arc4
priority     : 0
refcnt       : 3
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : fpu(xts(__aes-aesni))
driver       : cryptd(fpu(xts(__driver-aes-aesni)))
module       : kernel
priority     : 50
refcnt       : 9
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : fpu(xts(__aes-aesni))
driver       : fpu(xts(__driver-aes-aesni))
module       : kernel
priority     : 0
refcnt       : 9
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : xts(__aes-aesni)
driver       : xts(__driver-aes-aesni)
module       : xts
priority     : 0
refcnt       : 9
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : xts(aes)
driver       : xts-aes-aesni
module       : kernel
priority     : 400
refcnt       : 9
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : eseqiv

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : xts(aes)
driver       : xts-aes-aesni
module       : kernel
priority     : 400
refcnt       : 9
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : pcbc(aes)
driver       : pcbc-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : lrw(aes)
driver       : lrw-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
geniv        : <default>

name         : rfc3686(ctr(aes))
driver       : rfc3686-ctr-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : rfc4106(gcm(aes))
driver       : rfc4106-gcm-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : nivaead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

name         : __gcm-aes-aesni
driver       : __driver-gcm-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 0
geniv        : <built-in>

name         : ctr(aes)
driver       : ctr-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : __ctr-aes-aesni
driver       : __driver-ctr-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(aes)
driver       : cbc-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : ecb-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : unknown
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : __cbc-aes-aesni
driver       : __driver-cbc-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : __ecb-aes-aesni
driver       : __driver-ecb-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : __aes-aesni
driver       : __driver-aes-aesni
module       : kernel
priority     : 0
refcnt       : 17
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-aesni
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32



With the patch:

[jwboyer@zod ~]$ cat /proc/crypto 
name         : arc4
driver       : arc4-generic
module       : arc4
priority     : 0
refcnt       : 3
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : fpu(xts(__aes-aesni))
driver       : cryptd(fpu(xts(__driver-aes-aesni)))
module       : kernel
priority     : 50
refcnt       : 9
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : fpu(xts(__aes-aesni))
driver       : fpu(xts(__driver-aes-aesni))
module       : kernel
priority     : 0
refcnt       : 9
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : xts(__aes-aesni)
driver       : xts(__driver-aes-aesni)
module       : xts
priority     : 0
refcnt       : 9
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : xts(aes)
driver       : xts-aes-aesni
module       : kernel
priority     : 400
refcnt       : 9
selftest     : passed
type         : givcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : eseqiv

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : xts(aes)
driver       : xts-aes-aesni
module       : kernel
priority     : 400
refcnt       : 9
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : pcbc(aes)
driver       : pcbc-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : lrw(aes)
driver       : lrw-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
geniv        : <default>

name         : rfc3686(ctr(aes))
driver       : rfc3686-ctr-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : rfc4106(gcm(aes))
driver       : rfc4106-gcm-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : nivaead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

name         : __gcm-aes-aesni
driver       : __driver-gcm-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 0
geniv        : <built-in>

name         : ctr(aes)
driver       : ctr-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : __ctr-aes-aesni
driver       : __driver-ctr-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(aes)
driver       : cbc-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(aes)
driver       : ecb-aes-aesni
module       : kernel
priority     : 400
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : __cbc-aes-aesni
driver       : __driver-cbc-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : __ecb-aes-aesni
driver       : __driver-ecb-aes-aesni
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : __aes-aesni
driver       : __driver-aes-aesni
module       : kernel
priority     : 0
refcnt       : 17
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-aesni
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32



And below is an instrumented kernel with some printks leading up to the
failure.

josh

Aug 11 11:31:34 zod kernel: [    0.799743] aesni_init: 1275 registering
ablk_ecb_alg
Aug 11 11:31:34 zod kernel: [    0.799792] __crypto_register_alg: 235
ecb(aes)
Aug 11 11:31:34 zod kernel: [    0.799862] crypto_alg_mod_lookup: 278
ecb-aes-aesni
Aug 11 11:31:34 zod kernel: [    0.799910] crypto_lookup_skcipher: 576
Aug 11 11:31:34 zod kernel: [    0.801540] crypto_alg_mod_lookup: 286
cryptd(__driver-ecb-aes-aesni)
Aug 11 11:31:34 zod kernel: [    0.802260] crypto_larval_wait: 192
Aug 11 11:31:34 zod kernel: [    0.802307] crypto_alloc_base: 452
Aug 11 11:31:34 zod kernel: [    0.802352] cryptd_alloc_ablkcipher: 828
Aug 11 11:31:34 zod kernel: [    0.802398] __crypto_alloc_tfm: 400
Aug 11 11:31:34 zod kernel: [    0.802444] __crypto_alloc_tfm:
(null) ffffffff8103ba69 -2
Aug 11 11:31:34 zod kernel: [    0.802494] alg: skcipher: Failed to load
transform for ecb-aes-aesni: -2
Aug 11 11:31:34 zod kernel: [    0.802546] Pid: 36, comm: cryptomgr_test
Not tainted 2.6.40-4.fc15.x86_64 #14
Aug 11 11:31:34 zod kernel: [    0.802548] Call Trace:
Aug 11 11:31:34 zod kernel: [    0.802554]  [<ffffffff81216042>]
alg_test_skcipher+0x48/0xa3
Aug 11 11:31:34 zod kernel: [    0.802557]  [<ffffffff812162f5>] ?
alg_find_test+0x3a/0x5d
Aug 11 11:31:34 zod kernel: [    0.802560]  [<ffffffff812164d8>]
alg_test+0x1c0/0x277
Aug 11 11:31:34 zod kernel: [    0.802563]  [<ffffffff814b5b33>] ?
schedule+0x690/0x6be
Aug 11 11:31:34 zod kernel: [    0.802566]  [<ffffffff81213fd2>] ?
cryptomgr_probe+0xca/0xca
Aug 11 11:31:34 zod kernel: [    0.802569]  [<ffffffff81213ffb>]
cryptomgr_test+0x29/0x44
Aug 11 11:31:34 zod kernel: [    0.802571]  [<ffffffff8106fd2b>]
kthread+0x84/0x8c
Aug 11 11:31:34 zod kernel: [    0.802575]  [<ffffffff814beb64>]
kernel_thread_helper+0x4/0x10
Aug 11 11:31:34 zod kernel: [    0.802577]  [<ffffffff8106fca7>] ?
kthread_worker_fn+0x148/0x148
Aug 11 11:31:34 zod kernel: [    0.802580]  [<ffffffff814beb60>] ?
gs_change+0x13/0x13
Aug 11 11:31:34 zod kernel: [    0.802586] aesni_init: 1278 err: 0
