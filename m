Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0G0AA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:00:56 -0400
Received: from kroah.org ([198.145.64.141]:52248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0G0AAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:00:55 -0400
Date: Mon, 26 Jul 2010 16:45:41 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/6] Driver core: Fix memory leak on bus_register error
 path
Message-ID: <20100726234541.GA26421@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org>
 <20100722234107.GB674@kroah.com>
 <4C4A3F9B.6040600@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4A3F9B.6040600@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 06:19:23PM -0700, Patrick Pannuto wrote:
> On 07/22/2010 04:41 PM, Greg KH wrote:
> > On Thu, Jul 22, 2010 at 03:09:02PM -0700, Patrick Pannuto wrote:
> >> There is a subtle memory leak in driver core error path.
> >> Consider the simplified view of bus_register (drivers/base/bus.c):
> >>
> >> priv = kzalloc...
> >> kobject_set_name(&priv->subsys.kobj,...) <== allocate in priv->subsys.kobj.name
> >> if kset_register(&priv->subsys) FAILS:
> > 
> > Why would this fail?
> > 
> 
> This is not a likely failure path at all, but (from my understanding), it
> is possible:
> 
> kset_register {
>    kobject_add_internal {
>       create_dir()
> 
> is the most likely candidate to fail, mostly likely for EEXIST due to something
> else screwy going on. Regardless of how likely it is to fail, it *is* possible,
> otherwise, what is the point of checking the return code and having an error
> path? If the error path exists (and a panic is not eminent), we shouldn't leak
> memory on it IMHO.

I agree, within reason.  If the memory leak is not going to happen on a
working system, then digging into the kobject internals like this isn't
worth it, don't you agree?

> >>  	retval = kset_register(&priv->subsys);
> >> -	if (retval)
> >> +	if (retval) {
> >> +		kfree(priv->subsys.kobj.name);
> > 
> > I don't think we want to bury the logic of how kobject names are handled
> > up here in the bus code, right?  Shouldn't the subsys kobject name be
> > able to be cleaned up on its own somehow instead?
> > 
> 
> So, my first instinct was to use kobject_cleanup, but a few lines above:
> 
> 	priv->subsys.kobj.ktype = &bus_ktype;
> 
> and bus_ktype's definition, with the notable absence of a release method:
> 
> static struct kobj_type bus_ktype = {
> 	.sysfs_ops	= &bus_sysfs_ops,
> };
> 
> which in kobject_cleanup would yield:
> 
> 	struct kobj_type *t = get_ktype(kobj);
> 
> 	if (t && !t->release)
> 		pr_debug("kobject: '%s' (%p): does not have a release() "
> 			 "function, it is broken and must be fixed.\n",
> 			 kobject_name(kobj), kobj);
> 
> (if I understand everything correctly)

But yet it doesn't :)

You might want to dig further to figure out why if you are curious.

> I have no idea what would constitute a proper 'release' method in this
> context, thus I did not write one (and am hoping this patchset would
> motivate those who know more than me to write one, or indicate to me how
> to write one, if that would be the correct course of action)

Leave it as-is, right?

> Sorry if any of this is trivial / obvious / incorrect; it's my first time
> in this code at all, and kobject and friends aren't the easiest to
> comprehend on first glance :)

I agree, they aren't simple, any areas you can find to make them simpler
to understand is always appreciated.

thanks,

greg k-h
