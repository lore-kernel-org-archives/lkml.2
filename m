Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2JQWTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab2JQWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:19:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Date: Wed, 17 Oct 2012 23:19:42 +0100
Message-ID: <3179.1350512382@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds <torvalds@linux-foundation.org> wrote:

> This was based on the complaint from Davem that the "make
> allmodconfig" build got way slower because module signing takes a
> while.
> 
> And quite frankly, the whole "extra strip and sign" thing at modpost
> time was just nasty ugly code.
> 
> Why don't we do something *much* simpler? We already have a
> conditional stripping of modules (that whole INSTALL_MOD_STRIP) logic,
> and it really simplifies everything if we just do something very
> similar for the signing of modules. At "make modules_install" time,
> exactly like the stripping is done.

>From the point of view of generating Fedora/RHEL kernel RPMs, we probably
don't want to sign even at that point.  We want to do make modules_install,
run the debuginfo generator, then strip thoroughly and *then* sign.

As I understand it, Josh Boyer has a patch based on older code that adds a
modules_sign target or something like that signs the modules in their place of
installation as a separate step.  Even that much isn't really necessary:
there's a script provided to sign a module - it isn't necessary for the kernel
build to actually do it.  You can do it manually with:

	find $install_path -name "*.ko" | while read x
	do
		strip-as-appropriate $x
		./scripts/sign-file $key $x509 $x $x
	done

This is covered in the last part of Josh's blog entry on the subject:

	http://jwboyer.livejournal.com/44787.html

> Sure, it means that if you want to load modules directly from your
> kernel build tree (without installing them),

Which I do, especially for maintaining this.  It's much easier and quicker to
boot my test machine directly out of the build tree than have to build a fresh
kernel package and, especially, install it on the test machine each time I
make a change:-).

> you'd better be running a kernel that doesn't need the signing (or you need
> to sign things explicitly). But seriously, nobody cares.

True.  The only ones who really matter are the distribution kernels (including
things like Android in that).  They represent the vast majority of users of
kernels.  Everyone else is just in the noise - myself included, I guess.

> If you are building a module after booting the kernel with the intention of
> loading that modified module, you aren't going to be doing that whole module
> signing thing *anyway*.

You are mistaken in that.  We *do* want to be able to do this.  That's why
there's an extra_certificates file.

> Signed modules make sense when building the kernel and module together, so
> signing them as we install the kernel and module is just sensible.
>
> And it really is much simpler as shown by the diffstat: 13
> insertions(+), 78 deletions(-).
> 
> It seems to work for me from my (very very limited) testing. Comments?

It's probably even better to just get rid of all the automatic module signing
stuff completely and leave the sign-file script for the builder to use
manually.  The module verification code will still be present.

It would also be nice to get rid of the key autogeneration stuff.  I'm not
keen on the idea of unparameterised key autogeneration - anyone signing their
modules should really supply the appropriate address elements.  If we aren't
signing modules automatically, we can just insert an empty certificate if one
is not supplied to make allyes/modconfig work.

Distribution kernel packaging scripts (RPM spec files for example) can do the
key generation and the module signing from within the packaging fluff by
calling the script(s) the kernel provides.

We could then, perhaps, get rid of the extra_certificates file and just have
one certificates file that is the list of certs that get compiled into the
kernel, which can be filled in by the builder - though we still need access to
the specific X.509 certificate when signing so that we can put an ID into the
signature attached to the module.

David
