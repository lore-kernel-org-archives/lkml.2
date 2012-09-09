Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2IIUyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:54:11 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:38894 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2IIUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:54:08 -0400
Message-ID: <20120909235404.747466tf3h2pbf48@www.81.fi>
Date: Sun, 09 Sep 2012 23:54:04 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909155424.862635h7ncykg9s0@www.81.fi>
 <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
 <20120909185358.GA9782@gondor.apana.org.au>
In-Reply-To: <20120909185358.GA9782@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> On Sun, Sep 09, 2012 at 08:35:56AM -0700, Linus Torvalds wrote:
>> On Sun, Sep 9, 2012 at 5:54 AM, Jussi Kivilinna
>> <jussi.kivilinna@mbnet.fi> wrote:
>> >
>> > Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?
>> >
>> > That commit added crypto selftest for authenc(hmac(sha1),cbc(aes)) in 3.6,
>> > and probably made this bug visible (but not directly causing it).
>>
>> So Romain said it does - where do we go from here? Revert testing it,
>> or fix the authenc() case? I'd prefer the fix..
>
> I'm working on this right now.  If we don't get anywhere in a
> couple of days we can revert the test vector patch.
>

It seems that authenc is chaining empty assoc scatterlist, which causes
BUG_ON(!sg->length) set off in crypto/scatterwalk.c.

Following fixes the bug and self-test passes, but not sure if it's correct
(note, copy-paste to 'broken' email client, most likely does not apply etc):

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5ef7ba6..2373af5 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -336,7 +336,7 @@ static int crypto_authenc_genicv(struct  
aead_request *req, u8 *iv,
                 cryptlen += ivsize;
         }

-       if (sg_is_last(assoc)) {
+       if (req->assoclen > 0 && sg_is_last(assoc)) {
                 authenc_ahash_fn = crypto_authenc_ahash;
                 sg_init_table(asg, 2);
                 sg_set_page(asg, sg_page(assoc), assoc->length,  
assoc->offset);


Also does crypto_authenc_iverify() need same fix?

-Jussi

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>



