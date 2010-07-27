Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0G0ABH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:01:07 -0400
Received: from kroah.org ([198.145.64.141]:52254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab0G0AA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:00:56 -0400
Date: Mon, 26 Jul 2010 17:00:48 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 2/6] Driver core: Fix memory leak on bus_register error
 path
Message-ID: <20100727000048.GB26421@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org>
 <20100722234107.GB674@kroah.com>
 <4C4A3F9B.6040600@codeaurora.org>
 <4C4A4681.4070901@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4A4681.4070901@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 06:48:49PM -0700, Patrick Pannuto wrote:
> >>>  
> >>>  	retval = kset_register(&priv->subsys);
> >>> -	if (retval)
> >>> +	if (retval) {
> >>> +		kfree(priv->subsys.kobj.name);
> >>
> >> I don't think we want to bury the logic of how kobject names are handled
> >> up here in the bus code, right?  Shouldn't the subsys kobject name be
> >> able to be cleaned up on its own somehow instead?
> >>
> > 
> > So, my first instinct was to use kobject_cleanup, but a few lines above:
> > 
> > 	priv->subsys.kobj.ktype = &bus_ktype;
> > 
> > and bus_ktype's definition, with the notable absence of a release method:
> > 
> > static struct kobj_type bus_ktype = {
> > 	.sysfs_ops	= &bus_sysfs_ops,
> > };
> > 
> > which in kobject_cleanup would yield:
> > 
> > 	struct kobj_type *t = get_ktype(kobj);
> > 
> > 	if (t && !t->release)
> > 		pr_debug("kobject: '%s' (%p): does not have a release() "
> > 			 "function, it is broken and must be fixed.\n",
> > 			 kobject_name(kobj), kobj);
> > 
> > (if I understand everything correctly)
> > 
> 
> Thinking about this more, how does this ever work "correctly"? If we
> chase the 'normal' path from bus_unregister...
> 
> given bus->p->subsys.kobj.ktype = &bus_ktype
> 
> bus_unregister(struct bus_type *bus) {
>    kset_unregister(&bus->p->subsys) {
>       kobject_put(&k->kobj) {
>          kref_put(&kobj->kref, kobject_release) {
>             (assuming last ref)
>             kobject_cleanup(container_of(kref, struct kobject, kref)) {
>                	struct kobj_type *t = get_ktype(kobj);
> 
> 		if (t && !t->release)
> 			pr_debug("kobject: '%s' (%p): does not have a release() "
> 				 "function, it is broken and must be fixed.\n",
> 				 kobject_name(kobj), kobj);
> 
> Wouldn't this get hit every time a bus unregisters?  I feel like I'm
> missing something here?

You are, busses are wierd :)

I can't recall off the top of my head, but it all works out ok in the
end.

thanks,

greg k-h
