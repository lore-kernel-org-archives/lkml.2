Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2EXOBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab2EXOBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:01:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8762blyedn.fsf@rustcorp.com.au>
References: <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Thu, 24 May 2012 15:00:51 +0100
Message-ID: <5107.1337868051@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> (1) Your scheme signing looks something like this:
>         gpg --sign $m > $m.sig
>         MSIZE=`ls -l $m | awk '{ print $5 }'`
>         SSIZE=`ls -l $m.sig | awk '{ print $5 }'`
>         
>         printf '@%-10i@%-10i@This Is A Crypto Signed Module' $MSIZE $SSIZE >> $m

It doesn't really need the @ signs or the MSIZE; they can be dropped.

		gpg --batch --no-greeting $(KEYFLAGS) -b $< && \
		stat --printf %-5s $<.sig >$@.trailer && \
		echo -n "This Is A Crypto Signed Module" >>$@.trailer && \
		cat $< $<.sig $@.trailer >$@

Further, the signature size field can be reduced to 5 decimal digits easily -
if the signature is larger than 99999 bytes, there's very likely a problem
somewhere.

Oh, and I should use --printf, not -c with stat as the newline char is unneeded.

That then adds 5 bytes to the magic string.  Is that really so bad?

And if you object to generating a foo.ko.trailer file, then:

		gpg --batch --no-greeting $(KEYFLAGS) -b $< && \
		(cat $< $<.sig && \
		 stat --printf %-5s $<.sig && \
		 echo -n "This Is A Crypto Signed Module" && \
		 ) >$@

Note that this scheme does not preclude using multiple signatures as you
desire, but since you have no record of the module length you'd either have to
parse all the signature records first to find the end of the module, or include
each preceding signature and marker in the digest for the next one (which
shouldn't be a problem).  You should still check all signatures anyway and
verify all for which you have the public key.

You could even stick other types of record in with different magic strings
terminating them, provided you include a length.

> (2) Your verification scheme looks like this:

A chunk of which can be discarded with the above reductions.

> Now, the scheme I suggested looks like this:
> ...
>         for (i = size - modsign_magic;
>              memcmp(data + i, modsign_magic, magic_size) != 0);
>              i++) {
>                 if (i == 0)
>                         return 1;
>         }

Which will likely oops.  You need to decrement i, not increment it, but that's
a minor detail.  You're also subtracting a pointer from a size.

And no, I won't do this.  It's unnecessary and a potentially large overhead.
Say you've got a module that's 7.7M in size (an unstripped, unsigned CIFS
module for example)...  That's nearly eight *million* calls to memcmp() if
there's no signature.  I suspect that's on the order of a tenth of a second or
longer on most machines.

Stripped, CIFS is still on the order of half a meg - which in itself translates
to half a million calls to memcmp() if there's no signature.

Furthermore, the data cache may be of limited utility as it can't do readahead
as you're scanning backwards through the image.  You'd be much better off doing
a memchr() or just open-coding a forward search for 'T', and then doing the
memcmp() at each instance.  Better still, don't do the scan at all.

Doing a SHA digest on some machines will be done with hardware assistance
(s390, for example) - so this scan may take longer than the digest there.

> > Why would you want multiple signatures?  That just complicates things.
> 
> The code above stays pretty simple; if the signature fails, you set size
> to i, and loop again.  As I said, if you know exactly how you're going
> to strip the modules, you can avoid storing the stripped module and
> simply append both signatures.

You still haven't justified it.  One of your arguments about rejecting the ELF
parsing version was that it was too big for no useful extra value that I could
justify.  Supporting multiple signatures adds extra size and complexity for no
obvious value.

More importantly, a major problem with (multiple) signatures is that each
signing event has to risk exposing the private key - so you really only want to
sign once unless you cannot avoid it.  Further, in an automated system, the
private key cannot be protected by a password as all the secrets have to be
passed to the signer.

Trying to automatically save a during-build generated private key or trying to
get a private key into the build from within the RHEL and Fedora automated
build systems risks having a key stolen or having someone substitute their own
key - and also makes it more complicated to build a kernel outside of the build
system.

The way I handle the private key in these patches is with transience: A fresh
key is generated during a build from a clean tree and then discarded when the
build tree is deleted.  This key is then a one-off.  If it is stolen or
cracked, it can only affect a single build of the kernel.

Note that we _do_ allow extra public keys to be installed in the kernel as
there's much less risk there, and further they have to be there to permit
signature verification.

David
