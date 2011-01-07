Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1AGNFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:05:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1AGNFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:05:07 -0500
Date: Fri, 7 Jan 2011 14:04:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, mat <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20110107130426.GA24259@elte.hu>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
 <20101222124019.GG10809@elte.hu>
 <34428.1293053719@localhost>
 <AANLkTin55DXcQnK3NY7y-v8TXj5w-XT2rTJo9p90tj4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin55DXcQnK3NY7y-v8TXj5w-XT2rTJo9p90tj4g@mail.gmail.com>
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


* Xiaotian Feng <xtfeng@gmail.com> wrote:

> On Thu, Dec 23, 2010 at 5:35 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Wed, 22 Dec 2010 13:40:19 +0100, Ingo Molnar said:
> >>
> >> * mat <castet.matthieu@free.fr> wrote:
> >>
> >> > Le Wed, 8 Dec 2010 14:19:51 -0800,
> >> > Kees Cook <kees.cook@canonical.com> a écrit :
> >> >
> >> > > On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> >> > > > could you try the attached patch ?
> >> > > >
> >> > > > on module load, we sort the __jump_table section. So we should make
> >> > > > it writable.
> >> > > >
> >> > > >
> >> > > > Matthieu
> >> > >
> >> > > > diff --git a/arch/x86/include/asm/jump_label.h
> >> > > > b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644
> >> > > > --- a/arch/x86/include/asm/jump_label.h
> >> > > > +++ b/arch/x86/include/asm/jump_label.h
> >> > > > @@ -14,7 +14,7 @@
> >> > > >         do
> >> > > > {                                                       \ asm
> >> > > > goto("1:"                                       \
> >> > > > JUMP_LABEL_INITIAL_NOP                  \
> >> > > > -                       ".pushsection __jump_table,  \"a\" \n\t"\
> >> > > > +                       ".pushsection __jump_table,  \"aw\" \n\t"\
> >> > > >                         _ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> >> > > >                         ".popsection \n\t"                      \
> >> > > >                         : :  "i" (key) :  : label);
> >> > > > \
> >> > >
> >> > > Acked-by: Kees Cook <kees.cook@canonical.com>
> >> > >
> >> > > Can this please get committed to tip?
> >> > I think it is not need anymore with  Steven Rostedt patch [1]
> >> >
> >> > Matthieu
> >> >
> >> > [1]
> >> > > > Here we set the text read only before we call the notifiers. The
> >> > > > function tracer changes the calls to mcount into nops via a notifier
> >> > > > call so this must be done after the module notifiers.
> >>
> >> What's the status of this bug?
> >>
> >> If we still need the patch then please submit it standalone with a proper subject
> >> line, with acks/signoffs added, etc.
> >
> > Steve Rostedt's patch that moves the setting of the page permissions seems to
> > make this patch no longer necessary.  I tripped over this same issue, but the
> > version in the latest -mmotm does not need it, as it includes Steve's fix.
> >
> 
> I'm facing a boot failure (panic'ed on remove_jump_label_module_init)
> on 2.6.37 (latest commit 3c0cb7c), which is 100% reproducible.
> With this patch applied, I can boot my machine successfully, so I do
> think this patch is needed.

That would be commit:

 94462ad3b147: module: Move RO/NX module protection to after ftrace module update

So if commit 3c0cb7c is still broken, it has 94462ad3b147 included already, and 
there's some other bug. Kees, Steve, any ideas?

Xiaotian, please post as much about the crash as you can - a log/picture of the boot 
crash that occurs would be good.

Thanks,

	Ingo
