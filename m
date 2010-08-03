Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0HCAEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:04:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53394 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0HCAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:04:36 -0400
Message-ID: <4C575D0C.9080203@canonical.com>
Date: Mon, 02 Aug 2010 17:04:28 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
References: <20100802121601.363af4a9.sfr@canb.auug.org.au>
In-Reply-To: <20100802121601.363af4a9.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2010 07:16 PM, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the security-testing tree, today's linux-next build (x86_64
> allmodconfig) failed like this (also some warnings ...):
> 
> security/apparmor/ipc.c: In function 'aa_ptrace':
> security/apparmor/ipc.c:103: warning: initialization discards qualifiers from pointer target type
> security/apparmor/domain.c: In function 'may_change_ptraced_domain':
> security/apparmor/domain.c:73: warning: assignment discards qualifiers from pointer target type
> security/apparmor/lsm.c:701: error: 'param_ops_aabool' undeclared here (not in a function)
> security/apparmor/lsm.c:721: error: 'param_ops_aalockpolicy' undeclared here (not in a function)
> security/apparmor/lsm.c:729: error: 'param_ops_aauint' undeclared here (not in a function)
> 
> Error caused by commit e0500000b50a50ec8cc9967001f3ed201b83cb36
> ("AppArmor: LSM interface, and security module initialization")
> interacting with commit 0685652df0929cec7d78efa85127f6eb34962132
> ("param:param_ops") from the rr tree.
> 
> I applied the following merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 2 Aug 2010 12:00:43 +1000
> Subject: [PATCH] AppArmor: update for module_param_named API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
looks good, thanks Stephen

Signed-off-by: John Johansen <john.johansen@canonical.com>



> ---
>  security/apparmor/lsm.c |   36 ++++++++++++++++++++++++------------
>  1 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 8db33a8..d5666d3 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -667,17 +667,29 @@ static struct security_operations apparmor_ops = {
>   * AppArmor sysfs module parameters
>   */
>  
> -static int param_set_aabool(const char *val, struct kernel_param *kp);
> -static int param_get_aabool(char *buffer, struct kernel_param *kp);
> +static int param_set_aabool(const char *val, const struct kernel_param *kp);
> +static int param_get_aabool(char *buffer, const struct kernel_param *kp);
>  #define param_check_aabool(name, p) __param_check(name, p, int)
> +static struct kernel_param_ops param_ops_aabool = {
> +	.set = param_set_aabool,
> +	.get = param_get_aabool
> +};
>  
> -static int param_set_aauint(const char *val, struct kernel_param *kp);
> -static int param_get_aauint(char *buffer, struct kernel_param *kp);
> +static int param_set_aauint(const char *val, const struct kernel_param *kp);
> +static int param_get_aauint(char *buffer, const struct kernel_param *kp);
>  #define param_check_aauint(name, p) __param_check(name, p, int)
> +static struct kernel_param_ops param_ops_aauint = {
> +	.set = param_set_aauint,
> +	.get = param_get_aauint
> +};
>  
> -static int param_set_aalockpolicy(const char *val, struct kernel_param *kp);
> -static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp);
> +static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp);
> +static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
>  #define param_check_aalockpolicy(name, p) __param_check(name, p, int)
> +static struct kernel_param_ops param_ops_aalockpolicy = {
> +	.set = param_set_aalockpolicy,
> +	.get = param_get_aalockpolicy
> +};
>  
>  static int param_set_audit(const char *val, struct kernel_param *kp);
>  static int param_get_audit(char *buffer, struct kernel_param *kp);
> @@ -751,7 +763,7 @@ static int __init apparmor_enabled_setup(char *str)
>  __setup("apparmor=", apparmor_enabled_setup);
>  
>  /* set global flag turning off the ability to load policy */
> -static int param_set_aalockpolicy(const char *val, struct kernel_param *kp)
> +static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> @@ -760,35 +772,35 @@ static int param_set_aalockpolicy(const char *val, struct kernel_param *kp)
>  	return param_set_bool(val, kp);
>  }
>  
> -static int param_get_aalockpolicy(char *buffer, struct kernel_param *kp)
> +static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	return param_get_bool(buffer, kp);
>  }
>  
> -static int param_set_aabool(const char *val, struct kernel_param *kp)
> +static int param_set_aabool(const char *val, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	return param_set_bool(val, kp);
>  }
>  
> -static int param_get_aabool(char *buffer, struct kernel_param *kp)
> +static int param_get_aabool(char *buffer, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	return param_get_bool(buffer, kp);
>  }
>  
> -static int param_set_aauint(const char *val, struct kernel_param *kp)
> +static int param_set_aauint(const char *val, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
>  	return param_set_uint(val, kp);
>  }
>  
> -static int param_get_aauint(char *buffer, struct kernel_param *kp)
> +static int param_get_aauint(char *buffer, const struct kernel_param *kp)
>  {
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;

