Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2GYKXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab2GYKXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:23:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com>
References: <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk> <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Wed, 25 Jul 2012 11:23:18 +0100
Message-ID: <6193.1343211798@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> A few other points that I noticed now...
> 
> 1. GIT HISTORY COULD BE RETAINED IN SOME CASES
> ...
> But, as currently scripted the "new" uapi header file does not carry
> over the git history of the old "kapi" header, even though it is an
> exact duplicate of that file.

How do you retain git history?  Git relies entirely on the git client to
notice the rename or excision within a single commit - and this seems to work.

No history derivation clues are stored in the git repo.  It only stores that
the tree was at point A and is now at point B.  How it got there is not
recorded.

> i.e., those cases would be better scripted as the equivalent of
> a 'git mv'.

That's just a macro for "mv; git rm; git add", I believe.

> 2. EMPTY UAPI HEADERS
>
> Some of the resulting uapi header files are empty:
> ...
> I imagine this should be reasonably easy to fix.

Fix how?  The Kbuild files say these headers must exist in UAPI space, but the
__KERNEL__ guards therein don't define any content for them in UAPI.

> 3. HEADER COMMENTS NOT RETAINED IN KAPI FILES
> 
> Another point that may be more difficult to fix is the following. Your
> scripting is predicated on a header file structure that looks like
> this:
> 
>     /* Header comments (copyright, author, license, etc) */
>     #ifndef _GUARD_MACRO_H
>     #define _GUARD_MACRO_H
>     ...
>     #endif
> 
> And the header comments get (sensibly) duplicated in the new uapi header file.
> 
> But some of the header files have this structure:
> 
>     #ifndef _GUARD_MACRO_H
>     #define _GUARD_MACRO_H
>     /* Header comments (copyright, author, license, etc) */
>     ...
>     #endif

Yeah.  The problem was that the header following the guard also might not be
such, but as you say, checking for:

	copyright
	author
	licen[sc]e
	GPL
	warranty
	warranties
	merchantability
	liability

in the comment might well work.

> Some special casing or manual prepatching might best handle the
> following files, where it looks like there are two comments that
> should ideally be retained:

I see.

> Some other special casing may be needed for these files
> 
> include/uapi/linux/virtio_console.h
> include/uapi/sound/emu10k1.h
> include/uapi/linux/netfilter/xt_connmark.h

Hmmm.  Well, the virtio_console.h comment can actually be suitably modified to
get rid of the bit about __KERNEL__ for the UAPI file, I think.

It's looking like any comment that mentions one or more of the key words above
should be duplicated.

> 4. DISINTEGRATE MARKERS LEFT OVER (?)
> 
> Some of the DISINTEGRATE markers that you create during the scripting
> process are left in the final uapi files. Was this intentional?

Ummm... no, there shouldn't be any.

Certainly the marker has worked (the __KERNEL__ guard got retained), but I'm
not sure why it didn't get removed.  Probably my understanding of the black
magic required to make perl do what I want is lacking.

David
