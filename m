Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0JGV4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:56:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab0JGV4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:56:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] power: introduce library for device-specific OPPs
Date: Thu, 7 Oct 2010 23:54:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "l-o" <linux-omap@vger.kernel.org>,
        "l-a" <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
References: <1286357180-21565-1-git-send-email-nm@ti.com>
In-Reply-To: <1286357180-21565-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010072354.57011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, October 06, 2010, Nishanth Menon wrote:
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

The patch generally looks good to me, I only have a couple of cosmetic remarks
(below).

...
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

Please add an identification string to the messages, something like
"OPP: Unable to allocat object\n" (and similarly in the other messages).
That would help to find the source of a message in case there's any problem.


> +		return -ENOMEM;
> +	}
> +
> +	mutex_lock(&dev_opp_list_lock);
> +
> +	/* Find the device_opp */
> +	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
> +		if (dev == tmp_dev_opp->dev) {
> +			dev_opp = tmp_dev_opp;
> +			break;
> +		}
> +	}
> +	if (IS_ERR(dev_opp)) {
> +		r = PTR_ERR(dev_opp);
> +		pr_warning("Unable to find device\n");
> +		goto out1;

I'd prefer this lable to be called "unlock".  It will be a bit more informative.

> +	}
> +
> +	/* Do we have the frequency? */
> +	list_for_each_entry(tmp_opp, &dev_opp->opp_list, node) {
> +		if (tmp_opp->rate == freq) {
> +			opp = tmp_opp;
> +			break;
> +		}
> +	}
> +	if (IS_ERR(opp)) {
> +		r = PTR_ERR(opp);
> +		goto out1;
> +	}
> +
> +	/* Is update really needed? */
> +	if (opp->available == availability_req)
> +		goto out1;
> +	/* copy the old data over */
> +	*new_opp = *opp;
> +
> +	/* plug in new node */
> +	new_opp->available = availability_req;
> +
> +	list_replace_rcu(&opp->node, &new_opp->node);
> +	mutex_unlock(&dev_opp_list_lock);
> +	synchronize_rcu();
> +
> +	/* clean up old opp */
> +	new_opp = opp;
> +	goto out;
> +
> +out1:

+unlock:

> +	mutex_unlock(&dev_opp_list_lock);
> +out:
> +	kfree(new_opp);
> +	return r;
> +}

Thanks,
Rafael
