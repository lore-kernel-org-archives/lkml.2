Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919Ab2FWA2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:28:53 -0400
Received: from ozlabs.org ([203.10.76.45]:49484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab2FWA2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:28:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <25337.1340362993@redhat.com>
References: <8762akt2j4.fsf@rustcorp.com.au> <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com> <87r4u6w58c.fsf@rustcorp.com.au> <20120622015341.GA3414@kroah.com> <25337.1340362993@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 23 Jun 2012 09:50:31 +0930
Message-ID: <87wr2yswts.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 12:03:13 +0100, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > 1) No userspace needs to be modified to use the appended signature.
> >    modprobe doesn't.  depmod doesn't.  Even strip doesn't (not that
> >    that's much use).
> 
> Anything that currently automatically strips the module: mkinitrd perhaps?

True, if mkinitrd strips the module, it will break the signature.

> If we use a new system call, then the list includes a few more things.

Sure, but that's kind of independent of what Greg was asking.

> Your idea of providing multiple variants of the module, each signed and each
> with different levels of strippedness makes things more complicated - both at
> build/package generation time and at usage time (where 'use' may be loading
> the module or packaging it into a initrd).

Userspace a bit more complex.  Kernel simpler.  Win.

> > 2) It's far easier to add an appended signature than to add an elf
> >    section.
> 
> That's not true.  That bit of complexity in my implementation comes because
> I'm adding it as an ELF Note - which someone suggested I should do instead of
> just using an unstructured section.
> 
> If we reverted to an unstructured section, it's just one objcopy command, eg:
> 
> 	objcopy \
> 		--add-section .modsign=/etc/redhat-release \
> 		--set-section-flags .modsign=load \
> 		/bin/ls /tmp/ls
> 
> And for debugging purposes, removing it is:
> 
> 	objcopy \
> 		-R .modsign \
> 		/bin/ls /tmp/ls

OK, s/far//.  We already rely on objcopy for kernel builds, so no
additional requirements.

> > 3) It's far easier to generate an appended signature than to generate
> >    a signature for the module which will change when you add the
> >    signature section (roughly: gpg --sign module.ko > sig && echo
> >    '@@sig@@ >> module.ko && cat sig >> module.ko).
> 
> You would be better off putting the magic number last and including a length
> field right before.  That's much more efficient and much simpler.

No, that was more complex and tasteless.

> > 4) It's trivial to verify a module with an appended signature before you
> >    touch it.  With a section you need to carefully parse the module,
> >    make sure you don't include the could-be-modified stuff in the
> >    signature, and avoid any possible overflows or exploits.
> 
> I have to say that here Rusty is correct.  If the signature is embedded in the
> ELF, then the ELF needs a bit of careful checking first.  But, excluding the
> crypto bits which are the same in all cases, I managed to get the entire ELF
> parser/checker/canonicaliser, digest extractor and policy determiner down to a
> little over 2K of x86_64 code.

I've been tempted to search for a hole in your parsing code.  But while
finding one would be satisfying, not finding one isn't conclusive.  So
it's a waste of time.

> This is quite a good a trade off.  It simplifies building and installation a
> lot.  There is only one binary for each module.  That binary can be stripped
> quite aggressively - any strip that would ordinarily leave the module
> functional won't affect the signature verification.

Wouldn't it be nice if strip removed nop padding at the end of text
sections?

Cheers,
Rusty.
