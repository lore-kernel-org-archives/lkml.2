Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0GXBTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:19:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65042 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab0GXBTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:19:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6052"; a="48370642"
Message-ID: <4C4A3F9B.6040600@codeaurora.org>
Date: Fri, 23 Jul 2010 18:19:23 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/6] Driver core: Fix memory leak on bus_register error
 path
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org> <1279836546-26913-3-git-send-email-ppannuto@codeaurora.org> <20100722234107.GB674@kroah.com>
In-Reply-To: <20100722234107.GB674@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 04:41 PM, Greg KH wrote:
> On Thu, Jul 22, 2010 at 03:09:02PM -0700, Patrick Pannuto wrote:
>> There is a subtle memory leak in driver core error path.
>> Consider the simplified view of bus_register (drivers/base/bus.c):
>>
>> priv = kzalloc...
>> kobject_set_name(&priv->subsys.kobj,...) <== allocate in priv->subsys.kobj.name
>> if kset_register(&priv->subsys) FAILS:
> 
> Why would this fail?
> 

This is not a likely failure path at all, but (from my understanding), it
is possible:

kset_register {
   kobject_add_internal {
      create_dir()

is the most likely candidate to fail, mostly likely for EEXIST due to something
else screwy going on. Regardless of how likely it is to fail, it *is* possible,
otherwise, what is the point of checking the return code and having an error
path? If the error path exists (and a panic is not eminent), we shouldn't leak
memory on it IMHO.

>>  
>>  	retval = kset_register(&priv->subsys);
>> -	if (retval)
>> +	if (retval) {
>> +		kfree(priv->subsys.kobj.name);
> 
> I don't think we want to bury the logic of how kobject names are handled
> up here in the bus code, right?  Shouldn't the subsys kobject name be
> able to be cleaned up on its own somehow instead?
> 

So, my first instinct was to use kobject_cleanup, but a few lines above:

	priv->subsys.kobj.ktype = &bus_ktype;

and bus_ktype's definition, with the notable absence of a release method:

static struct kobj_type bus_ktype = {
	.sysfs_ops	= &bus_sysfs_ops,
};

which in kobject_cleanup would yield:

	struct kobj_type *t = get_ktype(kobj);

	if (t && !t->release)
		pr_debug("kobject: '%s' (%p): does not have a release() "
			 "function, it is broken and must be fixed.\n",
			 kobject_name(kobj), kobj);

(if I understand everything correctly)

I have no idea what would constitute a proper 'release' method in this
context, thus I did not write one (and am hoping this patchset would
motivate those who know more than me to write one, or indicate to me how
to write one, if that would be the correct course of action)


Sorry if any of this is trivial / obvious / incorrect; it's my first time
in this code at all, and kobject and friends aren't the easiest to
comprehend on first glance :)

-pat
