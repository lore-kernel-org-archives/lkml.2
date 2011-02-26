Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1BZTuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 14:50:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52184 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1BZTuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 14:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ia/ZFC5N7QlGqGt48xYPG6Wvt7NAsiTKjypSHjIIIWwnnBZbbfZrF0Z1M+VSbwkgGu
         2RZfY3CR0r8og1mGE0vHUe70skZxu0BPuZqSmtGsysZS/QCl8YBFqtvbQUTG9gDjelAL
         IlUYDjVDGHTO3j9nbIidlGMD99ITHvqD4ThTQ=
MIME-Version: 1.0
In-Reply-To: <4D671556.80607@suse.com>
References: <4D671556.80607@suse.com>
Date: Sat, 26 Feb 2011 14:50:06 -0500
Message-ID: <AANLkTimt1y_QwtRpAj1F9Nvh3j2VSJGw7MvtQSzW_oG9@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 24, 2011 at 9:35 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> Cloneconfig takes the first configuration it finds which appears
> to belong to the running kernel, and configures the kernel sources
> to match this configuration as closely as possible.
>
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  scripts/kconfig/Makefile |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -99,6 +99,23 @@ PHONY += allnoconfig allyesconfig allmod
>
>  allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
>        $< --$@ $(Kconfig)
> +
> +UNAME_RELEASE := $(shell uname -r)
> +CLONECONFIG := $(firstword $(wildcard /proc/config.gz \
> +                                     /lib/modules/$(UNAME_RELEASE)/.config \
> +                                     /etc/kernel-config \
> +                                     /boot/config-$(UNAME_RELEASE)))
> +cloneconfig: $(obj)/conf
> +       $(Q)case "$(CLONECONFIG)" in                            \
> +       '')     echo -e "The configuration of the running"      \
> +                       "kernel could not be determined\n";     \
You do not need the '\n', nor the '-e', echo(1) appends a newline by default.

> +               false ;;                                        \
> +       *.gz)   gzip -cd $(CLONECONFIG) > .config.running ;;    \
> +       *)      cat $(CLONECONFIG) > .config.running ;;         \
> +       esac &&                                                 \
> +       echo -e "Cloning configuration file $(CLONECONFIG)\n"
see above.

> +       $(Q)$< -D .config.running arch/$(SRCARCH)/Kconfig
> +
>
>  PHONY += listnewconfig oldnoconfig savedefconfig defconfig
>
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
