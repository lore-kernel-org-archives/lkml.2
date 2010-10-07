Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab0JGWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:04:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48572 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0JGWEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:04:12 -0400
From: "Menon, Nishanth" <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
Date: Thu, 7 Oct 2010 17:03:20 -0500
Subject: RE: [PATCH] power: introduce library for device-specific OPPs
Thread-Topic: [PATCH] power: introduce library for device-specific OPPs
Thread-Index: Actmam6qwvp7g+66SW+8t2WBMbrGPgAAD9Fw
Message-ID: <7A436F7769CA33409C6B44B358BFFF0C014F748B07@dlee02.ent.ti.com>
References: <1286357180-21565-1-git-send-email-nm@ti.com>
 <201010072354.57011.rjw@sisk.pl>
In-Reply-To: <201010072354.57011.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Thursday, October 07, 2010 4:55 PM


> 
> Hi,
> 
> On Wednesday, October 06, 2010, Nishanth Menon wrote:
> > SoCs have a standard set of tuples consisting of frequency and
> > voltage pairs that the device will support per voltage domain. These
> > are called Operating Performance Points or OPPs. The actual
> > definitions of OPP varies over silicon versions. For a specific domain,
> > we can have a set of {frequency, voltage} pairs. As the kernel boots
> > and more information is available, a default set of these are activated
> > based on the precise nature of device. Further on operation, based on
> > conditions prevailing in the system (such as temperature), some OPP
> > availability may be temporarily controlled by the SoC frameworks.
> >
> > To implement an OPP, some sort of power management support is necessary
> > hence this library depends on CONFIG_PM.
> 
> The patch generally looks good to me, I only have a couple of cosmetic
Thanks for the great reviews.. It did bump up the resultant patch.

> remarks
> (below).
> 
> ...
> > +static int opp_set_availability(struct device *dev, unsigned long freq,
> > +		bool availability_req)
> > +{
> > +	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
> > +	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
> > +	int r = 0;
> > +
> > +	/* keep the node allocated */
> > +	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
> > +	if (!new_opp) {
> > +		pr_warning("Unable to allocate opp\n");
> 
> Please add an identification string to the messages, something like
> "OPP: Unable to allocat object\n" (and similarly in the other messages).
> That would help to find the source of a message in case there's any
> problem.

pr_fmt has been reformatted for this. The actual message which will appear
is as follows:
opp_set_availability: Unable to allocate opp

is'nt that good enough considering that all functions are opp_ prefixed? 
I can modify pr_fmt to add "OPP:" but I kinda think it is redundant. But I
have no strong opinions on that and look forward to your recommendations.

> 
> 
> > +		return -ENOMEM;
> > +	}
> > +
> > +	mutex_lock(&dev_opp_list_lock);
> > +
> > +	/* Find the device_opp */
> > +	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
> > +		if (dev == tmp_dev_opp->dev) {
> > +			dev_opp = tmp_dev_opp;
> > +			break;
> > +		}
> > +	}
> > +	if (IS_ERR(dev_opp)) {
> > +		r = PTR_ERR(dev_opp);
> > +		pr_warning("Unable to find device\n");
> > +		goto out1;
> 
> I'd prefer this lable to be called "unlock".  It will be a bit more
> informative.
Ack. Fixing in v6 if you are ok with the above.

Regards,
Nishanth Menon

