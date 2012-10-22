Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2JVXAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:00:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43601 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab2JVXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:00:37 -0400
X-Sasl-enc: 9E1rhlNKq0ZRivVc89ui3Tnvmeh6czFkVLUq1IP3ewUk 1350946836
Date: Mon, 22 Oct 2012 16:00:35 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: wency@cn.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v3 2/9] suppress "Device nodeX does not have a release()
 function" warning
Message-ID: <20121022230035.GA25817@kroah.com>
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com>
 <1350629202-9664-3-git-send-email-wency@cn.fujitsu.com>
 <20121022155224.e8f306f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022155224.e8f306f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:52:24PM -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2012 14:46:35 +0800
> wency@cn.fujitsu.com wrote:
> 
> > From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > 
> > When calling unregister_node(), the function shows following message at
> > device_release().
> > 
> > "Device 'node2' does not have a release() function, it is broken and must
> > be fixed."
> > 
> > The reason is node's device struct does not have a release() function.
> > 
> > So the patch registers node_device_release() to the device's release()
> > function for suppressing the warning message. Additionally, the patch adds
> > memset() to initialize a node struct into register_node(). Because the node
> > struct is part of node_devices[] array and it cannot be freed by
> > node_device_release(). So if system reuses the node struct, it has a garbage.
> > 
> > ...
> >
> > --- a/drivers/base/node.c
> > +++ b/drivers/base/node.c
> > @@ -252,6 +252,9 @@ static inline void hugetlb_register_node(struct node *node) {}
> >  static inline void hugetlb_unregister_node(struct node *node) {}
> >  #endif
> >  
> > +static void node_device_release(struct device *dev)
> > +{
> > +}
> >  
> >  /*
> >   * register_node - Setup a sysfs device for a node.
> > @@ -263,8 +266,11 @@ int register_node(struct node *node, int num, struct node *parent)
> >  {
> >  	int error;
> >  
> > +	memset(node, 0, sizeof(*node));
> > +
> >  	node->dev.id = num;
> >  	node->dev.bus = &node_subsys;
> > +	node->dev.release = node_device_release;
> >  	error = device_register(&node->dev);
> >  
> >  	if (!error){
> 
> Greg won't like that empty ->release function ;)
> 
> As you say, this device item does not reside in per-device dynamically
> allocated memory - it is part of an externally managed array.
> 
> So a proper fix here would be to convert this storage so that it *is*
> dynamically allocated on a per-device basis.

I thought we had this fixed up already?

> Or perhaps we should recognize that the whole kobject
> get/put/release-on-last-put model is inappropriate for these objects,
> and stop using it entirely.

Yes, you can do the same thing with dynamic struct devices for what you
need to do here, it should be easy to convert the code to use it.

> From Kosaki's comment, it does sound that we plan to take the first
> option: convert to per-device dynamically allocated memory?  If so, I
> suggest that we just leave the warning as-is for now, until we fix
> things proprely.

Sounds good to me.

thanks,

greg k-h
