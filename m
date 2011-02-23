Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1BWPkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:40:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1BWPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:40:31 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=x7y_yQoqp1kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=DyRAi2A38MqU6YH3ZGgA:9 a=3q-s71bK4T61m83_fa6zayGwe4EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 10:40:28 -0500
Message-ID: <1298475628.7666.88.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:28 -0500, Jason Baron wrote:

> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index 1c70028..7e51b6f 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -1,14 +1,9 @@
>  #ifndef _DYNAMIC_DEBUG_H
>  #define _DYNAMIC_DEBUG_H
>  
> +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>  #include <linux/jump_label.h>
> -
> -/* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
> - * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
> - * use independent hash functions, to reduce the chance of false positives.
> - */
> -extern long long dynamic_debug_enabled;
> -extern long long dynamic_debug_enabled2;
> +#endif
>  
>  /*
>   * An instance of this structure is created in a special
> @@ -33,7 +28,11 @@ struct _ddebug {
>  #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
>  #define _DPRINTK_FLAGS_DEFAULT 0
>  	unsigned int flags:8;
> -	char enabled;
> +#ifdef HAVE_JUMP_LABEL

Shouldn't this be CONFIG_JUMP_LABEL?

> +	struct jump_label_key enabled;
> +#else
> +	int enabled;
> +#endif
>  } __attribute__((aligned(8)));
>  
> 
> @@ -43,14 +42,22 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
>  #if defined(CONFIG_DYNAMIC_DEBUG)
>  extern int ddebug_remove_module(const char *mod_name);
>  
> +#ifdef HAVE_JUMP_LABEL

Here too?

-- Steve

> +# define DDEBUG_INIT { JUMP_LABEL_INIT }
> +# define DDEBUG_BRANCH(enabled) static_branch(&enabled)
> +#else
> +# define DDEBUG_INIT 0
> +# define DDEBUG_BRANCH(enabled) unlikely(enabled)
> +#endif
> +
>  #define dynamic_pr_debug(fmt, ...) do {					\
>  	static struct _ddebug descriptor				\
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> -	if (unlikely(descriptor.enabled))				\
> -		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
> +		_DPRINTK_FLAGS_DEFAULT, DDEBUG_INIT };                   \
> +	if (DDEBUG_BRANCH(descriptor.enabled))				\
> +		printk(KERN_DEBUG pr_fmt(fmt),  ##__VA_ARGS__);         \
>  	} while (0)
>  
> 
> @@ -59,9 +66,9 @@ extern int ddebug_remove_module(const char *mod_name);
>  	__used								\
>  	__attribute__((section("__verbose"), aligned(8))) =		\
>  	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> -	if (unlikely(descriptor.enabled))				\
> -		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> +		_DPRINTK_FLAGS_DEFAULT, DDEBUG_INIT };                  \
> +	if (DDEBUG_BRANCH(descriptor.enabled))                          \
> +		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);        \
>  	} while (0)
>  



