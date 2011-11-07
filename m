Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1KGT6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:58:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65228 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1KGT6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <874nygu3cd.fsf@rustcorp.com.au>
References: <467be983bed865e1b772136ed488f9ff@localhost>
	<874nygu3cd.fsf@rustcorp.com.au>
Date: Mon, 7 Nov 2011 11:58:08 -0800
Message-ID: <CAJiQ=7D4SSzzkPpPMGnaTq-wZXUGmXCRfKhYdPFg7APDu+VTwA@mail.gmail.com>
Subject: Re: [PATCH] module: Fix performance regression on modules with large
 symbol tables
From: Kevin Cernekee <cernekee@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 5:29 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> I see you honored Jan's original patch by leaving it mysterious and
> undocumented.  I was totally confused by your patch.

Sorry - was just trying to mimic the existing level of verbosity.

> But I don't think it quite works in general.  gcc is allowed to
> compact the strtab itself, eg with two names "foobar" and "bar", it
> can reuse the tail of the first strtab entry.  It may not yet, but it
> could.

Well, sure enough, libbfd's elf-strtab.c is advertised as:

/* ELF strtab with GC and suffix merging support. */

The function that performs the suffix merging is
_bfd_elf_strtab_finalize().  For some reason this only seems to get
called for .shstrtab (or .dynstr), not for the larger .strtab .  And I'm
not sure why this would be useful for .shstrtab, since the section names
usually start with '.'.  I guess it might save a few dozen bytes for
cases like .init.data or .exit.text .

But as you said, there is nothing keeping the binutils maintainers from
extending this to .strtab in the future.

One thing I noticed when making a test case was that the earliest entry
in the section table doesn't necessarily pick the longest substring:

  [ 1] .text             PROGBITS         0000000000000000  00000040
       0000000000000006  0000000000000000  AX       0     0     4
  [ 2] .data             PROGBITS         0000000000000000  00000048
       0000000000000000  0000000000000000  WA       0     0     4
  [ 3] .bss              NOBITS           0000000000000000  00000048
       0000000000000000  0000000000000000  WA       0     0     4
  [ 4] a_                PROGBITS         0000000000000000  00000048
       0000000000000006  0000000000000000  AX       0     0     1
  [ 5] fedcba_           PROGBITS         0000000000000000  0000004e
       0000000000000006  0000000000000000  AX       0     0     1
  [ 6] cba_              PROGBITS         0000000000000000  00000054
       0000000000000006  0000000000000000  AX       0     0     1

Hex dump of section '.shstrtab':
  0x00000000 002e7379 6d746162 002e7374 72746162 ..symtab..strtab
  0x00000010 002e7368 73747274 6162002e 74657874 ..shstrtab..text
  0x00000020 002e6461 7461002e 62737300 67666564 ..data..bss.gfed
  0x00000030 6362615f 002e636f 6d6d656e 74002e6e cba_..comment..n
  0x00000040 6f74652e 474e552d 73746163 6b002e72 ote.GNU-stack..r
  0x00000050 656c612e 65685f66 72616d65 00       ela.eh_frame.

So, the first entry referencing "gfedcba_" has sh_name 0x32 ("a_").

The second entry referencing "gfedcba_" has sh_name 0x2d ("fedcba_").

The third entry referencing "gfedcba_" has sh_name 0x30 ("cba_").

If the same holds true for .symtab, this means we probably need to
change the logic to "backtrack" to the beginning of the string before
copying it into core_strtab, because a subsequent symtab entry could
reference a larger chunk of the string.

We will also want to check the strmap bits, since it's possible that
"cba_" was a core symbol but "edcba_" is not.  In which case we did not
allocate room for the "ed" part, back in layout_symtab().

> I've started a separate patch to add comments to all this.

Not sure how you want to handle combining these changes?

I'll just send a V2 that rolls in all of the desired modifications, if
there are no objections...

Thanks.
