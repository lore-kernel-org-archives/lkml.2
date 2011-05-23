Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1EWR62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:58:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38083 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab1EWR60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N8nBzY/kZ7mw4+FuGcbbebIezumuKIfV6cqhuQ04sMj6qvKplHL9bf3Xk7bVfM4FLj
         Z5ha40ET3uSptL29hToTA6s66/y1fsFiRTe8rpOBbjtoyYNUjL0abqQe4iDH0MO77850
         8v0FLlf1uErL9gEmNtRn/nbYiHQF4mlT3wrEc=
MIME-Version: 1.0
In-Reply-To: <1306167401.18840.8.camel@hiromu-MacBook>
References: <1306167401.18840.8.camel@hiromu-MacBook>
Date: Mon, 23 May 2011 13:58:25 -0400
Message-ID: <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Arnaud Lacombe <lacombar@gmail.com>
To: hiromu <hiromu1996@gmail.com>
Cc: llinux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        zippel@linux-m68k.org, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 23, 2011 at 12:16 PM, hiromu <hiromu1996@gmail.com> wrote:
> Some kbuild targets don't warn us about permission of the configure.
> If you don't set write permission, you lose changes.
Do you have a precise way to reproduce this, in particular which
target is involved ? I tried to `chmod 555' the kernel root directory,
re-ran `conf' (through the `defconfig' target) and `mconf' (manually
for this one, as check-lxdialog.sh fails when invoked though make).
The former failed with:

*** Error during writing of the configuration.

gmake[1]: *** [defconfig] Error 1
gmake: *** [defconfig] Error 2

so the error is also propagated through make(1) to the shell and the
latter failed with:

Error while writing of the configuration.
Your configuration changes were NOT saved.

So check _are_ being done whether or not the configuration can be
written, but there might be a corner-case not checked, in that case,
this specific path should be fixed.

Thanks,
 - Arnaud

> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Arnaud Lacombe <lacombar@gmail.com>
>
> Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
> ---
>  scripts/kconfig/conf.c     |    6 ++++++
>  scripts/kconfig/confdata.c |   17 +++++++++++++++++
>  scripts/kconfig/gconf.c    |    4 ++++
>  scripts/kconfig/lkc.h      |    1 +
>  scripts/kconfig/mconf.c    |    4 ++++
>  scripts/kconfig/nconf.c    |    4 ++++
>  scripts/kconfig/qconf.cc   |    4 ++++
>  7 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 006ad81..d93e351 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -466,6 +466,12 @@ int main(int ac, char **av)
>        bindtextdomain(PACKAGE, LOCALEDIR);
>        textdomain(PACKAGE);
>
> +       if (conf_check_permission()) {
> +               fprintf(stderr,
> +                       "*** Permission denied to write the configuration.\n\n");
> +               exit(1);
> +       }
> +
>        while ((opt = getopt_long(ac, av, "", long_opts, NULL)) != -1) {
>                input_mode = (enum input_mode)opt;
>                switch (opt) {
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 61c35bf..3de1fbe 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -7,6 +7,7 @@
>  #include <ctype.h>
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <libgen.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -1051,3 +1052,19 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
>                        set_all_choice_values(csym);
>        }
>  }
> +
> +int conf_check_permission(void)
> +{
> +       int ret, retval = 0;
> +       const char *name;
> +       char *dir;
> +
> +       name = conf_get_configname();
> +       dir = dirname((char *)name);
> +
> +       ret = access(dir, W_OK);
> +       if (ret < 0)
> +               retval = -errno;
> +
> +       return retval;
> +}
> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> index 4558961..3567a23 100644
> --- a/scripts/kconfig/gconf.c
> +++ b/scripts/kconfig/gconf.c
> @@ -1510,6 +1510,10 @@ int main(int ac, char *av[])
>        bind_textdomain_codeset(PACKAGE, "UTF-8");
>        textdomain(PACKAGE);
>
> +       if (conf_check_permission())
> +               fprintf(stderr,
> +                       "Warning: Permission denied to write the configuration.\n");
> +
>        /* GTK stuffs */
>        gtk_set_locale();
>        gtk_init(&ac, &av);
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index febf0c9..4d20841 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -91,6 +91,7 @@ char *conf_get_default_confname(void);
>  void sym_set_change_count(int count);
>  void sym_add_change_count(int count);
>  void conf_set_all_new_symbols(enum conf_def_mode mode);
> +int conf_check_permission(void);
>
>  /* confdata.c and expr.c */
>  static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index d433c7a..c820e05 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -803,6 +803,10 @@ int main(int ac, char **av)
>        bindtextdomain(PACKAGE, LOCALEDIR);
>        textdomain(PACKAGE);
>
> +       if (conf_check_permission())
> +               fprintf(stderr,
> +                       "Warning: Permission denied to write the configuration.\n");
> +
>        conf_parse(av[1]);
>        conf_read(NULL);
>
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index db56377..1cea031 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -1491,6 +1491,10 @@ int main(int ac, char **av)
>        bindtextdomain(PACKAGE, LOCALEDIR);
>        textdomain(PACKAGE);
>
> +       if (conf_check_permission())
> +               fprintf(stderr,
> +                       "Warning: Permission denied to write the configuration.\n");
> +
>        conf_parse(av[1]);
>        conf_read(NULL);
>
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index 06dd2e3..7dca7ac 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -1746,6 +1746,10 @@ int main(int ac, char** av)
>        bindtextdomain(PACKAGE, LOCALEDIR);
>        textdomain(PACKAGE);
>
> +       if (conf_check_permission())
> +               fprintf(stderr,
> +                       "Warning: Permission denied to write the configuration.\n");
> +
>  #ifndef LKC_DIRECT_LINK
>        kconfig_load();
>  #endif
> --
> 1.7.4.1
>
>
>
>
