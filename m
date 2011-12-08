Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1LHRK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:10:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1LHRKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:10:55 -0500
Date: Thu, 8 Dec 2011 12:10:44 -0500
From: Jason Baron <jbaron@redhat.com>
To: jim.cromie@gmail.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param
 $module.dyndbg
Message-ID: <20111208171044.GC2499@redhat.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
 <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 12:11:28PM -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
> from https://lkml.org/lkml/2010/9/15/397
> 
> Extend dynamic-debug facility to work during module initialization:
> 
>   foo.dyndbg bar.dyndbg="$bar-query-string"
> 
> This patch introduces a 'fake' module parameter: $module.ddebug for
> all modules.  It is not explicitly added to each module, but is
> implemented as an unknown-parameter callback invoked by kernel/param's
> parse_one(), and it applies each module's query-string as if it were
> written to the $DBGFS/dynamic_debug/control file.
> 
> The module-name is added to the unknown-parameter callback signature
> and to its caller: parse_one().  This lets the common callback know
> what module its handling a common parameter for.
> 
> If no value is given (as in foo.dyndbg example above), "+p" is
> assumed, which enables all pr_debug callsites in the module.
> 
> The parameter is not shown in /sys/module/*/parameters, thus it does
> not use any resources.  Changes to the parameter are made via the
> control file.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> CC: Thomas Renninger <trenn@suse.de>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  Documentation/dynamic-debug-howto.txt |   52 ++++++++++++++++++++++++++++++++-
>  include/linux/dynamic_debug.h         |   11 +++++++
>  include/linux/moduleparam.h           |    2 +-
>  init/main.c                           |    7 ++--
>  kernel/module.c                       |    3 +-
>  kernel/params.c                       |   10 ++++--
>  lib/dynamic_debug.c                   |   16 +++++++++-
>  7 files changed, 89 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
> index 989a892..56e496a 100644
> --- a/Documentation/dynamic-debug-howto.txt
> +++ b/Documentation/dynamic-debug-howto.txt
> @@ -219,7 +219,7 @@ Note also that there is no convenient syntax to remove all
>  the flags at once, you need to use "-flmpt".
>  
>  
> -Debug messages during boot process
> +Debug messages during Boot Process
>  ==================================
>  
>  To be able to activate debug messages during the boot process,
> @@ -238,6 +238,45 @@ PCI (or other devices) initialization also is a hot candidate for using
>  this boot parameter for debugging purposes.
>  
>  
> +Debug Messages at Module Initialization Time
> +============================================
> +
> +Enabling a module's debug messages via debug control file only works
> +once the module is loaded; too late for callsites in init functions.
> +And when module is unloaded, debug flag settings for the module are
> +lost.  Instead, a "dyndbg" module parameter can be passed:
> +
> +	- via kernel boot parameter: (this form works on built-ins too)
> +	  module.dyndbg=+mfp
> +	  module.dyndbg	# defaults to +p
> +
> +	- as an ordinary module parameter via modprobe
> +	  modprobe module dyndbg=+pmfl
> +	  modprobe module dyndbg # defaults to +p
> +
> +	- or the parameter can be used permanently via modprobe.conf(.local)
> +	  options module dyndbg=+pmflt
> +	  options module dyndbg # defaults to +p
> +
> +The $modname.dyndbg="value" should exclude "module $modname", as the
> +$modname is taken from the param-name, and only 1 spec of each type is
> +allowed.
> +
> +The dyndbg option is not implemented as an ordinary module parameter
> +and thus will not show up in /sys/module/module_name/parameters/dyndbg
> +The settings can be reverted later via the sysfs interface if the
> +debug messages are no longer needed:
> +
> +      echo "module module_name -p" > <debugfs>/dynamic_debug/control
> +
> +$module.dyndbg="..." on boot-line works on built-in modules as well as
> +those loaded by modprobe (from either early or normal userspace), and
> +somewhat overlaps debug_query functionality.
> +
> +Modprobed modules get dyndbg flags given on boot-line after those
> +given via modprobe (either explicitly, or from /etc/modprobe.d/*).
> +This can surprise if boot-line arg subtracts flags.
> +
>  Examples
>  ========
>  
> @@ -264,3 +303,14 @@ nullarbor:~ # echo -n 'func svc_process -p' >
>  // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
>  nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
>  				<debugfs>/dynamic_debug/control
> +
> +// boot-args example, with newlines and comments
> +Kernel command line: ... 
> +  ddebug_query="func i2c_del_adapter +p; func tboot_probe +p"
> +  dynamic_debug.verbose=1 		// see whats going on
> +  nouveau.dyndbg 			// implicit =+p
> +  tsc_sync.dyndbg=+p 			// builtin on my kernel
> +  i2c_core.dyndbg=+p			// loaded by udev
> +  *.dyndbg="=_"				// wildcard applies to builtins
> +  k10temp.dyndbg="+p # comment in query is stripped "
> +  pnp.dyndbg="func pnpacpi_get_resources +p; func pnp_assign_mem +p" # multi

I see you've added docs for the 'dyndbg' kernel command-line options,
but then I don't see any changes in the code to 'unkown_bootoption'.
What am I missing?

Thanks,

-Jason

