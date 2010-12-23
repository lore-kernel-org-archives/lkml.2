Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0LWAiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:38:24 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:61918 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab0LWAiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:38:23 -0500
Date: Wed, 22 Dec 2010 16:38:23 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Message-ID: <20101223003823.GA19568@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
 <201012221132.41057.rusty@rustcorp.com.au>
 <20101222011712.GA19105@dtor-ws.eng.vmware.com>
 <201012221218.45533.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012221218.45533.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 05:48:45PM -0800, Rusty Russell wrote:
> On Wed, 22 Dec 2010 11:47:12 am Dmitry Torokhov wrote:
> > On Tue, Dec 21, 2010 at 05:02:40PM -0800, Rusty Russell wrote:
> > > On Thu, 16 Dec 2010 08:30:19 am Dmitry Torokhov wrote:
> > > > +
> > > > +#ifdef MODULE
> > > >  #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
> > > > +#else
> > > > +#define MODULE_VERSION(_version)					\
> > > > +	extern ssize_t __modver_version_show(struct module_attribute *,	\
> > > > +					     struct module *, char *);	\
> > > > +	static struct module_version_attribute __modver_version_attr	\
> > > > +	__used								\
> > > > +    __attribute__ ((unused,__section__ ("__modver"),aligned(sizeof(void *)))) \
> > > 
> > > __used and unused seems overkill, and confused.
> > > 
> > 
> > Must admit that I copied used/unused verbatim from linux/moduleparam.h:
> > 
> > /* This is the fundamental function for registering boot/module
> >    parameters. */
> > #define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
> > 	/* Default value instead of permissions? */			\
> > 	static int __param_perm_check_##name __attribute__((unused)) =	\
> > 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> > 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
> > 	static const char __param_str_##name[] = prefix #name;		\
> > 	static struct kernel_param __moduleparam_const __param_##name	\
> > 	__used								\
> >     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
> > 	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
> > 	    { arg } }
> > 
> > 
> > So should it be removed from here as well?
> 
> I think so, but (as always!) check git blame.
> 

Whew, found it:

commit 4d62364652499ef106d1c0737968a879ef077bd4
Author: akpm <akpm>
Date:   Tue Jan 20 05:13:24 2004 +0000

    [PATCH] make gcc 3.4 compilation work

    From: David Mosberger <davidm@napali.hpl.hp.com>

    With gcc-3.4 we need "attribute((used))" declarations to get "make
    modules_install" to work.

    Otherwise these sections get dropped from the final image (I assume).

    BKrev: 400cb8f4ByHxZCElstAaZ3mBZ2oflQ

...

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 0a5becb..cbca007 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -52,6 +52,7 @@ struct kparam_array
 #define __module_param_call(prefix, name, set, get, arg, perm) \
        static char __param_str_##name[] __initdata = prefix #name; \
        static struct kernel_param const __param_##name \
+       __attribute_used__ \
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
        = { __param_str_##name, perm, set, get, arg }


Since we still claim to support GCC 3.4 I guess __used is still
needed...

Thanks,

Dmitry
