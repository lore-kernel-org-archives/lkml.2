Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0G0Pnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 11:43:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0G0Pnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 11:43:33 -0400
Message-ID: <4C4EFE80.7050808@suse.cz>
Date: Tue, 27 Jul 2010 17:42:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4] kconfig: add savedefconfig
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org>
In-Reply-To: <20100725214021.GD5834@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.7.2010 23:40, Sam Ravnborg wrote:
> From 5edffcc6890a7dbd43b8da9c453bee794e81e7c7 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sun, 25 Jul 2010 23:18:47 +0200
> Subject: [PATCH 4/4] kconfig: add savedefconfig
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> savedefconfig is used to save a minimal configuration
> that is useful for a defconfig.

General comment: I like this more than the "replace defconfigs with
Kconfig files" approach -- the .config format is efficient and easy to
read, we have tools to edit it (make *config), the issue was the size of
the defconfigs and the updates to them, which your patches address now.



> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  scripts/kconfig/Makefile    |    7 +++-
>  scripts/kconfig/conf.c      |   20 ++++++++-
>  scripts/kconfig/confdata.c  |   94 ++++++++++++++++++++++++++++++++++++++++++
>  scripts/kconfig/lkc.h       |    2 +
>  scripts/kconfig/lkc_proto.h |    1 +
>  scripts/kconfig/symbol.c    |   96 +++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 217 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 366711a..aeb04c2 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -95,7 +95,8 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
>  	$(Q)rm -f arch/um/Kconfig.arch
>  	$(Q)rm -f $(obj)/config.pot
>  
> -PHONY += randconfig allyesconfig allnoconfig allmodconfig alldefconfig defconfig
> +PHONY += randconfig allyesconfig allnoconfig allmodconfig alldefconfig
> +PHONY += defconfig savedefconfig
>  
>  randconfig: $(obj)/conf
>  	$< -r $(Kconfig)
> @@ -112,6 +113,9 @@ allmodconfig: $(obj)/conf
>  alldefconfig: $(obj)/conf
>  	$< -f $(Kconfig)
>  
> +savedefconfig: $(obj)/conf
> +	$< -M defconfig $(Kconfig)
> +

Out of curiosity, do you have any mnemonics for -f and -M, or are these
just random letters that were free? :) Maybe we should add long options
like --defconfig, --allmodconfig for each of the targets and use them in
the Makefile. The meaning of the single-letter options is not obvious
sometimes. scripts/genksyms already uses getopt_long() so we would not
regress in portability.


>  defconfig: $(obj)/conf
>  ifeq ($(KBUILD_DEFCONFIG),)
>  	$< -d $(Kconfig)
> @@ -140,6 +144,7 @@ help:
>  	@echo  '  allmodconfig	  - New config selecting modules when possible'
>  	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
>  	@echo  '  allnoconfig	  - New config where all options are answered with no'
> +	@echo  '  savedefconfig   - Save current config as ./defconfig (minimal config)'
>  
>  # lxdialog stuff
>  check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 2b4775e..b1a903b 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -28,7 +28,8 @@ enum {
>  	set_mod,
>  	set_no,
>  	set_default,
> -	set_random
> +	set_random,
> +	save_defconfig,
>  } input_mode = ask_all;
>  char *defconfig_file;
>  
> @@ -440,7 +441,7 @@ int main(int ac, char **av)
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> -	while ((opt = getopt(ac, av, "osdD:nmyfrh")) != -1) {
> +	while ((opt = getopt(ac, av, "osdD:nmM:yfrh")) != -1) {
>  		switch (opt) {
>  		case 'o':
>  			input_mode = ask_silent;
> @@ -485,6 +486,10 @@ int main(int ac, char **av)
>  			input_mode = set_random;
>  			break;
>  		}
> +		case 'M':
> +			input_mode = save_defconfig;
> +			defconfig_file = optarg;
> +			break;
>  		case 'h':
>  			printf(_("See README for usage info\n"));
>  			exit(0);
> @@ -553,6 +558,9 @@ int main(int ac, char **av)
>  		else if (!stat("all.config", &tmpstat))
>  			conf_read_simple("all.config", S_DEF_USER);
>  		break;
> +	case save_defconfig:
> +		conf_read(NULL);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -601,6 +609,8 @@ int main(int ac, char **av)
>  			check_conf(&rootmenu);
>  		} while (conf_cnt);
>  		break;
> +	case save_defconfig:
> +		break;
>  	}
>  
>  	if (sync_kconfig) {
> @@ -615,6 +625,12 @@ int main(int ac, char **av)
>  			fprintf(stderr, _("\n*** Error during update of the kernel configuration.\n\n"));
>  			return 1;
>  		}
> +	} else if (input_mode == save_defconfig) {
> +		if (conf_write_defconfig(defconfig_file)) {
> +			fprintf(stderr, _("\n*** Error during writing of mini config to %s.\n\n"),
> +			        defconfig_file);
> +			return 1;
> +		}
>  	} else {
>  		if (conf_write(NULL)) {
>  			fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index c4dec80..76c4e23 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -396,6 +396,100 @@ int conf_read(const char *name)
>  	return 0;
>  }
>  
> +/*
> + * Write out a minimal config.
> + * All values that has default values are skipped as this is redundant.
> + */
> +int conf_write_defconfig(const char *filename)
> +{
> +	struct symbol *sym;
> +	const char *str;
> +	FILE *out;
> +	int i, l;
> +
> +	out = fopen(filename, "w");
> +	if (!out)
> +		return 1;
> +
> +	sym_clear_all_valid();
> +
> +	for_all_symbols(i, sym) {
> +		sym_calc_value(sym);
> +		if (!(sym->flags & SYMBOL_WRITE) || !sym->name)
> +			goto next_symbol;
> +		/* If we cannot change the symbol - skip */
> +		if (!sym_is_changable(sym))
> +			goto next_symbol;
> +		/* If symbol equals to default value - skip */
> +		if (strcmp(sym_get_string_value(sym), sym_get_string_default(sym)) == 0)
> +			goto next_symbol;
> +
> +		/* choice symbols does not have a value - skip */
> +		if (sym_is_choice(sym))
> +			goto next_symbol;
> +		/*
> +		 * If symbol is a choice value and equals to the
> +		 * default for a choice - skip.
> +		 * But only if value equal to "y".
> +		 */
> +		if (sym_is_choice_value(sym)) {
> +			struct symbol *cs;
> +			struct symbol *ds;
> +
> +			cs = prop_get_symbol(sym_get_choice_prop(sym));
> +			ds = sym_choice_default(cs);
> +			if (sym == ds) {
> +				if ((sym->type == S_BOOLEAN ||
> +				     sym->type == S_TRISTATE) &&
> +				     sym_get_tristate_value(sym) == yes)
> +					goto next_symbol;
> +			}
> +		}
> +		switch (sym->type) {

This duplicates the switch statement in conf_write(), we should move it
into a separate function and call it from conf_write() and here.


> +		case S_BOOLEAN:
> +		case S_TRISTATE:
> +			switch (sym_get_tristate_value(sym)) {
> +			case no:
> +				fprintf(out, "# CONFIG_%s is not set\n", sym->name);
> +				break;
> +			case yes:
> +				fprintf(out, "CONFIG_%s=y\n", sym->name);
> +				break;
> +			case mod:
> +				fprintf(out, "CONFIG_%s=m\n", sym->name);
> +				break;
> +			}
> +			break;
> +		case S_STRING:
> +			str = sym_get_string_value(sym);
> +			fprintf(out, "CONFIG_%s=\"", sym->name);
> +			while (1) {
> +				l = strcspn(str, "\"\\");
> +				if (l) {
> +					fwrite(str, l, 1, out);
> +					str += l;
> +				}
> +				if (!*str)
> +					break;
> +				fprintf(out, "\\%c", *str++);
> +			}
> +			fputs("\"\n", out);
> +			break;
> +		case S_HEX:
> +		case S_INT:
> +			str = sym_get_string_value(sym);
> +			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
> +			break;
> +		default:
> +			break;
> +		}
> +next_symbol:
> +		;
> +	}

The gotos should be replaced by simple continue statements if there is
nothing to do after the label.

(maybe there are more issues, I didn't look closely into it. But I like
the approach.)

Michal

> +	fclose(out);
> +	return 0;
> +}
> +
>  int conf_write(const char *name)
>  {
>  	FILE *out;
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index ce6549c..76db065 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -126,6 +126,8 @@ void sym_init(void);
>  void sym_clear_all_valid(void);
>  void sym_set_all_changed(void);
>  void sym_set_changed(struct symbol *sym);
> +struct symbol *sym_choice_default(struct symbol *sym);
> +const char *sym_get_string_default(struct symbol *sym);
>  struct symbol *sym_check_deps(struct symbol *sym);
>  struct property *prop_alloc(enum prop_type type, struct symbol *sym);
>  struct symbol *prop_get_symbol(struct property *prop);
> diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
> index 7cadcad..e30d5f2 100644
> --- a/scripts/kconfig/lkc_proto.h
> +++ b/scripts/kconfig/lkc_proto.h
> @@ -4,6 +4,7 @@ P(conf_parse,void,(const char *name));
>  P(conf_read,int,(const char *name));
>  P(conf_read_simple,int,(const char *name, int));
>  P(conf_write,int,(const char *name));
> +P(conf_write_defconfig,int,(const char *name));
>  P(conf_write_autoconf,int,(void));
>  P(conf_get_changed,bool,(void));
>  P(conf_set_changed_callback, void,(void (*fn)(void)));
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index 0ea9c46..0bda646 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -216,6 +216,41 @@ static void sym_calc_visibility(struct symbol *sym)
>  	}
>  }
>  
> +/*
> + * Find the default isymbol for a choice.
> + * First try the default values for the choice symbol
> + * Next locate the first visible choice value
> + * Return NULL if none was found
> + */
> +struct symbol *sym_choice_default(struct symbol *sym)
> +{
> +	struct property *prop;
> +	struct symbol *def_sym;
> +	struct expr *e;
> +
> +	/* any of the defaults visible? */
> +	for_all_defaults(sym, prop) {
> +		prop->visible.tri = expr_calc_value(prop->visible.expr);
> +		if (prop->visible.tri == no)
> +			continue;
> +		def_sym = prop_get_symbol(prop);
> +		sym_calc_visibility(def_sym);
> +		if (def_sym->visible != no)
> +			return def_sym;
> +	}
> +
> +	/* just get the first visible value */
> +	prop = sym_get_choice_prop(sym);
> +	expr_list_for_each_sym(prop->expr, e, def_sym) {
> +		sym_calc_visibility(def_sym);
> +		if (def_sym->visible != no)
> +			return def_sym;
> +	}
> +
> +	/* failed to locate any defaults */
> +	return NULL;
> +}
> +
>  static struct symbol *sym_calc_choice(struct symbol *sym)
>  {
>  	struct symbol *def_sym;
> @@ -646,6 +681,67 @@ const char *sym_get_string_value(struct symbol *sym)
>  	return (const char *)sym->curr.val;
>  }
>  
> +/*
> + * Find the default value associated to a symbol.
> + * For tristate symbol hande the modules=n case
> + * in which case "m" bocomes "y".
> + * If the symbol does not have any default fallback
> + * to the fixed default values.
> + */
> +const char *sym_get_string_default(struct symbol *sym)
> +{
> +	struct property *prop;
> +	struct symbol *ds;
> +	tristate val;
> +
> +	prop = sym_get_default_prop(sym);
> +	if (!prop)
> +		goto default_value;
> +	ds = prop_get_symbol(prop);
> +	if (!ds)
> +		goto default_value;
> +
> +	switch (sym->type) {
> +	case S_BOOLEAN:
> +	case S_TRISTATE:
> +		val = sym_get_tristate_value(ds);
> +		switch (val) {
> +		case no:
> +			return "n";
> +		case yes:
> +			return "y";
> +		case mod:
> +			if (sym_is_choice_value(sym))
> +				return "m";
> +			sym_calc_value(modules_sym);
> +			if (modules_sym->curr.tri == no)
> +				return "y";
> +			else
> +				return "m";
> +		}
> +		break;
> +	default:
> +		return (const char *)ds->curr.val;
> +	}
> +
> +default_value:
> +
> +	switch (sym->type) {
> +	case S_BOOLEAN:
> +	case S_TRISTATE:
> +		return "n";
> +	case S_INT:
> +	case S_HEX:
> +		return "0";
> +	case S_STRING:
> +		return "";
> +	case S_OTHER:
> +	case S_UNKNOWN:
> +		break;
> +	}
> +	return "";
> +}
> +
>  bool sym_is_changable(struct symbol *sym)
>  {
>  	return sym->visible > sym->rev_dep.tri;

