Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0LWC2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:28:00 -0500
Received: from ozlabs.org ([203.10.76.45]:52515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab0LWC17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:27:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Date: Thu, 23 Dec 2010 12:57:56 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com> <201012221218.45533.rusty@rustcorp.com.au> <20101223003823.GA19568@dtor-ws.eng.vmware.com>
In-Reply-To: <20101223003823.GA19568@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231257.56971.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 11:08:23 am Dmitry Torokhov wrote:
> On Tue, Dec 21, 2010 at 05:48:45PM -0800, Rusty Russell wrote:
> > On Wed, 22 Dec 2010 11:47:12 am Dmitry Torokhov wrote:
> > > On Tue, Dec 21, 2010 at 05:02:40PM -0800, Rusty Russell wrote:
> > > > On Thu, 16 Dec 2010 08:30:19 am Dmitry Torokhov wrote:
> > > > > +
> > > > > +#ifdef MODULE
> > > > >  #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
> > > > > +#else
> > > > > +#define MODULE_VERSION(_version)					\
> > > > > +	extern ssize_t __modver_version_show(struct module_attribute *,	\
> > > > > +					     struct module *, char *);	\
> > > > > +	static struct module_version_attribute __modver_version_attr	\
> > > > > +	__used								\
> > > > > +    __attribute__ ((unused,__section__ ("__modver"),aligned(sizeof(void *)))) \
> > > > 
> > > > __used and unused seems overkill, and confused.
> > > > 
> > > 
> > > Must admit that I copied used/unused verbatim from linux/moduleparam.h:
> > > 
> > > /* This is the fundamental function for registering boot/module
> > >    parameters. */
> > > #define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
> > > 	/* Default value instead of permissions? */			\
> > > 	static int __param_perm_check_##name __attribute__((unused)) =	\
> > > 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> > > 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
> > > 	static const char __param_str_##name[] = prefix #name;		\
> > > 	static struct kernel_param __moduleparam_const __param_##name	\
> > > 	__used								\
> > >     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
> > > 	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
> > > 	    { arg } }
> > > 
> > > 
> > > So should it be removed from here as well?
> > 
> > I think so, but (as always!) check git blame.
> > 
> 
> Whew, found it:
> 
> commit 4d62364652499ef106d1c0737968a879ef077bd4
> Author: akpm <akpm>
> Date:   Tue Jan 20 05:13:24 2004 +0000
> 
>     [PATCH] make gcc 3.4 compilation work
> 
>     From: David Mosberger <davidm@napali.hpl.hp.com>
> 
>     With gcc-3.4 we need "attribute((used))" declarations to get "make
>     modules_install" to work.
> 
>     Otherwise these sections get dropped from the final image (I assume).
> 
>     BKrev: 400cb8f4ByHxZCElstAaZ3mBZ2oflQ
> 
> ...
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 0a5becb..cbca007 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -52,6 +52,7 @@ struct kparam_array
>  #define __module_param_call(prefix, name, set, get, arg, perm) \
>         static char __param_str_##name[] __initdata = prefix #name; \
>         static struct kernel_param const __param_##name \
> +       __attribute_used__ \
>      __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
>         = { __param_str_##name, perm, set, get, arg }
> 
> 
> Since we still claim to support GCC 3.4 I guess __used is still
> needed...

Well, __used is correct.  But this unused should have been removed
at the same time.

Cheers,
Rusty.
