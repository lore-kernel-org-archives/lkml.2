Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0DNNW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:22:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:49197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0DNNW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:22:27 -0400
Message-ID: <4BC5C190.3020501@suse.cz>
Date: Wed, 14 Apr 2010 15:22:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.5 Thunderbird/3.0.4
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and	loose_nonint_oldconfig
 (v2)
References: <20100413194747.GX31193@redhat.com> <20100413130031.d4dec19b.randy.dunlap@oracle.com> <20100413201759.GY31193@redhat.com> <4BC4D310.6060705@oracle.com> <20100413210352.GA31193@redhat.com>
In-Reply-To: <20100413210352.GA31193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.4.2010 23:03, Aristeu Rozanski wrote:
> This patch has been around for a long time in Fedora and Red Hat Enterprise   
> Linux kernels and it may be useful for others. The nonint_oldconfig target    
> will fail and print the unset config options

Nice.


> while loose_nonint_oldconfig will simply let the config option unset.

So loose_nonint_oldconfig is just a less chatty version of
$ yes '' | make oldconfig
? Also, you should update make help.


> They're useful in distro kernel packages  
> where the config files are built using a combination of smaller config files. 
> 
> Arjan van de Ven wrote the initial nonint_config and Roland McGrath added the
> loose_nonint_oldconfig.
> 
> v2:
> - when -B and -b are used, return "2" so the reason can be distinguished from
>   other errors
> 
> Signed-off-by: Arjan van de Ven <arjan@redhat.com> [defunct email]
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> --- linus-2.6.orig/scripts/kconfig/Makefile	2010-04-13 16:30:47.000000000 -0400
> +++ linus-2.6/scripts/kconfig/Makefile	2010-04-13 16:48:24.000000000 -0400
> @@ -69,6 +69,11 @@ localyesconfig: $(obj)/streamline_config
>  	fi
>  	$(Q)rm -f .tmp.config
>  
> +nonint_oldconfig: $(obj)/conf
> +	$< -b $(Kconfig)
> +loose_nonint_oldconfig: $(obj)/conf
> +	$< -B $(Kconfig)

Add an empty line between the two rules.


> +
>  # Create new linux.pot file
>  # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
>  # The symlink is used to repair a deficiency in arch/um
> --- linus-2.6.orig/scripts/kconfig/conf.c	2010-04-13 16:30:47.000000000 -0400
> +++ linus-2.6/scripts/kconfig/conf.c	2010-04-13 16:53:20.000000000 -0400
> @@ -16,6 +16,9 @@
>  #define LKC_DIRECT_LINK
>  #include "lkc.h"
>  
> +/* Return codes */
> +#define EUNSETOPT	2	/* if -B is used and unset config options were found */
> +
>  static void conf(struct menu *menu);
>  static void check_conf(struct menu *menu);
>  
> @@ -23,6 +26,8 @@ enum {
>  	ask_all,
>  	ask_new,
>  	ask_silent,
> +	dont_ask,
> +	dont_ask_dont_tell,
>  	set_default,
>  	set_yes,
>  	set_mod,
> @@ -360,7 +365,10 @@ static void conf(struct menu *menu)
>  
>  		switch (prop->type) {
>  		case P_MENU:
> -			if (input_mode == ask_silent && rootEntry != menu) {
> +			if ((input_mode == ask_silent ||
> +			     input_mode == dont_ask ||
> +			     input_mode == dont_ask_dont_tell) &&
> +			    rootEntry != menu) {
>  				check_conf(menu);
>  				return;
>  			}
> @@ -406,6 +414,8 @@ conf_childs:
>  		indent -= 2;
>  }
>  
> +static int return_value;
> +
>  static void check_conf(struct menu *menu)
>  {
>  	struct symbol *sym;
> @@ -418,10 +428,19 @@ static void check_conf(struct menu *menu
>  	if (sym && !sym_has_value(sym)) {
>  		if (sym_is_changable(sym) ||
>  		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
> -			if (!conf_cnt++)
> -				printf(_("*\n* Restart config...\n*\n"));
> -			rootEntry = menu_get_parent_menu(menu);
> -			conf(rootEntry);
> +			if (input_mode == dont_ask ||
> +			    input_mode == dont_ask_dont_tell) {
> +				if (input_mode == dont_ask &&
> +				    sym->name && !sym_is_choice_value(sym)) {
> +					fprintf(stderr,"CONFIG_%s\n",sym->name);

You should print "The following variables are not set:" or something
like that before the first variable, otherwise it's not very clear what
the list means.


> +					return_value = EUNSETOPT;

The name 'return_value' is a little confusing, we call exit(0) or
exit(1) at several places, but this variable only affects a single
statement. What about

static int unset_variables;
...
   unset_variables++;
...
return unset_variables ? EUNSETOPT : 0;

? Also, define the static var at the beginning of the file, where the
remaining variables are defined.


> +				}
> +			} else {
> +				if (!conf_cnt++)
> +					printf(_("*\n* Restart config...\n*\n"));
> +				rootEntry = menu_get_parent_menu(menu);
> +				conf(rootEntry);
> +			}
>  		}
>  	}
>  
> @@ -439,7 +458,7 @@ int main(int ac, char **av)
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> -	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
> + 	while ((opt = getopt(ac, av, "osbBdD:nmyrh")) != -1) {
>  		switch (opt) {
>  		case 'o':
>  			input_mode = ask_silent;
> @@ -448,6 +467,12 @@ int main(int ac, char **av)
>  			input_mode = ask_silent;
>  			sync_kconfig = 1;
>  			break;
> +		case 'b':
> +			input_mode = dont_ask;
> +			break;
> +		case 'B':
> +			input_mode = dont_ask_dont_tell;
> +			break;
>  		case 'd':
>  			input_mode = set_default;
>  			break;
> @@ -525,6 +550,8 @@ int main(int ac, char **av)
>  	case ask_silent:
>  	case ask_all:
>  	case ask_new:
> +	case dont_ask:
> +	case dont_ask_dont_tell:
>  		conf_read(NULL);
>  		break;
>  	case set_no:
> @@ -586,12 +613,16 @@ int main(int ac, char **av)
>  		conf(&rootmenu);
>  		input_mode = ask_silent;
>  		/* fall through */
> +	case dont_ask:
> +	case dont_ask_dont_tell:
>  	case ask_silent:
>  		/* Update until a loop caused no more changes */
>  		do {
>  			conf_cnt = 0;
>  			check_conf(&rootmenu);
> -		} while (conf_cnt);
> +		} while (conf_cnt &&
> +			 (input_mode != dont_ask &&
> +			  input_mode != dont_ask_dont_tell));
>  		break;
>  	}
>  
> @@ -613,5 +644,5 @@ int main(int ac, char **av)
>  			exit(1);
>  		}
>  	}
> -	return 0;
> +	return return_value;

IMO nonint_oldconfig should not update the .config if it's going to
fail. At least I find this output quite confusing:
$ make nonint_oldconfig
scripts/kconfig/conf -b arch/x86/Kconfig
CONFIG_FOO
#
# configuration written to .config
#
make[1]: *** [nonint_oldconfig] Error 2
make: *** [nonint_oldconfig] Error 2

and a subsequent make nonint_oldconfig call does not fail.

Michal
