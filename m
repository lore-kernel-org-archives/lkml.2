Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0HURIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:08:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0HURIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:08:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Miloslav =?utf-8?q?Trma=C4=8D?= <mitr@redhat.com>
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Date: Sat, 21 Aug 2010 19:08:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201008211908.03705.arnd@arndb.de>
X-Provags-ID: V02:K0:hwTLREVl0asrU7qwzAmlC3eOjqQa5WVzsXblvJhdwbV
 x59DlK8dt57pEjpRoGvVafi0SVaWsgJHvUu8LM7SVaIZcw4Zl2
 nzjzFXeLNYnYZAZD1mJ5wJ/pI319Cr9lUMsNdjRtjz1qcBMd4W
 Gex8pOXOyPDj4pjUCgcUBAqmoXC13mXBpw00iHv1WSI26PCTee
 qU20KfCqrIviLztIFFNEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 10:45:43 Miloslav Trmač wrote:
> 
> Major changes since the previous post:
> * "struct nlattr"-based extensible attributes used for extensibility
>   of most operations, both for input and output attributes

The API here looks overly complex resulting from the use of a combination
of ioctl and netlink. If your interface cannot be easily expressed using
simple (no indirect pointers or variable-length fields please) ioctl
and read/write operations, why not go all the way and turn the interface
into a netlink facility?

> * Full compat_ioctl implementation

New drivers should be written to *avoid* compat_ioctl calls, using only
very simple fixed-length data structures as ioctl commands.

> * Version number added to the data format used when wrapping keys for storage

Again, wrong direction. If you think you need a version number, the interface
is probably not ready for inclusion yet. Make sure it is simple enough that
you don't run into the case where you have to make incompatible changes
that require API versioning.

>   The libtom* patches will probably still be too large for the mailing list;
>   the whole patch set is also available at
>   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .

They actually seem to have made it to the list. However, the more signficant
problem is the amount of code added to a security module. 20000 lines of
code that is essentially a user-level library moved into kernel space
can open up so many possible holes that you end up with a less secure
(and slower) setup in the end than just doing everything in user space.
 
> Original patch set description follows.
> 
> These are the major differences compared to the BSD-like interface:
> 
> * The API supports key storage and management inside the kernel.
>   An application can thus ask the kernel to generate a key; the key is
>   then referenced via an integer identifier, and the application can be
>   prevented from accessing the raw key data.  Such a key can, if so configured,
>   still be wrapped for key transport to the recipient of the message, and
>   unwrapped by the recipient.

As Kyle mentioned, we already have a key management API in the kernel.
I think you should make a better effort of interfacing with that and
adding features you need to it, like a way to prevent the kernel from
handing out keys as you mentioned in your reply.

>   An user-space library is not separated, options are a) root
>   running daemon that does crypto, but this would be slow due to context
>   switches, scheduler mismatching and all the IPC overhead and b) use crypto
>   that is in the kernel.

I think you will have to back that statement by measurements. There are
reasonably fast ways to do IPC and the interface you suggest to put in the
kernel does not exactly look tuned for performance.
 
> * FIPS-140-3 calls out for cryptographic functions to be non-debuggable (ptrace)
>   meaning that you cannot get to the key material. The solution is the same as
>   above.

We have kgdb, kdb, qemu gdbserver, tracing and more things that would very
much make your code debuggable.

OTOH, disabling ptrace with a root-only prctl should be an easy thing to
implement if there is a use case for it.

> Other advantages to having kernel crypto available to user space:
> 
> * User space will be able to take advantage of kernel drivers for hardware
>   crypto accelerators.

I can see this as a good reason to put a proper interface for asymmetric
crypto into the kernel. There are PCI cards and other things that are
supported using ad-hoc interfaces right now. It would be wonderful
if someone could clean that up and create a simple common interface that
covers all the hardware variants.
But that does not justify putting a software implementation into the kernel.

For symmetric crypto and hashing hardware acceleration is typically
implemented as CPU instructions anyway and available to user space
already, without the need for kernel support.

> * glibc, which in some configurations links to libfreebl3.so for hashes
>   necessary for crypt(), will be able to use the kernel implementation; this
>   means one less library to load and dynamically link for each such process.

If you are really worried about library load times, you can probably create
a patch that statically links libfreebl3 into glibc.

	Arnd
