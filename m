Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0GVXpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:45:10 -0400
Received: from kroah.org ([198.145.64.141]:41485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab0GVXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:44:26 -0400
Date: Thu, 22 Jul 2010 16:41:07 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/6] Driver core: Fix memory leak on bus_register error
 path
Message-ID: <20100722234107.GB674@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:09:02PM -0700, Patrick Pannuto wrote:
> There is a subtle memory leak in driver core error path.
> Consider the simplified view of bus_register (drivers/base/bus.c):
> 
> priv = kzalloc...
> kobject_set_name(&priv->subsys.kobj,...) <== allocate in priv->subsys.kobj.name
> if kset_register(&priv->subsys) FAILS:

Why would this fail?

> 	(1) -- need to free name string here!
> 	goto out
> else
> 	keep going, assume we fail later...
> 
> err_path_after_kset_register:
> 	kset_unregister(&priv->subsys) <== calls kobject_put(&priv->subsys->kobj),
>                                            which is the last reference, which leads
> 					   to kobject_cleanup, which frees the name
> 					   field BUT DOES NOT SET IT TO NULL
> out:
> 	(2) Other place we could free name
> 	kfree(bus->p) // bus->p = priv
> 	...
> 
> Thus, we cannot insert the free'ing of name on the error path (2) since it will
> be indeterminite if we need to free the name string or not. kset_register cannot (and
> should not) free the name string if it fails since the caller may have other ideas,
> leaving only (1) as a viable location to free the name string.
> 
> A walk-through of the failure path that will trigger this leak:
> 
> bus_register(struct bus_type *bus) {
> 	...
> 	priv = kzalloc...
> 	kobject_set_name(&priv->subsys.kobj,... {
> 		kobject_set_name_vargs(kobj,... {
> 			kobj->name = kvasprintf... <== ALLOCATE INTO &priv->subsys.kobj.name
> 
> 	priv->subsys.kobj.kset = bus_kset
> 	priv->subsys.kobj.ktype = &bus_ktype
> 
> 	retval = kset_register(&priv->subsys)...
> 	if (retval) YES
> 		goto out;
> 
> 	...
> out:
> 	kfree(bus->p);
> 	bus->p = NULL;
> 	return retval;
> }
> 
> kset_register(struct kset *k) { // k = &priv->subsys
> 	kset_init(k) {
> 		kobject_init_internal(&k->kobj) {
> 			kref_init(&kobj->kref) {
> 				kref->refcount = 1
> 
> 	err = kobject_add_internal(&k->kobj)...
> 	if (err) YES
> 		return err;
> 	...
> }
> 
> kobject_add_internal(struct kobject *kobj) { // kobj = &priv->subsys.kobj
> 	...
> 	if (kobj->kset) YES {
> 		kobj_kset_join(kobj) {
> 			kset_get(kobj->kset) <== bus_kset
> 	...
> 	error = create_dir(kobj);
> 	if (error) YES {
> 		kobj_kset_leave(kobj) {
> 			kset_put(kobj->kset) <== bus_kset
> 		... (release parent and make KERN_ERR noise)
> 	}
> 	return error
> }
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  drivers/base/bus.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index eb1b7fa..fea1774 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -900,8 +900,10 @@ int bus_register(struct bus_type *bus)
>  	priv->drivers_autoprobe = 1;
>  
>  	retval = kset_register(&priv->subsys);
> -	if (retval)
> +	if (retval) {
> +		kfree(priv->subsys.kobj.name);

I don't think we want to bury the logic of how kobject names are handled
up here in the bus code, right?  Shouldn't the subsys kobject name be
able to be cleaned up on its own somehow instead?

thanks,

greg k-h
