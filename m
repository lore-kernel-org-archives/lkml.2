Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1HKTCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:02:11 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:60305 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297Ab1HKTCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:02:09 -0400
Subject: Re: [PATCH 09/11] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
	 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 12:02:06 -0700
Message-ID: <1313089327.13877.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 14:36 -0400, Jason Baron wrote:
> From: Jason Baron <jbaron@redhat.com>
> Replace the repetitive  struct _ddebug descriptor definitions with
> a new DYNAMIC_DEBUG_META_DATA(fmt) macro.

Hey Jason.

I think some improvements can be made to this one.

> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
[]
> @@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  			     const char *fmt, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  
> +#define DYNAMIC_DEBUG_METADATA(fmt)				\
> +	static struct _ddebug descriptor			\
> +	__used							\
> +	__attribute__((section("__verbose"), aligned(8))) =	\
> +	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
> +		_DPRINTK_FLAGS_DEFAULT };
> +

I think this is unclear and should be:

#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
	static struct _ddebug name				\
	__used							\
	__attribute__((section("__verbose"), aligned(8))) =	\
	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
		_DPRINTK_FLAGS_DEFAULT }

(extra semicolon at end removed)

so the uses become:

>  #define dynamic_dev_dbg(dev, fmt, ...) do {				\
> -	static struct _ddebug descriptor				\
> -	__used								\
> -	__attribute__((section("__verbose"), aligned(8))) =		\
> -	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> -		_DPRINTK_FLAGS_DEFAULT };				\
> +	DYNAMIC_DEBUG_METADATA(fmt);					\

	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);

>  	if (unlikely(descriptor.enabled))				\
> -		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
> +		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
>  	} while (0)

so then there aren't any magic variable names.

cheers, Joe

