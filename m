Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1BJPX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:23:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1BJPX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:23:57 -0500
Message-ID: <4D54030B.5040407@suse.cz>
Date: Thu, 10 Feb 2011 16:23:55 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ulf Magnusson <ulfalizer.lkml@gmail.com>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: undefined symbols can crash dependency loop
 detection
References: <20110204231611.GA9344@ulf>
In-Reply-To: <20110204231611.GA9344@ulf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.2.2011 00:16, Ulf Magnusson wrote:
> The Kconfig
> 
> config FOO
> 	bool "FOO" if BAR
> 	select BAR
> 
> has a dependency loop involving an undefined symbol BAR. This causes a
> segfault in sym_check_print_recursive() as it assumes all symbols have a
> non-null 'prop', which is not the case for undefined symbols. This is a
> proposed fix.
> 
> Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> ---
>  scripts/kconfig/symbol.c |   32 ++++++++++++++++++++++++++++----
>  1 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index a796c95..81a217f 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -5,6 +5,7 @@
>  
>  #include <ctype.h>
>  #include <stdlib.h>
> +#include <stdio.h>
>  #include <string.h>
>  #include <regex.h>
>  #include <sys/utsname.h>
> @@ -972,6 +973,10 @@ static void sym_check_print_recursive(struct symbol *last_sym)
>  	struct menu *menu = NULL;
>  	struct property *prop;
>  	struct dep_stack cv_stack;
> +	const char *filename;
> +	int lineno;
> +	char undef_msg_buf[100];
> +	int snprintf_size;
>  
>  	if (sym_is_choice_value(last_sym)) {
>  		dep_stack_insert(&cv_stack, last_sym);
> @@ -1001,18 +1006,37 @@ static void sym_check_print_recursive(struct symbol *last_sym)
>  					break;
>  			}
>  		}
> +
> +		if (prop) {
> +			filename = prop->file->name;
> +			lineno = prop->lineno;
> +		} else {
> +			/* The dependency loop involves an undefined symbol.
> +			 * Checking sym->name is probably unnecessary here, but
> +			 * just to be on the safe side. */
> +			snprintf_size = snprintf(undef_msg_buf,
> +						 sizeof(undef_msg_buf),
> +						 "<no file, %s is undefined>",
> +						 sym->name ? sym->name :
> +							     "<choice>");
> +			if (snprintf_size > sizeof(undef_msg_buf))
> +				undef_msg_buf[sizeof(undef_msg_buf) - 1] = '\0';
> +			filename = undef_msg_buf;
> +			lineno = 0;

Good catch. But as this handles a corner case involving a severely
borken Kconfig file, I would simply do
filename = "<unknown>";
lineno = 0;
and be done with it.

Michal
