Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1BYGHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:07:10 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38881 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1BYGHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:07:08 -0500
Date: Fri, 25 Feb 2011 07:07:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Add ``cloneconfig'' target
Message-ID: <20110225060706.GA12723@merkur.ravnborg.org>
References: <4D671556.80607@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D671556.80607@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:35:02PM -0500, Jeff Mahoney wrote:
> Cloneconfig takes the first configuration it finds which appears
> to belong to the running kernel, and configures the kernel sources
> to match this configuration as closely as possible.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  scripts/kconfig/Makefile |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -99,6 +99,23 @@ PHONY += allnoconfig allyesconfig allmod
>  
>  allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
>  	$< --$@ $(Kconfig)
> + 
> +UNAME_RELEASE := $(shell uname -r)
> +CLONECONFIG := $(firstword $(wildcard /proc/config.gz \
> +				      /lib/modules/$(UNAME_RELEASE)/.config \
> +				      /etc/kernel-config \
> +				      /boot/config-$(UNAME_RELEASE)))
> +cloneconfig: $(obj)/conf
> +	$(Q)case "$(CLONECONFIG)" in				\
> +	'')	echo -e "The configuration of the running"	\
> +			"kernel could not be determined\n";	\
> +		false ;;					\
> +	*.gz)	gzip -cd $(CLONECONFIG) > .config.running ;;	\
> +	*)	cat $(CLONECONFIG) > .config.running ;;		\
> +	esac &&							\
> +	echo -e "Cloning configuration file $(CLONECONFIG)\n"
> +	$(Q)$< -D .config.running arch/$(SRCARCH)/Kconfig
> +

We already have something remotely similar in kconfig.
We use the following list:
config DEFCONFIG_LIST
        string
        depends on !UML
        option defconfig_list
        default "/lib/modules/$UNAME_RELEASE/.config"
        default "/etc/kernel-config"
        default "/boot/config-$UNAME_RELEASE"
        default "$ARCH_DEFCONFIG"
        default "arch/$ARCH/defconfig"

It would be better to teach kconfig to read /proc/config.gz
and then add it to the list above.

This list is used if you just type "make enuconfig" without
any configuration.

	Sam
