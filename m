Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab1EXNGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:06:48 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:34223 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab1EXNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pejKEmF1rND0ottilo0zEd0bbnXWsUrpVrxCFP9q076GhwjUohXdAWdKw/VGDR356V
         pLdrQqYmt9sevJ4LE2RrRve+Nx70sbww0YvjNjXucqfhMuEplrDCjHhh3X/01RJktiwB
         y4TKEbd7gSyPL514i4DK1WrbSp2z3A0I2UTNw=
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Hiromu Yakura <hiromu1996@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        zippel@linux-m68k.org, mmarek@suse.cz
In-Reply-To: <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 22:06:40 +0900
Message-ID: <1306242400.7501.10.camel@hiromu-MacBook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
thanks for replying.

On Mon, May 23, 2011 at 13:58, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Do you have a precise way to reproduce this, in particular which
> target is involved ? I tried to `chmod 555' the kernel root directory,
> re-ran `conf' (through the `defconfig' target) and `mconf' (manually
> for this one, as check-lxdialog.sh fails when invoked though make).
> The former failed with:
> 
> *** Error during writing of the configuration.
> 
> gmake[1]: *** [defconfig] Error 1
> gmake: *** [defconfig] Error 2
In my environment, this patch is working properly.
The output is as follows:

hiromu@hiromu-MacBook:/usr/src/linux-2.6$ ls -ld .
dr-xr-sr-x 25 hiromu hiromu 4096 May 24 21:41 .
hiromu@hiromu-MacBook:/usr/src/linux-2.6$ make defconfig
*** Default configuration is based on 'x86_64_defconfig'
*** Permission denied to write the configuration.

make[1]: *** [defconfig] Error 1
make: *** [defconfig] Error 2
hiromu@hiromu-MacBook:/usr/src/linux-2.6$  

> So check _are_ being done whether or not the configuration can be
> written, but there might be a corner-case not checked, in that case,
> this specific path should be fixed.
I think it is OK if you have the write permission to the directory
which be saved the configuration.

> > Cc: Roman Zippel <zippel@linux-m68k.org>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Arnaud Lacombe <lacombar@gmail.com>
> >
> > Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
> > ---
> >  scripts/kconfig/conf.c     |    6 ++++++
> >  scripts/kconfig/confdata.c |   17 +++++++++++++++++
> >  scripts/kconfig/gconf.c    |    4 ++++
> >  scripts/kconfig/lkc.h      |    1 +
> >  scripts/kconfig/mconf.c    |    4 ++++
> >  scripts/kconfig/nconf.c    |    4 ++++
> >  scripts/kconfig/qconf.cc   |    4 ++++
> >  7 files changed, 40 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> > index 006ad81..d93e351 100644
> > --- a/scripts/kconfig/conf.c
> > +++ b/scripts/kconfig/conf.c
> > @@ -466,6 +466,12 @@ int main(int ac, char **av)
> >        bindtextdomain(PACKAGE, LOCALEDIR);
> >        textdomain(PACKAGE);
> >
> > +       if (conf_check_permission()) {
> > +               fprintf(stderr,
> > +                       "*** Permission denied to write the configuration.\n\n");
> > +               exit(1);
> > +       }
> > +
> >        while ((opt = getopt_long(ac, av, "", long_opts, NULL)) != -1) {
> >                input_mode = (enum input_mode)opt;
> >                switch (opt) {
> > diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> > index 61c35bf..3de1fbe 100644
> > --- a/scripts/kconfig/confdata.c
> > +++ b/scripts/kconfig/confdata.c
> > @@ -7,6 +7,7 @@
> >  #include <ctype.h>
> >  #include <errno.h>
> >  #include <fcntl.h>
> > +#include <libgen.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > @@ -1051,3 +1052,19 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
> >                        set_all_choice_values(csym);
> >        }
> >  }
> > +
> > +int conf_check_permission(void)
> > +{
> > +       int ret, retval = 0;
> > +       const char *name;
> > +       char *dir;
> > +
> > +       name = conf_get_configname();
> > +       dir = dirname((char *)name);
> > +
> > +       ret = access(dir, W_OK);
> > +       if (ret < 0)
> > +               retval = -errno;
> > +
> > +       return retval;
> > +}
> > diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> > index 4558961..3567a23 100644
> > --- a/scripts/kconfig/gconf.c
> > +++ b/scripts/kconfig/gconf.c
> > @@ -1510,6 +1510,10 @@ int main(int ac, char *av[])
> >        bind_textdomain_codeset(PACKAGE, "UTF-8");
> >        textdomain(PACKAGE);
> >
> > +       if (conf_check_permission())
> > +               fprintf(stderr,
> > +                       "Warning: Permission denied to write the configuration.\n");
> > +
> >        /* GTK stuffs */
> >        gtk_set_locale();
> >        gtk_init(&ac, &av);
> > diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> > index febf0c9..4d20841 100644
> > --- a/scripts/kconfig/lkc.h
> > +++ b/scripts/kconfig/lkc.h
> > @@ -91,6 +91,7 @@ char *conf_get_default_confname(void);
> >  void sym_set_change_count(int count);
> >  void sym_add_change_count(int count);
> >  void conf_set_all_new_symbols(enum conf_def_mode mode);
> > +int conf_check_permission(void);
> >
> >  /* confdata.c and expr.c */
> >  static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
> > diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> > index d433c7a..c820e05 100644
> > --- a/scripts/kconfig/mconf.c
> > +++ b/scripts/kconfig/mconf.c
> > @@ -803,6 +803,10 @@ int main(int ac, char **av)
> >        bindtextdomain(PACKAGE, LOCALEDIR);
> >        textdomain(PACKAGE);
> >
> > +       if (conf_check_permission())
> > +               fprintf(stderr,
> > +                       "Warning: Permission denied to write the configuration.\n");
> > +
> >        conf_parse(av[1]);
> >        conf_read(NULL);
> >
> > diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> > index db56377..1cea031 100644
> > --- a/scripts/kconfig/nconf.c
> > +++ b/scripts/kconfig/nconf.c
> > @@ -1491,6 +1491,10 @@ int main(int ac, char **av)
> >        bindtextdomain(PACKAGE, LOCALEDIR);
> >        textdomain(PACKAGE);
> >
> > +       if (conf_check_permission())
> > +               fprintf(stderr,
> > +                       "Warning: Permission denied to write the configuration.\n");
> > +
> >        conf_parse(av[1]);
> >        conf_read(NULL);
> >
> > diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> > index 06dd2e3..7dca7ac 100644
> > --- a/scripts/kconfig/qconf.cc
> > +++ b/scripts/kconfig/qconf.cc
> > @@ -1746,6 +1746,10 @@ int main(int ac, char** av)
> >        bindtextdomain(PACKAGE, LOCALEDIR);
> >        textdomain(PACKAGE);
> >
> > +       if (conf_check_permission())
> > +               fprintf(stderr,
> > +                       "Warning: Permission denied to write the configuration.\n");
> > +
> >  #ifndef LKC_DIRECT_LINK
> >        kconfig_load();
> >  #endif
> > --
> > 1.7.4.1
> >
> >
> >
> >

