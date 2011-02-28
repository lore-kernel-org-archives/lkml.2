Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1B1Vbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:31:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37901 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1B1Vbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:31:38 -0500
Date: Mon, 28 Feb 2011 22:31:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Message-ID: <20110228213134.GA10825@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
	Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org,
	bp@amd64.org
References: <20110221110322.GA9819@liondog.tnic>
 <201102282207.33489.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201102282207.33489.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:07:33PM +0100, Arnd Bergmann wrote:
> On Monday 21 February 2011 12:03:22 Borislav Petkov wrote:
> > Add a 'W=1' Makefile switch which adds additional checking per build
> > object.
> >
> > The idea behind this option is targeted at developers who, in the
> > process of writing their code, want to do the occasional
> >
> > make W=1 [target.o]
> 
> Great stuff, I really like the idea!

Thanks. :)

> 
> > +# $(call cc-option... ) handles gcc -W.. options which
> > +# are not supported by all versions of the compiler
> > +ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> > +ifneq ($(call cc-version),)
> > +KBUILD_EXTRA_WARNINGS := -Wextra
> > +KBUILD_EXTRA_WARNINGS += -Wunused -Wno-unused-parameter
> > +KBUILD_EXTRA_WARNINGS += -Waggregate-return
> > +KBUILD_EXTRA_WARNINGS += -Wbad-function-cast
> > +KBUILD_EXTRA_WARNINGS += -Wcast-qual
> > +KBUILD_EXTRA_WARNINGS += -Wcast-align
> > +KBUILD_EXTRA_WARNINGS += -Wconversion
> > +KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
> > +KBUILD_EXTRA_WARNINGS += -Wlogical-op
> > +KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
> > +KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
> > +KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
> > +KBUILD_EXTRA_WARNINGS += -Wmissing-prototypes
> > +KBUILD_EXTRA_WARNINGS += -Wnested-externs
> > +KBUILD_EXTRA_WARNINGS += -Wold-style-definition
> > +KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
> > +KBUILD_EXTRA_WARNINGS += -Wpacked
> > +KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
> > +KBUILD_EXTRA_WARNINGS += -Wpadded
> > +KBUILD_EXTRA_WARNINGS += -Wpointer-arith
> > +KBUILD_EXTRA_WARNINGS += -Wredundant-decls
> > +KBUILD_EXTRA_WARNINGS += -Wshadow
> > +KBUILD_EXTRA_WARNINGS += -Wswitch-default
> > +KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
> > +KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
> > +endif
> > +endif
> 
> I would be a little more selective here. Maybe we can have two levels
> W=1 and W=2, with the full set getting enabled by W=2, and the smaller
> set getting enabled in W=1. The reason is that many of the warnings
> are pointless or even hurting code quality, while others (e.g.
> -Wmissing-declarations) are generally useful and the only reason for
> not enabling them is that they cause too many warnings with existing
> code.

My intention was not to have multiple levels of warnings because then
you have to go and enable the different levels and have to remember
which level you used last, etc, etc.

Instead I am thinking along with the following lines:

make W=1 [path/to/kernel/file.o] 2>w.log

and then take a look at w.log and start fixing warnings.

You can selectively ignore some of the warnings since, as you say
yourself above, some simply make you write ugly code like enforcing
casts just for the sake of shutting up the compiler. A great deal of the
warnings come from includes which are hard to fix or gcc is issuing the
warning wrong since we do sick sh*t with C in the kernel and that's OK
:).

But in all cases you have all the warnings in one single file and that's
it. If a certain -W option is useless, we should rather remove it since
it doesn't help anyway. The selection above is clearly not complete so
I'd rather drop some instead of including different W=x levels.

Hmm... ?

-- 
Regards/Gruss,
    Boris.
