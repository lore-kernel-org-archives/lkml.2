Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1G3JEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 05:04:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:42492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1G3JEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 05:04:32 -0400
Subject: Re: [PATCH v2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Date: Sat, 30 Jul 2011 10:04:23 +0100
In-Reply-To: <CACqU3MWhc6cGqyR8g73ZxMu3kYjufzHoEEWku6of+-1W1FO21Q@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <1306795186.2029.459.camel@i7.infradead.org>
	 <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	 <1306856937.27477.3.camel@i7.infradead.org>
	 <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	 <4E0495F4.7080300@suse.cz> <1311982365.20983.42.camel@i7.infradead.org>
	 <CACqU3MWhc6cGqyR8g73ZxMu3kYjufzHoEEWku6of+-1W1FO21Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1312016665.20983.75.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 21:15 -0400, Arnaud Lacombe wrote:
> Technically, kconfig already provides you all the interfaces to set
> symbol to a given value, for `randconfig' via "rand.config", for
> `all{yes,mod,no}config', via all.{yes,mod,no}config, for oldconfig via
> .config. Why another interface ?

It's useful for some people to be able to do this as simply as possible
from the command line, and they get very upset if you suggest that they
might use those other methods instead.

In particular, some people currently use the legacy 'ARCH=i386' and
'ARCH=x86_64' settings on the command line in order to switch the value
of CONFIG_64BIT on and off for various *config targets¹. In fact, I
think that's the *only* thing that those legacy ARCH settings still do;
they could (technically, at least) be killed off if we have an
alternative way of doing it. This provides an alternative, more generic
way of doing it for *all* config options; not just CONFIG_64BIT and not
just for x86.

(¹ Note: in fact, *many* people use 'ARCH=i386' and 'ARCH=x86_64', but
not really for this purpose. Most people use it just to work around the
bug I fixed in my other patch — that the value of CONFIG_64BIT is
*always* overridden to match the build host, unless you do *something*
on the command line to work around it. Just ARCH=x86 would suffice,
since that makes CONFIG_64BIT work sanely again.)

> > +void conf_set_symbol_from_env(char *str)
> > +{
> > +       char *p = strchr(str, '=');
> > +       struct symbol *sym;
> > +       int def = S_DEF_USER;
> > +       int def_flags = SYMBOL_DEF << def;
> > +
> > +       if (!p)
> > +               return;
> the environment should already gives you the guarantee that `p' won't
> be NULL. If that's not the case, the environment is likely to be
> broken.

Yes, that's true. Nevertheless, I've seen broken environments — there's
no harm in being robust. We can't be robust in the face of *all* the
ways the environment could screw up, of course, but this check doesn't
really hurt. Especially given that the getenv() isn't even *in* this
function, so this function is even more justified in checking its
inputs.

> > +
> > +       *p = 0;
> > +       sym = sym_find(str + strlen(CONFIG_));
> > +       *p++ = '=';
> > +
> > +       if (!sym)
> > +               return;
> > +
> > +       sym_calc_value(sym);
> > +       if (!sym_set_string_value(sym, p))
> > +               return;
> > +       conf_message("CONFIG_%s set to %s from environment", sym->name, p);
> please do not hardcode the prefix.

OK.

> > +       if (sym && sym_is_choice_value(sym)) {
> you do not need to test for the validity of a pointer you
> unconditionally dereference right before :)

That's a copy-and-paste from identical code in conf_read_simple(), which
I suppose should be factored out into a separate function. if I really
understood what it was doing I'd be able to suggest a sane name...
sym_validate_choice_state() perhaps?

I'll do that.

> > +               struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
> > +               switch (sym->def[def].tri) {
> > +               case no:
> > +                       break;
> > +               case mod:
> > +                       if (cs->def[def].tri == yes) {
> > +                               conf_warning("%s creates inconsistent choice state", sym->name);
> > +                               cs->flags &= ~def_flags;
> > +                       }
> > +                       break;
> > +               case yes:
> > +                       if (cs->def[def].tri != no)
> > +                               conf_warning("override: %s changes choice state", sym->name);
> > +                       cs->def[def].val = sym;
> > +                       break;
> > +               }
> > +               cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
> > +       }
> > +}
> > +
-- 
dwmw2

