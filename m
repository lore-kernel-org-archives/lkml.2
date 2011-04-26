Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1DZGil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:38:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56861 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab1DZGij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KMFZ6VX+qHKFlf1vxWZhS4pxSJggt/T8wU3yAL4C802cLZXqTJB65ulNwU1g5Pg1GK
         ZHsDU40GPh3xFnMcG4tn/wNx8n93NrSY+ZKpTJuBIMcVFivE5c8z1JMmQCB/fQrqXn6I
         BeE0xoVUZquRAgGOCrYgowCcmtwEv1587wFMo=
MIME-Version: 1.0
In-Reply-To: <4DB60DE1.8060402@verizon.net>
References: <4DB60DE1.8060402@verizon.net>
Date: Tue, 26 Apr 2011 02:38:36 -0400
Message-ID: <BANLkTiniyJ6u-1X9DT74+2xHBKJDVc6bSA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: scripts/kconfig/Makefile cleanup and fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 25, 2011 at 8:12 PM, Peter Foley <pefoley2@verizon.net> wrote:
> This patch:
> Changes the update-po-config target to work when make is run from KBUILD_OUTDIR.
> Adds a check to only build kxgettext when needed.
> Changes the qconf and gconf targets to change hostprogs-y when they are being built
>        like nconfig and menuconfig instead of defining *-objs.
> Cleans up the clean-files definitions.
>
Would it be possible to split that one into several patches, one for
each change ? Associating the diff and to log is pretty much
impossible. From the commit message, that should be 4 patches.

Thanks,
 - Arnaud

> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/kconfig/Makefile |   35 +++++++++++++++++++++--------------
>  1 files changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 368ae30..c4206ce 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -77,14 +77,15 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
>  # The symlink is used to repair a deficiency in arch/um
>  update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
>        $(Q)echo "  GEN config"
> -       $(Q)xgettext --default-domain=linux              \
> -           --add-comments --keyword=_ --keyword=N_      \
> -           --from-code=UTF-8                            \
> -           --files-from=scripts/kconfig/POTFILES.in     \
> +       $(Q)xgettext --default-domain=linux                         \
> +           --add-comments --keyword=_ --keyword=N_                 \
> +           --from-code=UTF-8                                       \
> +           --files-from=$(srctree)/scripts/kconfig/POTFILES.in     \
> +           --directory=$(srctree) --directory=$(objtree)           \
>            --output $(obj)/config.pot
>        $(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
> -       $(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
> -       $(Q)(for i in `ls arch/*/Kconfig`;               \
> +       $(Q)ln -fs Kconfig.x86 $(srctree)/arch/um/Kconfig
> +       $(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
>            do                                           \
>                echo "  GEN $$i";                        \
>                $(obj)/kxgettext $$i                     \
> @@ -92,7 +93,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
>            done )
>        $(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
>            --output $(obj)/linux.pot
> -       $(Q)rm -f arch/um/Kconfig.arch
> +       $(Q)rm -f $(srctree)/arch/um/Kconfig
>        $(Q)rm -f $(obj)/config.pot
>
>  PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
> @@ -167,9 +168,12 @@ lxdialog += lxdialog/textbox.o lxdialog/yesno.o
> lxdialog/menubox.o
>  conf-objs      := conf.o  zconf.tab.o
>  mconf-objs     := mconf.o zconf.tab.o $(lxdialog)
>  nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
> +qconf-cxxobjs  := qconf.o
> +qconf-objs     := kconfig_load.o zconf.tab.o
> +gconf-objs     := gconf.o kconfig_load.o zconf.tab.o
>  kxgettext-objs := kxgettext.o zconf.tab.o
>
> -hostprogs-y := conf qconf gconf kxgettext
> +hostprogs-y := conf
>
>  ifeq ($(MAKECMDGOALS),nconfig)
>        hostprogs-y += nconf
> @@ -186,18 +190,20 @@ ifeq ($(MAKECMDGOALS),gconfig)
>        gconf-target := 1
>  endif
>
> +ifeq ($(MAKECMDGOALS),update-po-config)
> +       hostprogs-y += kxgettext
> +endif
>
>  ifeq ($(qconf-target),1)
> -qconf-cxxobjs  := qconf.o
> -qconf-objs     := kconfig_load.o zconf.tab.o
> +       hostprogs-y += qconf
>  endif
>
>  ifeq ($(gconf-target),1)
> -gconf-objs     := gconf.o kconfig_load.o zconf.tab.o
> +       hostprogs-y += gconf
>  endif
>
> -clean-files    := lkc_defs.h qconf.moc .tmp_qtcheck \
> -                  .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
> +clean-files    := lkc_defs.h qconf.moc .tmp_qtcheck .tmp_gtkcheck
> +clean-files     += zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
>  clean-files     += mconf qconf gconf nconf
>  clean-files     += config.pot linux.pot
>
> @@ -325,7 +331,8 @@ $(obj)/lkc_defs.h: $(src)/lkc_proto.h
>
>  # Extract gconf menu items for I18N support
>  $(obj)/gconf.glade.h: $(obj)/gconf.glade
> -       intltool-extract --type=gettext/glade $(obj)/gconf.glade
> +       $(Q)intltool-extract --type=gettext/glade --srcdir $(srctree) \
> +       $(src)/gconf.glade
>
>  ###
>  # The following requires flex/bison/gperf
> --
> 1.7.5.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
