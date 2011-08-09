Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1HIPWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:22:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50612 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1HIPWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <1312150698.18010.21.camel@i7.infradead.org>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E34A1E4.8040103@zytor.com>
	<CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
	<4E34AFAD.90008@zytor.com>
	<CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
	<1312150698.18010.21.camel@i7.infradead.org>
Date: Tue, 9 Aug 2011 11:22:19 -0400
Message-ID: <CACqU3MVjgh9tm9AT67ZavFVj3w4wFezpKUa6c95uA_+E-hZ5Tw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 6:18 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2011-07-30 at 22:09 -0400, Arnaud Lacombe wrote:
>> Btw, `make CONFIG_GENERIC_BUG=n oldconfig' or `make CONFIG_64BIT=n
>> oldconfig'[0] does not even work, and I'm getting no error. So either
>> you make it work for all possible uses, or you warn the user he tried
>> something illegal, but you don't just fail silently.
>
> You're absolutely right that we should report it. I'm dubious about
> trying to report a *reason*... it would be nice if we could do it
> *reliably*, but we don't actually pass the reasons back up so the code
> has to guess. I'm torn between ripping it out because it's guessing, and
> trying to improve it. What do you think?
>
> I'd *love* to be able to say 'You need to enable CONFIG_SATA in order to
> enable CONFIG_SATA_MV'. But if I were to do *that* then I'd probably end
> up ripping out the whole of this 'select' atrocity (which would now have
> no excuse for its existence) and I'd be even further from the simple
> task I started off with :)
>
> [dwmw2@i7 linux-2.6]$ make CONFIG_GENERIC_BUG=n oldconfig
> scripts/kconfig/conf --oldconfig Kconfig
> #
> # Could not set CONFIG_GENERIC_BUG=n; perhaps it is selected by another option?
> #
> #
> # configuration written to .config
> #
> [dwmw2@i7 linux-2.6]$ make CONFIG_SATA_MV=y oldconfig
> scripts/kconfig/conf --oldconfig Kconfig
> #
> # Could not set CONFIG_SATA_MV=y; perhaps it has unmet dependencies?
> #
> #
> # configuration written to .config
> #
>
>
> Incremental patch:
>
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 0341254..ff25669 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -364,8 +364,22 @@ void conf_set_symbol_from_env(char *str)
>                return;
>
>        sym_calc_value(sym);
> -       if (!sym_set_string_value(sym, p))
> +       if (!sym_set_string_value(sym, p)) {
> +               char *reason;
> +
> +               if ((sym->type == S_BOOLEAN || sym->type == S_TRISTATE) &&
> +                        !p[1] && toupper(p[0]) == 'N')
> +                       /* We were turning it *off* and failed... selected? */
> +                       reason = "perhaps it is selected by another option?";
> +               else if (!sym->visible)
> +                       reason = "perhaps it has unmet dependencies?";
> +               else
> +                       reason = "perhaps your setting was invalid?";
> +
> +               conf_message("Could not set " CONFIG_ "%s=%s; %s",
> +                            sym->name, p, reason);
>                return;
> +       }
>
>        conf_message(CONFIG_ "%s set to %s from environment", sym->name, p);
>        if (sym_is_choice_value(sym))
>
You are still breaking dependencies. Currently every environment
variable creates a dependency in auto.conf.cmd in order to force
`auto.conf' regeneration if the environment change. Your patch lacks
such a safety. cf

commit 93449082e905ce73d0346d617dd67c4b668b58af
Author: Roman Zippel <zippel@linux-m68k.org>
Date:   Mon Jan 14 04:50:54 2008 +0100

    kconfig: environment symbol support

for implementation details about how it is dealt with currently.

Btw, Michal (or Sam), is it voluntary not to make `auto.conf' just
depends on `.config' ?

Thanks,
 - Arnaud
