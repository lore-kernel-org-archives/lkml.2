Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab0FQUTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:19:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41387 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab0FQUTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YUfQjqzVx1k767jiqWu1LndWRor/pIKEZUnql5QD0sldnU0T/7Guk1YlhmSepVzjrF
         1yUnHBsNlRyjpaouPaeoVuZus+TQ1h5lmsS4VWD5uSweHlFVfZWwEydVcZ8/++wldyWj
         JADwsvI7+9tiQvW/6kf6DvYsRmxptjTEqBIIM=
MIME-Version: 1.0
In-Reply-To: <1276804567.7398.264.camel@mulgrave.site>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
	<alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu>
	<87y6ehxvby.fsf@linux-g6p1.site>
	<1276545951.5374.260.camel@mulgrave.site>
	<alpine.DEB.1.10.1006141608550.1248@dr-wily.mit.edu>
	<1276556919.5374.822.camel@mulgrave.site>
	<alpine.DEB.1.10.1006142039250.1248@dr-wily.mit.edu>
	<1276724403.2847.453.camel@mulgrave.site>
	<AANLkTikgzvZvb30QhSMs_GQ6MCawl0V6GzixnDYfqmzg@mail.gmail.com>
	<1276804567.7398.264.camel@mulgrave.site>
Date: Thu, 17 Jun 2010 22:19:07 +0200
Message-ID: <AANLkTink485wn-EaLibaD3Xh7X5RwXM06d6jx3GijD40@mail.gmail.com>
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
From: Denys Vlasenko <vda.linux@googlemail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Matt Fleming <matt@console-pimps.org>,
       linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Michal Marek <mmarek@suse.cz>,
       Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is doable in asm, yes. For .bss, we need to not forget about
>> @nobits too: section .bss.foo,"aw",@nobits
>
> That's only for bss ... we have about a handful of such statements and
> they always use the assembler .bss directive (which doesn't need flags).
>
>> > Actually, as I said, that would be .data-

You are right, in assembly we can specify needed attributes.

I am more concerned about C:

arch/x86/include/asm/cache.h:
#define __read_mostly __attribute__((__section__(".data..read_mostly")))

If we change it to

#define __read_mostly __attribute__((__section__(".data-read_mostly")))

What makes this section have correct attributes?

With current gcc, __attribute__((__section__(".bss-page_aligned")))
does get wrong attributes. That's why we settled on .bss..foo
scheme.

> I thought I just refuted that in the above: we don't care what the
> assembler sections are flagged as because the linker script gets to pick
> the flags anyway ... so most bugs arrived at this way have no visible
> side effects ... and section merging problems have to be accounted for
> anyway in the final linker scripts.

When I was working on a older iteration of this patch,
I renamed .bss.page_aligned to .page_aligned.bss
and was bitten by linker bug: linker tried to merge
the sections and corrupted them.

Aha, here is it:
http://sourceware.org/bugzilla/show_bug.cgi?id=5006

It was since fixed, and if I read the ld patch correctly,
now ld emits a warning and switches entire target section
to PROGBITS - not what we want to happen to bss.

-- 
vda
