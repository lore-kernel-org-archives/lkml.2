Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1HLGj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:39:27 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:36859 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791Ab1HLGj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:39:26 -0400
Subject: Re: [PATCH 09/11 re-post] dynamic_debug: consolidate repetitive
 struct _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110811205253.GC6670@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
	 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
	 <1313089327.13877.11.camel@Joe-Laptop>  <20110811205253.GC6670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 23:39:24 -0700
Message-ID: <1313131164.27549.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 16:52 -0400, Jason Baron wrote:
> Replace the repetitive struct _ddebug descriptor definitions with
> a new DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt) macro.
[]
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
[]
> @@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  			     const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  
> +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> +	static struct _ddebug name				\
> +	__used							\
> +	__attribute__((section("__verbose"), aligned(8))) =	\
> +	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
> +		_DPRINTK_FLAGS_DEFAULT }

Hey again Jason.

>From a kernel coding style consistency POV, shouldn't
this use c99 named initializers?

#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)			\
	static struct _ddebug name = {					\
		.modname = KBUILD_MODNAME,				\
		.function = __func__,					\
		.filename = __FILE__,					\
		.format = fmt,						\
		.lineno = __LINE__,					\
		.flags =  _DPRINTK_FLAGS_DEFAULT,			\
		.enabled = false,					\
	} __used __aligned(8) __attribute__((section("__verbose")))

If the pr_debug/dynamic_debug inversion is done,
the .enabled flag should be set on as well when
-DDEBUG is set, correct?

>  #define dynamic_pr_debug(fmt, ...) do {					\
> -	static struct _ddebug descriptor				\
> -	__used								\
> -	__attribute__((section("__verbose"), aligned(8))) =		\
> -	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> +	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
>  	if (unlikely(descriptor.enabled))				\
> -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
> +		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
>  	} while (0)

Perhaps

#define dynamic_pr_debug(fmt, ...)					\
do {									\
	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
	if (unlikely(descriptor.enabled))				\
		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
				   ##__VA_ARGS__);			\
} while (0)

Lastly, are the unlikely()s really useful?

