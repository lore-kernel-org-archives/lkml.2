Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1DFHNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:13:08 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:45678 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1DFHNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:13:07 -0400
Message-ID: <4D9C12BF.9090402@ladisch.de>
Date: Wed, 06 Apr 2011 09:14:07 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Jean Delvare <khali@linux-fr.org>, Thomas Renninger <trenn@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
 information
References: <20110404160733.GA11818@alberich.amd.com> <20110405144536.GA5054@alberich.amd.com> <20110405201238.GA20551@ericsson.com>
In-Reply-To: <20110405201238.GA20551@ericsson.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
> On Tue, Apr 05, 2011 at 10:45:36AM -0400, Andreas Herrmann wrote:
> > +static int __devinit f15h_power_is_internal_node0(struct pci_dev *f4)
> > +{
> > +	u32 val;
> > +	struct pci_dev *f3;
> > +
> > +	f3 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3));
> > +	if (!f3) {
> > +		dev_err(&f4->dev, "no function 3 available on this slot\n");
> > +		return 0;
> 
> It is a common practice to return a negative value on errors. Why not here ?

Apparently, this function returns a boolean value.  Using "bool"/"true"/
"false" would have made this more obvious.

> Also, is this really an error which asks for an error message, or just a CPU
> or system which does not support the attribute ?

AFAICT all F15h CPUs are _known_ to have all these PCI functions; the
error should never occur in practice.

What I do in the k10temp driver in this situation is to trust the CPU to
be there, omitting the pci_get_slot/pci_dev_put and just replacing this:

> > +	pci_read_config_dword(f3, REG_NORTHBRIDGE_CAP, &val);
> > +	pci_dev_put(f3);

with the equivalent of:

  pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3),
                            REG_NORTHBRIDGE_CAP, &val);


BTW: The family 15h CPUs have the same temperature sensor registers
(D18F3xA4 and D18F3x64) as the earlier families, haven't they?


Regards,
Clemens
