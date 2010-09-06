Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0IFVLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:11:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60565 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0IFVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WtMka5RyylIB6r7489B8woO/iJbtJmBKHMvwTs+SCPm2JIErJ824Nk8qUBF01TMYAO
         S2+ATbXwloS/wBzbl9UL986cdNO7Yv9SLyQAmzw2lu2hjtEITb3DUVE+Sh4dOkKj7n1g
         O67c9Vh0+7/cjXNq6NnRccu3NMdZVRbD85F3M=
Message-ID: <4C8558FD.2010107@gmail.com>
Date: Mon, 06 Sep 2010 23:11:25 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Miloslav Trmac <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
References: <272391166.1009231283787434910.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <169108422.1009631283788251084.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <AANLkTim=nf7VVs0zDshivjrdFFYeWaoWYqAA6PCs3c4k@mail.gmail.com> <4C853D69.2080108@gmail.com> <AANLkTi=kF880O_DuemgRPajvs3diyuvK8s4Ap04+kPzL@mail.gmail.com>
In-Reply-To: <AANLkTi=kF880O_DuemgRPajvs3diyuvK8s4Ap04+kPzL@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 10:42 PM, Kyle Moffett wrote:

>>> The problem with the approach you're proposing is that we then have
>>> two entirely separate classes of keys.  First we have the existing
>>> keyring class, which can be securely and revokably passed between
>>> different processes with limited rights, but cannot be handed up to
>>> the kernel's cryptoapi.
>>
>> I don't think this is the case. The NCR does not store any keys nor
>> retrieves them. It does delegate the burden of that to userspace
>> application. NCR exports a wrapped version of the key and the userspace
>> application stores it. It could use the keyring to store the keys or
>> could directly store them in the filesystem.
> 
> Hmm, I'm confused.  You say "The NCR does not store any keys nor
> retrieves them", but ~75% of your API is specifically related to
> storing keys into kernel memory or retrieving them out of kernel
> memory.
> Specifically, putting keys into and out of the kernel and
> passing them around between processes is the *whole point* of the
> keyring API.

I suppose you mean the reference to the internal representation of the
key. This might be valid for few seconds until the required operation is
over.
This is not really what I would call storage. The storage and retrieval
of keys is being done using two ioctl() the STORAGE_WRAP and STORAGE_UNWRAP.

An example of how NCR works:
1. A Process generates an RSA key pair
2. Stores the (encrypted) pair using the STORAGE_WRAP to a file.

3. Another process loads the file, unwraps it using STORAGE_UNWRAP and
gets a reference to the key
4. Does an RSA decryption using the key
5. Discards the reference to the key

Consider the reference as a file descriptor after you have opened a file
(a wrapped key).

How do you see keyring being involved in a setup like this?

> So let me ask for some clarification:
> You talk a lot in the patches about the API itself, but what is the
> intended *use-case* for NCR?

In short: cryptographic operations.

> Is it to provide a back-end for code such as enhanced-security OpenSSL
> libraries?  For example, a privileged process would loads a key from
> disk into the kernel, then fork the unprivileged SSL server process?

An unprivileged process will load a key from disk to kernel and use it.
The keys leave the NCR framework only encrypted and authenticated.

> Is it just a canonical interface for userspace to encrypt or decrypt
> data using the kernel's CryptoAPI?

I don't understand what do you mean by canonical, but this API can be
used to perform crypto operations. It uses the internal linux API where
possible.

regards,
Nikos
