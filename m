Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1E3B6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:58:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56565 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1E3B6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:58:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE2F9BA.5030802@jp.fujitsu.com>
Date: Mon, 30 May 2011 10:58:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux@treblig.org
CC: linux-kernel@vger.kernel.org
Subject: Re: sparse build breakage with 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad
References: <20110529003857.GA9898@gallifrey>
In-Reply-To: <20110529003857.GA9898@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/29 9:38), Dr. David Alan Gilbert wrote:
> Hi Kosaki,
>   I'm getting a problem when running the current (5dbe0af47f8a8f968bac2991c3ec974c6e3eaabc)
> kernel tree through sparse, and I think it's down to an
> interaction between your commit
> 
> 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad sparse: define dummy BUILD_BUG_ON definition for sparse
> 
> and the __module_param_call code in moduleparam.h
> 
> The error is:
> init/main.c:643:1: error: Syntax error in unary expression
> 
> core_param(initcall_debug, initcall_debug, bool, 0644);
> 
> this calls __module_param_call which is defined as:
> 
> 
> #define __module_param_call(prefix, name, ops, arg, isbool, perm)       \
>         /* Default value instead of permissions? */                     \
>         static int __param_perm_check_##name __attribute__((unused)) =  \
>         BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))  \
>         + BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);   \
>         static const char __param_str_##name[] = prefix #name;          \
>         static struct kernel_param __moduleparam_const __param_##name   \
>         __used                                                          \
>     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
>         = { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,  \
>             { arg } }
> 
> which ends up with a postprocessed line of:
> 
> static inline void __check_initcall_debug(void) {; }; static int __param_perm_check_initcall_debug __attribute__((unused)) = +; static const char __param_str_initcall_debug[] = "" "initcall_debug"; static struct kernel_param const __param_initcall_debug __attribute__((__used__)) __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) = { __param_str_initcall_debug, &param_ops_bool, 0644, __builtin_types_compatible_p(typeof(initcall_debug), typeof(bool)) ? 2 : 0, { &initcall_debug } };
> 
> Note the '+;' being assigned to __param_perm_check_initcall_debug
> 
> So I think your dummy BUILD_BUG_ON_ZERO's needs to have a value:
> 
> The following diff seems to fix it, but I've not let
> a fuller sparse run complete yet:
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fb0e732..953352a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -671,8 +671,8 @@ struct sysinfo {
>  
>  #ifdef __CHECKER__
>  #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
> -#define BUILD_BUG_ON_ZERO(e)
> -#define BUILD_BUG_ON_NULL(e)
> +#define BUILD_BUG_ON_ZERO(e) (0)
> +#define BUILD_BUG_ON_NULL(e) ((void*)0)
>  #define BUILD_BUG_ON(condition)
>  #else /* __CHECKER__ */
>  

Hi David,

Right you are. Can you please send a formal patch and append following line?
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks.







