Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1DFSmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:42:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab1DFSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:42:05 -0400
Date: Wed, 6 Apr 2011 14:41:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Vossen <rvossen@broadcom.com>,
        devel <devel@linuxdriverproject.org>, gregkh@suse.de
Subject: Re: [Fwd: Fwd: Re: Why is dynamic debug disabled for staging drivers
 ?]
Message-ID: <20110406184158.GA6981@redhat.com>
References: <1302104075.1683.46.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302104075.1683.46.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 08:34:35AM -0700, Joe Perches wrote:
> Adding Jason and LKML. to cc's...
> 
> -------- Forwarded Message --------
> From: Roland Vossen <rvossen@broadcom.com>
> To: rusty@rustcorp.com.au
> Cc: devel@linuxdriverproject.org <devel@linuxdriverproject.org>,
> gregkh@suse.de <gregkh@suse.de>
> Subject: Fwd: Re: Why is dynamic debug disabled for staging drivers ?
> Date: Wed, 6 Apr 2011 17:09:04 +0200
> 
> Hello Rusty,
> 
> I would like to make a change to module.c and noticed with 'git blame' 
> that you were the last person who touched these specific lines in module.c:
> 
> http://lxr.linux.no/#linux+v2.6.38/kernel/module.c#L2792
> 
> ===== Corresponding commit for your reference:
> 
> commit 811d66a0e1e99902d365497eec7884113a2665bd
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Thu Aug 5 12:59:12 2010 -0600
> 
> module: group post-relocation functions into post_relocation()
> 
> This simply hoists more code out of load_module; we also put the
> identification of the extable and dynamic debug table in with the
> others in find_module_sections().
> 
> We move the taint check to the actual add/remove of the dynamic debug
> info: this is certain (find_module_sections is too early).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Yehuda Sadeh <yehuda@hq.newdream.net>
> 
> ==============
> 
> 
> Can you tell me if the following proposed code change in module.c is ok 
> with you:
> 
> 	/* This has to be done once we're sure module name is unique. */
> 	if (!mod->taints || mod->taints == (1U << TAINT_CRAP))
> 		dynamic_debug_setup(info.debug, info.num_debug);
> 
> Thanks, Roland.
> 
> 
> -------- Original Message --------
> Subject: Re: Why is dynamic debug disabled for staging drivers ?
> Date: Wed, 6 Apr 2011 07:13:29 -0700
> From: Greg KH <greg@kroah.com>
> To: Roland Vossen <rvossen@broadcom.com>
> CC: devel@linuxdriverproject.org <devel@linuxdriverproject.org>
> 
> On Wed, Apr 06, 2011 at 03:54:37PM +0200, Roland Vossen wrote:
> > Hi,
> >
> > I want to replace the proprietary logging mechanism in brcm80211
> > with a Linux mechanism. 'Dynamic debug' seemed to be a good fit.
> > But, to my disappointment, I discovered that dynamic debugging is
> > not supported for drivers from the staging dir:
> >
> > - staging drivers are marked tainted (ref:
> > http://lxr.linux.no/#linux+v2.6.38/kernel/module.c#L2417)
> >
> > - subsequently tainted drivers don't get dynamic debug goodies (ref:
> > http://lxr.linux.no/#linux+v2.6.38/kernel/module.c#L2792)
> >
> > I wonder if this is intentional behavior. Does anybody know ?
> 
> Ah, no it isn't.  I didn't realize that tainted modules didn't get
> dynamic debug stuff, that's not nice.  I'd be glad to take a fix that
> allows drivers tainted with the TAINT_CRAP flag to be able to use
> dynamic debug.
> 

Indeed, orginally dynamic debug didn't have a taint restriction...I'm not
sure when it got picked up...

> In looking at that check, it probably can be fixed to just make sure
> that the module name is unique (i.e. only a specific taint flag check)
> which is the real goal of that check in module.c.
> 

The check for name uniqueness is performed right before the dynamic
debug setup:

...
        mutex_lock(&module_mutex);
        if (find_module(mod->name)) {
                err = -EEXIST;
                goto unlock;
        }

        /* This has to be done once we're sure module name is unique. */
        if (!mod->taints)
                dynamic_debug_setup(info.debug, info.num_debug);



The concern I would have in allowing tainted modules is that we are
relying on a specific format for the dynamic debug section in the
compiled module. For example, if a module was built with a format with an old
section, we could potentially get confused. This can be solved with
versioning, but that adds extra complexity. We can of course also make
sure we don't change the format...

Notice that tracepoints, which also rely on a specific module format,
also employ a taint flag check.

thanks,

-Jason

