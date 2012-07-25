Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2GYHsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:48:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45025 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2GYHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <28702.1343135952@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
 <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 25 Jul 2012 09:48:18 +0200
X-Google-Sender-Auth: osLdmrpQZRPaq5KdFIbmIdRfKNQ
Message-ID: <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com>
Subject: Re: [PATCH 00/13] UAPI header file split
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de, mingo@kernel.org, davej@redhat.com,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 3:19 PM, David Howells <dhowells@redhat.com> wrote:
> Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>
>> In the uapi-split branch, there are now 44 empty Kbuild files. Was
>> that intended? Or, should these files rather be removed by your
>> patches?
>
> To be removed by a later patch, I think.  Getting rid of some of them isn't
> trivial - ones in arch/x/include/asm/Kbuild for example - because that Kbuild
> is referenced by common code IIRC as a function of the arch.

>From a brief glance, I wonder if any of this could be automated. From
a quick inspection, some of the Kbuild files seem not to be referred
to elsewhere in the sources.

A few other points that I noticed now...

1. GIT HISTORY COULD BE RETAINED IN SOME CASES

This case appears to occur for several hundred of the uapi files.

When all of the content in a "kapi" file migrates to the uapi header,
the "kapi" file is simply removed, which makes sense. In that case,
the creation of the uapi file is effectively a "rename" operation.
But, as currently scripted the "new" uapi header file does not carry
over the git history of the old "kapi" header, even though it is an
exact duplicate of that file.

For example, the scripts in effect rename
include/asm-generic/posix_types.h to
include/uapi/asm-generic/posix_types.h, but the latter file carries
none of the git history of the former file.

In this case, would it nit be better that the git history *is*carried
over? i.e., those cases would be better scripted as the equivalent of
a 'git mv'.


2. EMPTY UAPI HEADERS

Some of the resulting uapi header files are empty:

include/uapi/asm-generic/kvm_para.h
include/uapi/linux/irqnr.h
arch/sparc/include/uapi/asm/sigcontext.h
arch/x86/include/uapi/asm/setup.h
arch/x86/include/uapi/asm/hw_breakpoint.h
arch/cris/include/uapi/asm/swab.h
arch/sh/include/uapi/asm/hw_breakpoint.h
arch/ia64/include/uapi/asm/kvm_para.h
arch/mn10300/include/uapi/asm/setup.h
arch/s390/include/uapi/asm/kvm_para.h

I imagine this should be reasonably easy to fix.


3. HEADER COMMENTS NOT RETAINED IN KAPI FILES

Another point that may be more difficult to fix is the following. Your
scripting is predicated on a header file structure that looks like
this:

    /* Header comments (copyright, author, license, etc) */
    #ifndef _GUARD_MACRO_H
    #define _GUARD_MACRO_H
    ...
    #endif

And the header comments get (sensibly) duplicated in the new uapi header file.

But some of the header files have this structure:

    #ifndef _GUARD_MACRO_H
    #define _GUARD_MACRO_H
    /* Header comments (copyright, author, license, etc) */
    ...
    #endif

With the consequence that the header comment is removed from the
original header file. Since there's often copyright and licensing
information in that comment, that seems undesirable. I wonder if some
work on the script could improve that situation. In particular, if
there's a header comment just after the #ifndef that contains
something like a copyright/author/license, then that should be
retained in the original header as well.

I wrote a short script against your output uapi header files that I
think captures all of the files where there is potential for
improvement:

egrep -l 'Author|\([cC]\)|[Cc]opyright |COPYRIGHT|[Ll]icensed|Modified' \
    $(grep -n '#ifndef'  $(find -name '*.h'|g uapi) | \
    grep ':1:' | awk -F':' '{print $1}')

That script finds 83 matching files, and in each case (two
exceptions), the single comment just below the #ifndef should ideally
be retained in the "kapi" header (if the "kapi" header itself is
retained, which appears to be the case in about 50% of the matching
uapi files). There are two special false positives from that script:

include/uapi/linux/netfilter/x_tables.h
arch/x86/include/uapi/asm/mce.h

The heuristic to correctly retain the comment in the "kapi" file would
be something like this (which would also handle the two exceptions
just noted):

if the "kapi" header is retained:
    if there was no header before the #ifndef guard:
        if there is a comment block immediately following
        the #ifndef guard:
            if that comment block contains one of the above strings:
                duplicate the comment block in the "kapi" header

Some special casing or manual prepatching might best handle the
following files, where it looks like there are two comments that
should ideally be retained:

include/uapi/linux/joystick.h
include/uapi/linux/ultrasound.h
include/uapi/linux/hiddev.h
include/uapi/linux/hid.h
include/uapi/linux/hidraw.h

Some other special casing may be needed for these files

include/uapi/linux/virtio_console.h
include/uapi/sound/emu10k1.h
include/uapi/linux/netfilter/xt_connmark.h


4. DISINTEGRATE MARKERS LEFT OVER (?)

Some of the DISINTEGRATE markers that you create during the scripting
process are left in the final uapi files. Was this intentional?

$ grep -rl 'DISINTEGRATE' .
./include/uapi/linux/acct.h
./include/uapi/linux/ncp.h
./include/uapi/linux/netfilter/xt_policy.h
./include/uapi/linux/coda.h
./arch/sparc/include/uapi/asm/termbits.h


Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
