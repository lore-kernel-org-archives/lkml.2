Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1G1Min (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:38:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab1G1Mij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:38:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,282,1309762800"; 
   d="scan'208";a="33084480"
Date: Thu, 28 Jul 2011 15:38:42 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: power_supply: USB charging question
Message-ID: <20110728123842.GA10955@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking for a way to create generic USB charging support. I want
to take advantage of the power supply class, but there is one problem.
How do I get properties from the external power supply?

The batteries need to get the CURRENT_MAX property from USB chargers.
It's not enough to be aware are they supplied or not. We must obey the
bMaxPower field from the USB configuration that the USB host has
selected when charging from normal downstream port.

There are several ways that I thought could solve this. Firstly,
simply deliver the external power_supply with the
external_power_changed hook and leave the problem to the drivers. This
did not feel like an ideal solution.

Next idea. Add functions for getting properties from the supplying
power supply:

static int power_supply_find_supplier(struct device *dev, void
data)
{
       struct power_supply *psy = (struct power_supply *)data;
       struct power_supply *epsy = dev_get_drvdata(dev);
       int i;

       for (i = 0; i < epsy->num_supplicants; i++)
               if (!strcmp(epsy->supplied_to[i], psy->name))
                       return 1;
                       
       return 0;
}

int power_supply_get_supplier_property(struct power_supply *psy,
                                       enum power_supply_property psp,
                                       union power_supply_propval *val);
{
       struct power_supply *epsy;
       struct device *dev;

       dev = class_find_device(power_supply_class, NULL, psy,
                               power_supply_find_supplier);
       if (!dev)
               return 1;

       epsy = dev_get_drvdata(dev);
       put_device(dev);

       return epsy->get_property(epsy, psp, &val);
}
EXPORT_SYMBOL_GPL(power_supply_get_supplier_property);


Third idea. We only need to know how much are we allowed to draw, so
add a function for that purpose only. Something like
"power_supply_how_much_can_i_draw". Same as power_supply_am_i_supplied()
except the property would be POWER_SUPPLY_PROP_CURRENT_MAX.

How do you think this should be handled? What would be the best
solution?

-- 
heikki
