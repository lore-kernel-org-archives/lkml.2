Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0IGDGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:06:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0IGDGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <4C8558FD.2010107@gmail.com>
References: <272391166.1009231283787434910.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <169108422.1009631283788251084.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <AANLkTim=nf7VVs0zDshivjrdFFYeWaoWYqAA6PCs3c4k@mail.gmail.com>
 <4C853D69.2080108@gmail.com> <AANLkTi=kF880O_DuemgRPajvs3diyuvK8s4Ap04+kPzL@mail.gmail.com>
 <4C8558FD.2010107@gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 6 Sep 2010 23:05:54 -0400
Message-ID: <AANLkTimmue10v8TRSXSL51CdHibF-tUVpGmrFJj5JHuv@mail.gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
To: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Cc: Miloslav Trmac <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 17:11, Nikos Mavrogiannopoulos
<n.mavrogiannopoulos@gmail.com> wrote:
> I suppose you mean the reference to the internal representation of the
> key. This might be valid for few seconds until the required operation is
> over.
>
> This is not really what I would call storage. The storage and retrieval
> of keys is being done using two ioctl() the STORAGE_WRAP and STORAGE_UNWRAP.
>
> An example of how NCR works:
> 1. A Process generates an RSA key pair
> 2. Stores the (encrypted) pair using the STORAGE_WRAP to a file.
>
> 3. Another process loads the file, unwraps it using STORAGE_UNWRAP and
> gets a reference to the key
> 4. Does an RSA decryption using the key
> 5. Discards the reference to the key
>
> Consider the reference as a file descriptor after you have opened a file
> (a wrapped key).
>
> How do you see keyring being involved in a setup like this?

Fundamentally the operations you described are *EXACTLY* the kind of
things that I believe the keyring API should support.  It does not
support them now, but that API is where the described functionality
really belongs.  Please consider just extending the keyring API to
support what you need.

For example, assuming that we automatically register 1 keyring key
type per algo it should be pretty straightforward.

You would want to write a "request_key()" handler for those key types
which can use whatever hardware support is available to automatically
generate a new random key or alternatively pass the operation off to
the /sbin/request-key process to generate and load one from userspace.
 The call might take a *long* time to complete, depending on the key
type and whether or not there is hardware support.

That would allow you to perform the "generate an RSA key" step in
either a trusted "request-key" process or directly in a piece of
hardware, helping to avoid accidental key material leaks from the
unprivileged process.

Then, you would want "KEYCTL_DECRYPT_KEY", and "KEYCTL_ENCRYPT_KEY"
which would use one key to encrypt another into a user buffer (or
decrypt a key from a user buffer).  These would probably need new LSM
hooks and maybe key DAC permission bits.

This would implement the "STORAGE_WRAP" and "STORAGE_UNWRAP"
functionality you want, but it would be extensible to much more than
just what NCR needs.  I could see this being very useful as an
extension to the existing Kerberos or NFS keyring usage.  Other
potential applications include very secure replacements for the SSH or
GPG agent programs.

For the final step of actually performing encryption/decryption of
user data you would then want generic keyctl() ops for
"KEYCTL_ENCRYPT" and "KEYCTL_DECRYPT", which would simply call
CryptoAPI with the user-provided input and output buffers.  Again,
you'd need new LSM hooks, etc.  These are very obviously extensible to
other applications.

It's getting a bit late here, so I apologize if anything I've written
above makes particularly little sense, but hopefully I've gotten the
gist across.

Cheers,
Kyle Moffett
