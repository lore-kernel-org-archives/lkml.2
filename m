Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1EaAYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:24:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35578 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1EaAYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FeqcVYeD1wYct4lMr+VfGfkF/iHBWdRiRUvH7g/kkpng4RrhD24cfFsTgMrZ9Wap87
         98cjHtaXa7Y9RdHDbPT8TQia6+Myrh2TNcLPU3ryHY4Mgl1pMV1BfpcON6Xx6h5MSF2p
         qkoD5Mx7ejVtV28oFCDyGI1eKhE8gTbLT5K4U=
MIME-Version: 1.0
In-Reply-To: <1306795186.2029.459.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
Date: Mon, 30 May 2011 20:24:05 -0400
Message-ID: <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
Subject: Re: [PATCH] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 30, 2011 at 6:39 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> This allows you to set (and clear) config options on the make command
> line, for all config targets. For example:
>
>   make CONFIG_64BIT=n randconfig
>   make CONFIG_64BIT=n allmodconfig
>   make CONFIG_64BIT=y CONFIG_SATA_MV=y oldconfig
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
This does not seem to work with:

% make CONFIG_ARCH_OMAP=y ARCH=arm allnoconfig
  HOSTCC  scripts/kconfig/conf.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allnoconfig Kconfig
#
# configuration written to .config
#

% grep CONFIG_ARCH_OMAP .config
# CONFIG_ARCH_OMAP is not set

It would seem that the underlying symbol is not visible, triggering
the failure of sym_set_tristate_value().

 - Arnaud

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
> index 61c35bf..e8ff902 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -338,6 +338,47 @@ setsym:
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
> +       if (!sym_set_string_value(sym, p))
> +               return;
> +       conf_message("CONFIG_%s set to %s from environment", sym->name, p);
> +       if (sym && sym_is_choice_value(sym)) {
> +               struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
> +               switch (sym->def[def].tri) {
> +               case no:
> +                       break;
> +               case mod:
> +                       if (cs->def[def].tri == yes) {
> +                               conf_warning("%s creates inconsistent choice state", sym->name);
> +                               cs->flags &= ~def_flags;
> +                       }
> +                       break;
> +               case yes:
> +                       if (cs->def[def].tri != no)
> +                               conf_warning("override: %s changes choice state", sym->name);
> +                       cs->def[def].val = sym;
> +                       break;
> +               }
> +               cs->def[def].tri = EXPR_OR(cs->def[def].tri, sym->def[def].tri);
> +       }
> +}
> +
>  int conf_read(const char *name)
>  {
>        struct symbol *sym, *choice_sym;
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index febf0c9..bf6fade 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -91,6 +91,7 @@ char *conf_get_default_confname(void);
>  void sym_set_change_count(int count);
>  void sym_add_change_count(int count);
>  void conf_set_all_new_symbols(enum conf_def_mode mode);
> +void conf_set_symbol_from_env(char *);
>
>  /* confdata.c and expr.c */
>  static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
>
>
> --
> dwmw2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
