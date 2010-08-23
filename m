Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0HWPjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:39:12 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55518 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751520Ab0HWPjK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:39:10 -0400
Date: Mon, 23 Aug 2010 11:37:40 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Message-ID: <1269957386.1124701282577860651.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1278368294.1123931282577639823.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Kyle Moffett" <kyle@moffetthome.net> wrote:
> On Fri, Aug 20, 2010 at 04:45, Miloslav Trmač <mitr@redhat.com>
> wrote:
> > * ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
> >  material inside the kernel, load a plaintext key, unwrap a key, or
> >  derive a key.  Similarly the key material can be copied out of the
> >  kernel or wrapped.
> >
> Ugh... We already have one very nice key/keyring API in the kernel
> (see Documentation/keys.txt) that's being used for crypto keys for
> NFSv4, AFS, etc.  Can't you just add a bunch of cryptoapi key types to
> that API instead?
I have examined that API; going purely by the names, having only one facility to manage "keys" does sound reasonable.

Looking at the details, the keyring API is primarily designed for long-term secure storage of unstructured, named blobs, in various namespaces - in some respects it is quite similar to a memory-only filesystem: each key has an explicit name and permissions, there is a hierarchy, and keys are designed to be shared between processes (although in some namespaces they are not).

The keys for crypto are often short-lived, almost exclusively local to a specific process, most don't have an unique name (which means a kernel-choosen integer is a better identifier than an application-choosen string, especially if user-space libraries hide the existence of the kernel crypto API from applications, because choosing an unique string identifier is non-trivial).  The crypto keys also are also formatted for use by a specific algorithm, often using a non-trivial format (e.g. a RSA key should be internally stored as the separate integer components, not as a blob).  They have some attribute flags, with no overlap with the flags in the keyring API.

I can see almost no overlap between the two sets of requirements.  Probably the only common use case is handling session keys (e.g. keys used in a kerberos ticket), which should be stored in the kernel for the duration of the session, made available to each process in the session, and available as keys for kernel crypto.  Such keys will be in the minority, though, and it seems to me the best approach for handling these is to allow key export/import from/to keyring keys in addition to export/import from/to data in userspace: the long-term storage would be handled by the existing keyring API, which stores the key as unformatted binary data, and import into the crypto context would convert the key into the internal representation more suitable for crypto.

I have seriously considered the keyring API, and this is what I came up with - but I'd love to be shown a better way.
    Mirek
