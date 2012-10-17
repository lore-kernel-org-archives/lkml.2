Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2JQXz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:55:28 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:32786 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2JQXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:55:27 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2012 19:55:27 EDT
Date: Thu, 18 Oct 2012 01:47:51 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 03/23] printk: Move braille console support into separate
 braille.[ch] files
Message-ID: <20121017234751.GQ5931@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
References: <cover.1350449851.git.joe@perches.com>
 <592f6af296db3e82a392252b3a7c8a7b1020194d.1350449851.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <592f6af296db3e82a392252b3a7c8a7b1020194d.1350449851.git.joe@perches.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches, le Tue 16 Oct 2012 23:06:07 -0700, a écrit :
> Create files with prototypes and static inlines for braille
> support.  Make braille_console functions return 1 on success.
> 
> cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/accessibility/braille/braille_console.c |    9 ++++-
>  kernel/printk/Makefile                          |    1 +
>  kernel/printk/braille.c                         |   48 +++++++++++++++++++++++
>  kernel/printk/braille.h                         |   48 +++++++++++++++++++++++
>  kernel/printk/printk.c                          |   44 ++++++---------------
>  5 files changed, 117 insertions(+), 33 deletions(-)
>  create mode 100644 kernel/printk/braille.c
>  create mode 100644 kernel/printk/braille.h
> 
> diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
> index d21167b..dc34a5b 100644
> --- a/drivers/accessibility/braille/braille_console.c
> +++ b/drivers/accessibility/braille/braille_console.c
> @@ -359,6 +359,9 @@ int braille_register_console(struct console *console, int index,
>  		char *console_options, char *braille_options)
>  {
>  	int ret;
> +
> +	if (!(console->flags & CON_BRL))
> +		return 0;
>  	if (!console_options)
>  		/* Only support VisioBraille for now */
>  		console_options = "57600o8";
> @@ -374,15 +377,17 @@ int braille_register_console(struct console *console, int index,
>  	braille_co = console;
>  	register_keyboard_notifier(&keyboard_notifier_block);
>  	register_vt_notifier(&vt_notifier_block);
> -	return 0;
> +	return 1;
>  }
>  
>  int braille_unregister_console(struct console *console)
>  {
>  	if (braille_co != console)
>  		return -EINVAL;
> +	if (!(console->flags & CON_BRL))
> +		return 0;
>  	unregister_keyboard_notifier(&keyboard_notifier_block);
>  	unregister_vt_notifier(&vt_notifier_block);
>  	braille_co = NULL;
> -	return 0;
> +	return 1;
>  }
> diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
> index 36d306d..85405bd 100644
> --- a/kernel/printk/Makefile
> +++ b/kernel/printk/Makefile
> @@ -1 +1,2 @@
>  obj-y	= printk.o
> +obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
> diff --git a/kernel/printk/braille.c b/kernel/printk/braille.c
> new file mode 100644
> index 0000000..b51087f
> --- /dev/null
> +++ b/kernel/printk/braille.c
> @@ -0,0 +1,48 @@
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/console.h>
> +#include <linux/string.h>
> +
> +#include "console_cmdline.h"
> +#include "braille.h"
> +
> +char *_braille_console_setup(char **str, char **brl_options)
> +{
> +	if (!memcmp(*str, "brl,", 4)) {
> +		*brl_options = "";
> +		*str += 4;
> +	} else if (!memcmp(str, "brl=", 4)) {
> +		*brl_options = *str + 4;
> +		*str = strchr(*brl_options, ',');
> +		if (!*str)
> +			pr_err("need port name after brl=\n");
> +		else
> +			*((*str)++) = 0;
> +	}
> +
> +	return *str;
> +}
> +
> +int
> +_braille_register_console(struct console *console, struct console_cmdline *c)
> +{
> +	int rtn = 0;
> +
> +	if (c->brl_options) {
> +		console->flags |= CON_BRL;
> +		rtn = braille_register_console(console, c->index, c->options,
> +					       c->brl_options);
> +	}
> +
> +	return rtn;
> +}
> +
> +int
> +_braille_unregister_console(struct console *console)
> +{
> +	if (console->flags & CON_BRL)
> +		return braille_unregister_console(console);
> +
> +	return 0;
> +}
> diff --git a/kernel/printk/braille.h b/kernel/printk/braille.h
> new file mode 100644
> index 0000000..d2e6bc3
> --- /dev/null
> +++ b/kernel/printk/braille.h
> @@ -0,0 +1,48 @@
> +#ifndef _PRINTK_BRAILLE_H
> +#define _PRINTK_BRAILLE_H
> +
> +#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> +
> +static inline void
> +braille_set_options(struct console_cmdline *c, char *brl_options)
> +{
> +	c->brl_options = brl_options;
> +}
> +
> +char *
> +_braille_console_setup(char **str, char **brl_options);
> +
> +int
> +_braille_register_console(struct console *console, struct console_cmdline *c);
> +
> +int
> +_braille_unregister_console(struct console *console);
> +
> +#else
> +
> +static inline void
> +braille_set_options(struct console_cmdline *c, char *brl_options)
> +{
> +}
> +
> +static inline char *
> +_braille_console_setup(char **str, char **brl_options)
> +{
> +	return *str;
> +}
> +
> +static inline int
> +_braille_register_console(struct console *console, struct console_cmdline *c)
> +{
> +	return 0;
> +}
> +
> +static inline int
> +_braille_unregister_console(struct console *console)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 50ef6af..df5b80f 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -47,6 +47,7 @@
>  #include <trace/events/printk.h>
>  
>  #include "console_cmdline.h"
> +#include "braille.h"
>  
>  /*
>   * Architectures can override it:
> @@ -1731,9 +1732,8 @@ static int __add_preferred_console(char *name, int idx, char *options,
>  	c = &console_cmdline[i];
>  	strlcpy(c->name, name, sizeof(c->name));
>  	c->options = options;
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	c->brl_options = brl_options;
> -#endif
> +	braille_set_options(c, brl_options);
> +
>  	c->index = idx;
>  	return 0;
>  }
> @@ -1746,20 +1746,8 @@ static int __init console_setup(char *str)
>  	char *s, *options, *brl_options = NULL;
>  	int idx;
>  
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	if (!memcmp(str, "brl,", 4)) {
> -		brl_options = "";
> -		str += 4;
> -	} else if (!memcmp(str, "brl=", 4)) {
> -		brl_options = str + 4;
> -		str = strchr(brl_options, ',');
> -		if (!str) {
> -			printk(KERN_ERR "need port name after brl=\n");
> -			return 1;
> -		}
> -		*(str++) = 0;
> -	}
> -#endif
> +	if (_braille_console_setup(&str, &brl_options))
> +		return 1;
>  
>  	/*
>  	 * Decode str into name, index, options.
> @@ -2286,16 +2274,10 @@ void register_console(struct console *newcon)
>  			continue;
>  		if (newcon->index < 0)
>  			newcon->index = console_cmdline[i].index;
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -		if (console_cmdline[i].brl_options) {
> -			newcon->flags |= CON_BRL;
> -			braille_register_console(newcon,
> -					console_cmdline[i].index,
> -					console_cmdline[i].options,
> -					console_cmdline[i].brl_options);
> +
> +		if (_braille_register_console(newcon, &console_cmdline[i]))
>  			return;
> -		}
> -#endif
> +
>  		if (newcon->setup &&
>  		    newcon->setup(newcon, console_cmdline[i].options) != 0)
>  			break;
> @@ -2383,13 +2365,13 @@ EXPORT_SYMBOL(register_console);
>  int unregister_console(struct console *console)
>  {
>          struct console *a, *b;
> -	int res = 1;
> +	int res;
>  
> -#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	if (console->flags & CON_BRL)
> -		return braille_unregister_console(console);
> -#endif
> +	res = _braille_unregister_console(console);
> +	if (res)
> +		return res;
>  
> +	res = 1;
>  	console_lock();
>  	if (console_drivers == console) {
>  		console_drivers=console->next;
> -- 
> 1.7.10.4
> 

-- 
Samuel
J'ai beaucoup de mal a lire fcola quand il y a toutes les annonces de howto :
les annonces interessantes sont noyees dans les howto. Ca serait pas mal
de degager toute cette pollution dans un autre groupe.
  JLM in Guide du linuxien pervers : "Cachez ces doc que je ne saurais voir"
