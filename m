Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400Ab2FVLDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:03:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab2FVLDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:03:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8762akt2j4.fsf@rustcorp.com.au>
References: <8762akt2j4.fsf@rustcorp.com.au> <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com> <87r4u6w58c.fsf@rustcorp.com.au> <20120622015341.GA3414@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Fri, 22 Jun 2012 12:03:13 +0100
Message-ID: <25337.1340362993@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> 1) No userspace needs to be modified to use the appended signature.
>    modprobe doesn't.  depmod doesn't.  Even strip doesn't (not that
>    that's much use).

Anything that currently automatically strips the module: mkinitrd perhaps?

If we use a new system call, then the list includes a few more things.

Your idea of providing multiple variants of the module, each signed and each
with different levels of strippedness makes things more complicated - both at
build/package generation time and at usage time (where 'use' may be loading
the module or packaging it into a initrd).

> 2) It's far easier to add an appended signature than to add an elf
>    section.

That's not true.  That bit of complexity in my implementation comes because
I'm adding it as an ELF Note - which someone suggested I should do instead of
just using an unstructured section.

If we reverted to an unstructured section, it's just one objcopy command, eg:

	objcopy \
		--add-section .modsign=/etc/redhat-release \
		--set-section-flags .modsign=load \
		/bin/ls /tmp/ls

And for debugging purposes, removing it is:

	objcopy \
		-R .modsign \
		/bin/ls /tmp/ls

> 3) It's far easier to generate an appended signature than to generate
>    a signature for the module which will change when you add the
>    signature section (roughly: gpg --sign module.ko > sig && echo
>    '@@sig@@ >> module.ko && cat sig >> module.ko).

You would be better off putting the magic number last and including a length
field right before.  That's much more efficient and much simpler.

> 4) It's trivial to verify a module with an appended signature before you
>    touch it.  With a section you need to carefully parse the module,
>    make sure you don't include the could-be-modified stuff in the
>    signature, and avoid any possible overflows or exploits.

I have to say that here Rusty is correct.  If the signature is embedded in the
ELF, then the ELF needs a bit of careful checking first.  But, excluding the
crypto bits which are the same in all cases, I managed to get the entire ELF
parser/checker/canonicaliser, digest extractor and policy determiner down to a
little over 2K of x86_64 code.

Since the ELF loader/linker has to parse much of this stuff anyway, it might
be possible to combine the two to some extent.

> 5) It wasn't just that they wanted an elf section.  They wanted the
>    signature to work against both a stripped and unstripped module, so
>    only the unstrippable parts of the module were signed.

Yes.  Those are the bits that the module loader needs...

This is quite a good a trade off.  It simplifies building and installation a
lot.  There is only one binary for each module.  That binary can be stripped
quite aggressively - any strip that would ordinarily leave the module
functional won't affect the signature verification.  Any content or metadata
change that affects the module's operational code and data is detected.

> > And I think we really want the ability to have multiple signatures, the
> > whole "chain of trust" thing that is needed will work out much better if
> > multiple signatures are allowed.  Putting it in an elf section allows
> > this to work out easier, right?
> 
> Not at all.  Multiple appended signatures is trivial.  Figuring out the
> semantics (do they chain, or is any one sufficient?), well that's the
> same whether you're talking about an ELF section or not.

Agreed, it makes no difference either way.

But it doesn't necessarily work with a new syscall that has an extra pair of
args for passing a signature.  The kernel really wants to have all the
available sigs available in one go so that it can implement its policy (which
might be to panic in FIPS mode).

David
