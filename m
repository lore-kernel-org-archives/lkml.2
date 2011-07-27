Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1G0PJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:09:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39999 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1G0PJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:09:15 -0400
MIME-Version: 1.0
In-Reply-To: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
Date: Wed, 27 Jul 2011 11:09:15 -0400
Message-ID: <CACqU3MX3=edNJSNXYLVP=nYFx+bDnBs-zi3A3uYCPLNUrJiMyA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 6:58 PM, Michal Marek <mmarek@suse.cz> wrote:
> Replace the config_is_*() macros with a variant that allows for grepping
> for usage of CONFIG_* options in the code. Usage:
>
>  if (KCONFIG(CONFIG_NUMA))
>
> or
>
>  #if KCONFIG(CONFIG_NUMA)
>
> The KCONFIG() macro evaluates to 1 if the argument is set (to either 'y'
> or 'm'), KCONFIG_BUILTIN() and KCONFIG_MODULE() test if the respective
> option is 'y' and 'm', respectively.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile                   |    2 +-
>  include/linux/kconfig.h    |   24 +++++++++++++++
>  scripts/kconfig/confdata.c |   70 ++++++++-----------------------------------
>  3 files changed, 38 insertions(+), 58 deletions(-)
>  create mode 100644 include/linux/kconfig.h
>
> diff --git a/Makefile b/Makefile
> index afb8e0d..bd7629b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -360,7 +360,7 @@ CFLAGS_GCOV = -fprofile-arcs -ftest-coverage
>  LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
>                    -Iarch/$(hdr-arch)/include/generated -Iinclude \
>                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
> -                   -include include/generated/autoconf.h
> +                   -include $(srctree)/include/linux/kconfig.h
>
>  KBUILD_CPPFLAGS := -D__KERNEL__
>
> diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
> new file mode 100644
> index 0000000..fe80348
> --- /dev/null
> +++ b/include/linux/kconfig.h
> @@ -0,0 +1,24 @@
> +#ifndef __LINUX_KCONFIG_H
> +#define __LINUX_KCONFIG_H
> +
> +#include <generated/autoconf.h>
> +
> +/*
> + * Evaluates to 1 if CONFIG_option is set to 'y', 0 otherwise
> + */
> +#define KCONFIG_BUILTIN(option) __enabled_ ## option
> +
> +/*
> + * Evaluates to 1 if CONFIG_option is set to 'm', 0 otherwise
> + */
> +#define KCONFIG_MODULE(option) __enabled_ ## option ## _MODULE
> +
> +/*
> + * Evaluates to 1 if CONFIG_option is set to 'y' or 'm', 0 otherwise
> + *
> + */
> +#define KCONFIG(option) \
> +       (__enabled_ ## option || __enabled_ ## option ## _MODULE)
> +
> +
> +#endif /* __LINUX_KCONFIG_H */
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index df629ec..3bab40a 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -495,15 +495,24 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
>
>                switch (*value) {
>                case 'n':
> -                       return;
> +                       break;
>                case 'm':
>                        suffix = "_MODULE";
>                        /* fall through */
>                default:
> -                       value = "1";
> +                       fprintf(fp, "#define %s%s%s 1\n",
> +                           CONFIG_, sym->name, suffix);
>                }
> -               fprintf(fp, "#define %s%s%s %s\n",
> -                   CONFIG_, sym->name, suffix, value);
> +               /*
> +                * Generate the __enabled_CONFIG_* and
> +                * __enabled_CONFIG_*_MODULE macros for use by the KCONFIG*()
> +                * macros. The _MODULE variant is generated even for booleans
> +                * so that the KCONFIG() macro works.
> +                */
> +               fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
> +                               sym->name, (*value == 'y'));
> +               fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
> +                               sym->name, (*value == 'm'));
>                break;
>        }
>        case S_HEX: {
Just to comment on the patch itself, it will certainly not apply
against kbuild/kconfig as I changed header_print_symbol() to fix the
S_HEX prefix issue.

 - Arnaud

> @@ -555,58 +564,6 @@ static struct conf_printer header_printer_cb =
>  };
>
>  /*
> - * Function-style header printer
> - *
> - * This printer is used to generate the config_is_xxx() function-style macros
> - * in `include/generated/autoconf.h'
> - */
> -static void
> -header_function_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
> -{
> -       int val = 0;
> -       char c;
> -       char *tmp, *d;
> -
> -       switch (sym->type) {
> -       case S_BOOLEAN:
> -       case S_TRISTATE:
> -               break;
> -       default:
> -               return;
> -       }
> -       if (*value == 'm')
> -               val = 2;
> -       else if (*value == 'y')
> -               val = 1;
> -
> -       d = strdup(CONFIG_);
> -       tmp = d;
> -       while ((c = *d)) {
> -               *d = tolower(c);
> -               d++;
> -       }
> -
> -       fprintf(fp, "#define %sis_", tmp);
> -       free(tmp);
> -
> -       d = strdup(sym->name);
> -       tmp = d;
> -       while ((c = *d)) {
> -               *d = tolower(c);
> -               d++;
> -       }
> -       fprintf(fp, "%s%s() %d\n", tmp, (val > 1) ? "_module" : "",
> -                     val ? 1 : 0);
> -       free(tmp);
> -}
> -
> -static struct conf_printer header_function_printer_cb =
> -{
> -       .print_symbol = header_function_print_symbol,
> -};
> -
> -
> -/*
>  * Tristate printer
>  *
>  * This printer is used when generating the `include/config/tristate.conf' file.
> @@ -997,7 +954,6 @@ int conf_write_autoconf(void)
>                conf_write_symbol(tristate, sym, &tristate_printer_cb, (void *)1);
>
>                conf_write_symbol(out_h, sym, &header_printer_cb, NULL);
> -               conf_write_symbol(out_h, sym, &header_function_printer_cb, NULL);
>        }
>        fclose(out);
>        fclose(tristate);
> --
> 1.7.6
>
>
