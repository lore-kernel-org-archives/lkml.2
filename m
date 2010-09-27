Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0I0O3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:29:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39772 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0I0O3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:29:18 -0400
Message-ID: <4CA0AA31.3030801@ti.com>
Date: Mon, 27 Sep 2010 09:29:05 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v4] power: introduce library for device-specific OPPs
References: <1285332640-16736-1-git-send-email-nm@ti.com> <20100924193742.GJ2375@linux.vnet.ibm.com> <4C9D177D.6090708@ti.com> <20100924214003.GL2375@linux.vnet.ibm.com>
In-Reply-To: <20100924214003.GL2375@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney had written, on 09/24/2010 04:40 PM, the following:
[...]
>>>> +/**
>>>> + * opp_find_freq_ceil() - Search for an rounded ceil freq
>>>> + * @dev:     device for which we do this operation
>>>> + * @freq:    Start frequency
>>>> + *
>>>> + * Search for the matching ceil *available* OPP from a starting freq
>>>> + * for a device.
>>>> + *
>>>> + * Returns matching *opp and refreshes *freq accordingly, else returns
>>>> + * ERR_PTR in case of error and should be handled using IS_ERR.
>>>> + *
>>>> + * Locking: RCU reader.
>>>> + */
>>>> +struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
>>>> +{
>>>> +     struct device_opp *dev_opp;
>>>> +     struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
>>>> +
>>>> +     if (!dev || !freq) {
>>>> +             pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
>>>> +                             dev, freq);
>>>> +             return ERR_PTR(-EINVAL);
>>>> +     }
>>>> +
>>>> +     dev_opp = find_device_opp(dev);
>>>> +     if (IS_ERR(dev_opp))
>>>> +             return opp;
>>>> +
>>>> +     rcu_read_lock();
>>>> +     list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>>>> +             if (temp_opp->available && temp_opp->rate >= *freq) {
>>>> +                     opp = temp_opp;
>>>> +                     *freq = opp->rate;
>>>> +                     break;
>>>> +             }
>>>> +     }
>>>> +     rcu_read_unlock();
>>> And this one also has the same problem that find_device_opp() does.
>> guessing opp ptr here.. am I right? if it is about device_opp, it is
>> not going to be freed as I mentioned above - at least we dont give
>> an function to update(hence free) it.
> 
> It really does look to me that you are passing a pointer to the thing
> being freed out of an RCU read-side critical section.  If you are really
> doing this, you do need to do something to fix it.  I outlined some of
> the options earlier.
ack. will try to fix in v5.

> 
>>>> +     return opp;
>>>> +}
>>>> +
>>>> +/**
>>>> + * opp_find_freq_floor() - Search for a rounded floor freq
>>>> + * @dev:     device for which we do this operation
>>>> + * @freq:    Start frequency
>>>> + *
>>>> + * Search for the matching floor *available* OPP from a starting freq
>>>> + * for a device.
>>>> + *
>>>> + * Returns matching *opp and refreshes *freq accordingly, else returns
>>>> + * ERR_PTR in case of error and should be handled using IS_ERR.
>>>> + *
>>>> + * Locking: RCU reader.
>>>> + */
>>>> +struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
>>>> +{
>>>> +     struct device_opp *dev_opp;
>>>> +     struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
>>>> +
>>>> +     if (!dev || !freq) {
>>>> +             pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
>>>> +                             dev, freq);
>>>> +             return ERR_PTR(-EINVAL);
>>>> +     }
>>>> +
>>>> +     dev_opp = find_device_opp(dev);
>>>> +     if (IS_ERR(dev_opp))
>>>> +             return opp;
>>>> +
>>>> +     rcu_read_lock();
>>>> +     list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
>>>> +             if (temp_opp->available) {
>>>> +                     /* go to the next node, before choosing prev */
>>>> +                     if (temp_opp->rate > *freq)
>>>> +                             break;
>>>> +                     else
>>>> +                             opp = temp_opp;
>>>> +             }
>>>> +     }
>>>> +     if (!IS_ERR(opp))
>>>> +             *freq = opp->rate;
>>>> +     rcu_read_unlock();
>>> As does this one.
>> guessing opp ptr here.. am I right?
> 
> Again, here it looks to me like you are passing a pointer out of an RCU
> read-side critical section that could be freed out from under you.  If
> so, again, this must be fixed.
> 
[...]
>>>> +static int opp_set_availability(struct opp *opp, bool availability_req)
>>>> +{
>>>> +     struct opp *new_opp, *tmp_opp;
>>>> +     bool is_available;
>>>> +
>>>> +     if (unlikely(!opp || IS_ERR(opp))) {
>>>> +             pr_err("%s: Invalid parameters being passed\n", __func__);
>>>> +             return -EINVAL;
>>>> +     }
>>>> +
>>>> +     new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
>>>> +     if (!new_opp) {
>>>> +             pr_warning("%s: unable to allocate opp\n", __func__);
>>>> +             return -ENOMEM;
>>>> +     }
>>>> +
>>>> +     mutex_lock(&opp->dev_opp->lock);
>>>> +
>>>> +     rcu_read_lock();
>>>> +     tmp_opp = rcu_dereference(opp);
>>>> +     is_available = tmp_opp->available;
>>>> +     rcu_read_unlock();
>>>> +
>>>> +     /* Is update really needed? */
>>>> +     if (is_available == availability_req) {
>>>> +             mutex_unlock(&opp->dev_opp->lock);
>>>> +             kfree(tmp_opp);
>>>> +             return 0;
>>>> +     }
>>>> +
>>>> +     *new_opp = *opp;
>>>> +     new_opp->available = availability_req;
>>>> +     list_replace_rcu(&opp->node, &new_opp->node);
>>>> +
>>>> +     mutex_unlock(&opp->dev_opp->lock);
>>>> +     synchronize_rcu();
>>> If you decide to rely on reference counts to fix the problem in
>>> find_device_opp(), you will need to check the reference counts here.
>>> Again, please see Documentation/RCU/rcuref.txt.
>> Does the original point about not needing to free dev_opp resolve this?
> 
> For the dev_opp case, yes.  However, I believe that my point is still
> valid for the opp case.
Ack. I missed that :(.. let me relook at the logic yet again. hopefully 
fix in v5.

> 
>>>> +     kfree(opp);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +/**
>>>> + * opp_enable() - Enable a specific OPP
>>>> + * @opp:     Pointer to opp
>>>> + *
>>>> + * Enables a provided opp. If the operation is valid, this returns 0, else the
>>>> + * corresponding error value. It is meant to be used for users an OPP available
>>>> + * after being temporarily made unavailable with opp_disable.
>>>> + *
>>>> + * Locking: RCU, mutex
>>> By "Locking: RCU", you presumably don't mean that the caller must do
>>> an rcu_read_lock() -- this would result in a synchronize_rcu() being
>>> invoked in an RCU read-side critical section, which is illegal.
>> aye..thx. I will make it more verbose. Does the following sound right?
>>
>> Locking used internally: RCU copy-update and read_lock used, mutex
>>
>> and for the readers:
>>
>> Locking used internally: RCU read_lock used
>>
>> or do we need to go all verbatim about the implementation here?
>>
>> I intended the user to know the context in which they can call it,
>> for example, since mutex is used, dont think of using this in
>> interrupt context. since read_locks are already used, dont need to
>> double lock it.. opp library takes care of it's own exclusivity.
> 
> I would stick to the constraints on the caller, and describe the internals
> elsewhere, for example, near the data-structure definitions.  But tastes
> do vary on this.

okay. let me see how to clean this up.

[..]
>>>> +void opp_init_cpufreq_table(struct device *dev,
>>>> +                         struct cpufreq_frequency_table **table)
>>>> +{
>>>> +     struct device_opp *dev_opp;
>>>> +     struct opp *opp;
>>>> +     struct cpufreq_frequency_table *freq_table;
>>>> +     int i = 0;
>>>> +
>>>> +     dev_opp = find_device_opp(dev);
>>>> +     if (IS_ERR(dev_opp)) {
>>>> +             pr_warning("%s: unable to find device\n", __func__);
>>>> +             return;
>>>> +     }
>>>> +
>>>> +     freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
>>>> +                          (opp_get_opp_count(dev) + 1), GFP_ATOMIC);
>>>> +     if (!freq_table) {
>>>> +             pr_warning("%s: failed to allocate frequency table\n",
>>>> +                        __func__);
>>>> +             return;
>>> How does the caller tell that the allocation failed?  Should the caller
>>> set the pointer passed in through the "table" argument to NULL before
>>> calling this function?  Or should this function set *table to NULL
>>> before returning in this case?
>> Good catch. Thanks. I would rather change the return to int and pass
>> proper errors to caller so that they can handle it appropriately.
> 
> Works for me!
thx.

-- 
Regards,
Nishanth Menon
