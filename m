Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1HKRxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:53:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HKRxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:53:14 -0400
Date: Thu, 11 Aug 2011 12:40:06 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Cryptomgr race vs built-in aesni
Message-ID: <20110811164006.GA2167@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4TjqNjKKgDsnbfzC-s9U3m=ZtXWb6rCAOYGz_Vbzunrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fedora has had a bug[1] open for a while with people seeing this upon boot:

> [    0.807387] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2

> We're still seeing it with the 3.0 kernel, so I poked at it today.

<snip>

> So it seems that the aesni module is trying to register the ecb(aes) alg
> and before that completes (or something?) the test gets scheduled and
> tries to do a CRYPTO_MSG_ALG_REQUEST on something that hasn't
> finished it's module_init function yet.  Eventually the aesni_init function
> completes successfully (the last printk), so I'm assuming that the
> module is still present but that particular algorithm is listed as unavailable.

Ok, so it's not what I thought it was.  I did some more investigation today,
and it seems that the ablk_ebc_alg is missing the ivsize setting and the
crypto stack doesn't like that on a CRYPTO_ALG_TYPE_BLKCIPHER type.  I added
ivsize = AES_BLOCK_SIZE, and the error message goes away entirely.  This also
matches how ablk_cbc_alg works now, so I'm somewhat guessing this is correct.

My understanding of the crypto layer is at best non-existent, so if I'm wrong
please shout.  I'll send a patch sortly.

josh
