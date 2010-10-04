Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0JDWha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:37:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0JDWh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:37:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v5] power: introduce library for device-specific OPPs
Date: Tue, 5 Oct 2010 00:36:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Kevin H <khilman@deeprootsystems.com>
References: <1285933174-24053-1-git-send-email-nm@ti.com>
In-Reply-To: <1285933174-24053-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010050036.23179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 01, 2010, Nishanth Menon wrote:
> SoCs have a standard set of tuples consisting of frequency and
> voltage pairs that the device will support per voltage domain. These
> are called Operating Performance Points or OPPs. The actual
> definitions of OPP varies over silicon versions. For a specific domain,
> we can have a set of {frequency, voltage} pairs. As the kernel boots
> and more information is available, a default set of these are activated
> based on the precise nature of device. Further on operation, based on
> conditions prevailing in the system (such as temperature), some OPP
> availability may be temporarily controlled by the SoC frameworks.
> 
> To implement an OPP, some sort of power management support is necessary
> hence this library depends on CONFIG_PM.

Well, I still have some comments.

...
> +/**
> + * opp_add()  - Add an OPP table from a table definitions
> + * @dev:	device for which we do this operation
> + * @freq:	Frequency in Hz for this OPP
> + * @u_volt:	Voltage in uVolts for this OPP
> + *
> + * This function adds an opp definition to the opp list and returns status.
> + * The opp is made available by default and it can be controlled using
> + * opp_enable/disable functions.
> + *
> + * Locking: The internal device_opp and opp structures are RCU protected.
> + * Hence this function internally uses RCU and mutex locks to keep the
> + * integrity of the internal data structures. Callers should ensure that
> + * this function is *NOT* called under RCU protection or in contexts where
> + * mutex cannot be locked.

I'm not really sure why so many mutexes are needed here.  I don't think you
need a separate mutex in every struct device_opp object.  I'd just use
dev_opp_list_lock for everything.

> + */
> +int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> +{
> +	struct device_opp *dev_opp = NULL;
> +	struct opp *opp, *new_opp;
> +	struct list_head *head;
> +
> +	/* allocate new OPP node */
> +	new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
> +	if (!new_opp) {
> +		pr_warning("Unable to allocate new opp node\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Check for existing list for 'dev' */
> +	rcu_read_lock();

If you acquire dev_opp_list_lock here, you won't need the rcu_read_lock(),
because every other updater will block on dev_opp_list_lock until you're done.

> +	dev_opp = find_device_opp(dev);
> +	rcu_read_unlock();
> +	if (!dev_opp) {

Now you can drop dev_opp_list_lock temporarily, because the allocation doesn't
need synchronization.

> +		/* Allocate a new device OPP table */
> +		dev_opp = kzalloc(sizeof(struct device_opp), GFP_KERNEL);
> +		if (!dev_opp) {
> +			kfree(new_opp);
> +			pr_warning("Unable to allocate device structure\n");
> +			return -ENOMEM;
> +		}
> +
> +		dev_opp->dev = dev;
> +		INIT_LIST_HEAD(&dev_opp->opp_list);
> +		mutex_init(&dev_opp->lock);
> +

Reacquire dev_opp_list_lock at this point and hold it to the end of the routine.

> +		/* Secure the device list modification */
> +		mutex_lock(&dev_opp_list_lock);

This won't be necessary any more.

> +		list_add_rcu(&dev_opp->node, &dev_opp_list);

Of course, this is still needed.

> +		mutex_unlock(&dev_opp_list_lock);

Not necessary.

> +	}
> +
> +	/* populate the opp table */
> +	new_opp->dev_opp = dev_opp;
> +	new_opp->rate = freq;
> +	new_opp->u_volt = u_volt;
> +	new_opp->available = true;
> +
> +	/* make the dev_opp modification safe */
> +	mutex_lock(&dev_opp->lock);

That's not necessary.

> +
> +	rcu_read_lock();

Ditto.

> +	/* Insert new OPP in order of increasing frequency */
> +	head = &dev_opp->opp_list;
> +	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
> +		if (new_opp->rate < opp->rate)
> +			break;
> +		else
> +			head = &opp->node;
> +	}
> +	rcu_read_unlock();

Ditto.

> +	list_add_rcu(&new_opp->node, head);
> +	mutex_unlock(&dev_opp->lock);

Now release dev_opp_list_lock instead.

And remember to call synchronize_rcu() when you're done.

> +	return 0;
> +}
> +
> +/**
> + * opp_set_availability() - helper to set the availability of an opp
> + * @dev:		device for which we do this operation
> + * @freq:		OPP frequency to modify availability
> + * @availability_req:	availability status requested for this opp
> + *
> + * Set the availability of an OPP with an RCU operation, opp_{enable,disable}
> + * share a common logic which is isolated here.
> + *
> + * Returns -EINVAL for bad pointers, -ENOMEM if no memory available for the
> + * copy operation, returns 0 if no modifcation was done OR modification was
> + * successful.
> + *
> + * Locking: The internal device_opp and opp structures are RCU protected.
> + * Hence this function internally uses RCU and mutex locks to keep the
> + * integrity of the internal data structures. Callers should ensure that
> + * this function is *NOT* called under RCU protection or in contexts where
> + * mutex locking or synchronize_rcu() blocking calls cannot be used.
> + */
> +static int opp_set_availability(struct device *dev, unsigned long freq,
> +		bool availability_req)
> +{
> +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
> +	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
> +	int r = 0;
> +
> +	/* keep the node allocated */
> +	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
> +	if (!new_opp) {
> +		pr_warning("Unable to allocate opp\n");
> +		return -ENOMEM;
> +	}
> +
> +	rcu_read_lock();

Acquire dev_opp_list_lock instead.

> +
> +	/* Find the device_opp */
> +	list_for_each_entry_rcu(tmp_dev_opp, &dev_opp_list, node) {

You can use a normal list_for_each_entry here, because it's under the lock.

> +		if (dev == tmp_dev_opp->dev) {
> +			dev_opp = tmp_dev_opp;
> +			break;
> +		}
> +	}
> +	dev_opp = find_device_opp(dev);

Hmm.  I wonder why this is necessary?

> +	if (IS_ERR(dev_opp)) {
> +		r = PTR_ERR(dev_opp);
> +		pr_warning("Unable to find device\n");
> +		goto err;
> +	}
> +
> +	/* Do we have the frequency? */
> +	list_for_each_entry_rcu(tmp_opp, &dev_opp->opp_list, node) {

Use list_for_each_entry here too.

> +		if (tmp_opp->rate == freq) {
> +			opp = tmp_opp;
> +			break;
> +		}
> +	}
> +	if (IS_ERR(opp)) {
> +		r = PTR_ERR(opp);
> +		goto err;
> +	}
> +
> +	mutex_lock(&opp->dev_opp->lock);

And that won't be necessary any more.

> +	tmp_opp = rcu_dereference(opp);

Ditto (we're an updater, not a reader).

> +	/* Is update really needed? */
> +	if (tmp_opp->available == availability_req)
> +		goto out1;
> +	/* copy the old data over */
> +	*new_opp = *tmp_opp;
> +	rcu_read_unlock();

Not necessary.

> +	/* plug in new node */
> +	new_opp->available = availability_req;
> +	list_replace_rcu(&opp->node, &new_opp->node);
> +	mutex_unlock(&opp->dev_opp->lock);

Now unlock dev_opp_list_lock instead.

> +	synchronize_rcu();
> +

And rework the exit code below accordingly.

> +	/* clean up old opp */
> +	new_opp = opp;
> +	goto out;
> +
> +out1:
> +	mutex_unlock(&opp->dev_opp->lock);
> +err:
> +	rcu_read_unlock();
> +out:
> +	kfree(new_opp);
> +	return r;
> +}
> +
...
> +int opp_init_cpufreq_table(struct device *dev,
> +			    struct cpufreq_frequency_table **table)
> +{
> +	struct device_opp *dev_opp;
> +	struct opp *opp;
> +	struct cpufreq_frequency_table *freq_table;
> +	int i = 0;
> +
> +	rcu_read_lock();

I would pretend I'm an updater here and acquire dev_opp_list_lock instead.

> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp)) {
> +		rcu_read_unlock();

So that won't be necessary.

> +		pr_warning("Unable to find device\n");
> +		return PTR_ERR(dev_opp);
> +	}
> +

Now, you can sleep with the mutex held, so GFP_KERNEL may be used below.

> +	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
> +			     (opp_get_opp_count(dev) + 1), GFP_ATOMIC);
> +	if (!freq_table) {
> +		rcu_read_unlock();

Drop dev_opp_list_lock instead.

> +		pr_warning("Failed to allocate frequency table\n");
> +		return -ENOMEM;
> +	}
> +
> +	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {

That may be list_for_each_entry() now.

> +		if (opp->available) {
> +			freq_table[i].index = i;
> +			freq_table[i].frequency = opp->rate / 1000;
> +			i++;
> +		}
> +	}
> +	rcu_read_unlock();

Drop dev_opp_list_lock instead.

> +
> +	freq_table[i].index = i;
> +	freq_table[i].frequency = CPUFREQ_TABLE_END;
> +
> +	*table = &freq_table[0];
> +
> +	return 0;
> +}

I think I didn't confuse anything, but surely Paul will fix me if I did. :-)

Thanks,
Rafael

