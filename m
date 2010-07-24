Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab0GXBsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:48:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29736 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab0GXBsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:48:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48374616"
Message-ID: <4C4A4681.4070901@codeaurora.org>
Date: Fri, 23 Jul 2010 18:48:49 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 2/6] Driver core: Fix memory leak on bus_register error
 path
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org> <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org> <20100722234107.GB674@kroah.com> <4C4A3F9B.6040600@codeaurora.org>
In-Reply-To: <4C4A3F9B.6040600@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  
>>>  	retval = kset_register(&priv->subsys);
>>> -	if (retval)
>>> +	if (retval) {
>>> +		kfree(priv->subsys.kobj.name);
>>
>> I don't think we want to bury the logic of how kobject names are handled
>> up here in the bus code, right?  Shouldn't the subsys kobject name be
>> able to be cleaned up on its own somehow instead?
>>
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
> 

Thinking about this more, how does this ever work "correctly"? If we
chase the 'normal' path from bus_unregister...

given bus->p->subsys.kobj.ktype = &bus_ktype

bus_unregister(struct bus_type *bus) {
   kset_unregister(&bus->p->subsys) {
      kobject_put(&k->kobj) {
         kref_put(&kobj->kref, kobject_release) {
            (assuming last ref)
            kobject_cleanup(container_of(kref, struct kobject, kref)) {
               	struct kobj_type *t = get_ktype(kobj);

		if (t && !t->release)
			pr_debug("kobject: '%s' (%p): does not have a release() "
				 "function, it is broken and must be fixed.\n",
				 kobject_name(kobj), kobj);

Wouldn't this get hit every time a bus unregisters?  I feel like I'm
missing something here?
