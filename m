Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0IXV1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:27:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50904 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326Ab0IXV1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:27:05 -0400
Message-ID: <4C9D177D.6090708@ti.com>
Date: Fri, 24 Sep 2010 16:26:21 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v4] power: introduce library for device-specific OPPs
References: <1285332640-16736-1-git-send-email-nm@ti.com> <20100924193742.GJ2375@linux.vnet.ibm.com>
In-Reply-To: <20100924193742.GJ2375@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney had written, on 09/24/2010 02:37 PM, the following:
[...]
> 
> Looks like a good start!!!  Some questions and suggestions about RCU
Thanks for the review.. few comments below..
> usage interspersed below.
> 
>                                                         Thanx, Paul
[...]
>> +
>> +/**
>> + * find_device_opp() - find device_opp struct using device pointer
>> + * @dev:     device pointer used to lookup device OPPs
>> + *
>> + * Search list of device OPPs for one containing matching device. Does a RCU
>> + * reader operation to grab the pointer needed.
>> + *
>> + * Returns pointer to 'struct device_opp' if found, otherwise -ENODEV or
>> + * -EINVAL based on type of error.
>> + */
>> +static struct device_opp *find_device_opp(struct device *dev)
>> +{
>> +     struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
>> +
>> +     if (unlikely(!dev || IS_ERR(dev))) {
>> +             pr_err("%s: Invalid parameters being passed\n", __func__);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(tmp_dev_opp, &dev_opp_list, node) {
>> +             if (tmp_dev_opp->dev == dev) {
>> +                     dev_opp = tmp_dev_opp;
>> +                     break;
>> +             }
>> +     }
>> +     rcu_read_unlock();
> 
> What prevents the structure pointed to by dev_opp from being freed
> at this point?  We are no longer in an RCU read-side critical section,
> so RCU grace periods starting during the above RCU read-side critical
> section can now end.

dev_opp is never freed in the implementation -> it represents domains, 
only adds with list_add_rcu() is done -> wont the usage be safe then? or 
I being blind?

the reason why we dont free is coz of the following: dev_opp represents 
voltage domains in opp library. SoC frameworks are required to register 
only those voltage domain opp that are required. by allowing a free 
logic, I knew it'd have complicated the implementation way beyond what 
we needed it to be.

> 
> Here is an example sequence of events that I am worried about:
> 
> o       CPU 1 enters find_device_opp(), and pick up a pointer to
>         a given device opp.
> 
> o       CPU 2 executes opp_set_availability(), replacing that same
>         device opp with a new one.  It then calls synchronize_rcu()
>         which blocks waiting for CPU 1 to exit its RCU read-side
>         critical section.
> 
> o       CPU 1 exits its RCU read-side critical section, arriving at
>         this point in the code.
> 
> o       CPU 2's synchronize_rcu() is now permitted to return, executing
>         the kfree(), which frees up the memory that CPU 1's dev_opp
>         pointer references.
> 
> o       This newly freed memory is allocated for some other structure
>         by CPU 3.  CPU 1 and CPU 3 are now trying to use the same
>         memory for two different structures, and nothing good can
>         possibly come of this.  The kernel dies a brutal and nasty
>         death.
> 
> One way to fix this is to have the caller do rcu_read_lock() before
> calling find_device_opp(), and to do rcu_read_unlock() only after the
> caller has finished using the pointer that find_device_opp() returns.
> This works well unless the caller needs to do some blocking operation
> before it gets done using the pointer.
> 
> Another approach is for find_device_opp() to use a reference count on
> the structure, and for opp_set_availability() to avoid freeing the
> structure unless/until the reference counter drops to zero.
> 
> There are other approaches as well, please feel free to take a look
> at Documentation/RCU/rcuref.txt for more info on using reference
> counting and RCU.
thx. I probably should read yet again if I got my understanding of usage 
right..

> 
[...]
>> +
>> +/**
>> + * opp_find_freq_exact() - search for an exact frequency
>> + * @dev:             device for which we do this operation
>> + * @freq:            frequency to search for
>> + * @is_available:    true/false - match for available opp
>> + *
>> + * Searches for exact match in the opp list and returns pointer to the matching
>> + * opp if found, else returns ERR_PTR in case of error and should be handled
>> + * using IS_ERR.
>> + *
>> + * Note: available is a modifier for the search. if available=true, then the
>> + * match is for exact matching frequency and is available in the stored OPP
>> + * table. if false, the match is for exact frequency which is not available.
>> + *
>> + * This provides a mechanism to enable an opp which is not available currently
>> + * or the opposite as well.
>> + *
>> + * Locking: RCU reader.
>> + */
>> +struct opp *opp_find_freq_exact(struct device *dev,
>> +                                  unsigned long freq, bool available)
>> +{
>> +     struct device_opp *dev_opp;
>> +     struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
>> +
>> +     dev_opp = find_device_opp(dev);
>> +     if (IS_ERR(dev_opp))
>> +             return opp;
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>> +             if (temp_opp->available == available &&
>> +                             temp_opp->rate == freq) {
>> +                     opp = temp_opp;
>> +                     break;
>> +             }
>> +     }
>> +     rcu_read_unlock();
> 
> But this one sadly has the same problem that find_device_opp() does.
is the concern about opp OR about dev_opp here? I am guessing opp..
> 
>> +     return opp;
>> +}
>> +
>> +/**
>> + * opp_find_freq_ceil() - Search for an rounded ceil freq
>> + * @dev:     device for which we do this operation
>> + * @freq:    Start frequency
>> + *
>> + * Search for the matching ceil *available* OPP from a starting freq
>> + * for a device.
>> + *
>> + * Returns matching *opp and refreshes *freq accordingly, else returns
>> + * ERR_PTR in case of error and should be handled using IS_ERR.
>> + *
>> + * Locking: RCU reader.
>> + */
>> +struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
>> +{
>> +     struct device_opp *dev_opp;
>> +     struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
>> +
>> +     if (!dev || !freq) {
>> +             pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
>> +                             dev, freq);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     dev_opp = find_device_opp(dev);
>> +     if (IS_ERR(dev_opp))
>> +             return opp;
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>> +             if (temp_opp->available && temp_opp->rate >= *freq) {
>> +                     opp = temp_opp;
>> +                     *freq = opp->rate;
>> +                     break;
>> +             }
>> +     }
>> +     rcu_read_unlock();
> 
> And this one also has the same problem that find_device_opp() does.
guessing opp ptr here.. am I right? if it is about device_opp, it is not 
going to be freed as I mentioned above - at least we dont give an 
function to update(hence free) it.

> 
>> +     return opp;
>> +}
>> +
>> +/**
>> + * opp_find_freq_floor() - Search for a rounded floor freq
>> + * @dev:     device for which we do this operation
>> + * @freq:    Start frequency
>> + *
>> + * Search for the matching floor *available* OPP from a starting freq
>> + * for a device.
>> + *
>> + * Returns matching *opp and refreshes *freq accordingly, else returns
>> + * ERR_PTR in case of error and should be handled using IS_ERR.
>> + *
>> + * Locking: RCU reader.
>> + */
>> +struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
>> +{
>> +     struct device_opp *dev_opp;
>> +     struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
>> +
>> +     if (!dev || !freq) {
>> +             pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
>> +                             dev, freq);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     dev_opp = find_device_opp(dev);
>> +     if (IS_ERR(dev_opp))
>> +             return opp;
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>> +             if (temp_opp->available) {
>> +                     /* go to the next node, before choosing prev */
>> +                     if (temp_opp->rate > *freq)
>> +                             break;
>> +                     else
>> +                             opp = temp_opp;
>> +             }
>> +     }
>> +     if (!IS_ERR(opp))
>> +             *freq = opp->rate;
>> +     rcu_read_unlock();
> 
> As does this one.
guessing opp ptr here.. am I right?

> 
>> +     return opp;
>> +}
>> +
>> +/**
>> + * opp_add()  - Add an OPP table from a table definitions
>> + * @dev:     device for which we do this operation
>> + * @freq:    Frequency in Hz for this OPP
>> + * @u_volt:  Voltage in uVolts for this OPP
>> + *
>> + * This function adds an opp definition to the opp list and returns status.
>> + * The opp is made available by default and it can be controlled using
>> + * opp_enable/disable functions.
>> + *
>> + * Locking: RCU, mutex
>> + */
>> +int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>> +{
>> +     struct device_opp *tmp_dev_opp, *dev_opp = NULL;
>> +     struct opp *opp, *new_opp;
>> +     struct list_head *head;
>> +
>> +     /* Check for existing list for 'dev' */
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(tmp_dev_opp, &dev_opp_list, node) {
>> +             if (dev == tmp_dev_opp->dev) {
>> +                     dev_opp = tmp_dev_opp;
>> +                     break;
>> +             }
>> +     }
>> +     rcu_read_unlock();
>> +
>> +     /* allocate new OPP node */
>> +     new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
>> +     if (!new_opp) {
>> +             pr_warning("%s: unable to allocate new opp node\n",
>> +                     __func__);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     if (!dev_opp) {
>> +             /* Allocate a new device OPP table */
>> +             dev_opp = kzalloc(sizeof(struct device_opp), GFP_KERNEL);
>> +             if (!dev_opp) {
>> +                     kfree(new_opp);
>> +                     pr_warning("%s: unable to allocate device structure\n",
>> +                             __func__);
>> +                     return -ENOMEM;
>> +             }
>> +
>> +             dev_opp->dev = dev;
>> +             INIT_LIST_HEAD(&dev_opp->opp_list);
>> +             mutex_init(&dev_opp->lock);
>> +
>> +             /* Secure the device list modification */
>> +             mutex_lock(&dev_opp_list_lock);
>> +             list_add_rcu(&dev_opp->node, &dev_opp_list);
>> +             mutex_unlock(&dev_opp_list_lock);
>> +             synchronize_rcu();
> 
> You do not need to wait for an RCU grace period when adding objects, only
> between removing them and freeing them.
ouch.. my bad.. thx.. will fix

> 
>> +     }
>> +
>> +     /* populate the opp table */
>> +     new_opp->dev_opp = dev_opp;
>> +     new_opp->rate = freq;
>> +     new_opp->u_volt = u_volt;
>> +     new_opp->available = true;
>> +
>> +     /* make the dev_opp modification safe */
>> +     mutex_lock(&dev_opp->lock);
>> +
>> +     rcu_read_lock();
>> +     /* Insert new OPP in order of increasing frequency */
>> +     head = &dev_opp->opp_list;
>> +     list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
>> +             if (new_opp->rate < opp->rate)
>> +                     break;
>> +             else
>> +                     head = &opp->node;
>> +     }
>> +     rcu_read_unlock();
>> +
>> +     list_add_rcu(&new_opp->node, head);
>> +     mutex_unlock(&dev_opp->lock);
>> +     synchronize_rcu();
> 
> Ditto.
thx.. will fix.

> 
>> +     return 0;
>> +}
>> +
>> +/**
>> + * opp_set_availability() - helper to set the availability of an opp
>> + * @opp:             Pointer to opp
>> + * @availability_req:        availability status requested for this opp
>> + *
>> + * Set the availability of an OPP with an RCU operation, opp_{enable,disable}
>> + * share a common logic which is isolated here.
>> + *
>> + * Returns -EINVAL for bad pointers, -ENOMEM if no memory available for the
>> + * copy operation, returns 0 if no modifcation was done OR modification was
>> + * successful.
>> + */
>> +static int opp_set_availability(struct opp *opp, bool availability_req)
>> +{
>> +     struct opp *new_opp, *tmp_opp;
>> +     bool is_available;
>> +
>> +     if (unlikely(!opp || IS_ERR(opp))) {
>> +             pr_err("%s: Invalid parameters being passed\n", __func__);
>> +             return -EINVAL;
>> +     }
>> +
>> +     new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
>> +     if (!new_opp) {
>> +             pr_warning("%s: unable to allocate opp\n", __func__);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     mutex_lock(&opp->dev_opp->lock);
>> +
>> +     rcu_read_lock();
>> +     tmp_opp = rcu_dereference(opp);
>> +     is_available = tmp_opp->available;
>> +     rcu_read_unlock();
>> +
>> +     /* Is update really needed? */
>> +     if (is_available == availability_req) {
>> +             mutex_unlock(&opp->dev_opp->lock);
>> +             kfree(tmp_opp);
>> +             return 0;
>> +     }
>> +
>> +     *new_opp = *opp;
>> +     new_opp->available = availability_req;
>> +     list_replace_rcu(&opp->node, &new_opp->node);
>> +
>> +     mutex_unlock(&opp->dev_opp->lock);
>> +     synchronize_rcu();
> 
> If you decide to rely on reference counts to fix the problem in
> find_device_opp(), you will need to check the reference counts here.
> Again, please see Documentation/RCU/rcuref.txt.

Does the original point about not needing to free dev_opp resolve this?

> 
>> +     kfree(opp);
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * opp_enable() - Enable a specific OPP
>> + * @opp:     Pointer to opp
>> + *
>> + * Enables a provided opp. If the operation is valid, this returns 0, else the
>> + * corresponding error value. It is meant to be used for users an OPP available
>> + * after being temporarily made unavailable with opp_disable.
>> + *
>> + * Locking: RCU, mutex
> 
> By "Locking: RCU", you presumably don't mean that the caller must do
> an rcu_read_lock() -- this would result in a synchronize_rcu() being
> invoked in an RCU read-side critical section, which is illegal.
aye..thx. I will make it more verbose. Does the following sound right?

Locking used internally: RCU copy-update and read_lock used, mutex

and for the readers:

Locking used internally: RCU read_lock used

or do we need to go all verbatim about the implementation here?

I intended the user to know the context in which they can call it, for 
example, since mutex is used, dont think of using this in interrupt 
context. since read_locks are already used, dont need to double lock 
it.. opp library takes care of it's own exclusivity.

> 
>> + */
>> +int opp_enable(struct opp *opp)
>> +{
>> +     return opp_set_availability(opp, true);
>> +}
>> +
>> +/**
>> + * opp_disable() - Disable a specific OPP
>> + * @opp:     Pointer to opp
>> + *
>> + * Disables a provided opp. If the operation is valid, this returns
>> + * 0, else the corresponding error value. It is meant to be a temporary
>> + * control by users to make this OPP not available until the circumstances are
>> + * right to make it available again (with a call to opp_enable).
>> + *
>> + * Locking: RCU, mutex
> 
> Ditto.  (And similar feedback applies elsewhere.)
> 
>> + */
>> +int opp_disable(struct opp *opp)
>> +{
>> +     return opp_set_availability(opp, false);
>> +}
>> +
>> +#ifdef CONFIG_CPU_FREQ
>> +/**
>> + * opp_init_cpufreq_table() - create a cpufreq table for a device
>> + * @dev:     device for which we do this operation
>> + * @table:   Cpufreq table returned back to caller
>> + *
>> + * Generate a cpufreq table for a provided device- this assumes that the
>> + * opp list is already initialized and ready for usage.
>> + *
>> + * This function allocates required memory for the cpufreq table. It is
>> + * expected that the caller does the required maintenance such as freeing
>> + * the table as required.
>> + *
>> + * WARNING: It is  important for the callers to ensure refreshing their copy of
>> + * the table if any of the mentioned functions have been invoked in the interim.
>> + *
>> + * Locking: RCU reader
>> + */
>> +void opp_init_cpufreq_table(struct device *dev,
>> +                         struct cpufreq_frequency_table **table)
>> +{
>> +     struct device_opp *dev_opp;
>> +     struct opp *opp;
>> +     struct cpufreq_frequency_table *freq_table;
>> +     int i = 0;
>> +
>> +     dev_opp = find_device_opp(dev);
>> +     if (IS_ERR(dev_opp)) {
>> +             pr_warning("%s: unable to find device\n", __func__);
>> +             return;
>> +     }
>> +
>> +     freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
>> +                          (opp_get_opp_count(dev) + 1), GFP_ATOMIC);
>> +     if (!freq_table) {
>> +             pr_warning("%s: failed to allocate frequency table\n",
>> +                        __func__);
>> +             return;
> 
> How does the caller tell that the allocation failed?  Should the caller
> set the pointer passed in through the "table" argument to NULL before
> calling this function?  Or should this function set *table to NULL
> before returning in this case?

Good catch. Thanks. I would rather change the return to int and pass 
proper errors to caller so that they can handle it appropriately.


[...]
-- 
Regards,
Nishanth Menon
