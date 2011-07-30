Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1G3Xo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:44:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42832 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1G3XoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <1312067670.22074.61.camel@i7.infradead.org>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
Date: Sat, 30 Jul 2011 19:44:18 -0400
Message-ID: <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 7:14 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> This allows you to set (and clear) config options on the make command
> line, for all config targets. For example:
>
>   make CONFIG_64BIT=n randconfig
>   make CONFIG_64BIT=n allmodconfig
>   make CONFIG_64BIT=y CONFIG_SATA_MV=y oldconfig
>
technically, no, this will not work as you intend. The following:

 make CONFIG_SATA_MV=y allnoconfig

will fail to set CONFIG_SATA_MV=y. This is not a flaw in your patch,
but a known issue with kconfig as even if you are setting
CONFIG_SATA_MV=y, it's direct dependency are still unmet and thus the
symbol in never considered to be output. The same flaw is present with
the "allno.config" logic.

Beside that, the one thing I dislike with your patch is that it is
unconditional and global to all symbols, and you have no way to forbid
the environment to override a value.

What about:
 - a "select"-like approach, which would guarantee symbol selection
and warn you when unmet-dependency are present
 - an opt-in approach to the symbol override from the environment


 - Arnaud


> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  scripts/kconfig/conf.c     |    7 ++++++-
>  scripts/kconfig/confdata.c |   26 ++++++++++++++++++++++++++
>  scripts/kconfig/lkc.h      |    1 +
>  3 files changed, 33 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 006ad81..2b91e3b 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -456,7 +456,7 @@ static struct option long_opts[] = {
>        {NULL, 0, NULL, 0}
>  };
>
> -int main(int ac, char **av)
> +int main(int ac, char **av, char **ep)
>  {
>        int opt;
>        const char *name;
> @@ -563,6 +563,11 @@ int main(int ac, char **av)
>                break;
>        }
>
> +       for ( ; *ep;  ep++) {
> +               if (!strncmp(*ep, CONFIG_, strlen(CONFIG_)))
> +                       conf_set_symbol_from_env(*ep);
> +       }
> +
>        if (sync_kconfig) {
>                if (conf_get_changed()) {
>                        name = getenv("KCONFIG_NOSILENTUPDATE");
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index a518ab3..c64eb33 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -342,6 +342,32 @@ setsym:
>        return 0;
>  }
>
> +void conf_set_symbol_from_env(char *str)
> +{
> +       char *p = strchr(str, '=');
> +       struct symbol *sym;
> +       int def = S_DEF_USER;
> +       int def_flags = SYMBOL_DEF << def;
> +
> +       if (!p)
> +               return;
> +
> +       *p = 0;
> +       sym = sym_find(str + strlen(CONFIG_));
> +       *p++ = '=';
> +
> +       if (!sym)
> +               return;
> +
> +       sym_calc_value(sym);
> +       if (!sym_set_string_value(sym, p))
> +               return;
> +
> +       conf_message(CONFIG_ "%s set to %s from environment", sym->name, p);
> +       if (sym_is_choice_value(sym))
> +               conf_validate_choice_val(sym, def, def_flags);
> +}
> +
>  int conf_read(const char *name)
>  {
>        struct symbol *sym, *choice_sym;
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index f34a0a9..fc2f3ad 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -89,6 +89,7 @@ char *conf_get_default_confname(void);
>  void sym_set_change_count(int count);
>  void sym_add_change_count(int count);
>  void conf_set_all_new_symbols(enum conf_def_mode mode);
> +void conf_set_symbol_from_env(char *);
>
>  /* confdata.c and expr.c */
>  static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
> --
> 1.7.6
>
>
>
>
