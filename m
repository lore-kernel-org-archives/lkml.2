Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab0JSKdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:33:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54235 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933952Ab0JSKdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:33:01 -0400
Date: Tue, 19 Oct 2010 12:32:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, heukelum@fastmail.fm, tglx@linutronix.de,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
Message-ID: <20101019103248.GB32212@elte.hu>
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org>
 <4C91F07E0200007800016B50@vpn.id2.novell.com>
 <20100916082816.GA25681@elte.hu>
 <4C91F3A30200007800016B64@vpn.id2.novell.com>
 <20100916101355.GA31458@elte.hu>
 <4C9219BC0200007800016C53@vpn.id2.novell.com>
 <4CA52AA5.5040402@zytor.com>
 <4CBD8B75020000780001DF71@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD8B75020000780001DF71@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 01.10.10 at 02:26, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > On 09/16/2010 04:21 AM, Jan Beulich wrote:
> >>>
> >>> Yes, to only generate CFI on binutils that allows us to write sane 
> >>> looking code.
> >>>
> >>> I.e. to disable CONFIG_AS_CFI on binutils that are broken for this.
> >> 
> >> Again - that won't help, as it's the macro invocation that gas
> >> fails one, not one of the actual .cfi_* directives.
> >> 
> > 
> > Looking again at this issue with the binutils version from hell
> > (sigh)... I'm running quickly out of ideas.
> > 
> > The problem is that cpp inserts spaces around expansions, so:
> > 
> > 	pushq_cfi $(USER_DS)
> > 
> > ... turns into something like ...
> > 
> > 	pushq_cfi $( ( 5 * 8 + 3 ) )
> > 
> > ... which these old versions of gas considers multiple arguments to the
> > macro, even though there is no comma anywhere.  We can defang *some* of
> > these problems by using cpp macros to kill them off:
> > 
> > #define pushq_cfi pushq
> > 
> > ... but that doesn't work with the macros like movq_cfi.  On those, we
> > could argue that at least people won't put $ on them, but cpp will still
> > split them apart with spaces; this apparently causes problems at least
> > as soon as there is an expression more complicated than addition
> > involved (apparently plus signs are okay, but minus signs aren't!)
> > 
> > I'm completely lost about how to deal with this.   We can't simply
> > defang the macros -- at least not in a way that is likely to *stay*
> > working -- and dropping the macros is seriously going to impact the
> > debuggability of the kernel.  One way, of course, is to simply declare
> > binutils 2.16 and 2.15.9x (which is apparently included in
> > RHEL/CentOS 4) to be broken beyond repair unless distros backport a fix,
> > and in many ways I think that is the preferred option, but I don't know
> > if that makes sense to others...
> 
> Would excessive parenthesisation (in the header files) be an
> acceptable workaround? cpp inserts the spaces only when
> a preprocessing identifier that expands to a token sequence
> ending in a number is followed by ., +, or -. (The asymmetry
> in behavior between + and - then results from gas considering
> - a symbol char, but not +, which is the case even in current
> mainline, and which I think ought to be fixed - I'll bring this
> up on their mailing list -, but that fix would break the kernel
> build in its current shape afaict.)
> 
> Basically, all constants potentially used in assembly expressions
> passed to macros would need to change from e.g.
> 
> #define RIP		128
> 
> to
> 
> #define RIP		(128)
> 
> I'll put together a patch if this is considered acceptable, and if
> it turns out to work across all cpp/gas version combinations
> that I can reasonably try.

We already have cases of such parenthesisation - so i suspect it would be 
acceptable, if it doesnt affect an unacceptably excessive number of constants.

Thanks,

	Ingo
