Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0G0Qut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:50:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37490 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0G0Qus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:50:48 -0400
Date: Tue, 27 Jul 2010 18:50:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4] kconfig: add savedefconfig
Message-ID: <20100727165045.GA26649@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4EFE80.7050808@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> >  randconfig: $(obj)/conf
> >  	$< -r $(Kconfig)
> > @@ -112,6 +113,9 @@ allmodconfig: $(obj)/conf
> >  alldefconfig: $(obj)/conf
> >  	$< -f $(Kconfig)
> >  
> > +savedefconfig: $(obj)/conf
> > +	$< -M defconfig $(Kconfig)
> > +
> 
> Out of curiosity, do you have any mnemonics for -f and -M, or are these
> just random letters that were free? :) Maybe we should add long options
> like --defconfig, --allmodconfig for each of the targets and use them in
> the Makefile. The meaning of the single-letter options is not obvious
> sometimes. scripts/genksyms already uses getopt_long() so we would not
> regress in portability.
Random letters that were free.
I will take a look at getopt_long() in next spin.

> 
> 
> >  defconfig: $(obj)/conf
> >  ifeq ($(KBUILD_DEFCONFIG),)
> >  	$< -d $(Kconfig)
> > @@ -140,6 +144,7 @@ help:
> >  	@echo  '  allmodconfig	  - New config selecting modules when possible'
> >  	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
> >  	@echo  '  allnoconfig	  - New config where all options are answered with no'
> > +	@echo  '  savedefconfig   - Save current config as ./defconfig (minimal config)'
> >  
> >  # lxdialog stuff
> >  check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
> > diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> > index 2b4775e..b1a903b 100644
> > --- a/scripts/kconfig/conf.c
> > +++ b/scripts/kconfig/conf.c
> > @@ -28,7 +28,8 @@ enum {
> >  	set_mod,
> >  	set_no,
> >  	set_default,
> > -	set_random
> > +	set_random,
> > +	save_defconfig,
> >  } input_mode = ask_all;
> >  char *defconfig_file;
> >  
> > @@ -440,7 +441,7 @@ int main(int ac, char **av)
> >  	bindtextdomain(PACKAGE, LOCALEDIR);
> >  	textdomain(PACKAGE);
> >  
> > -	while ((opt = getopt(ac, av, "osdD:nmyfrh")) != -1) {
> > +	while ((opt = getopt(ac, av, "osdD:nmM:yfrh")) != -1) {
> >  		switch (opt) {
> >  		case 'o':
> >  			input_mode = ask_silent;
> > @@ -485,6 +486,10 @@ int main(int ac, char **av)
> >  			input_mode = set_random;
> >  			break;
> >  		}
> > +		case 'M':
> > +			input_mode = save_defconfig;
> > +			defconfig_file = optarg;
> > +			break;
> >  		case 'h':
> >  			printf(_("See README for usage info\n"));
> >  			exit(0);
> > @@ -553,6 +558,9 @@ int main(int ac, char **av)
> >  		else if (!stat("all.config", &tmpstat))
> >  			conf_read_simple("all.config", S_DEF_USER);
> >  		break;
> > +	case save_defconfig:
> > +		conf_read(NULL);
> > +		break;
> >  	default:
> >  		break;
> >  	}
> > @@ -601,6 +609,8 @@ int main(int ac, char **av)
> >  			check_conf(&rootmenu);
> >  		} while (conf_cnt);
> >  		break;
> > +	case save_defconfig:
> > +		break;
> >  	}
> >  
> >  	if (sync_kconfig) {
> > @@ -615,6 +625,12 @@ int main(int ac, char **av)
> >  			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
> >  			return 1;
> >  		}
> > +	} else if (input_mode == save_defconfig) {
> > +		if (conf_write_defconfig(defconfig_file)) {
> > +			fprintf(stderr, _("\n*** Error during writing of mini config to %s.\n\n"),
> > +			        defconfig_file);
> > +			return 1;
> > +		}
> >  	} else {
> >  		if (conf_write(NULL)) {
> >  			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
> > diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> > index c4dec80..76c4e23 100644
> > --- a/scripts/kconfig/confdata.c
> > +++ b/scripts/kconfig/confdata.c
> > @@ -396,6 +396,100 @@ int conf_read(const char *name)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Write out a minimal config.
> > + * All values that has default values are skipped as this is redundant.
> > + */
> > +int conf_write_defconfig(const char *filename)
> > +{
> > +	struct symbol *sym;
> > +	const char *str;
> > +	FILE *out;
> > +	int i, l;
> > +
> > +	out = fopen(filename, "w");
> > +	if (!out)
> > +		return 1;
> > +
> > +	sym_clear_all_valid();
> > +
> > +	for_all_symbols(i, sym) {
> > +		sym_calc_value(sym);
> > +		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
> > +			goto next_symbol;
> > +		/* If we cannot change the symbol - skip */
> > +		if (!sym_is_changable(sym))
> > +			goto next_symbol;
> > +		/* If symbol equals to default value - skip */
> > +		if (strcmp(sym_get_string_value(sym), sym_get_string_default(sym)) == 0)
> > +			goto next_symbol;
> > +
> > +		/* choice symbols does not have a value - skip */
> > +		if (sym_is_choice(sym))
> > +			goto next_symbol;
> > +		/*
> > +		 * If symbol is a choice value and equals to the
> > +		 * default for a choice - skip.
> > +		 * But only if value equal to "y".
> > +		 */
> > +		if (sym_is_choice_value(sym)) {
> > +			struct symbol *cs;
> > +			struct symbol *ds;
> > +
> > +			cs = prop_get_symbol(sym_get_choice_prop(sym));
> > +			ds = sym_choice_default(cs);
> > +			if (sym == ds) {
> > +				if ((sym->type == S_BOOLEAN ||
> > +				     sym->type == S_TRISTATE) &&
> > +				     sym_get_tristate_value(sym) == yes)
> > +					goto next_symbol;
> > +			}
> > +		}
> > +		switch (sym->type) {
> 
> This duplicates the switch statement in conf_write(), we should move it
> into a separate function and call it from conf_write() and here.
Will do.
Same goes for some of the code in symbol.c.

I will do it in a few steps to ease review.

> 
> 
> > +		case S_BOOLEAN:
> > +		case S_TRISTATE:
> > +			switch (sym_get_tristate_value(sym)) {
> > +			case no:
> > +				fprintf(out, "# CONFIG_%s is not set\n", sym->name);
> > +				break;
> > +			case yes:
> > +				fprintf(out, "CONFIG_%s=y\n", sym->name);
> > +				break;
> > +			case mod:
> > +				fprintf(out, "CONFIG_%s=m\n", sym->name);
> > +				break;
> > +			}
> > +			break;
> > +		case S_STRING:
> > +			str = sym_get_string_value(sym);
> > +			fprintf(out, "CONFIG_%s=\"", sym->name);
> > +			while (1) {
> > +				l = strcspn(str, "\"\\");
> > +				if (l) {
> > +					fwrite(str, l, 1, out);
> > +					str += l;
> > +				}
> > +				if (!*str)
> > +					break;
> > +				fprintf(out, "\\%c", *str++);
> > +			}
> > +			fputs("\"\n", out);
> > +			break;
> > +		case S_HEX:
> > +		case S_INT:
> > +			str = sym_get_string_value(sym);
> > +			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +next_symbol:
> > +		;
> > +	}
> 
> The gotos should be replaced by simple continue statements if there is
> nothing to do after the label.

In an earlier version I jumped to the goto inside a nested for loop.
It is gone so I will use continue as you recommend.

> 
> (maybe there are more issues, I didn't look closely into it. But I like
> the approach.)

Likely - I will take a critical look when I respin the patches.
Thanks for the review!

	Sam
