Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0JEUpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:45:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab0JEUpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:45:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v5] power: introduce library for device-specific OPPs
Date: Tue, 5 Oct 2010 22:44:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Kevin H <khilman@deeprootsystems.com>
References: <1285933174-24053-1-git-send-email-nm@ti.com> <201010050036.23179.rjw@sisk.pl> <4CAB228C.7030902@ti.com>
In-Reply-To: <4CAB228C.7030902@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010052244.11403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 05, 2010, Nishanth Menon wrote:
> Rafael J. Wysocki had written, on 10/04/2010 05:36 PM, the following:
> > On Friday, October 01, 2010, Nishanth Menon wrote:
> >> SoCs have a standard set of tuples consisting of frequency and
> >> voltage pairs that the device will support per voltage domain. These
> >> are called Operating Performance Points or OPPs. The actual
> >> definitions of OPP varies over silicon versions. For a specific domain,
> >> we can have a set of {frequency, voltage} pairs. As the kernel boots
> >> and more information is available, a default set of these are activated
> >> based on the precise nature of device. Further on operation, based on
> >> conditions prevailing in the system (such as temperature), some OPP
> >> availability may be temporarily controlled by the SoC frameworks.
> >>
> >> To implement an OPP, some sort of power management support is necessary
> >> hence this library depends on CONFIG_PM.
> > 
> > Well, I still have some comments.
> Thanks for the same. Few views below.
> 
> > 
> > ...
> >> +/**
> >> + * opp_add()  - Add an OPP table from a table definitions
> >> + * @dev:	device for which we do this operation
> >> + * @freq:	Frequency in Hz for this OPP
> >> + * @u_volt:	Voltage in uVolts for this OPP
> >> + *
> >> + * This function adds an opp definition to the opp list and returns status.
> >> + * The opp is made available by default and it can be controlled using
> >> + * opp_enable/disable functions.
> >> + *
> >> + * Locking: The internal device_opp and opp structures are RCU protected.
> >> + * Hence this function internally uses RCU and mutex locks to keep the
> >> + * integrity of the internal data structures. Callers should ensure that
> >> + * this function is *NOT* called under RCU protection or in contexts where
> >> + * mutex cannot be locked.
> > 
> > I'm not really sure why so many mutexes are needed here.  I don't think you
> > need a separate mutex in every struct device_opp object.  I'd just use
> > dev_opp_list_lock for everything.
> 
> I did consider using  dev_opp_list_lock to lock everything *but* here is 
> the contention:
> 
> dev_opp_list_lock locks modification for addition of domains device. 
> This operation happens usually during init stage.
> 
> each domain device has multiple opps, new opps can be added, but the 
> more often usage will probably be opp_enable and disable. domain are 
> usually modifiable independent of each other - device_opp->lock provides 
> device level lock allowing for each domain device opp list to be 
> modified independent of each other. e.g. on thermal overage we may 
> choose to lower mpu domain while a coprocessor driver in parallel might 
> choose to disable co-processor domain in parallel.
> 
> Wondering why you'd like a single lock for all domains and restrict 
> parallelization?

Because of the simplicity, mostly.  If there's only a relatively short period
when the lock will be contended for, that still is not too bad and it's much
easier to get the synchronization right with just one lock for starters.

> >> + */
> >> +int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> >> +{
> >> +	struct device_opp *dev_opp = NULL;
> >> +	struct opp *opp, *new_opp;
> >> +	struct list_head *head;
> >> +
> >> +	/* allocate new OPP node */
> >> +	new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
> >> +	if (!new_opp) {
> >> +		pr_warning("Unable to allocate new opp node\n");
> >> +		return -ENOMEM;
> >> +	}
> >> +
> >> +	/* Check for existing list for 'dev' */
> >> +	rcu_read_lock();
> > 
> > If you acquire dev_opp_list_lock here, you won't need the rcu_read_lock(),
> > because every other updater will block on dev_opp_list_lock until you're done.
> [contention on using a single lock dev_opp_list_lock as discussed above]

I don't think it's a big issue at this point.

> >> +	dev_opp = find_device_opp(dev);
> >> +	rcu_read_unlock();
> >> +	if (!dev_opp) {
> > 
> > Now you can drop dev_opp_list_lock temporarily, because the allocation doesn't
> > need synchronization.
> [contention on using a single lock dev_opp_list_lock as discussed above]

Well, see above.

> >> +		/* Allocate a new device OPP table */
> >> +		dev_opp = kzalloc(sizeof(struct device_opp), GFP_KERNEL);
> >> +		if (!dev_opp) {
> >> +			kfree(new_opp);
> >> +			pr_warning("Unable to allocate device structure\n");
> >> +			return -ENOMEM;
> >> +		}
> >> +
> >> +		dev_opp->dev = dev;
> >> +		INIT_LIST_HEAD(&dev_opp->opp_list);
> >> +		mutex_init(&dev_opp->lock);
> >> +
> > 
> > Reacquire dev_opp_list_lock at this point and hold it to the end of the routine.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> >> +		/* Secure the device list modification */
> >> +		mutex_lock(&dev_opp_list_lock);
> > 
> > This won't be necessary any more.
> > 
> >> +		list_add_rcu(&dev_opp->node, &dev_opp_list);
> > 
> > Of course, this is still needed.
> > 
> >> +		mutex_unlock(&dev_opp_list_lock);
> > 
> > Not necessary.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> >> +	}
> >> +
> >> +	/* populate the opp table */
> >> +	new_opp->dev_opp = dev_opp;
> >> +	new_opp->rate = freq;
> >> +	new_opp->u_volt = u_volt;
> >> +	new_opp->available = true;
> >> +
> >> +	/* make the dev_opp modification safe */
> >> +	mutex_lock(&dev_opp->lock);
> > 
> > That's not necessary.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> >> +
> >> +	rcu_read_lock();
> > 
> > Ditto.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> >> +	/* Insert new OPP in order of increasing frequency */
> >> +	head = &dev_opp->opp_list;
> >> +	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
> >> +		if (new_opp->rate < opp->rate)
> >> +			break;
> >> +		else
> >> +			head = &opp->node;
> >> +	}
> >> +	rcu_read_unlock();
> > 
> > Ditto.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> >> +	list_add_rcu(&new_opp->node, head);
> >> +	mutex_unlock(&dev_opp->lock);
> > 
> > Now release dev_opp_list_lock instead.
> [contention on using a single lock dev_opp_list_lock as discussed above]

See above.

> > And remember to call synchronize_rcu() when you're done.
> 
> we dont need synchronize_rcu() for list_add_rcu as Paul pointed out in 
> [1]. quote:
> "
>  > +		mutex_lock(&dev_opp_list_lock);
>  > +		list_add_rcu(&dev_opp->node, &dev_opp_list);
>  > +		mutex_unlock(&dev_opp_list_lock);
>  > +		synchronize_rcu();
> 
> You do not need to wait for an RCU grace period when adding objects, 
> only between removing them and freeing them.
> "

OK

> 
> in our usage, this points to list_replace_rcu
> 
> > 
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * opp_set_availability() - helper to set the availability of an opp
> >> + * @dev:		device for which we do this operation
> >> + * @freq:		OPP frequency to modify availability
> >> + * @availability_req:	availability status requested for this opp
> >> + *
> >> + * Set the availability of an OPP with an RCU operation, opp_{enable,disable}
> >> + * share a common logic which is isolated here.
> >> + *
> >> + * Returns -EINVAL for bad pointers, -ENOMEM if no memory available for the
> >> + * copy operation, returns 0 if no modifcation was done OR modification was
> >> + * successful.
> >> + *
> >> + * Locking: The internal device_opp and opp structures are RCU protected.
> >> + * Hence this function internally uses RCU and mutex locks to keep the
> >> + * integrity of the internal data structures. Callers should ensure that
> >> + * this function is *NOT* called under RCU protection or in contexts where
> >> + * mutex locking or synchronize_rcu() blocking calls cannot be used.
> >> + */
> >> +static int opp_set_availability(struct device *dev, unsigned long freq,
> >> +		bool availability_req)
> >> +{
> >> +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
> >> +	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
> >> +	int r = 0;
> >> +
> >> +	/* keep the node allocated */
> >> +	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
> >> +	if (!new_opp) {
> >> +		pr_warning("Unable to allocate opp\n");
> >> +		return -ENOMEM;
> >> +	}
> >> +
> >> +	rcu_read_lock();
> > 
> > Acquire dev_opp_list_lock instead.
> [contention on using a single lock dev_opp_list_lock as discussed above]

Well, I'm tired of this.

To summarize, I don't think the synchronization will work correctly in the
version of the patch you've submitted and I suggested you how it can be fixed.

As I said, I don't think the lock contention is a big issue at this point.

Thanks,
Rafael
 
