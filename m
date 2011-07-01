Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1GAOMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:12:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab1GAOMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:12:01 -0400
Message-ID: <4E0DD5AF.5040604@suse.cz>
Date: Fri, 01 Jul 2011 16:11:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] Kconfig library check merge
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.6.2011 21:16, Arnaud Lacombe wrote:
> Hi Michal, Sam,
>
> This is a bit a more deep patch. I was fed up of seeing the various library
> check done for kconfig in at least 3 places in the scripts/kconfig/ tree. In
> particular, the QT and GTK checks are far too messy to be in a Makefile, while
> the gettext is pretty trivial and has its own shell script... Moreover, `nconf'
> is missing explicit check for ncurses.
>
> Anyway, here it is. It is a single huge patch _on_purpose_, merely meant to be a
> proof of concept. It is based on the previous serie of trivial fixes.
>
> Most of the changes are made to rationalize the architecture. I thought in the
> beginning of using autoconf/automake, but that'd be overkill. A single shell
> script is far enough to do the job. All the checks only do a bunch of
> verification, and export CFLAGS/LDFLAGS for building the frontend. The script
> itself output a Makefile ready to be included for the top-level Makefile, with
> the necessary check to trigger a re-check if the requested front-end is changed.
>
> Comments welcome!
>
> Regards,
>   - Arnaud
>
> Cc: Sam Ravnborg<sam@ravnborg.org>
>
> ---
>   scripts/kconfig/Makefile                   |  160 +++++++------------------
>   scripts/kconfig/check.sh                   |  184 ++++++++++++++++++++++++++--
>   scripts/kconfig/lxdialog/check-lxdialog.sh |   84 -------------
>   3 files changed, 216 insertions(+), 212 deletions(-)
>
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 84abb2f..f8f853d 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -141,14 +141,6 @@ help:
>   	@echo  '  listnewconfig   - List new options'
>   	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
>
> -# lxdialog stuff
> -check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
> -
> -# Use recursively expanded variables so we do not call gcc unless
> -# we really need to do so. (Do not call gcc as part of make mrproper)
> -HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags) \
> -                    -DLOCALE
> -
>   # ===========================================================================
>   # Shared Makefile for the various kconfig executables:
>   # conf:	  Used for defconfig, oldconfig and related targets
> @@ -173,14 +165,19 @@ qconf-cxxobjs	:= qconf.o
>   qconf-objs	:= zconf.tab.o
>   gconf-objs	:= gconf.o zconf.tab.o
>
> -hostprogs-y := conf
> +frontends-objs := $(conf-objs) $(mconf-objs) $(nconf-objs)
> +frontends-objs := $(qconf-cxxobjs) $(gconf-objs)
                   ^^
Should be +=.

> +
> +hostprogs-y :=
>
>   ifeq ($(MAKECMDGOALS),nconfig)
>   	hostprogs-y += nconf
> +	ncurses-check := 1
>   endif
>
>   ifeq ($(MAKECMDGOALS),menuconfig)
>   	hostprogs-y += mconf
> +	ncurses-check := 1
>   endif
>
>   ifeq ($(MAKECMDGOALS),update-po-config)
> @@ -188,140 +185,67 @@ ifeq ($(MAKECMDGOALS),update-po-config)
>   endif
>
>   ifeq ($(MAKECMDGOALS),xconfig)
> -	qconf-target := 1
> -endif
> -ifeq ($(MAKECMDGOALS),gconfig)
> -	gconf-target := 1
> -endif
> -
> -
> -ifeq ($(qconf-target),1)
>   	hostprogs-y += qconf
> +	qt-check := 1
>   endif
> -
> -ifeq ($(gconf-target),1)
> +ifeq ($(MAKECMDGOALS),gconfig)
>   	hostprogs-y += gconf
> +	gtk-check := 1
>   endif
...
> +KC_CHECK	:= gettext
> +
> +ifeq ($(ncurses-check),1)
> +KC_CHECK	+= ncurses
>   endif

You could also build the KC_CHECK right when doing the $(MAKECMDGOALS) 
tests and drop the *-check variables. Otherwise it is a very nice 
cleanup, thanks a lot!

Michal
