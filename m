Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1CQR6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:58:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1CQR6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:58:01 -0400
Date: Thu, 17 Mar 2011 13:56:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Banks <gnb@fmeh.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH 05/50] Dynamic debug: Add more flags
Message-ID: <20110317175607.GD2648@redhat.com>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
 <1300309888-5028-5-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300309888-5028-5-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:10:43PM -0700, Greg Kroah-Hartman wrote:
> Add flags that allow the user to specify via debugfs whether or not the
> module name, function name, line number and/or thread ID have to be
> included in the printed message.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Greg Banks <gnb@fmeh.org>
> Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  Documentation/dynamic-debug-howto.txt |   12 +++++-
>  include/linux/dynamic_debug.h         |    8 ++++-
>  lib/dynamic_debug.c                   |   60 ++++++++++++++++++++++++++++-----
>  3 files changed, 68 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
> index 58ea64a..e6c4b75 100644
> --- a/Documentation/dynamic-debug-howto.txt
> +++ b/Documentation/dynamic-debug-howto.txt
> @@ -205,12 +205,20 @@ of the characters:
>  
>  The flags are:
>  
> +f
> +    Include the function name in the printed message
> +l
> +    Include line number in the printed message
> +m
> +    Include module name in the printed message
>  p
>      Causes a printk() message to be emitted to dmesg
> +t
> +    Include thread ID in messages not generated from interrupt context
>  
> -Note the regexp ^[-+=][scp]+$ matches a flags specification.
> +Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
>  Note also that there is no convenient syntax to remove all
> -the flags at once, you need to use "-psc".
> +the flags at once, you need to use "-flmpt".
>  
>  
>  Debug messages during boot process
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index 1c70028..0c9653f 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -31,6 +31,10 @@ struct _ddebug {
>  	 * writes commands to <debugfs>/dynamic_debug/control
>  	 */
>  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
> +#define _DPRINTK_FLAGS_INCL_MODNAME	(1<<1)
> +#define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
> +#define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
> +#define _DPRINTK_FLAGS_INCL_TID		(1<<4)
>  #define _DPRINTK_FLAGS_DEFAULT 0
>  	unsigned int flags:8;
>  	char enabled;
> @@ -42,6 +46,8 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
>  
>  #if defined(CONFIG_DYNAMIC_DEBUG)
>  extern int ddebug_remove_module(const char *mod_name);
> +extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
> +	__attribute__ ((format (printf, 2, 3)));
>  
>  #define dynamic_pr_debug(fmt, ...) do {					\
>  	static struct _ddebug descriptor				\
> @@ -50,7 +56,7 @@ extern int ddebug_remove_module(const char *mod_name);
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
>  		_DPRINTK_FLAGS_DEFAULT };				\
>  	if (unlikely(descriptor.enabled))				\
> -		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
> +		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
>  	} while (0)
>  

This piece is going to conflict with the jump label update patches, I'm
trying to get into .39. The 'if (unlikely(descriptor.enabled))' bit is
now: 'if (DDEBUG_BRANCH(descriptor.enabled))'. So its a small conflict,
but they wouldn't merge together. So we need to adjust either one (and
make sure they're applied in the correct orer), or drop one.

thanks,

-Jason


