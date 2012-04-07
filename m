Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2DGUjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:39:22 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:54951 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab2DGUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:39:21 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2012 16:39:21 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFAKU/KE8YNOMa/2dsb2JhbACBX5x7eaB5hFo3f4YZBJARhC+KYg
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="172633911"
Message-ID: <4F80A3AF.2070406@gmail.com>
Date: Sat, 07 Apr 2012 16:29:35 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Pawel Moll <pawel.moll@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: fix bug where environment vars can't be passed
 via boot args
References: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
In-Reply-To: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Metcalf wrote:
> Commit 026cee0086f had the side-effect of dropping the '=' from
> the unknown boot arguments that are passed to init as environment
> variables.  This is because parse_args() puts a NUL in the string
> where the '=' was when it passes the "param" and "val" pointers
> to the parsing subfunctions.  Previously, unknown_bootoption() was
> the last parse_args() subfunction to run, and it carefully put back
> the '=' character.  Now ignore_unknown_bootoption() is the last
> one to run, and it wasn't doing the necessary repair, so the
> envp params ended up with the embedded NUL and were no longer
> seen as valid environment variables by init.
>
> Signed-off-by: Chris Metcalf<cmetcalf@tilera.com>
> ---
>   init/main.c |   25 +++++++++++++------------
>   1 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 9d454f0..44b2433 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -225,13 +225,9 @@ static int __init loglevel(char *str)
>
>   early_param("loglevel", loglevel);
>
> -/*
> - * Unknown boot options get handed to init, unless they look like
> - * unused parameters (modprobe will find them in /proc/cmdline).
> - */
> -static int __init unknown_bootoption(char *param, char *val)
> +/* Change NUL term back to "=", to make "param" the whole string. */
> +static int __init repair_env_string(char *param, char *val)
>   {
> -	/* Change NUL term back to "=", to make "param" the whole string. */
>   	if (val) {
>   		/* param=val or param="val"? */
>   		if (val == param+strlen(param)+1)
> @@ -243,6 +239,16 @@ static int __init unknown_bootoption(char *param, char *val)
>   		} else
>   			BUG();
>   	}
> +	return 0;
> +}
> +
> +/*
> + * Unknown boot options get handed to init, unless they look like
> + * unused parameters (modprobe will find them in /proc/cmdline).
> + */
> +static int __init unknown_bootoption(char *param, char *val)
> +{
> +	repair_env_string(param, val);
>
>   	/* Handle obsolete-style parameters */
>   	if (obsolete_checksetup(param))
> @@ -732,11 +738,6 @@ static char *initcall_level_names[] __initdata = {
>   	"late parameters",
>   };
>
> -static int __init ignore_unknown_bootoption(char *param, char *val)
> -{
> -	return 0;
> -}
> -
>   static void __init do_initcall_level(int level)
>   {
>   	extern const struct kernel_param __start___param[], __stop___param[];
> @@ -747,7 +748,7 @@ static void __init do_initcall_level(int level)
>   		   static_command_line, __start___param,
>   		   __stop___param - __start___param,
>   		   level, level,
> -		   ignore_unknown_bootoption);
> +		   repair_env_string);
>
>   	for (fn = initcall_levels[level]; fn<  initcall_levels[level+1]; fn++)
>   		do_one_initcall(*fn);

Thanks for the patch, works for me...
Woody

