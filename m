Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1LLRx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:53:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43778 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LLRx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:53:26 -0500
Message-ID: <1323712401.2391.93.camel@hornet.cambridge.arm.com>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Mon, 12 Dec 2011 17:53:21 +0000
In-Reply-To: <877h2ht58w.fsf@rustcorp.com.au>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
	 <87sjlooq3m.fsf@rustcorp.com.au>
	 <1321467222.3137.417.camel@hornet.cambridge.arm.com>
	 <87vcqe9ml9.fsf@rustcorp.com.au>
	 <1321886688.3093.248.camel@hornet.cambridge.arm.com>
	 <1321898210.3093.263.camel@hornet.cambridge.arm.com>
	 <87fwhhx9is.fsf@rustcorp.com.au>
	 <1322071732.3093.491.camel@hornet.cambridge.arm.com>
	 <87zkfht7dp.fsf@rustcorp.com.au>
	 <1322588190.3164.129.camel@hornet.cambridge.arm.com>
	 <877h2ht58w.fsf@rustcorp.com.au>
X-Mailer: Evolution 3.2.1-
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Dec 2011 17:53:21.0612 (UTC) FILETIME=[F012A0C0:01CCB8F6]
X-MC-Unique: 111121217532302701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for the delay - last weeks were a bit hectic for me (and nothing
will change till Friday when I'm off for holiday! :-)

On Thu, 2011-12-01 at 02:06 +0000, Rusty Russell wrote:
> > Yes, this was my initial idea as well. The only problem I faced is the
> > fact that there is no "between levels"... It's easy to add parameters
> > parsing _at_ any particular level, but hard to do this _after_ level A
> > and _before_ level B. The initcalls section simply contains all the
> > calls, ordered by the level - the only "separated" level is the pre-SMP
> > early one. And order within one level is determined by the link order,
> > so I can't guarantee parsing the parameters as the first call of a level
> > (nor as the last call of the previous level).
> 
> Yeah, that's why I suggested changing the linker script.

Sounded a bit scary, but turned out to be much less intrusive that I
expected... I'll post the proposal in a second.

> >  /* This is the fundamental function for registering boot/module
> >     parameters. */
> > -#define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
> > +#define __module_param_call(prefix, name, ops, arg, isbool, late, perm)	\
> >  	/* Default value instead of permissions? */			\
> >  	static int __param_perm_check_##name __attribute__((unused)) =	\
> >  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> 
> Might as well change isbool to "flags", since we have to fix callers
> anyway.

Sure thing, done.

> > diff --git a/init/main.c b/init/main.c
> > index 217ed23..ce89a53 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -407,7 +407,7 @@ static int __init do_early_param(char *param, char *val)
> >  
> >  void __init parse_early_options(char *cmdline)
> >  {
> > -	parse_args("early options", cmdline, NULL, 0, do_early_param);
> > +	parse_args("early options", cmdline, NULL, 0, 0, 0, do_early_param);
> 
> It'd be nice to replace the early param stuff too, but that's probably a
> separate patch.  As is getting rid of the old __setup() calls everywhere
> ;)

I promise to look into it next year ;-)

> But so far, it looks good!

Cool, have a look at the patches following this mail then. I hope they
make some sense, however it's unlikely I'll get them ready for 3.3
(unless they already are? ;-) because of my holidays. Maybe at least
they could be linux-next-ed to see what did I break?

Cheers!

Paweł


