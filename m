Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681Ab0FQTLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:11:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64199 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab0FQTLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=raAeM8NcOePORWDs/p5SWcLpVLn8VsmdBcbL82Uyh0f7cRRzi7NJZsTBuosUAzewoe
         DVHaFETRMSy5NQq6bDF4oB1hKFdrMK/7PRyQ/zW/833KRQx5iKM8Cc0M0OmpBP+ZMVkA
         OH+HWgxImtZDEDWSmUILLqotd2Q7Ox+Q2PmMU=
MIME-Version: 1.0
In-Reply-To: <1276724403.2847.453.camel@mulgrave.site>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
	<alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu>
	<87y6ehxvby.fsf@linux-g6p1.site>
	<1276545951.5374.260.camel@mulgrave.site>
	<alpine.DEB.1.10.1006141608550.1248@dr-wily.mit.edu>
	<1276556919.5374.822.camel@mulgrave.site>
	<alpine.DEB.1.10.1006142039250.1248@dr-wily.mit.edu>
	<1276724403.2847.453.camel@mulgrave.site>
Date: Thu, 17 Jun 2010 21:11:46 +0200
Message-ID: <AANLkTikgzvZvb30QhSMs_GQ6MCawl0V6GzixnDYfqmzg@mail.gmail.com>
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
From: Denys Vlasenko <vda.linux@googlemail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Matt Fleming <matt@console-pimps.org>,
       linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Michal Marek <mmarek@suse.cz>,
       Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 11:40 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> True ... but I didn't say that it was valid C.  I said the compiler is
> spitting them out in the assembly ... I suspect it uses invalid C
> function characters precisely to avoid clashes.

Then we need to add all such chars to that regexp.

> The problem is that it's hard to get the linker to distinguish
> between .text.. and .text. without funny regexp contortions.  However,
> if the two sections began .text- and .text. they are easy to distinguish
> because one prefix isn't a subset of the other.
>
>> Both .page_aligned.data and .data-page_aligned are valid choices (and in
>> fact, the first patch series I sent on this topic about 18 months ago did
>> .page_aligned.data, I think).
>>
>> The main technical difference between ".data..page_aligned" and
>> ".page_aligned.data" in my view is that you need to be more careful when
>> writing assembly files with ".page_aligned.data".
>>
>> To give an example, if I run the following:
>>
>> $ cat > foo.s
>> .section .data-page-aligned
>>       .long 0
>> .section .data.page_aligned
>>       .long 1
>> $ gcc -c foo.s -o foo.o
>> $ objdump -h foo.o
>> foo.o:     file format elf32-i386
>>
>> Sections:
>> Idx Name          Size      VMA       LMA       File off  Algn
>>   0 .text         00000000  00000000  00000000  00000034  2**2
>>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>>   1 .data         00000000  00000000  00000000  00000034  2**2
>>                   CONTENTS, ALLOC, LOAD, DATA
>>   2 .bss          00000000  00000000  00000000  00000034  2**2
>>                   ALLOC
>>   3 .data-page-aligned 00000004  00000000  00000000  00000034  2**0
>>                   CONTENTS, READONLY
>>   4 .data.page_aligned 00000004  00000000  00000000  00000038  2**0
>>                   CONTENTS, ALLOC, LOAD, DATA
>>
>> one can see that the .data-page-aligned section doesn't have the right
>> section flags.  So I'm pretty sure the relevant assembler heuristic is
>> looking for things starting with ".data.", not just ".data".
>>
>> The kernel has a lot of code in assembly files that just does:
>>
>> .section ".data"
>>
>> and so there's a very real risk that folks who are doing pattern-matching
>> development on assembly files will end up creating non-allocated sections
>> by accident (I've certainly made this mistake myself, and there's a bug of
>> this form in arch/x86/lib/thunk.S until commit
>> c6c2d7a084d14a8a701be84872aa1b77d2945f46, so I don't think I'm alone)
>
> But that commit isn't anything to do with the section not being
> allocated.  That's actually irrelevant to us, since we sort out the
> sectional allocations out at link time with the linker script (which
> ends up completely ignoring the original file flags).  The problem,
> specifically, is that the linker does a rename of two identically named
> sections with different flags ... we would also get the same behaviour
> if the linker thought two sections weren't mergeable even if they did
> have identical flags.
>
> In general, I think it's good practise for all use of sections to
> specify the elf flags.

This is doable in asm, yes. For .bss, we need to not forget about
@nobits too: section .bss.foo,"aw",@nobits

> Actually, as I said, that would be .data-
>
> But, to be honest, I don't care that much about the data names because
> we don't use -fdata-sections, the only objection is that having two
> separate conventions for text and data is adding needless complexity ...
> I do care about the text names, and I'd rather we stuck to the existing
> convention there, or provided a good reason for the change ... and
> wanting .text. as a prefix for everything is weak at best.
>
> The specific objection I have to converting everything to the .text..*
> prefix for linux sections is that the gather all function sections can
> no longer be *(.text.*), but has to become a regular expression, which
> is adding fragility.

I agree that it's not pretty, but otherwise we add fragility in other places:
every section directive must be correct now. These places are more numerous
than linker scripts.

But, leaving aside the question whether we want to take the risk
of people forgetting to do it properly everywhere, -
is it even *possible* to specify these attributes in C - that is,
in gcc's __attribute__((section(".bss.foo")))?

I think currently gcc does not support it - it guesses attributes
based on the section name.

-- 
vda
